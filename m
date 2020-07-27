Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B4E22F7C7
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 20:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbgG0Scx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 14:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728313AbgG0Scx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 14:32:53 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12EB9C061794
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 11:32:53 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id y22so15149364oie.8
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 11:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wg3zwqBeUuNoJaILsloi5u/NbFFAAVUZUa5+v+OHsRg=;
        b=X/OMRxI78sOrX6By7O57Jh21nMM06U02gC+l0+D2eVTYFnJaurdh4wrBv/mdKKKaHd
         bcJuC1Uon5Y8czLh5cm10qwJCFgNwjBqVN5yZX3I9crTRFWf+MxdeaC0XVc4pLsyLiiu
         lRErHQkaTEZ0AXp56XbauxAivjZzQENvzLq0I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wg3zwqBeUuNoJaILsloi5u/NbFFAAVUZUa5+v+OHsRg=;
        b=JskUQs6Ra7CfoEO4sDkBpUP0ClKgDqmUJg2DWafVn90iBzyVJ5kkDN3RXlSnoYqrt1
         emhLqxzlB8irqWVYNgeYDLSrjoj606CsISS1Na3iDUVgMYwGGG8/TRNb0x211mablbJP
         /Eb72zA+a4IKG7URGAFq5dKTm3dMMal7WBT+7UafLs6BQQDmNoSMD1v0b/QWrHyDMg4F
         h/HKijH1UElzwEacxQobXaHRaFTBFwCIq3JYZmexd5mHqjTrPN+6+TdcyCw0XIRIOcpt
         9gVVXKVPEJ5mpqpGeiSgXS0b6aCPIg97pDdBQxIL9Ou6vXNX4grLtrIYJHmjC6szO+v1
         +LzA==
X-Gm-Message-State: AOAM530+9Tka7TskgPCM0zZyrk5FglOSciXozOLNSGZZdsgSYsTUnpVK
        TXMUZjtcAGeXgUiD+sZMMiWV0MVSO6aLNeefHkD/XQ==
X-Google-Smtp-Source: ABdhPJw5/8ydEFEvM1ERpnv7sfeSl7S9OGSWtxhAwQryPPYTkJ+IHTbMqawOCyp3tQ7MXW0jNBi7yefzFjUskzJG6iw=
X-Received: by 2002:aca:ab87:: with SMTP id u129mr538150oie.128.1595874772448;
 Mon, 27 Jul 2020 11:32:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200727073707.21097-1-tzimmermann@suse.de> <20200727073707.21097-3-tzimmermann@suse.de>
 <20200727104250.GV6419@phenom.ffwll.local> <8c92a1c5-59b8-6b36-5c45-20783b5435eb@suse.de>
In-Reply-To: <8c92a1c5-59b8-6b36-5c45-20783b5435eb@suse.de>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Mon, 27 Jul 2020 20:32:41 +0200
Message-ID: <CAKMK7uETuoTZ=hSYk4An8waS0r0NyEvtVfjtbCkwQQLC8_6KkA@mail.gmail.com>
Subject: Re: [PATCH 2/3] drm/ast: Store image size in HW cursor info
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     Emil Velikov <emil.l.velikov@gmail.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Dave Airlie <airlied@redhat.com>,
        stable <stable@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 27, 2020 at 1:37 PM Thomas Zimmermann <tzimmermann@suse.de> wro=
te:
>
> Hi
>
> Am 27.07.20 um 12:42 schrieb daniel@ffwll.ch:
> > On Mon, Jul 27, 2020 at 09:37:06AM +0200, Thomas Zimmermann wrote:
> >> Store the image size as part of the HW cursor info, so that the
> >> cursor show function doesn't require the information from the
> >> caller. No functional changes.
> >
> > Uh just pass the state structure and done? All these "store random stuf=
f
> > in private structures" (they're not even atomic state structures, it's =
the
> > driver private thing even!) is very non-atomic. And I see zero reasons =
why
> > you have to do this, the cursor stays around.
>
> It's not random stuff. Ast cannot use ARGB8888 for cursors. Anything in
> ast_private.cursor represents cursor hardware state (not DRM state);
> duplicated for double buffering.
>
>  * gbo: two perma-pinned GEM objects at the end of VRAM. It's the HW
> cursor buffer in ARGB4444 format. The userspace's cursor image is
> converted to ARGB4444 and copied into the current backbuffer.
>
>  * vaddr: A mapping of the gbo's into kernel address space. We don't
> want to map the gbo on each update, so they are mapped once and the
> kernel address is stored in vaddr.
>
>  * size: the size of each HW buffer. We could use the value in the fb,
> but storing this as well makes the cursor code self-contained.

Yeah, but this kind of stuff should be in the ast_plane_state. Not in
ast_private, that latter option is very non-atomic and results in all
kinds of coordination fun.
-Daniel

>
> Best regards
> Thomas
>
> > -Daniel
> >
> >>
> >> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> >> Fixes: 4961eb60f145 ("drm/ast: Enable atomic modesetting")
> >> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> >> Cc: Gerd Hoffmann <kraxel@redhat.com>
> >> Cc: Dave Airlie <airlied@redhat.com>
> >> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> >> Cc: Sam Ravnborg <sam@ravnborg.org>
> >> Cc: Emil Velikov <emil.l.velikov@gmail.com>
> >> Cc: "Y.C. Chen" <yc_chen@aspeedtech.com>
> >> Cc: <stable@vger.kernel.org> # v5.6+
> >> ---
> >>  drivers/gpu/drm/ast/ast_cursor.c | 13 +++++++++++--
> >>  drivers/gpu/drm/ast/ast_drv.h    |  7 +++++--
> >>  drivers/gpu/drm/ast/ast_mode.c   |  8 +-------
> >>  3 files changed, 17 insertions(+), 11 deletions(-)
> >>
> >> diff --git a/drivers/gpu/drm/ast/ast_cursor.c b/drivers/gpu/drm/ast/as=
t_cursor.c
> >> index acf0d23514e8..8642a0ce9da6 100644
> >> --- a/drivers/gpu/drm/ast/ast_cursor.c
> >> +++ b/drivers/gpu/drm/ast/ast_cursor.c
> >> @@ -87,6 +87,8 @@ int ast_cursor_init(struct ast_private *ast)
> >>
> >>              ast->cursor.gbo[i] =3D gbo;
> >>              ast->cursor.vaddr[i] =3D vaddr;
> >> +            ast->cursor.size[i].width =3D 0;
> >> +            ast->cursor.size[i].height =3D 0;
> >>      }
> >>
> >>      return drmm_add_action_or_reset(dev, ast_cursor_release, NULL);
> >> @@ -194,6 +196,9 @@ int ast_cursor_blit(struct ast_private *ast, struc=
t drm_framebuffer *fb)
> >>      /* do data transfer to cursor BO */
> >>      update_cursor_image(dst, src, fb->width, fb->height);
> >>
> >> +    ast->cursor.size[ast->cursor.next_index].width =3D fb->width;
> >> +    ast->cursor.size[ast->cursor.next_index].height =3D fb->height;
> >> +
> >>      drm_gem_vram_vunmap(gbo, src);
> >>      drm_gem_vram_unpin(gbo);
> >>
> >> @@ -249,14 +254,18 @@ static void ast_cursor_set_location(struct ast_p=
rivate *ast, u16 x, u16 y,
> >>      ast_set_index_reg(ast, AST_IO_CRTC_PORT, 0xc7, y1);
> >>  }
> >>
> >> -void ast_cursor_show(struct ast_private *ast, int x, int y,
> >> -                 unsigned int offset_x, unsigned int offset_y)
> >> +void ast_cursor_show(struct ast_private *ast, int x, int y)
> >>  {
> >> +    unsigned int offset_x, offset_y;
> >>      u8 x_offset, y_offset;
> >>      u8 __iomem *dst, __iomem *sig;
> >>      u8 jreg;
> >>
> >>      dst =3D ast->cursor.vaddr[ast->cursor.next_index];
> >> +    offset_x =3D AST_MAX_HWC_WIDTH -
> >> +               ast->cursor.size[ast->cursor.next_index].width;
> >> +    offset_y =3D AST_MAX_HWC_HEIGHT -
> >> +               ast->cursor.size[ast->cursor.next_index].height;
> >>
> >>      sig =3D dst + AST_HWC_SIZE;
> >>      writel(x, sig + AST_HWC_SIGNATURE_X);
> >> diff --git a/drivers/gpu/drm/ast/ast_drv.h b/drivers/gpu/drm/ast/ast_d=
rv.h
> >> index e3a264ac7ee2..57414b429db3 100644
> >> --- a/drivers/gpu/drm/ast/ast_drv.h
> >> +++ b/drivers/gpu/drm/ast/ast_drv.h
> >> @@ -116,6 +116,10 @@ struct ast_private {
> >>      struct {
> >>              struct drm_gem_vram_object *gbo[AST_DEFAULT_HWC_NUM];
> >>              void __iomem *vaddr[AST_DEFAULT_HWC_NUM];
> >> +            struct {
> >> +                    unsigned int width;
> >> +                    unsigned int height;
> >> +            } size[AST_DEFAULT_HWC_NUM];
> >>              unsigned int next_index;
> >>      } cursor;
> >>
> >> @@ -311,8 +315,7 @@ void ast_release_firmware(struct drm_device *dev);
> >>  int ast_cursor_init(struct ast_private *ast);
> >>  int ast_cursor_blit(struct ast_private *ast, struct drm_framebuffer *=
fb);
> >>  void ast_cursor_page_flip(struct ast_private *ast);
> >> -void ast_cursor_show(struct ast_private *ast, int x, int y,
> >> -                 unsigned int offset_x, unsigned int offset_y);
> >> +void ast_cursor_show(struct ast_private *ast, int x, int y);
> >>  void ast_cursor_hide(struct ast_private *ast);
> >>
> >>  #endif
> >> diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_=
mode.c
> >> index 3680a000b812..5b2b39c93033 100644
> >> --- a/drivers/gpu/drm/ast/ast_mode.c
> >> +++ b/drivers/gpu/drm/ast/ast_mode.c
> >> @@ -671,20 +671,14 @@ ast_cursor_plane_helper_atomic_update(struct drm=
_plane *plane,
> >>                                    struct drm_plane_state *old_state)
> >>  {
> >>      struct drm_plane_state *state =3D plane->state;
> >> -    struct drm_framebuffer *fb =3D state->fb;
> >>      struct ast_private *ast =3D plane->dev->dev_private;
> >> -    unsigned int offset_x, offset_y;
> >> -
> >> -    offset_x =3D AST_MAX_HWC_WIDTH - fb->width;
> >> -    offset_y =3D AST_MAX_HWC_WIDTH - fb->height;
> >>
> >>      if (state->fb !=3D old_state->fb) {
> >>              /* A new cursor image was installed. */
> >>              ast_cursor_page_flip(ast);
> >>      }
> >>
> >> -    ast_cursor_show(ast, state->crtc_x, state->crtc_y,
> >> -                    offset_x, offset_y);
> >> +    ast_cursor_show(ast, state->crtc_x, state->crtc_y);
> >>  }
> >>
> >>  static void
> >> --
> >> 2.27.0
> >>
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
