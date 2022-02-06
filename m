Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B498E4AAF4A
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 13:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236087AbiBFMzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Feb 2022 07:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235893AbiBFMzt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Feb 2022 07:55:49 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1857BC06173B
        for <stable@vger.kernel.org>; Sun,  6 Feb 2022 04:55:48 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id s6-20020a0568301e0600b0059ea5472c98so9029183otr.11
        for <stable@vger.kernel.org>; Sun, 06 Feb 2022 04:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6uI9pgr8uKI8nQcT17iijmqmkC77saILXhRcQXsZGYo=;
        b=Yl98KIb5P6hnPDpjowEKriMoe8/W4GGtszhQlKPgzuQSvTViPTUQQapMPrsiTSSjsh
         bca+wIxO1OSSbHBbDl4KDJf4PC+J8Vkvtsc3Z3cokwS125fE0KIv2KSWA9gVGCl80uKD
         aIKzbX3p2ai7EulDISDXjWXneeCp11fa5wBfM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6uI9pgr8uKI8nQcT17iijmqmkC77saILXhRcQXsZGYo=;
        b=a1wSoMUhA0BPdXhxZ1K0Hduo9gXhntwXQAueaGkSgSGlXs+yTpJMsJE2+ED7k6evXs
         pn/hWhgfkDJLYm1aLDYCkcc2lwUbyMqI7vQGUkzZNu3x8QXz/l7C7hP0Qyq3xL2I8lYW
         Tk6yCzi/RX9/mb7rpZhKCQvqgZe00QW81IJOffWBtqv6ddnQZe5gsGNCyoNbFSvMx488
         7tlw98jeNsG+rgm1ChEsx+JHkaBaoqxLvDVY9u4S2VqfgcuCV0fj3nqN8yUuny+7ZUB2
         bojCnT29dlGdhx1gr9765C98LlOZl660NccEAdqVC/vZ0iRghY87UbwljIcTB1k726vy
         2aGw==
X-Gm-Message-State: AOAM5326EleszwwLQRfcBMpYzgIisTBw762kjm1UO5G9g8LxQtZa3wZS
        K5vGJhDXcNSIOgPjEbgXzfrvAulLR1ipj01EjWQeKCgiXkM=
X-Google-Smtp-Source: ABdhPJyfwjgaztys7bYp5VILCX25ObGqENIH9tprOH6143IFwWsa1kOU61aW+MONuMzr/bS2RtdW98UgvJDFtU5q8nI=
X-Received: by 2002:a05:6830:1153:: with SMTP id x19mr2521907otq.321.1644152147379;
 Sun, 06 Feb 2022 04:55:47 -0800 (PST)
MIME-Version: 1.0
References: <1644066743887@kroah.com> <Yf7DsmnLOBa6BnzM@p100>
In-Reply-To: <Yf7DsmnLOBa6BnzM@p100>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Sun, 6 Feb 2022 13:55:35 +0100
Message-ID: <CAKMK7uFB--nvHStJLPLFMDh_+4+Xt6fSCQVt5YO29K2uReQ5Tw@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] Revert "fbcon: Disable accelerated
 scrolling"" failed to apply to 5.10-stable tree
To:     Helge Deller <deller@gmx.de>
Cc:     gregkh@linuxfoundation.org, geert@linux-m68k.org,
        svens@stackframe.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 5, 2022 at 7:36 PM Helge Deller <deller@gmx.de> wrote:
>
> * gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>:
> >
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
>
> Hello Greg,
>
> below is a rebased patch which you can use instead and which applies cleanly.
> The attached patch below is a 100% "git revert 397971e1d891", with added
> info to the commit message.
>
> After applying the patch below, the other failed patch:
> "[PATCH] fbcon: Add option to enable legacy hardware acceleration"
> doesn't fail to apply any longer either.
>
> Please make sure to apply BOTH patches (the one below and the other
> failed one) or NONE of those two patches.
>
> Ideally, I'd suggest to wait until monday to get an Ack from Daniel for this.

Ack.
-Daniel

>
> Thanks,
> Helge
>
> Replacement patch:
>
> From 19081652e320da7caf1ae5b6a73751cb4ded1e68 Mon Sep 17 00:00:00 2001
> From: Helge Deller <deller@gmx.de>
> Date: Sat, 5 Feb 2022 19:08:26 +0100
> Subject: [PATCH] Revert "fbcon: Disable accelerated scrolling"
>
> This reverts commit 397971e1d891f3af98f96da608ca03ac8cf75e94.
>
> Revert the first (of 2) commits which disabled scrolling acceleration in
> fbcon/fbdev.  It introduced a regression for fbdev-supported graphic cards
> because of the performance penalty by doing screen scrolling by software
> instead of using the existing graphic card 2D hardware acceleration.
>
> Console scrolling acceleration was disabled by dropping code which
> checked at runtime the driver hardware capabilities for the
> BINFO_HWACCEL_COPYAREA or FBINFO_HWACCEL_FILLRECT flags and if set, it
> enabled scrollmode SCROLL_MOVE which uses hardware acceleration to move
> screen contents.  After dropping those checks scrollmode was hard-wired
> to SCROLL_REDRAW instead, which forces all graphic cards to redraw every
> character at the new screen position when scrolling.
>
> This change effectively disabled all hardware-based scrolling acceleration for
> ALL drivers, because now all kind of 2D hardware acceleration (bitblt,
> fillrect) in the drivers isn't used any longer.
>
> The original commit message mentions that only 3 DRM drivers (nouveau, omapdrm
> and gma500) used hardware acceleration in the past and thus code for checking
> and using scrolling acceleration is obsolete.
>
> This statement is NOT TRUE, because beside the DRM drivers there are around 35
> other fbdev drivers which depend on fbdev/fbcon and still provide hardware
> acceleration for fbdev/fbcon.
>
> The original commit message also states that syzbot found lots of bugs in fbcon
> and thus it's "often the solution to just delete code and remove features".
> This is true, and the bugs - which actually affected all users of fbcon,
> including DRM - were fixed, or code was dropped like e.g. the support for
> software scrollback in vgacon (commit 973c096f6a85).
>
> So to further analyze which bugs were found by syzbot, I've looked through all
> patches in drivers/video which were tagged with syzbot or syzkaller back to
> year 2005. The vast majority fixed the reported issues on a higher level, e.g.
> when screen is to be resized, or when font size is to be changed. The few ones
> which touched driver code fixed a real driver bug, e.g. by adding a check.
>
> But NONE of those patches touched code of either the SCROLL_MOVE or the
> SCROLL_REDRAW case.
>
> That means, there was no real reason why SCROLL_MOVE had to be ripped-out and
> just SCROLL_REDRAW had to be used instead. The only reason I can imagine so far
> was that SCROLL_MOVE wasn't used by DRM and as such it was assumed that it
> could go away. That argument completely missed the fact that SCROLL_MOVE is
> still heavily used by fbdev (non-DRM) drivers.
>
> Some people mention that using memcpy() instead of the hardware acceleration is
> pretty much the same speed. But that's not true, at least not for older graphic
> cards and machines where we see speed decreases by factor 10 and more and thus
> this change leads to console responsiveness way worse than before.
>
> That's why the original commit is to be reverted. By reverting we
> reintroduce hardware-based scrolling acceleration and fix the
> performance regression for fbdev drivers.
>
> There isn't any impact on DRM when reverting those patches.
>
> Signed-off-by: Helge Deller <deller@gmx.de>
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Acked-by: Sven Schnelle <svens@stackframe.org>
> Cc: stable@vger.kernel.org # v5.10+
> Signed-off-by: Helge Deller <deller@gmx.de>
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Link: https://patchwork.freedesktop.org/patch/msgid/20220202135531.92183-3-deller@gmx.de
>
> diff --git a/Documentation/gpu/todo.rst b/Documentation/gpu/todo.rst
> index 7272a4bd74dd..28841609aa4f 100644
> --- a/Documentation/gpu/todo.rst
> +++ b/Documentation/gpu/todo.rst
> @@ -273,24 +273,6 @@ Contact: Daniel Vetter, Noralf Tronnes
>
>  Level: Advanced
>
> -Garbage collect fbdev scrolling acceleration
> ---------------------------------------------
> -
> -Scroll acceleration is disabled in fbcon by hard-wiring p->scrollmode =
> -SCROLL_REDRAW. There's a ton of code this will allow us to remove:
> -- lots of code in fbcon.c
> -- a bunch of the hooks in fbcon_ops, maybe the remaining hooks could be called
> -  directly instead of the function table (with a switch on p->rotate)
> -- fb_copyarea is unused after this, and can be deleted from all drivers
> -
> -Note that not all acceleration code can be deleted, since clearing and cursor
> -support is still accelerated, which might be good candidates for further
> -deletion projects.
> -
> -Contact: Daniel Vetter
> -
> -Level: Intermediate
> -
>  idr_init_base()
>  ---------------
>
> diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
> index 42c72d051158..66eb2dd2166c 100644
> --- a/drivers/video/fbdev/core/fbcon.c
> +++ b/drivers/video/fbdev/core/fbcon.c
> @@ -1033,7 +1033,7 @@ static void fbcon_init(struct vc_data *vc, int init)
>         struct vc_data *svc = *default_mode;
>         struct fbcon_display *t, *p = &fb_display[vc->vc_num];
>         int logo = 1, new_rows, new_cols, rows, cols, charcnt = 256;
> -       int ret;
> +       int cap, ret;
>
>         if (WARN_ON(info_idx == -1))
>             return;
> @@ -1042,6 +1042,7 @@ static void fbcon_init(struct vc_data *vc, int init)
>                 con2fb_map[vc->vc_num] = info_idx;
>
>         info = registered_fb[con2fb_map[vc->vc_num]];
> +       cap = info->flags;
>
>         if (logo_shown < 0 && console_loglevel <= CONSOLE_LOGLEVEL_QUIET)
>                 logo_shown = FBCON_LOGO_DONTSHOW;
> @@ -1146,13 +1147,11 @@ static void fbcon_init(struct vc_data *vc, int init)
>
>         ops->graphics = 0;
>
> -       /*
> -        * No more hw acceleration for fbcon.
> -        *
> -        * FIXME: Garbage collect all the now dead code after sufficient time
> -        * has passed.
> -        */
> -       p->scrollmode = SCROLL_REDRAW;
> +       if ((cap & FBINFO_HWACCEL_COPYAREA) &&
> +           !(cap & FBINFO_HWACCEL_DISABLED))
> +               p->scrollmode = SCROLL_MOVE;
> +       else /* default to something safe */
> +               p->scrollmode = SCROLL_REDRAW;
>
>         /*
>          *  ++guenther: console.c:vc_allocate() relies on initializing
> @@ -1965,15 +1964,45 @@ static void updatescrollmode(struct fbcon_display *p,
>  {
>         struct fbcon_ops *ops = info->fbcon_par;
>         int fh = vc->vc_font.height;
> +       int cap = info->flags;
> +       u16 t = 0;
> +       int ypan = FBCON_SWAP(ops->rotate, info->fix.ypanstep,
> +                                 info->fix.xpanstep);
> +       int ywrap = FBCON_SWAP(ops->rotate, info->fix.ywrapstep, t);
>         int yres = FBCON_SWAP(ops->rotate, info->var.yres, info->var.xres);
>         int vyres = FBCON_SWAP(ops->rotate, info->var.yres_virtual,
>                                    info->var.xres_virtual);
> +       int good_pan = (cap & FBINFO_HWACCEL_YPAN) &&
> +               divides(ypan, vc->vc_font.height) && vyres > yres;
> +       int good_wrap = (cap & FBINFO_HWACCEL_YWRAP) &&
> +               divides(ywrap, vc->vc_font.height) &&
> +               divides(vc->vc_font.height, vyres) &&
> +               divides(vc->vc_font.height, yres);
> +       int reading_fast = cap & FBINFO_READS_FAST;
> +       int fast_copyarea = (cap & FBINFO_HWACCEL_COPYAREA) &&
> +               !(cap & FBINFO_HWACCEL_DISABLED);
> +       int fast_imageblit = (cap & FBINFO_HWACCEL_IMAGEBLIT) &&
> +               !(cap & FBINFO_HWACCEL_DISABLED);
>
>         p->vrows = vyres/fh;
>         if (yres > (fh * (vc->vc_rows + 1)))
>                 p->vrows -= (yres - (fh * vc->vc_rows)) / fh;
>         if ((yres % fh) && (vyres % fh < yres % fh))
>                 p->vrows--;
> +
> +       if (good_wrap || good_pan) {
> +               if (reading_fast || fast_copyarea)
> +                       p->scrollmode = good_wrap ?
> +                               SCROLL_WRAP_MOVE : SCROLL_PAN_MOVE;
> +               else
> +                       p->scrollmode = good_wrap ? SCROLL_REDRAW :
> +                               SCROLL_PAN_REDRAW;
> +       } else {
> +               if (reading_fast || (fast_copyarea && !fast_imageblit))
> +                       p->scrollmode = SCROLL_MOVE;
> +               else
> +                       p->scrollmode = SCROLL_REDRAW;
> +       }
>  }
>
>  #define PITCH(w) (((w) + 7) >> 3)
>


-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
