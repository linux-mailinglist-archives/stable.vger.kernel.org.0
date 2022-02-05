Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 406174AAAF7
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 19:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242869AbiBESgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 13:36:41 -0500
Received: from mout.gmx.net ([212.227.15.19]:59783 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237920AbiBESgl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Feb 2022 13:36:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1644086196;
        bh=4bgKqt0VU7PCgTgJ/qvdBir0S/LjSM50YQEN5Kkg2qQ=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=TJpQdecdc16wdBLGX4qP/dV6qq0azz9iSTh1zqW4BfLeTLz3sP364OqZzDOGulRTg
         5NklpHUt+pZqN3ObJIFMadyxN7dufyOT3JrcxZnBIzJqDtty1nWMDPkswl00g3H0mU
         XU0ee01LrypX4v+Eg30wlayURx0stmMOPhIoBw0I=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from p100 ([92.116.146.104]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MUGe1-1mphrD1EXr-00RMIM; Sat, 05
 Feb 2022 19:36:36 +0100
Date:   Sat, 5 Feb 2022 19:36:34 +0100
From:   Helge Deller <deller@gmx.de>
To:     gregkh@linuxfoundation.org
Cc:     deller@gmx.de, daniel.vetter@ffwll.ch, geert@linux-m68k.org,
        svens@stackframe.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] Revert "fbcon: Disable accelerated
 scrolling"" failed to apply to 5.10-stable tree
Message-ID: <Yf7DsmnLOBa6BnzM@p100>
References: <1644066743887@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1644066743887@kroah.com>
X-Provags-ID: V03:K1:LSg/MZ8btS1n7he3DrlApf9nDfbLiNtbnRdfbqsKz8zR7KelAdk
 sbBCZshFOP83fPtjRUWGKNgUdakTGbigeR8dF1TxyD6YG39F1EzKCypnjcl7sqrmjNqdfDs
 TSUu0w9mTwsfUsjbFDslxsBPa5AJE2l19eAZVrEEv5nh1VLhdqKj/5INkTZDajacsaDosZP
 oekzhUfSFDrAVAEyl2Tuw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:B/xvAvUIsH0=:AjCHfuMJqHex7nzT3dkWid
 Zg0tGE0NW3AYjsclu4UbfmdcxaGJU2Psd+dVrFVDcXoco/4uunfQIxtc26hiHmxqTXuBju9rv
 spYI7JKyACJs57qJCql44RlfK+jCii5PjDcWONVevOjCpVu2TEi2Yl5eQZLr5+vh8h4no1d40
 g3lYKGF7zPWDp0DOjGGWkTO5cb6j4brVy+qjDZzO+GNRBQbvXaV7Y9OzJJklj0g07qFVcDHhd
 Q0bhBDQTeDHL7k2Z5uQnT/S4uy7xlFFQJ3eYHCbsbsqDLGiACsEKDq6w5s2xnWwC3EPC1e4eC
 xdq6KB+sVnq/D6E/kGlXZDB0/W7cMzAQAEsnwxAOm7qp34ppvH1Ro1P3b6Trkm7LeUyuv/DzW
 clgIOszGAG9SndkmzgGxnsEmLM4cSxMi99VN2hRVCqn08EC+n+b5bEyNMmw7kS6NoohIVCK2b
 LII97pnn76dTJ6zNRyyUHygK1ATap68vMy1bSOvwI34JIU72oqBTkcaMqfRIcy972nbFsemCo
 3hiavDT9o8mjLiqJb10zoAPzkQ+QjCzGxp3tuXws8JKSyGww9zyLXO+npHsPLZdIZ/kSNLyMh
 1r6zZs6jHS/vGMiNyVNIIxV4jfKGMufRy8XiRPwlYn9zgjF3cMumgmysz84qme4PvfaIUzENE
 w0Fodg3dee61YlXFhllR2emr2AvWpdf40PQGdGgJ0347gFPksqiySHQxZLv1EfW1Py+MsFdwu
 uv4/ZRIRS3bni1VF/dplzaMMkV8BpU4bUKkGhlXDZwTCCBniKRg1KH/akV+J8doUEgLIEAp7V
 aAO6Zjsx8YAj5DmYdtocSZO3GhNOtsNCrG7ls74DmsrsByYBqqbz7tXUKVMK+eVZ1jxi6lt/f
 kCm+fIM/C8zkYGtbPzJABHi/KBU06v2JV4jLX8AYeHXh9PJ7PlwNGhQCt16UpmIYzsoGpBOVc
 A2WyNyWjYp9JyN4BnwbOAFPWui7YwkZWyTC3/mYRJNz2uVsDhgoDD68e/ecuajEmdP2tm7R8V
 z6g5RbJzr/YlMz/HAZ+yQ9ZnLsebYRpufh5IcG3D7HEICzBfWmBtiKUfIW9TczsJrP1JjSmTJ
 rQn9qDEKr8rQSQ=
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>:
>
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Hello Greg,

below is a rebased patch which you can use instead and which applies clean=
ly.
The attached patch below is a 100% "git revert 397971e1d891", with added
info to the commit message.

After applying the patch below, the other failed patch:
"[PATCH] fbcon: Add option to enable legacy hardware acceleration"
doesn't fail to apply any longer either.

Please make sure to apply BOTH patches (the one below and the other
failed one) or NONE of those two patches.

Ideally, I'd suggest to wait until monday to get an Ack from Daniel for th=
is.

Thanks,
Helge

Replacement patch:

=46rom 19081652e320da7caf1ae5b6a73751cb4ded1e68 Mon Sep 17 00:00:00 2001
From: Helge Deller <deller@gmx.de>
Date: Sat, 5 Feb 2022 19:08:26 +0100
Subject: [PATCH] Revert "fbcon: Disable accelerated scrolling"

This reverts commit 397971e1d891f3af98f96da608ca03ac8cf75e94.

Revert the first (of 2) commits which disabled scrolling acceleration in
fbcon/fbdev.  It introduced a regression for fbdev-supported graphic cards
because of the performance penalty by doing screen scrolling by software
instead of using the existing graphic card 2D hardware acceleration.

Console scrolling acceleration was disabled by dropping code which
checked at runtime the driver hardware capabilities for the
BINFO_HWACCEL_COPYAREA or FBINFO_HWACCEL_FILLRECT flags and if set, it
enabled scrollmode SCROLL_MOVE which uses hardware acceleration to move
screen contents.  After dropping those checks scrollmode was hard-wired
to SCROLL_REDRAW instead, which forces all graphic cards to redraw every
character at the new screen position when scrolling.

This change effectively disabled all hardware-based scrolling acceleration=
 for
ALL drivers, because now all kind of 2D hardware acceleration (bitblt,
fillrect) in the drivers isn't used any longer.

The original commit message mentions that only 3 DRM drivers (nouveau, oma=
pdrm
and gma500) used hardware acceleration in the past and thus code for check=
ing
and using scrolling acceleration is obsolete.

This statement is NOT TRUE, because beside the DRM drivers there are aroun=
d 35
other fbdev drivers which depend on fbdev/fbcon and still provide hardware
acceleration for fbdev/fbcon.

The original commit message also states that syzbot found lots of bugs in =
fbcon
and thus it's "often the solution to just delete code and remove features"=
.
This is true, and the bugs - which actually affected all users of fbcon,
including DRM - were fixed, or code was dropped like e.g. the support for
software scrollback in vgacon (commit 973c096f6a85).

So to further analyze which bugs were found by syzbot, I've looked through=
 all
patches in drivers/video which were tagged with syzbot or syzkaller back t=
o
year 2005. The vast majority fixed the reported issues on a higher level, =
e.g.
when screen is to be resized, or when font size is to be changed. The few =
ones
which touched driver code fixed a real driver bug, e.g. by adding a check.

But NONE of those patches touched code of either the SCROLL_MOVE or the
SCROLL_REDRAW case.

That means, there was no real reason why SCROLL_MOVE had to be ripped-out =
and
just SCROLL_REDRAW had to be used instead. The only reason I can imagine s=
o far
was that SCROLL_MOVE wasn't used by DRM and as such it was assumed that it
could go away. That argument completely missed the fact that SCROLL_MOVE i=
s
still heavily used by fbdev (non-DRM) drivers.

Some people mention that using memcpy() instead of the hardware accelerati=
on is
pretty much the same speed. But that's not true, at least not for older gr=
aphic
cards and machines where we see speed decreases by factor 10 and more and =
thus
this change leads to console responsiveness way worse than before.

That's why the original commit is to be reverted. By reverting we
reintroduce hardware-based scrolling acceleration and fix the
performance regression for fbdev drivers.

There isn't any impact on DRM when reverting those patches.

Signed-off-by: Helge Deller <deller@gmx.de>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Sven Schnelle <svens@stackframe.org>
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20220202135531.92183-3=
-deller@gmx.de

diff --git a/Documentation/gpu/todo.rst b/Documentation/gpu/todo.rst
index 7272a4bd74dd..28841609aa4f 100644
=2D-- a/Documentation/gpu/todo.rst
+++ b/Documentation/gpu/todo.rst
@@ -273,24 +273,6 @@ Contact: Daniel Vetter, Noralf Tronnes

 Level: Advanced

-Garbage collect fbdev scrolling acceleration
=2D--------------------------------------------
-
-Scroll acceleration is disabled in fbcon by hard-wiring p->scrollmode =3D
-SCROLL_REDRAW. There's a ton of code this will allow us to remove:
=2D- lots of code in fbcon.c
=2D- a bunch of the hooks in fbcon_ops, maybe the remaining hooks could be=
 called
-  directly instead of the function table (with a switch on p->rotate)
=2D- fb_copyarea is unused after this, and can be deleted from all drivers
-
-Note that not all acceleration code can be deleted, since clearing and cu=
rsor
-support is still accelerated, which might be good candidates for further
-deletion projects.
-
-Contact: Daniel Vetter
-
-Level: Intermediate
-
 idr_init_base()
 ---------------

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/f=
bcon.c
index 42c72d051158..66eb2dd2166c 100644
=2D-- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -1033,7 +1033,7 @@ static void fbcon_init(struct vc_data *vc, int init)
 	struct vc_data *svc =3D *default_mode;
 	struct fbcon_display *t, *p =3D &fb_display[vc->vc_num];
 	int logo =3D 1, new_rows, new_cols, rows, cols, charcnt =3D 256;
-	int ret;
+	int cap, ret;

 	if (WARN_ON(info_idx =3D=3D -1))
 	    return;
@@ -1042,6 +1042,7 @@ static void fbcon_init(struct vc_data *vc, int init)
 		con2fb_map[vc->vc_num] =3D info_idx;

 	info =3D registered_fb[con2fb_map[vc->vc_num]];
+	cap =3D info->flags;

 	if (logo_shown < 0 && console_loglevel <=3D CONSOLE_LOGLEVEL_QUIET)
 		logo_shown =3D FBCON_LOGO_DONTSHOW;
@@ -1146,13 +1147,11 @@ static void fbcon_init(struct vc_data *vc, int ini=
t)

 	ops->graphics =3D 0;

-	/*
-	 * No more hw acceleration for fbcon.
-	 *
-	 * FIXME: Garbage collect all the now dead code after sufficient time
-	 * has passed.
-	 */
-	p->scrollmode =3D SCROLL_REDRAW;
+	if ((cap & FBINFO_HWACCEL_COPYAREA) &&
+	    !(cap & FBINFO_HWACCEL_DISABLED))
+		p->scrollmode =3D SCROLL_MOVE;
+	else /* default to something safe */
+		p->scrollmode =3D SCROLL_REDRAW;

 	/*
 	 *  ++guenther: console.c:vc_allocate() relies on initializing
@@ -1965,15 +1964,45 @@ static void updatescrollmode(struct fbcon_display =
*p,
 {
 	struct fbcon_ops *ops =3D info->fbcon_par;
 	int fh =3D vc->vc_font.height;
+	int cap =3D info->flags;
+	u16 t =3D 0;
+	int ypan =3D FBCON_SWAP(ops->rotate, info->fix.ypanstep,
+				  info->fix.xpanstep);
+	int ywrap =3D FBCON_SWAP(ops->rotate, info->fix.ywrapstep, t);
 	int yres =3D FBCON_SWAP(ops->rotate, info->var.yres, info->var.xres);
 	int vyres =3D FBCON_SWAP(ops->rotate, info->var.yres_virtual,
 				   info->var.xres_virtual);
+	int good_pan =3D (cap & FBINFO_HWACCEL_YPAN) &&
+		divides(ypan, vc->vc_font.height) && vyres > yres;
+	int good_wrap =3D (cap & FBINFO_HWACCEL_YWRAP) &&
+		divides(ywrap, vc->vc_font.height) &&
+		divides(vc->vc_font.height, vyres) &&
+		divides(vc->vc_font.height, yres);
+	int reading_fast =3D cap & FBINFO_READS_FAST;
+	int fast_copyarea =3D (cap & FBINFO_HWACCEL_COPYAREA) &&
+		!(cap & FBINFO_HWACCEL_DISABLED);
+	int fast_imageblit =3D (cap & FBINFO_HWACCEL_IMAGEBLIT) &&
+		!(cap & FBINFO_HWACCEL_DISABLED);

 	p->vrows =3D vyres/fh;
 	if (yres > (fh * (vc->vc_rows + 1)))
 		p->vrows -=3D (yres - (fh * vc->vc_rows)) / fh;
 	if ((yres % fh) && (vyres % fh < yres % fh))
 		p->vrows--;
+
+	if (good_wrap || good_pan) {
+		if (reading_fast || fast_copyarea)
+			p->scrollmode =3D good_wrap ?
+				SCROLL_WRAP_MOVE : SCROLL_PAN_MOVE;
+		else
+			p->scrollmode =3D good_wrap ? SCROLL_REDRAW :
+				SCROLL_PAN_REDRAW;
+	} else {
+		if (reading_fast || (fast_copyarea && !fast_imageblit))
+			p->scrollmode =3D SCROLL_MOVE;
+		else
+			p->scrollmode =3D SCROLL_REDRAW;
+	}
 }

 #define PITCH(w) (((w) + 7) >> 3)

