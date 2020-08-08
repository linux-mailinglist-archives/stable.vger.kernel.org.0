Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D35123F706
	for <lists+stable@lfdr.de>; Sat,  8 Aug 2020 11:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbgHHJOG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 05:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725786AbgHHJOG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Aug 2020 05:14:06 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1D0C061756
        for <stable@vger.kernel.org>; Sat,  8 Aug 2020 02:14:06 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id 93so3517521otx.2
        for <stable@vger.kernel.org>; Sat, 08 Aug 2020 02:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=24P2R3iVcnrOVSSenxctB0reUXuzwiMFeIzgtckdjnQ=;
        b=VZSTvPMQ/yzY43GMEjA309dZbKPoB3JrUdztqdlcNbwoJaGz+ONoR61ClxJZIZ7QY2
         XwOF/TMFs8OiiBRZsDvhLx8mHzmUGLdg593ZF1G91m9Hntlt8YpjAhqGJDAnGmGey2zJ
         SU6xWgjIGDzJ4YXg42NlXo+Q4/Lt/pUdOSoYw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=24P2R3iVcnrOVSSenxctB0reUXuzwiMFeIzgtckdjnQ=;
        b=JoLLHUKRbqVUnDECJDUAFRP0jIWLBNpU2JUY+49AjALI319yA3yvDCVHR/kiF0Gws4
         LxIPeNVMmarSRtxVcRdHNIPiUuqlWX3P70USyXaq2/Ox7k+bDSLmste5fJl43finOu37
         Ro6LNZA03bT4EZgvo8JCBSEv1ANDAt6FMmfEO7EoVDnfN8HWFOY11nfoMLU359tT8/Cs
         tKutV2HjWfrD7Japq8RuhmJwvl/9JZJxcmn0iTZFFCGBpvmi3H+wNb09F5z+/01UqEoT
         BU8+ymuKjbRp/Q3oUTxKfT+l8eJUtbwZJaNxTSGvjD8ci6JESQkKybFpD6ACJdXZSLWe
         +usg==
X-Gm-Message-State: AOAM533h7ttSpNCc6Fji+/vLhr2pxliNBcv+vKgOYHYupk01EEGSdjek
        an6L1q2lMeYyAd/exCNttMzczUv22cnP/+jMdyJc/CIZ
X-Google-Smtp-Source: ABdhPJxnWgfizsjj2THY4MKb14jO/HbFHZNuM2TlbFDBt1XKYCwRXHRBhJ81bYE6Zmsl3WU7PcdVDZxCGjY8iqXmbAc=
X-Received: by 2002:a9d:7283:: with SMTP id t3mr14613601otj.303.1596878045298;
 Sat, 08 Aug 2020 02:14:05 -0700 (PDT)
MIME-Version: 1.0
References: <159680700523135@kroah.com> <a92e73b9-c3da-76f6-9405-b2456fe68ce6@suse.de>
In-Reply-To: <a92e73b9-c3da-76f6-9405-b2456fe68ce6@suse.de>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Sat, 8 Aug 2020 11:13:54 +0200
Message-ID: <CAKMK7uFJVzm1avAOZd0kPAzRUQkTQv3LtrjafjpjXh4K8TaAHg@mail.gmail.com>
Subject: Re: WTF: patch "[PATCH] drm/mgag200: Remove declaration of
 mgag200_mmap() from header" was seriously submitted to be applied to the
 5.8-stable tree?
To:     Thomas Zimmermann <tzimmermann@suse.de>,
        dri-devel <dri-devel@lists.freedesktop.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Dave Airlie <airlied@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>, armijn@tjaldur.nl,
        Emil Velikov <emil.velikov@collabora.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        =?UTF-8?Q?Noralf_Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        stable <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 7, 2020 at 3:54 PM Thomas Zimmermann <tzimmermann@suse.de> wrot=
e:
>
> Hi
>
> Am 07.08.20 um 15:30 schrieb gregkh@linuxfoundation.org:
> > The patch below was submitted to be applied to the 5.8-stable tree.
> >
> > I fail to see how this patch meets the stable kernel rules as found at
> > Documentation/process/stable-kernel-rules.rst.
> >
> > I could be totally wrong, and if so, please respond to
> > <stable@vger.kernel.org> and let me know why this patch should be
> > applied.  Otherwise, it is now dropped from my patch queues, never to b=
e
> > seen again.
>
> Sorry for the noise. There's no reason this should go into stable.

We have a little script in our maintainer toolbox for bugfixes, which
generates the Fixes: line, adds everyone from the original commit to
the cc: list and also adds Cc: stable if that sha1 the patch fixes is
in a release already.

I guess we trained people a bit too much on using Fixes: tags like
that with the tooling, since they often do that for checkpatch stuff
and spelling fixes like this here too. I think the autoselect bot also
loves Fixes: tags a bit too much for its own good.

Not sure what to do, since telling people to "please sprinkle less
Fixes: tags" doesn't sound great either. I also don't want to tell
people to use the maintainer toolbox less, the autogenerated cc: list
is generally the right thing to do. Maybe best if the stable team
catches the obvious ones before adding them to the stable queue, if
you're ok with that Greg?

Also adding dri-devel here in case this becomes a bigger discussion.

Cheers, Daniel

>
> Best regards
> Thomas
>
> >
> > thanks,
> >
> > greg k-h
> >
> > ------------------ original commit in Linus's tree ------------------
> >
> > From 1d8d42ba365101fa68d210c0e2ed2bc9582fda6c Mon Sep 17 00:00:00 2001
> > From: Thomas Zimmermann <tzimmermann@suse.de>
> > Date: Fri, 5 Jun 2020 15:57:50 +0200
> > Subject: [PATCH] drm/mgag200: Remove declaration of mgag200_mmap() from=
 header
> >  file
> > MIME-Version: 1.0
> > Content-Type: text/plain; charset=3DUTF-8
> > Content-Transfer-Encoding: 8bit
> >
> > Commit 94668ac796a5 ("drm/mgag200: Convert mgag200 driver to VRAM MM")
> > removed the implementation of mgag200_mmap(). Also remove the declarati=
on.
> >
> > Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> > Acked-by: Sam Ravnborg <sam@ravnborg.org>
> > Fixes: 94668ac796a5 ("drm/mgag200: Convert mgag200 driver to VRAM MM")
> > Cc: Gerd Hoffmann <kraxel@redhat.com>
> > Cc: Dave Airlie <airlied@redhat.com>
> > Cc: Krzysztof Kozlowski <krzk@kernel.org>
> > Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> > Cc: Sam Ravnborg <sam@ravnborg.org>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: "Noralf Tr=C3=B8nnes" <noralf@tronnes.org>
> > Cc: Armijn Hemel <armijn@tjaldur.nl>
> > Cc: Alex Deucher <alexander.deucher@amd.com>
> > Cc: Emil Velikov <emil.velikov@collabora.com>
> > Cc: <stable@vger.kernel.org> # v5.3+
> > Link: https://patchwork.freedesktop.org/patch/msgid/20200605135803.1981=
1-2-tzimmermann@suse.de
> >
> > diff --git a/drivers/gpu/drm/mgag200/mgag200_drv.h b/drivers/gpu/drm/mg=
ag200/mgag200_drv.h
> > index 47df62b1ad29..92b6679029fe 100644
> > --- a/drivers/gpu/drm/mgag200/mgag200_drv.h
> > +++ b/drivers/gpu/drm/mgag200/mgag200_drv.h
> > @@ -198,6 +198,5 @@ void mgag200_i2c_destroy(struct mga_i2c_chan *i2c);
> >
> >  int mgag200_mm_init(struct mga_device *mdev);
> >  void mgag200_mm_fini(struct mga_device *mdev);
> > -int mgag200_mmap(struct file *filp, struct vm_area_struct *vma);
> >
> >  #endif                               /* __MGAG200_DRV_H__ */
> >
>
> --
> Thomas Zimmermann
> Graphics Driver Developer
> SUSE Software Solutions Germany GmbH
> Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
> (HRB 36809, AG N=C3=BCrnberg)
> Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer
>


--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
