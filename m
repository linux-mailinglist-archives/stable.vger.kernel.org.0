Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 001D95BE515
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 13:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbiITL7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 07:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbiITL7i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 07:59:38 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C4426F1;
        Tue, 20 Sep 2022 04:59:36 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id u9so5562555ejy.5;
        Tue, 20 Sep 2022 04:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=SC6OE5NQVppkG8ec1Bn2cJrZ5JuNfZEXXEVMq2fc1nE=;
        b=JKiXlIOjQWrVZIt6TBVBA2nvdwgBofVoLbO9nChl0L1nJmnQnVvoFMPaYj9pyzFfqN
         +VdavKa4O35l7pCZ1T30sp1fy7+7uq1lZ8xmU3DvhiKklC7z1EKF1h1N9ufcSRA9yTAy
         /yAY+9iOqKKxZuTfCPqw+MoWCpkCOHsK0zFS2/9hcmYHm3QH+ZiOSnEyNDDdEP2VCN2j
         HBtobpikJXKpItUjrAiYMuneZYdCHZueqx9rwfmUjhiuYBfk6oSCEF26CyEQ5c1SC4Kc
         wWiSdEE8oX/PTWKPfzVl6KowR8XaIgwisR2EVJgRi2Vpa0N3AEZLuStiH9nkMSE32Q8Z
         NHnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=SC6OE5NQVppkG8ec1Bn2cJrZ5JuNfZEXXEVMq2fc1nE=;
        b=TRrgHkZlx9ZCajy1dERBdJHsR60oSH60TdxU7p3PVC5tIqvgWhtiewyCh+vjWJeQLP
         bP7M2M95Rk5PiWYkVAqe11dPyOcXZy43/gq6rIItj35zKoOJM6J9IeCyJkalxqw3J/jX
         7+u4GOWNzbI8naJx3ObonJgWTegO8jTUYOJQ0tNKxQ0/jNWMdsLXgEAf0f5qAKcZxYHA
         Aj6FWIHNlLInKo2wTYvF9Gz+QAw5LgBhMAjOZs3+0inPpmEbOzO93q8f+K9N7TEmeEE3
         iFpHe7BACExoyjHQm1mHHGGuCd/CTfhkRPzdoUSNfhaDfh/+mJO4Dfo6nGY4HXtxmI77
         dxqA==
X-Gm-Message-State: ACrzQf1w7yeM+croD4UvsvVaLZnwe/pCex+ZvrG6+fn9jzm2h99Ukbhv
        B73di/9TuEpaUtqYm20+kbjnkJsmFpnxxQ==
X-Google-Smtp-Source: AMsMyM5XZEcTzipjvNCPeZLjA+G0dWoNeLLNjY91MsM3cfvxahrH2M9ghnXEdTaBdeBhYgVRR0rRWQ==
X-Received: by 2002:a17:907:2d0b:b0:77c:68a8:a47 with SMTP id gs11-20020a1709072d0b00b0077c68a80a47mr16789733ejc.473.1663675174834;
        Tue, 20 Sep 2022 04:59:34 -0700 (PDT)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id 17-20020a170906211100b0073ddb2eff27sm714916ejt.167.2022.09.20.04.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 04:59:34 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
        id 1E80DBE356D; Tue, 20 Sep 2022 13:59:33 +0200 (CEST)
Date:   Tue, 20 Sep 2022 13:59:33 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Karol Herbst <kherbst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Lyude Paul <lyude@redhat.com>, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, stable@vger.kernel.org,
        Computer Enthusiastic <computer.enthusiastic@gmail.com>
Subject: Re: [PATCH] nouveau: explicitly wait on the fence in
 nouveau_bo_move_m2mf
Message-ID: <YymrJSfXe4LaXmkA@eldamar.lan>
References: <20220819200928.401416-1-kherbst@redhat.com>
 <YymY+3+C2aI7T3GU@eldamar.lan>
 <CACO55ts7rpbyYv3ovWt1iCfkGsChCUVitmHqtzAwFpfbPEZGYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACO55ts7rpbyYv3ovWt1iCfkGsChCUVitmHqtzAwFpfbPEZGYQ@mail.gmail.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Tue, Sep 20, 2022 at 01:36:32PM +0200, Karol Herbst wrote:
> On Tue, Sep 20, 2022 at 12:42 PM Salvatore Bonaccorso <carnil@debian.org> wrote:
> >
> > Hi,
> >
> > On Fri, Aug 19, 2022 at 10:09:28PM +0200, Karol Herbst wrote:
> > > It is a bit unlcear to us why that's helping, but it does and unbreaks
> > > suspend/resume on a lot of GPUs without any known drawbacks.
> > >
> > > Cc: stable@vger.kernel.org # v5.15+
> > > Closes: https://gitlab.freedesktop.org/drm/nouveau/-/issues/156
> > > Signed-off-by: Karol Herbst <kherbst@redhat.com>
> > > ---
> > >  drivers/gpu/drm/nouveau/nouveau_bo.c | 9 +++++++++
> > >  1 file changed, 9 insertions(+)
> > >
> > > diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
> > > index 35bb0bb3fe61..126b3c6e12f9 100644
> > > --- a/drivers/gpu/drm/nouveau/nouveau_bo.c
> > > +++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
> > > @@ -822,6 +822,15 @@ nouveau_bo_move_m2mf(struct ttm_buffer_object *bo, int evict,
> > >               if (ret == 0) {
> > >                       ret = nouveau_fence_new(chan, false, &fence);
> > >                       if (ret == 0) {
> > > +                             /* TODO: figure out a better solution here
> > > +                              *
> > > +                              * wait on the fence here explicitly as going through
> > > +                              * ttm_bo_move_accel_cleanup somehow doesn't seem to do it.
> > > +                              *
> > > +                              * Without this the operation can timeout and we'll fallback to a
> > > +                              * software copy, which might take several minutes to finish.
> > > +                              */
> > > +                             nouveau_fence_wait(fence, false, false);
> > >                               ret = ttm_bo_move_accel_cleanup(bo,
> > >                                                               &fence->base,
> > >                                                               evict, false,
> > > --
> > > 2.37.1
> > >
> > >
> >
> > While this is marked for 5.15+ only, a user in Debian was seeing the
> > suspend issue as well on 5.10.y and did confirm the commit fixes the
> > issue as well in the 5.10.y series:
> >
> > https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=989705#69
> >
> > Karol, Lyude, should that as well be picked for 5.10.y?
> >
> 
> mhh from the original report 5.10 was fine, but maybe something got
> backported and it broke it? I'll try to do some testing on my machine
> and see what I can figure out, but it could also be a debian only
> issue at this point.

Right, this is a possiblity, thanks for looking into it!

Computer Enthusiastic, can you verify the problem as well in a
non-Debian patched upstream kernel directly from the 5.10.y series
(latest 5.10.144) and verify the fix there?

Regards,
Salvatore
