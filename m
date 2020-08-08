Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF4A23F71C
	for <lists+stable@lfdr.de>; Sat,  8 Aug 2020 11:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbgHHJhP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 05:37:15 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:49286 "EHLO
        asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgHHJhP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Aug 2020 05:37:15 -0400
Received: from ravnborg.org (unknown [188.228.123.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by asavdk3.altibox.net (Postfix) with ESMTPS id F3DEC20021;
        Sat,  8 Aug 2020 11:37:09 +0200 (CEST)
Date:   Sat, 8 Aug 2020 11:37:08 +0200
From:   Sam Ravnborg <sam@ravnborg.org>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     Thomas Zimmermann <tzimmermann@suse.de>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Dave Airlie <airlied@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>, armijn@tjaldur.nl,
        Emil Velikov <emil.velikov@collabora.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Noralf =?iso-8859-1?Q?Tr=F8nnes?= <noralf@tronnes.org>,
        stable <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: WTF: patch "[PATCH] drm/mgag200: Remove declaration of
 mgag200_mmap() from header" was seriously submitted to be applied to the
 5.8-stable tree?
Message-ID: <20200808093708.GA14702@ravnborg.org>
References: <159680700523135@kroah.com>
 <a92e73b9-c3da-76f6-9405-b2456fe68ce6@suse.de>
 <CAKMK7uFJVzm1avAOZd0kPAzRUQkTQv3LtrjafjpjXh4K8TaAHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKMK7uFJVzm1avAOZd0kPAzRUQkTQv3LtrjafjpjXh4K8TaAHg@mail.gmail.com>
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=f+hm+t6M c=1 sm=1 tr=0
        a=S6zTFyMACwkrwXSdXUNehg==:117 a=S6zTFyMACwkrwXSdXUNehg==:17
        a=8nJEP1OIZ-IA:10 a=ag1SF4gXAAAA:8 a=VwQbUJbxAAAA:8 a=7gkXJVJtAAAA:8
        a=20KFwNOVAAAA:8 a=SJz97ENfAAAA:8 a=zd2uoN0lAAAA:8 a=QX4gbG5DAAAA:8
        a=e5mUnYsNAAAA:8 a=25-AhOLfAAAA:8 a=EzpU4EXsebg0j6g3O_gA:9
        a=wPNLvfGTeEIA:10 a=HUqATDVKn4QA:10 a=Yupwre4RP9_Eg_Bd0iYG:22
        a=AjGcO6oz07-iQ99wixmX:22 a=E9Po1WZjFZOl8hwRPBS3:22
        a=vFet0B0WnEQeilDPIY6i:22 a=AbAUZ8qAyYyZVLSsDulk:22
        a=Vxmtnl_E_bksehYqCbjh:22 a=dnuY3_Gu-P7Vi9ynLKQe:22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Daniel.

On Sat, Aug 08, 2020 at 11:13:54AM +0200, Daniel Vetter wrote:
> On Fri, Aug 7, 2020 at 3:54 PM Thomas Zimmermann <tzimmermann@suse.de> wrote:
> >
> > Hi
> >
> > Am 07.08.20 um 15:30 schrieb gregkh@linuxfoundation.org:
> > > The patch below was submitted to be applied to the 5.8-stable tree.
> > >
> > > I fail to see how this patch meets the stable kernel rules as found at
> > > Documentation/process/stable-kernel-rules.rst.
> > >
> > > I could be totally wrong, and if so, please respond to
> > > <stable@vger.kernel.org> and let me know why this patch should be
> > > applied.  Otherwise, it is now dropped from my patch queues, never to be
> > > seen again.
> >
> > Sorry for the noise. There's no reason this should go into stable.
> 
> We have a little script in our maintainer toolbox for bugfixes, which
> generates the Fixes: line, adds everyone from the original commit to
> the cc: list and also adds Cc: stable if that sha1 the patch fixes is
> in a release already.
> 
> I guess we trained people a bit too much on using Fixes: tags like
> that with the tooling, since they often do that for checkpatch stuff
> and spelling fixes like this here too. I think the autoselect bot also
> loves Fixes: tags a bit too much for its own good.
> 
> Not sure what to do, since telling people to "please sprinkle less
> Fixes: tags" doesn't sound great either.

We know that at lot of the drm people uses "dim fixes".
So maybe teach them a litte here?

diff --git a/dim b/dim
index e4f4d2e..d4fd310 100755
--- a/dim
+++ b/dim
@@ -2428,6 +2428,10 @@ function dim_fixes
 
 	sha1=${1:?$usage}
 
+	echo ""
+	echo "Note: Patch must meet the stable-kernel-rules criterias (Documentation/process/stable-kernel-rules.rst)"
+	echo ""
+
 	cd $DIM_PREFIX/$DIM_REPO
 	echo "Fixes: $(dim_cite $sha1)"
 

Output would then look like this:

$ dim fixes 1d8d42ba365101fa68d210c0e2ed2bc9582fda6c

Note: Patch must meet the stable-kernel-rules criterias (Documentation/process/stable-kernel-rules.rst)

Fixes: 1d8d42ba3651 ("drm/mgag200: Remove declaration of mgag200_mmap() from header file")
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Noralf Trønnes" <noralf@tronnes.org>
Cc: Armijn Hemel <armijn@tjaldur.nl>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Emil Velikov <emil.velikov@collabora.com>
Cc: <stable@vger.kernel.org> # v5.3+
Cc: Lyude Paul <lyude@redhat.com>

No guarantee that people will look up the rules outlined in
stable-kernel-rules.rst - but at least a reminder.

	Sam

> I also don't want to tell
> people to use the maintainer toolbox less, the autogenerated cc: list
> is generally the right thing to do. Maybe best if the stable team
> catches the obvious ones before adding them to the stable queue, if
> you're ok with that Greg?
> 
> Also adding dri-devel here in case this becomes a bigger discussion.
> 
> Cheers, Daniel
> 
> >
> > Best regards
> > Thomas
> >
> > >
> > > thanks,
> > >
> > > greg k-h
> > >
> > > ------------------ original commit in Linus's tree ------------------
> > >
> > > From 1d8d42ba365101fa68d210c0e2ed2bc9582fda6c Mon Sep 17 00:00:00 2001
> > > From: Thomas Zimmermann <tzimmermann@suse.de>
> > > Date: Fri, 5 Jun 2020 15:57:50 +0200
> > > Subject: [PATCH] drm/mgag200: Remove declaration of mgag200_mmap() from header
> > >  file
> > > MIME-Version: 1.0
> > > Content-Type: text/plain; charset=UTF-8
> > > Content-Transfer-Encoding: 8bit
> > >
> > > Commit 94668ac796a5 ("drm/mgag200: Convert mgag200 driver to VRAM MM")
> > > removed the implementation of mgag200_mmap(). Also remove the declaration.
> > >
> > > Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> > > Acked-by: Sam Ravnborg <sam@ravnborg.org>
> > > Fixes: 94668ac796a5 ("drm/mgag200: Convert mgag200 driver to VRAM MM")
> > > Cc: Gerd Hoffmann <kraxel@redhat.com>
> > > Cc: Dave Airlie <airlied@redhat.com>
> > > Cc: Krzysztof Kozlowski <krzk@kernel.org>
> > > Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> > > Cc: Sam Ravnborg <sam@ravnborg.org>
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: "Noralf Trønnes" <noralf@tronnes.org>
> > > Cc: Armijn Hemel <armijn@tjaldur.nl>
> > > Cc: Alex Deucher <alexander.deucher@amd.com>
> > > Cc: Emil Velikov <emil.velikov@collabora.com>
> > > Cc: <stable@vger.kernel.org> # v5.3+
> > > Link: https://patchwork.freedesktop.org/patch/msgid/20200605135803.19811-2-tzimmermann@suse.de
> > >
> > > diff --git a/drivers/gpu/drm/mgag200/mgag200_drv.h b/drivers/gpu/drm/mgag200/mgag200_drv.h
> > > index 47df62b1ad29..92b6679029fe 100644
> > > --- a/drivers/gpu/drm/mgag200/mgag200_drv.h
> > > +++ b/drivers/gpu/drm/mgag200/mgag200_drv.h
> > > @@ -198,6 +198,5 @@ void mgag200_i2c_destroy(struct mga_i2c_chan *i2c);
> > >
> > >  int mgag200_mm_init(struct mga_device *mdev);
> > >  void mgag200_mm_fini(struct mga_device *mdev);
> > > -int mgag200_mmap(struct file *filp, struct vm_area_struct *vma);
> > >
> > >  #endif                               /* __MGAG200_DRV_H__ */
> > >
> >
> > --
> > Thomas Zimmermann
> > Graphics Driver Developer
> > SUSE Software Solutions Germany GmbH
> > Maxfeldstr. 5, 90409 Nürnberg, Germany
> > (HRB 36809, AG Nürnberg)
> > Geschäftsführer: Felix Imendörffer
> >
> 
> 
> -- 
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch
