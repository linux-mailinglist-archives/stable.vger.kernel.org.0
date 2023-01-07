Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF1C660B6A
	for <lists+stable@lfdr.de>; Sat,  7 Jan 2023 02:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbjAGBV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 20:21:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232821AbjAGBVZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 20:21:25 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A4C9FFA
        for <stable@vger.kernel.org>; Fri,  6 Jan 2023 17:21:23 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id l1-20020a17090a384100b00226f05b9595so1571381pjf.0
        for <stable@vger.kernel.org>; Fri, 06 Jan 2023 17:21:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fGp7XQc2VGbBDxiW6oPsPSq8rd+Pp+GUF89FSmtguMY=;
        b=ctHCqkF8lWWCEMvSMP9SB71dYd2YSRUg9u4uNjoTKAZOuhG9kNvAcXTqwBn8Pl6rDm
         o/rzUuIRcux5YaDdSV5Ygdm16fu+ymgygpIhROQBk1CdYiXLc6BAV0oHyT4CP24tQoAP
         BJLKuFdc8n/R4v9FAHU85MgPACIAHu0IsRGws=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fGp7XQc2VGbBDxiW6oPsPSq8rd+Pp+GUF89FSmtguMY=;
        b=Uq/vPFH7A7XdhpRs+BKzTzzI2O5xaYJ3/fCs3p0bMaq42PA53y7o+4Sj5P1HsqxrYs
         yj9rEm18GlAt5GX66U34Ku4lQzJTjpcNmtze6ceXyXjfqNb8gHXOD+1LZgVNsZYjuQpm
         gIxfVyNUpQ9RfvOvaVOGiz2WPHiv4uaOV5F7N0h1UNAQtXqCdqtZk05/k43Zci/ISTNg
         rMmvNFAJyil8aCCWZkawTh+Idd+sP5emwop1iVOeCzdZNAbwQRMUXOxFqf1RxBqkgZ5C
         g6ytfrAyuub9aPQwxCAXd+dowE+Mdjo/BOOsJAGtdQ1PHhPU1aDAyOGBD9GGZKiKvLbD
         ZMAg==
X-Gm-Message-State: AFqh2kqSRje8TeNj93C+QGXk4ERNVAwWDt7h/t3Xm808l7eIrdL7UBdo
        h7wN07E6R+i3LaEI4rkp7yBFig==
X-Google-Smtp-Source: AMrXdXucd5QiL3Gpmu1dQs5wApEskRuwAtx0qubwZvtkLbZyghXUapggu1smjFX+LjoGpUNSoGZhlw==
X-Received: by 2002:a17:902:e354:b0:192:6aa8:e3d8 with SMTP id p20-20020a170902e35400b001926aa8e3d8mr46653793plc.28.1673054482918;
        Fri, 06 Jan 2023 17:21:22 -0800 (PST)
Received: from google.com ([2620:15c:9d:2:bc4e:2cc9:68b3:15dc])
        by smtp.gmail.com with ESMTPSA id m7-20020a170902db0700b00192b0a07891sm1545055plx.101.2023.01.06.17.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 17:21:22 -0800 (PST)
Date:   Fri, 6 Jan 2023 17:21:19 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     Michel =?iso-8859-1?Q?D=E4nzer?= <michel.daenzer@mailbox.org>
Cc:     Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Sean Paul <seanpaul@chromium.org>,
        "kernelci.org bot" <bot@kernelci.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Sandy Huang <hjc@rock-chips.com>,
        linux-rockchip@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] drm/rockchip: vop: Leave vblank enabled in
 self-refresh
Message-ID: <Y7jJDw4RcNceyLbR@google.com>
References: <20230105174001.1.I3904f697863649eb1be540ecca147a66e42bfad7@changeid>
 <20230105174001.2.Ic07cba4ab9a7bd3618a9e4258b8f92ea7d10ae5a@changeid>
 <9455bc5b-2074-4f48-71a7-5c816ee19a78@mailbox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9455bc5b-2074-4f48-71a7-5c816ee19a78@mailbox.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 06, 2023 at 12:42:54PM +0100, Michel Dänzer wrote:
> On 1/6/23 02:40, Brian Norris wrote:
> > --- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
> > +++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
> > @@ -719,11 +719,11 @@ static void vop_crtc_atomic_disable(struct drm_crtc *crtc,
> >  
> >  	mutex_lock(&vop->vop_lock);
> >  
> > -	drm_crtc_vblank_off(crtc);
> > -
> >  	if (crtc->state->self_refresh_active)
> >  		goto out;
> >  
> > +	drm_crtc_vblank_off(crtc);
> > +
> >  	/*
> >  	 * Vop standby will take effect at end of current frame,
> >  	 * if dsp hold valid irq happen, it means standby complete.
> 
> The out label immediately unlocks vop->vop_lock again, seems a bit pointless. :)

Oops, of course. Will change that in v2.

> AFAICT the self_refresh_active case should just return immediately,
> the out label would also send any pending atomic commit completion
> event, which seems wrong now that the vblank interrupt is left
> enabled.

If I return immediately and drop that completion, I hit a warning:

[    4.423876] WARNING: CPU: 5 PID: 58 at drivers/gpu/drm/drm_atomic_helper.c:2460 drm_atomic_helper_commit_hw_done+0xe0/0xe8
...
[    4.424036] Call trace:
[    4.424039]  drm_atomic_helper_commit_hw_done+0xe0/0xe8
[    4.424045]  drm_atomic_helper_commit_tail_rpm+0x58/0x7c
...

I plan to leave it as-is for v2.

> (I also wonder if drm_crtc_vblank_off doesn't take care of
> that already, at least amdgpu doesn't do this explicitly AFAICT)

I'm not sure.

Brian
