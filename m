Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 348416D7B7E
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 13:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236967AbjDELiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 07:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236449AbjDELiP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 07:38:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B6D1BD7
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 04:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680694649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TqQ80Zxc7TIJSa7ZvAwt9oQmNHqtPUMz0WDZ7JjmvKo=;
        b=HvVu/F0RX+jHa2h3xBlPJQd/jndvb/uNtjYf4tO2k3cBfXie3Xkdc6ZSTSSdKvN4YrhLfi
        jg5qrgjbWZFT+hCgnd4lak0gfh78toNNIy2joZM1R3PUgnbaBUvmFsXJxPm/4wpP6wv9oH
        8TjCLigbzyjSJegec+g56GUAoAnht9g=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-75-ZZbJoBOiOn6s4qMGDKJBZA-1; Wed, 05 Apr 2023 07:37:28 -0400
X-MC-Unique: ZZbJoBOiOn6s4qMGDKJBZA-1
Received: by mail-wm1-f70.google.com with SMTP id m7-20020a05600c4f4700b003ee7e120bdfso17021931wmq.6
        for <stable@vger.kernel.org>; Wed, 05 Apr 2023 04:37:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680694647;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TqQ80Zxc7TIJSa7ZvAwt9oQmNHqtPUMz0WDZ7JjmvKo=;
        b=vG/8kHEX9TeRX8bBtDwE+8O04/2YTd0oh2Izv01QDw4F8sVIz1L3Ntc5ocb38bSw1W
         yQEGm0JUSzbs/qigF7LLwKpt1eEoQ3CQJc4V/Dy4tAilUTgBLLonoM+P1BsbTFxSxawK
         Q5a75VXMj8pHJTC0VLDOSg/7+zwQFgRO8SRaOF5z12jVqnwB4nSnxyibuViHfaE4lVP8
         +gwHdSCwZmCjGHC3M9d8c1tjihvQ2FEZTryDeWlUQn8qXod168bhAMlhiJOySgcN8joo
         mX7eJTHl5ZuYTovjNA+6xav4CHPZVuFVRr3KcO5s07I9E92uSKOo0DYwftgDZfPUkre+
         BY+A==
X-Gm-Message-State: AAQBX9czSzmHHIAXn50N46bPsm2/5gKboY9sVZoJ4XT9aRZeYyy8hn1f
        6r0PV/KsQ/Sf4lBWYN9wmmEw3NRCwJBfwqijr6+tb7cgT+tRs8d4xgSD37KJ6YSjj/qjyn8PVmg
        q34HHNzwMSlrpunne
X-Received: by 2002:a05:600c:211a:b0:3f0:44f1:9714 with SMTP id u26-20020a05600c211a00b003f044f19714mr4526859wml.30.1680694647325;
        Wed, 05 Apr 2023 04:37:27 -0700 (PDT)
X-Google-Smtp-Source: AKy350ap/kJBMaVXiTkEpHLntbqdMO6Me8Kx2LSJWWjtkpOBf7LVwv76PkfSXSEo1lOs2BLcmmPlJA==
X-Received: by 2002:a05:600c:211a:b0:3f0:44f1:9714 with SMTP id u26-20020a05600c211a00b003f044f19714mr4526835wml.30.1680694646990;
        Wed, 05 Apr 2023 04:37:26 -0700 (PDT)
Received: from localhost (205.pool92-176-231.dynamic.orange.es. [92.176.231.205])
        by smtp.gmail.com with ESMTPSA id k20-20020a7bc414000000b003ee1b2ab9a0sm1934447wmi.11.2023.04.05.04.37.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 04:37:26 -0700 (PDT)
From:   Javier Martinez Canillas <javierm@redhat.com>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Aaron Plattner <aplattner@nvidia.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Helge Deller <deller@gmx.de>, Sam Ravnborg <sam@ravnborg.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 7/8] video/aperture: Only remove sysfb on the default
 vga pci device
In-Reply-To: <20230404201842.567344-7-daniel.vetter@ffwll.ch>
References: <20230404201842.567344-1-daniel.vetter@ffwll.ch>
 <20230404201842.567344-7-daniel.vetter@ffwll.ch>
Date:   Wed, 05 Apr 2023 13:37:25 +0200
Message-ID: <87pm8iblvu.fsf@minerva.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Daniel Vetter <daniel.vetter@ffwll.ch> writes:

> Instead of calling aperture_remove_conflicting_devices() to remove the
> conflicting devices, just call to aperture_detach_devices() to detach
> the device that matches the same PCI BAR / aperture range. Since the
> former is just a wrapper of the latter plus a sysfb_disable() call,
> and now that's done in this function but only for the primary devices.
>
> This fixes a regression introduced by ee7a69aa38d8 ("fbdev: Disable
> sysfb device registration when removing conflicting FBs"), where we
> remove the sysfb when loading a driver for an unrelated pci device,
> resulting in the user loosing their efifb console or similar.
>
> Note that in practice this only is a problem with the nvidia blob,
> because that's the only gpu driver people might install which does not
> come with an fbdev driver of it's own. For everyone else the real gpu
> driver will restore a working console.
>
> Also note that in the referenced bug there's confusion that this same
> bug also happens on amdgpu. But that was just another amdgpu specific
> regression, which just happened to happen at roughly the same time and
> with the same user-observable symptoms. That bug is fixed now, see
> https://bugzilla.kernel.org/show_bug.cgi?id=216331#c15
>
> Note that we should not have any such issues on non-pci multi-gpu
> issues, because I could only find two such cases:
> - SoC with some external panel over spi or similar. These panel
>   drivers do not use drm_aperture_remove_conflicting_framebuffers(),
>   so no problem.
> - vga+mga, which is a direct console driver and entirely bypasses all
>   this.
>
> For the above reasons the cc: stable is just notionally, this patch
> will need a backport and that's up to nvidia if they care enough.
>
> v2:
> - Explain a bit better why other multi-gpu that aren't pci shouldn't
>   have any issues with making all this fully pci specific.
>
> v3
> - polish commit message (Javier)
>
> Fixes: ee7a69aa38d8 ("fbdev: Disable sysfb device registration when removing conflicting FBs")
> Tested-by: Aaron Plattner <aplattner@nvidia.com>
> Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
> References: https://bugzilla.kernel.org/show_bug.cgi?id=216303#c28
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> Cc: Aaron Plattner <aplattner@nvidia.com>
> Cc: Javier Martinez Canillas <javierm@redhat.com>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: Helge Deller <deller@gmx.de>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: <stable@vger.kernel.org> # v5.19+ (if someone else does the backport)
> ---
>  drivers/video/aperture.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)

Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>

-- 
Best regards,

Javier Martinez Canillas
Core Platforms
Red Hat

