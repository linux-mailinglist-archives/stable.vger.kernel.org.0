Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE7403B1571
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 10:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhFWILi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 04:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbhFWILh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 04:11:37 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725D7C061574
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 01:09:17 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id e20so1146308pgg.0
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 01:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GelCnd5q7HqKlcNkNFvA+hI74Sq6lVXWthbKSfoDoxQ=;
        b=iXkwXoCrXQVxHtEjpfyCe/MBIYYwvjBrwrGXQXfpfQz7gAycv1HaOwOC05y5+gIIYS
         wFwa2zVQXfg8Tw8k3CSS6hs11wOgv/qt3IEkzh/wIw23RetBXj55LYpruOWzk1Q5Idid
         wnVWKvxpXO9ZPYShWMKm1oFmETbmin4/xZEbDbE0qkoBOoMkPp8YASlRlZzttjdqukOd
         5or8fJm0T8IryqczDB5QC+ywXj8+p2AfyVUEgKDubtuhvN78CyJFE8EQlf4YOCPz6h3t
         ilF2Mt61IPVmBAW+q1QUr24AGdOr4ldEgskdPt1hMTqAe3wot2YYlQ4qj00dA6DrE4CC
         105w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GelCnd5q7HqKlcNkNFvA+hI74Sq6lVXWthbKSfoDoxQ=;
        b=Y7868XYsZ6j67UNPimFoWBnCC92dTP5QmAhP/DI6HNvM78TBbd2wAWB1vanD6o1oPO
         7+uT0PDWAC7k3Zxkjld9cfuL7jJRdDt1myChalx3z3Xyjs9gwraUfztNho3IW1JazJ46
         8LGx22TJNycy2/9YJqZyWukucNGi8RPCO1n0BXVE3C9/Qop7BnqD3Ve+1jTkTrzrSJSQ
         zuy7Di0VQaLoCrArxDvPC5Er6fSPJzeCRBppl4c57ucJONZjCF5OUJN5kUX4dEsrgo2L
         tchgGWshV3XC+njZV5dmi3mkDt/LoeIm4055c8zmFtrPnTbLZaOrSWer276KNw4x39qD
         3edQ==
X-Gm-Message-State: AOAM530BAr+TLzdObjROaxAZZlX4pABRoSuELtbN141gQhf0u/7luGRS
        rZY9L3WN/3oTYXhDFBZquNM=
X-Google-Smtp-Source: ABdhPJyVb9C2UJJeAZ7pvXZggmqlGiMoRT89FiccVC0afdoJhXKWRot+K2sEXDSQ2g0n0L7T1VJl3g==
X-Received: by 2002:aa7:8707:0:b029:306:7e78:ee7a with SMTP id b7-20020aa787070000b02903067e78ee7amr2905766pfo.29.1624435756822;
        Wed, 23 Jun 2021 01:09:16 -0700 (PDT)
Received: from [192.168.1.237] ([118.200.190.93])
        by smtp.gmail.com with ESMTPSA id s20sm4930672pjn.23.2021.06.23.01.09.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 01:09:16 -0700 (PDT)
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Subject: Re: [PATCH] Revert "drm: add a locked version of
 drm_is_current_master"
To:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        Emil Velikov <emil.l.velikov@gmail.com>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>
References: <20210622075409.2673805-1-daniel.vetter@ffwll.ch>
Message-ID: <94029dc6-6e8c-2a33-0efa-bfca678fc6b1@gmail.com>
Date:   Wed, 23 Jun 2021 16:09:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210622075409.2673805-1-daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22/6/21 3:54 pm, Daniel Vetter wrote:
> This reverts commit 1815d9c86e3090477fbde066ff314a7e9721ee0f.
> 
> Unfortunately this inverts the locking hierarchy, so back to the
> drawing board. Full lockdep splat below:
> 
> ======================================================
> WARNING: possible circular locking dependency detected
> 5.13.0-rc7-CI-CI_DRM_10254+ #1 Not tainted
> ------------------------------------------------------
> kms_frontbuffer/1087 is trying to acquire lock:
> ffff88810dcd01a8 (&dev->master_mutex){+.+.}-{3:3}, at: drm_is_current_master+0x1b/0x40
> but task is already holding lock:
> ffff88810dcd0488 (&dev->mode_config.mutex){+.+.}-{3:3}, at: drm_mode_getconnector+0x1c6/0x4a0
> which lock already depends on the new lock.
> the existing dependency chain (in reverse order) is:
> -> #2 (&dev->mode_config.mutex){+.+.}-{3:3}:
>         __mutex_lock+0xab/0x970
>         drm_client_modeset_probe+0x22e/0xca0
>         __drm_fb_helper_initial_config_and_unlock+0x42/0x540
>         intel_fbdev_initial_config+0xf/0x20 [i915]
>         async_run_entry_fn+0x28/0x130
>         process_one_work+0x26d/0x5c0
>         worker_thread+0x37/0x380
>         kthread+0x144/0x170
>         ret_from_fork+0x1f/0x30
> -> #1 (&client->modeset_mutex){+.+.}-{3:3}:
>         __mutex_lock+0xab/0x970
>         drm_client_modeset_commit_locked+0x1c/0x180
>         drm_client_modeset_commit+0x1c/0x40
>         __drm_fb_helper_restore_fbdev_mode_unlocked+0x88/0xb0
>         drm_fb_helper_set_par+0x34/0x40
>         intel_fbdev_set_par+0x11/0x40 [i915]
>         fbcon_init+0x270/0x4f0
>         visual_init+0xc6/0x130
>         do_bind_con_driver+0x1e5/0x2d0
>         do_take_over_console+0x10e/0x180
>         do_fbcon_takeover+0x53/0xb0
>         register_framebuffer+0x22d/0x310
>         __drm_fb_helper_initial_config_and_unlock+0x36c/0x540
>         intel_fbdev_initial_config+0xf/0x20 [i915]
>         async_run_entry_fn+0x28/0x130
>         process_one_work+0x26d/0x5c0
>         worker_thread+0x37/0x380
>         kthread+0x144/0x170
>         ret_from_fork+0x1f/0x30
> -> #0 (&dev->master_mutex){+.+.}-{3:3}:
>         __lock_acquire+0x151e/0x2590
>         lock_acquire+0xd1/0x3d0
>         __mutex_lock+0xab/0x970
>         drm_is_current_master+0x1b/0x40
>         drm_mode_getconnector+0x37e/0x4a0
>         drm_ioctl_kernel+0xa8/0xf0
>         drm_ioctl+0x1e8/0x390
>         __x64_sys_ioctl+0x6a/0xa0
>         do_syscall_64+0x39/0xb0
>         entry_SYSCALL_64_after_hwframe+0x44/0xae
> other info that might help us debug this:
> Chain exists of: &dev->master_mutex --> &client->modeset_mutex --> &dev->mode_config.mutex
>   Possible unsafe locking scenario:
>         CPU0                    CPU1
>         ----                    ----
>    lock(&dev->mode_config.mutex);
>                                 lock(&client->modeset_mutex);
>                                 lock(&dev->mode_config.mutex);
>    lock(&dev->master_mutex);
> *** DEADLOCK ***

Hi Daniel,

Just a thought.

Since &dev->mode_config.mutex is the modeset BKL and its scope isn't 
clear, keeping the dependency as is would mean that any lock that 
depends on &dev->mode_config.mutex would also depend on 
&client->modeset_mutex. Seems like this might be vulnerable to more 
circular dependencies.

Would it make sense to invert the locking dependency for 
&client->modeset_mutex and &dev->mode_config.mutex to become 
&dev->mode_config.mutex --> &client->modeset_mutex? Something like this:

diff --git a/drivers/gpu/drm/drm_client_modeset.c 
b/drivers/gpu/drm/drm_client_modeset.c
index ced09c7c06f9..859f99d97cde 100644
--- a/drivers/gpu/drm/drm_client_modeset.c
+++ b/drivers/gpu/drm/drm_client_modeset.c
@@ -811,9 +811,9 @@ int drm_client_modeset_probe(struct drm_client_dev 
*client, unsigned int width,
  		goto out;
  	}

+	mutex_lock(&dev->mode_config.mutex);
  	mutex_lock(&client->modeset_mutex);

-	mutex_lock(&dev->mode_config.mutex);
  	for (i = 0; i < connector_count; i++)
  		total_modes_count += connectors[i]->funcs->fill_modes(connectors[i], 
width, height);
  	if (!total_modes_count)
@@ -838,7 +838,6 @@ int drm_client_modeset_probe(struct drm_client_dev 
*client, unsigned int width,
  		drm_client_pick_crtcs(client, connectors, connector_count,
  				      crtcs, modes, 0, width, height);
  	}
-	mutex_unlock(&dev->mode_config.mutex);

  	drm_client_modeset_release(client);

@@ -869,6 +868,7 @@ int drm_client_modeset_probe(struct drm_client_dev 
*client, unsigned int width,
  	}

  	mutex_unlock(&client->modeset_mutex);
+	mutex_unlock(&dev->mode_config.mutex);
  out:
  	kfree(crtcs);
  	kfree(modes);
diff --git a/drivers/gpu/drm/drm_fb_helper.c 
b/drivers/gpu/drm/drm_fb_helper.c
index f6baa2046124..74302d110609 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -1443,8 +1443,8 @@ static int pan_display_legacy(struct 
fb_var_screeninfo *var,
  	struct drm_mode_set *modeset;
  	int ret = 0;

-	mutex_lock(&client->modeset_mutex);
  	drm_modeset_lock_all(fb_helper->dev);
+	mutex_lock(&client->modeset_mutex);
  	drm_client_for_each_modeset(modeset, client) {
  		modeset->x = var->xoffset;
  		modeset->y = var->yoffset;
@@ -1457,8 +1457,8 @@ static int pan_display_legacy(struct 
fb_var_screeninfo *var,
  			}
  		}
  	}
-	drm_modeset_unlock_all(fb_helper->dev);
  	mutex_unlock(&client->modeset_mutex);
+	drm_modeset_unlock_all(fb_helper->dev);

  	return ret;
  }

> 1 lock held by kms_frontbuffer/1087:
>   #0: ffff88810dcd0488 (&dev->mode_config.mutex){+.+.}-{3:3}, at: drm_mode_getconnector+0x1c6/0x4a0
> stack backtrace:
> CPU: 7 PID: 1087 Comm: kms_frontbuffer Not tainted 5.13.0-rc7-CI-CI_DRM_10254+ #1
> Hardware name: Intel Corporation Ice Lake Client Platform/IceLake U DDR4 SODIMM PD RVP TLC, BIOS ICLSFWR1.R00.3234.A01.1906141750 06/14/2019
> Call Trace:
>   dump_stack+0x7f/0xad
>   check_noncircular+0x12e/0x150
>   __lock_acquire+0x151e/0x2590
>   lock_acquire+0xd1/0x3d0
>   __mutex_lock+0xab/0x970
>   drm_is_current_master+0x1b/0x40
>   drm_mode_getconnector+0x37e/0x4a0
>   drm_ioctl_kernel+0xa8/0xf0
>   drm_ioctl+0x1e8/0x390
>   __x64_sys_ioctl+0x6a/0xa0
>   do_syscall_64+0x39/0xb0
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> daniel@phenom:~/linux/drm-misc-fixes$ dim fixes 1815d9c86e3090477fbde066ff314a7e9721ee0f
> Fixes: 1815d9c86e30 ("drm: add a locked version of drm_is_current_master")
> Cc: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
> Cc: Emil Velikov <emil.l.velikov@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> ---
>   drivers/gpu/drm/drm_auth.c | 51 ++++++++++++++------------------------
>   1 file changed, 19 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_auth.c b/drivers/gpu/drm/drm_auth.c
> index 86d4b72e95cb..232abbba3686 100644
> --- a/drivers/gpu/drm/drm_auth.c
> +++ b/drivers/gpu/drm/drm_auth.c
> @@ -61,35 +61,6 @@
>    * trusted clients.
>    */
>   
> -static bool drm_is_current_master_locked(struct drm_file *fpriv)
> -{
> -	lockdep_assert_held_once(&fpriv->master->dev->master_mutex);
> -
> -	return fpriv->is_master && drm_lease_owner(fpriv->master) == fpriv->minor->dev->master;
> -}
> -
> -/**
> - * drm_is_current_master - checks whether @priv is the current master
> - * @fpriv: DRM file private
> - *
> - * Checks whether @fpriv is current master on its device. This decides whether a
> - * client is allowed to run DRM_MASTER IOCTLs.
> - *
> - * Most of the modern IOCTL which require DRM_MASTER are for kernel modesetting
> - * - the current master is assumed to own the non-shareable display hardware.
> - */
> -bool drm_is_current_master(struct drm_file *fpriv)
> -{
> -	bool ret;
> -
> -	mutex_lock(&fpriv->master->dev->master_mutex);
> -	ret = drm_is_current_master_locked(fpriv);
> -	mutex_unlock(&fpriv->master->dev->master_mutex);
> -
> -	return ret;
> -}
> -EXPORT_SYMBOL(drm_is_current_master);
> -
>   int drm_getmagic(struct drm_device *dev, void *data, struct drm_file *file_priv)
>   {
>   	struct drm_auth *auth = data;
> @@ -252,7 +223,7 @@ int drm_setmaster_ioctl(struct drm_device *dev, void *data,
>   	if (ret)
>   		goto out_unlock;
>   
> -	if (drm_is_current_master_locked(file_priv))
> +	if (drm_is_current_master(file_priv))
>   		goto out_unlock;
>   
>   	if (dev->master) {
> @@ -301,7 +272,7 @@ int drm_dropmaster_ioctl(struct drm_device *dev, void *data,
>   	if (ret)
>   		goto out_unlock;
>   
> -	if (!drm_is_current_master_locked(file_priv)) {
> +	if (!drm_is_current_master(file_priv)) {
>   		ret = -EINVAL;
>   		goto out_unlock;
>   	}
> @@ -350,7 +321,7 @@ void drm_master_release(struct drm_file *file_priv)
>   	if (file_priv->magic)
>   		idr_remove(&file_priv->master->magic_map, file_priv->magic);
>   
> -	if (!drm_is_current_master_locked(file_priv))
> +	if (!drm_is_current_master(file_priv))
>   		goto out;
>   
>   	drm_legacy_lock_master_cleanup(dev, master);
> @@ -371,6 +342,22 @@ void drm_master_release(struct drm_file *file_priv)
>   	mutex_unlock(&dev->master_mutex);
>   }
>   
> +/**
> + * drm_is_current_master - checks whether @priv is the current master
> + * @fpriv: DRM file private
> + *
> + * Checks whether @fpriv is current master on its device. This decides whether a
> + * client is allowed to run DRM_MASTER IOCTLs.
> + *
> + * Most of the modern IOCTL which require DRM_MASTER are for kernel modesetting
> + * - the current master is assumed to own the non-shareable display hardware.
> + */
> +bool drm_is_current_master(struct drm_file *fpriv)
> +{
> +	return fpriv->is_master && drm_lease_owner(fpriv->master) == fpriv->minor->dev->master;
> +}
> +EXPORT_SYMBOL(drm_is_current_master);
> +
>   /**
>    * drm_master_get - reference a master pointer
>    * @master: &struct drm_master
> 

