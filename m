Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB6493B1747
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 11:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbhFWJxq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 05:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbhFWJxq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 05:53:46 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D186C061574
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 02:51:28 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id g192so1892310pfb.6
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 02:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0QDvHuJfqREZz3f3vm3J735hL5aeH0dddoGUvB6Zf7U=;
        b=C4aDFBRG7R7KsfK169gc3kwblRIFSu9c3UtpBQYEHGgc5vB9NkPFfw7VVvWxPBPhjM
         ChTtnJ8xg16ie3NhUO+0xe2cAQeHfhYiSQ4g8kC1Ujxrw8sSz9hV8kWiytBq2D0CbhKm
         UT95QHibOM3m3J1X6tOQt07EPx8M8qeV9xMLf1GZ55WToZqWEL7WsWuQD6WipxpT6y5W
         zNs5dZgMWJ0A+UyxNoeychvrPAWciQsyy2zlD78s/RQmXNpPUBm/78gcBNjG0tN9dYME
         38ElgnMjMnXS2y339JatJqaIp2sMRTLzaoClhb8Kt2lv0Z4J0bbIRCeCrVnerRI26PBh
         aqLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0QDvHuJfqREZz3f3vm3J735hL5aeH0dddoGUvB6Zf7U=;
        b=scfjJRiOtKYy2B9qm/vS4pI59YK3giZoTzZpqzp3pxkUIWR/XDcvHj9TjeTUVHaUCb
         /morV3gmWTZd8zZSDDHA0G6JfOpnjNYyWtWdoc4NF8aQUUMQVyWP+UqGE5n4HMOw4iwJ
         9cd9f1nbsMtplSnX7bdWPaJb85wepiMx9Rx6r2yAWtlLJ0VVvia1jNbJTxo58VgpMyit
         mDi6otJYLrAhTfjSNEMkFDRfseep/D89PVrg0pJDSP1/xcn9Y5yNu5yFbvt4WhIeYeh3
         VXClutY2QoRh5n8dejNOFjmyeoZzveLUxYm2Wx7l0uZUh1UVpWJ5UtqVFb9+w+aZ+U+z
         QA0w==
X-Gm-Message-State: AOAM532AttngsU1qo3e+jmN4tr8z0S39ctOcgiUY2XBzxf5/0iGhFkBD
        /T056yEue3O/RX0GGUZ+da8=
X-Google-Smtp-Source: ABdhPJxknexnakpSxTsVEJv8bon2/iYIwXjzdEjoiKs7bxR/THceDVH+82ZxvDdW3HZkKupeFPcXXQ==
X-Received: by 2002:a62:d41e:0:b029:305:b3ff:4056 with SMTP id a30-20020a62d41e0000b0290305b3ff4056mr6218702pfh.78.1624441887581;
        Wed, 23 Jun 2021 02:51:27 -0700 (PDT)
Received: from [192.168.1.237] ([118.200.190.93])
        by smtp.gmail.com with ESMTPSA id ne11sm4791002pjb.40.2021.06.23.02.51.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 02:51:27 -0700 (PDT)
Subject: Re: [PATCH] Revert "drm: add a locked version of
 drm_is_current_master"
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Emil Velikov <emil.l.velikov@gmail.com>,
        stable <stable@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>
References: <20210622075409.2673805-1-daniel.vetter@ffwll.ch>
 <94029dc6-6e8c-2a33-0efa-bfca678fc6b1@gmail.com>
 <CAKMK7uE+=aWfL+rZCudmXjk6zR4c3q8QaMAVUP4XNg1gY=6rcg@mail.gmail.com>
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Message-ID: <94ac6fbb-631e-b346-700f-45d546daec1f@gmail.com>
Date:   Wed, 23 Jun 2021 17:51:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAKMK7uE+=aWfL+rZCudmXjk6zR4c3q8QaMAVUP4XNg1gY=6rcg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23/6/21 4:14 pm, Daniel Vetter wrote:
> On Wed, Jun 23, 2021 at 10:09 AM Desmond Cheong Zhi Xi
> <desmondcheongzx@gmail.com> wrote:
>>
>> On 22/6/21 3:54 pm, Daniel Vetter wrote:
>>> This reverts commit 1815d9c86e3090477fbde066ff314a7e9721ee0f.
>>>
>>> Unfortunately this inverts the locking hierarchy, so back to the
>>> drawing board. Full lockdep splat below:
>>>
>>> ======================================================
>>> WARNING: possible circular locking dependency detected
>>> 5.13.0-rc7-CI-CI_DRM_10254+ #1 Not tainted
>>> ------------------------------------------------------
>>> kms_frontbuffer/1087 is trying to acquire lock:
>>> ffff88810dcd01a8 (&dev->master_mutex){+.+.}-{3:3}, at: drm_is_current_master+0x1b/0x40
>>> but task is already holding lock:
>>> ffff88810dcd0488 (&dev->mode_config.mutex){+.+.}-{3:3}, at: drm_mode_getconnector+0x1c6/0x4a0
>>> which lock already depends on the new lock.
>>> the existing dependency chain (in reverse order) is:
>>> -> #2 (&dev->mode_config.mutex){+.+.}-{3:3}:
>>>          __mutex_lock+0xab/0x970
>>>          drm_client_modeset_probe+0x22e/0xca0
>>>          __drm_fb_helper_initial_config_and_unlock+0x42/0x540
>>>          intel_fbdev_initial_config+0xf/0x20 [i915]
>>>          async_run_entry_fn+0x28/0x130
>>>          process_one_work+0x26d/0x5c0
>>>          worker_thread+0x37/0x380
>>>          kthread+0x144/0x170
>>>          ret_from_fork+0x1f/0x30
>>> -> #1 (&client->modeset_mutex){+.+.}-{3:3}:
>>>          __mutex_lock+0xab/0x970
>>>          drm_client_modeset_commit_locked+0x1c/0x180
>>>          drm_client_modeset_commit+0x1c/0x40
>>>          __drm_fb_helper_restore_fbdev_mode_unlocked+0x88/0xb0
>>>          drm_fb_helper_set_par+0x34/0x40
>>>          intel_fbdev_set_par+0x11/0x40 [i915]
>>>          fbcon_init+0x270/0x4f0
>>>          visual_init+0xc6/0x130
>>>          do_bind_con_driver+0x1e5/0x2d0
>>>          do_take_over_console+0x10e/0x180
>>>          do_fbcon_takeover+0x53/0xb0
>>>          register_framebuffer+0x22d/0x310
>>>          __drm_fb_helper_initial_config_and_unlock+0x36c/0x540
>>>          intel_fbdev_initial_config+0xf/0x20 [i915]
>>>          async_run_entry_fn+0x28/0x130
>>>          process_one_work+0x26d/0x5c0
>>>          worker_thread+0x37/0x380
>>>          kthread+0x144/0x170
>>>          ret_from_fork+0x1f/0x30
>>> -> #0 (&dev->master_mutex){+.+.}-{3:3}:
>>>          __lock_acquire+0x151e/0x2590
>>>          lock_acquire+0xd1/0x3d0
>>>          __mutex_lock+0xab/0x970
>>>          drm_is_current_master+0x1b/0x40
>>>          drm_mode_getconnector+0x37e/0x4a0
>>>          drm_ioctl_kernel+0xa8/0xf0
>>>          drm_ioctl+0x1e8/0x390
>>>          __x64_sys_ioctl+0x6a/0xa0
>>>          do_syscall_64+0x39/0xb0
>>>          entry_SYSCALL_64_after_hwframe+0x44/0xae
>>> other info that might help us debug this:
>>> Chain exists of: &dev->master_mutex --> &client->modeset_mutex --> &dev->mode_config.mutex
>>>    Possible unsafe locking scenario:
>>>          CPU0                    CPU1
>>>          ----                    ----
>>>     lock(&dev->mode_config.mutex);
>>>                                  lock(&client->modeset_mutex);
>>>                                  lock(&dev->mode_config.mutex);
>>>     lock(&dev->master_mutex);
>>> *** DEADLOCK ***
>>
>> Hi Daniel,
>>
>> Just a thought.
>>
>> Since &dev->mode_config.mutex is the modeset BKL and its scope isn't
>> clear, keeping the dependency as is would mean that any lock that
>> depends on &dev->mode_config.mutex would also depend on
>> &client->modeset_mutex. Seems like this might be vulnerable to more
>> circular dependencies.
>>
>> Would it make sense to invert the locking dependency for
>> &client->modeset_mutex and &dev->mode_config.mutex to become
>> &dev->mode_config.mutex --> &client->modeset_mutex? Something like this:
> 
> This isn't the problem I think, the problem is the inversion against
> master_mutex. fbdev emulation code holds master mutex while doing
> modesets, whereas getconnector checks for master status while holding
> a modeset mutex. I think just pulling the drm_is_current_master check
> out of getconnector should be fine to break the loop here?
> 
> Wrt changing the layering here: drm_client sits on top of the
> lower-level modeset interfaces. So drm_client locks should defintiely
> be outside of modeset locks, not the other way round. Also I'm not
> sure why you're focusing on the client lock here, that's just a lock
> that sits in the middle of the chain but otherwise doesn't matter. If
> you flip these these two intermediate chain links are flipped, but the
> overall chain is still closed. Heck you could completely remove
> client->modeset_mutex, and the bug is still the same.
> 
> Cheers, Daniel
> 

Right, scrap that thought then.

I was initially confused by the lockdep splat report because I was on 
the wrong drm-misc branch. Pulling drm_is_current_master out from the 
&dev->mode_config.mutex lock makes sense to me now. Thanks.

Best wishes,
Desmond

> 
>>
>> diff --git a/drivers/gpu/drm/drm_client_modeset.c
>> b/drivers/gpu/drm/drm_client_modeset.c
>> index ced09c7c06f9..859f99d97cde 100644
>> --- a/drivers/gpu/drm/drm_client_modeset.c
>> +++ b/drivers/gpu/drm/drm_client_modeset.c
>> @@ -811,9 +811,9 @@ int drm_client_modeset_probe(struct drm_client_dev
>> *client, unsigned int width,
>>                  goto out;
>>          }
>>
>> +       mutex_lock(&dev->mode_config.mutex);
>>          mutex_lock(&client->modeset_mutex);
>>
>> -       mutex_lock(&dev->mode_config.mutex);
>>          for (i = 0; i < connector_count; i++)
>>                  total_modes_count += connectors[i]->funcs->fill_modes(connectors[i],
>> width, height);
>>          if (!total_modes_count)
>> @@ -838,7 +838,6 @@ int drm_client_modeset_probe(struct drm_client_dev
>> *client, unsigned int width,
>>                  drm_client_pick_crtcs(client, connectors, connector_count,
>>                                        crtcs, modes, 0, width, height);
>>          }
>> -       mutex_unlock(&dev->mode_config.mutex);
>>
>>          drm_client_modeset_release(client);
>>
>> @@ -869,6 +868,7 @@ int drm_client_modeset_probe(struct drm_client_dev
>> *client, unsigned int width,
>>          }
>>
>>          mutex_unlock(&client->modeset_mutex);
>> +       mutex_unlock(&dev->mode_config.mutex);
>>    out:
>>          kfree(crtcs);
>>          kfree(modes);
>> diff --git a/drivers/gpu/drm/drm_fb_helper.c
>> b/drivers/gpu/drm/drm_fb_helper.c
>> index f6baa2046124..74302d110609 100644
>> --- a/drivers/gpu/drm/drm_fb_helper.c
>> +++ b/drivers/gpu/drm/drm_fb_helper.c
>> @@ -1443,8 +1443,8 @@ static int pan_display_legacy(struct
>> fb_var_screeninfo *var,
>>          struct drm_mode_set *modeset;
>>          int ret = 0;
>>
>> -       mutex_lock(&client->modeset_mutex);
>>          drm_modeset_lock_all(fb_helper->dev);
>> +       mutex_lock(&client->modeset_mutex);
>>          drm_client_for_each_modeset(modeset, client) {
>>                  modeset->x = var->xoffset;
>>                  modeset->y = var->yoffset;
>> @@ -1457,8 +1457,8 @@ static int pan_display_legacy(struct
>> fb_var_screeninfo *var,
>>                          }
>>                  }
>>          }
>> -       drm_modeset_unlock_all(fb_helper->dev);
>>          mutex_unlock(&client->modeset_mutex);
>> +       drm_modeset_unlock_all(fb_helper->dev);
>>
>>          return ret;
>>    }
>>
>>> 1 lock held by kms_frontbuffer/1087:
>>>    #0: ffff88810dcd0488 (&dev->mode_config.mutex){+.+.}-{3:3}, at: drm_mode_getconnector+0x1c6/0x4a0
>>> stack backtrace:
>>> CPU: 7 PID: 1087 Comm: kms_frontbuffer Not tainted 5.13.0-rc7-CI-CI_DRM_10254+ #1
>>> Hardware name: Intel Corporation Ice Lake Client Platform/IceLake U DDR4 SODIMM PD RVP TLC, BIOS ICLSFWR1.R00.3234.A01.1906141750 06/14/2019
>>> Call Trace:
>>>    dump_stack+0x7f/0xad
>>>    check_noncircular+0x12e/0x150
>>>    __lock_acquire+0x151e/0x2590
>>>    lock_acquire+0xd1/0x3d0
>>>    __mutex_lock+0xab/0x970
>>>    drm_is_current_master+0x1b/0x40
>>>    drm_mode_getconnector+0x37e/0x4a0
>>>    drm_ioctl_kernel+0xa8/0xf0
>>>    drm_ioctl+0x1e8/0x390
>>>    __x64_sys_ioctl+0x6a/0xa0
>>>    do_syscall_64+0x39/0xb0
>>>    entry_SYSCALL_64_after_hwframe+0x44/0xae
>>>
>>> daniel@phenom:~/linux/drm-misc-fixes$ dim fixes 1815d9c86e3090477fbde066ff314a7e9721ee0f
>>> Fixes: 1815d9c86e30 ("drm: add a locked version of drm_is_current_master")
>>> Cc: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
>>> Cc: Emil Velikov <emil.l.velikov@gmail.com>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
>>> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
>>> Cc: Maxime Ripard <mripard@kernel.org>
>>> Cc: Thomas Zimmermann <tzimmermann@suse.de>
>>> Cc: David Airlie <airlied@linux.ie>
>>> Cc: Daniel Vetter <daniel@ffwll.ch>
>>> ---
>>>    drivers/gpu/drm/drm_auth.c | 51 ++++++++++++++------------------------
>>>    1 file changed, 19 insertions(+), 32 deletions(-)
>>>
>>> diff --git a/drivers/gpu/drm/drm_auth.c b/drivers/gpu/drm/drm_auth.c
>>> index 86d4b72e95cb..232abbba3686 100644
>>> --- a/drivers/gpu/drm/drm_auth.c
>>> +++ b/drivers/gpu/drm/drm_auth.c
>>> @@ -61,35 +61,6 @@
>>>     * trusted clients.
>>>     */
>>>
>>> -static bool drm_is_current_master_locked(struct drm_file *fpriv)
>>> -{
>>> -     lockdep_assert_held_once(&fpriv->master->dev->master_mutex);
>>> -
>>> -     return fpriv->is_master && drm_lease_owner(fpriv->master) == fpriv->minor->dev->master;
>>> -}
>>> -
>>> -/**
>>> - * drm_is_current_master - checks whether @priv is the current master
>>> - * @fpriv: DRM file private
>>> - *
>>> - * Checks whether @fpriv is current master on its device. This decides whether a
>>> - * client is allowed to run DRM_MASTER IOCTLs.
>>> - *
>>> - * Most of the modern IOCTL which require DRM_MASTER are for kernel modesetting
>>> - * - the current master is assumed to own the non-shareable display hardware.
>>> - */
>>> -bool drm_is_current_master(struct drm_file *fpriv)
>>> -{
>>> -     bool ret;
>>> -
>>> -     mutex_lock(&fpriv->master->dev->master_mutex);
>>> -     ret = drm_is_current_master_locked(fpriv);
>>> -     mutex_unlock(&fpriv->master->dev->master_mutex);
>>> -
>>> -     return ret;
>>> -}
>>> -EXPORT_SYMBOL(drm_is_current_master);
>>> -
>>>    int drm_getmagic(struct drm_device *dev, void *data, struct drm_file *file_priv)
>>>    {
>>>        struct drm_auth *auth = data;
>>> @@ -252,7 +223,7 @@ int drm_setmaster_ioctl(struct drm_device *dev, void *data,
>>>        if (ret)
>>>                goto out_unlock;
>>>
>>> -     if (drm_is_current_master_locked(file_priv))
>>> +     if (drm_is_current_master(file_priv))
>>>                goto out_unlock;
>>>
>>>        if (dev->master) {
>>> @@ -301,7 +272,7 @@ int drm_dropmaster_ioctl(struct drm_device *dev, void *data,
>>>        if (ret)
>>>                goto out_unlock;
>>>
>>> -     if (!drm_is_current_master_locked(file_priv)) {
>>> +     if (!drm_is_current_master(file_priv)) {
>>>                ret = -EINVAL;
>>>                goto out_unlock;
>>>        }
>>> @@ -350,7 +321,7 @@ void drm_master_release(struct drm_file *file_priv)
>>>        if (file_priv->magic)
>>>                idr_remove(&file_priv->master->magic_map, file_priv->magic);
>>>
>>> -     if (!drm_is_current_master_locked(file_priv))
>>> +     if (!drm_is_current_master(file_priv))
>>>                goto out;
>>>
>>>        drm_legacy_lock_master_cleanup(dev, master);
>>> @@ -371,6 +342,22 @@ void drm_master_release(struct drm_file *file_priv)
>>>        mutex_unlock(&dev->master_mutex);
>>>    }
>>>
>>> +/**
>>> + * drm_is_current_master - checks whether @priv is the current master
>>> + * @fpriv: DRM file private
>>> + *
>>> + * Checks whether @fpriv is current master on its device. This decides whether a
>>> + * client is allowed to run DRM_MASTER IOCTLs.
>>> + *
>>> + * Most of the modern IOCTL which require DRM_MASTER are for kernel modesetting
>>> + * - the current master is assumed to own the non-shareable display hardware.
>>> + */
>>> +bool drm_is_current_master(struct drm_file *fpriv)
>>> +{
>>> +     return fpriv->is_master && drm_lease_owner(fpriv->master) == fpriv->minor->dev->master;
>>> +}
>>> +EXPORT_SYMBOL(drm_is_current_master);
>>> +
>>>    /**
>>>     * drm_master_get - reference a master pointer
>>>     * @master: &struct drm_master
>>>
>>
> 
> 

