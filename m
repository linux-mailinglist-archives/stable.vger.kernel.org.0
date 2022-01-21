Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2AA6496204
	for <lists+stable@lfdr.de>; Fri, 21 Jan 2022 16:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239044AbiAUPZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jan 2022 10:25:28 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:48930
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351382AbiAUPZ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jan 2022 10:25:27 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 4D15340027
        for <stable@vger.kernel.org>; Fri, 21 Jan 2022 15:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1642778719;
        bh=kmO+xAN2J4Jy/ih5e+qjMQI4v9QuAWJh5wyH2KxAvmg=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=F6sF4wIR7KMeNaBObaF9kHgghIT1luIw3GpPHBP0pulO8ZFqHznEB70pkv97lmuy6
         9kq1Ck4/TKIwXQUSnk3MXRmr3SsUI1yMIEcc7adNQqRs2Pg8uvUhzZXs0Xf0njqAQW
         Ji6HwnDMCE6Zmr/NuVlghcgy8NqpBaTbM3t6BAE4bC3yWl/osuNobDvuArmRSSo4cZ
         eEq0Rh0MvJeNRTz2DeGL2bjJFJOmsVYazCAkEayfOVtii2FUKutpxXI1reXqmn3YA8
         QFXfv8WQRjZCfvT6Vqmou2W+txkjKACSpilAGbA/YwU2Vwqs+Ksvf57nwdKPgTw0pG
         sPonrqdVIbVFg==
Received: by mail-io1-f70.google.com with SMTP id l124-20020a6b3e82000000b005ed165a1506so6386718ioa.5
        for <stable@vger.kernel.org>; Fri, 21 Jan 2022 07:25:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kmO+xAN2J4Jy/ih5e+qjMQI4v9QuAWJh5wyH2KxAvmg=;
        b=6wi3/vT3cqI8Q5bnQ+rg7iSRhF4dtIkrBTpuFuFo4eyrb2IYxa4qjkNyKEOXXYGawt
         Od5HrwPt2ofh0CK3ZltAZJS7+t1J6/A1EASbDpKJRORhrd/dYpgKiEof/Skhvb5EMCW2
         aLggNHKksWyNkkA9RweTZGRPF43Bhty7zljhBx0hofjpIGlyUhkHNGywlqEUiR9sVM2o
         nntCvVWUaPXrq3yLkWRTzEIoT+rW75tzxJ7I+IbbvYfQcfP30evJFA1DuSCAJJbrYr9y
         7FGEgoTVJKoHv+lY9L0E7OPlKPDL7mxhCsMQL/A0hWh+AAdmHyEQ1f99ujFJppMgAKBK
         airQ==
X-Gm-Message-State: AOAM530Q+5zh+KF/sUfr4cNcU32jeVxvLxfuYoNiqjERihVNXIyDKtMV
        k2Y7RkYiDExmBKRCeZSxx/QIjttDZpdNpO5XJ2vy27yN/NpQ1EfOOqhtbYQHBAyuKR88ZEGaQ6n
        xOJrmdQK3AiRVhzz4YvkL2Xdn34Z61K1Ncw==
X-Received: by 2002:a02:85e3:: with SMTP id d90mr632661jai.15.1642778716283;
        Fri, 21 Jan 2022 07:25:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzeOIQp+Scen5y5VsEkzFbri8UfeMJMq603bTmQNLXleUNzAxbMTmooyHEggHDV9wKJC/Ogyw==
X-Received: by 2002:a02:85e3:: with SMTP id d90mr632645jai.15.1642778716007;
        Fri, 21 Jan 2022 07:25:16 -0800 (PST)
Received: from xps13.dannf (c-71-196-238-11.hsd1.co.comcast.net. [71.196.238.11])
        by smtp.gmail.com with ESMTPSA id w4sm3282353ilv.32.2022.01.21.07.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 07:25:14 -0800 (PST)
Date:   Fri, 21 Jan 2022 08:25:12 -0700
From:   dann frazier <dann.frazier@canonical.com>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     airlied@redhat.com, daniel@ffwll.ch, kraxel@redhat.com,
        sam@ravnborg.org, emil.velikov@collabora.com, cogarre@gmail.com,
        dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@vger.kernel.org
Subject: Re: [PATCH v3] drm/ast: Don't check new mode if CRTC is being
 disabled
Message-ID: <YerQWPxMNYV+zOSG@xps13.dannf>
References: <20200507090640.21561-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507090640.21561-1-tzimmermann@suse.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 07, 2020 at 11:06:40AM +0200, Thomas Zimmermann wrote:
> Suspending failed because there's no mode if the CRTC is being
> disabled. Early-out in this case. This fixes runtime PM for ast.
> 
> v3:
> 	* fixed commit message
> v2:
> 	* added Tested-by/Reported-by tags
> 	* added Fixes tags and CC (Sam)
> 	* improved comment
> 
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Reported-by: Cary Garrett <cogarre@gmail.com>
> Tested-by: Cary Garrett <cogarre@gmail.com>
> Fixes: b48e1b6ffd28 ("drm/ast: Add CRTC helpers for atomic modesetting")
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: Gerd Hoffmann <kraxel@redhat.com>
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: <stable@vger.kernel.org> # v5.6+
> ---
>  drivers/gpu/drm/ast/ast_mode.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_mode.c
> index 7a9f20a2fd303..0cbbb21edb4e1 100644
> --- a/drivers/gpu/drm/ast/ast_mode.c
> +++ b/drivers/gpu/drm/ast/ast_mode.c
> @@ -801,6 +801,9 @@ static int ast_crtc_helper_atomic_check(struct drm_crtc *crtc,
>  		return -EINVAL;
>  	}
>  
> +	if (!state->enable)
> +		return 0; /* no mode checks if CRTC is being disabled */
> +
>  	ast_state = to_ast_crtc_state(state);
>  
>  	format = ast_state->format;

hey,
  I'm seeing a regression that I bisected down to this change. I
installed GNOME on a couple of different server models that have
AMI-based BMCs, which provide a web-based graphics display (virtual
KVM). When I enter the lock screen on current upstream kernels, the
display freezes, and I see the following messages appear in syslog
whenever I generate keyboard/mouse events on that display:

Jan 19 20:34:53 starbuck gnome-shell[5002]: Failed to post KMS update: drmModeAtomicCommit: Invalid argument
Jan 19 20:34:53 starbuck gnome-shell[5002]: Page flip discarded: drmModeAtomicCommit: Invalid argument
Jan 19 20:34:53 starbuck gnome-shell[5002]: Failed to post KMS update: drmModeAtomicCommit: Invalid argument
Jan 19 20:34:53 starbuck gnome-shell[5002]: Page flip discarded: drmModeAtomicCommit: Invalid argument
Jan 19 20:34:53 starbuck gnome-shell[5002]: Failed to post KMS update: drmModeAtomicCommit: Invalid argument
Jan 19 20:34:53 starbuck gnome-shell[5002]: Page flip discarded: drmModeAtomicCommit: Invalid argument
Jan 19 20:34:53 starbuck gnome-shell[5002]: Failed to post KMS update: drmModeAtomicCommit: Invalid argument

If I back out this change w/ the following patch (code has evolved
slightly preventing a clean revert), then the lock screen once again
behaves normally:

diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_mode.c
index 956c8982192b..336c545c46f5 100644
--- a/drivers/gpu/drm/ast/ast_mode.c
+++ b/drivers/gpu/drm/ast/ast_mode.c
@@ -1012,9 +1012,6 @@ static int ast_crtc_helper_atomic_check(struct drm_crtc *crtc,
 	const struct drm_format_info *format;
 	bool succ;
 
-	if (!crtc_state->enable)
-		return 0; /* no mode checks if CRTC is being disabled */
-
 	ast_state = to_ast_crtc_state(crtc_state);
 
 	format = ast_state->format;


Apologies for noticing so long after the fact. I don't normally run a
desktop environment on these servers, I just happened to be debugging
something recently that required it.

  -dann
