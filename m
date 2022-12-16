Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17FDC64F315
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 22:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbiLPVVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 16:21:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLPVVo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 16:21:44 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C76C61D50;
        Fri, 16 Dec 2022 13:21:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1671225684; bh=aUOSQEhCMR/62w3hhkuJ9BsB1wW4vOhU1ddyczTpHTc=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=rpUj14RuTxPXnlnwLehw+nouQjJwRkStKnC+FATbjevuT2NLvO3vHB4e84GpHSy25
         fF+d6hEHRkic1YKcmS6xfFyFJSk9j2g2W0yRA8bSff6+tEEup+EDtf6VdEiAgyMs5B
         8RXJhwBrJZ0/GmlIoCIZrZUp/1UKYrxG6gIrSQ2ENHeQnPh7IDAYNTrl7VG7OYJPvS
         SXfzNwKVG9rFsbz9XRv1kjUzYIX2qs62spJ6J9XEiSPI0SGWaeBpK28Cuu49/uSZNc
         +2MuiBsYrwH8qn3CCg+8wvwlndxZS3zuFjUCnF3FNhkXuj2MIZhJ4hS147KCrD7v/y
         F7bxWnOP6DCkg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from p100 ([92.116.155.237]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mof9P-1oZQEv1CZN-00p8Wn; Fri, 16
 Dec 2022 22:21:24 +0100
Date:   Fri, 16 Dec 2022 22:21:22 +0100
From:   Helge Deller <deller@gmx.de>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Helge Deller <deller@gmx.de>, "Z. Liu" <liuzx@knownsec.com>,
        linux-fbdev@vger.kernel.org, it+linux-fbdev@molgen.mpg.de,
        regressions@lists.linux.dev, stable@vger.kernel.org
Subject: Re: matroxfb: cannot determine memory size
Message-ID: <Y5zhUl7r9z0lFJxc@p100>
References: <5da53ec5-3a9c-ec87-da20-69f140aaaa6b@molgen.mpg.de>
 <6ef71be5-def9-4578-3f73-c43c35d7e4a9@gmx.de>
 <dc0b1487-04f9-5a2f-e0f8-d157a74b6bcb@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <dc0b1487-04f9-5a2f-e0f8-d157a74b6bcb@molgen.mpg.de>
X-Provags-ID: V03:K1:j5u2j/ROt/Uxz6zlMZOTjJBO8Y4Gu9BJJtWwaigPJOdbthEddOb
 Be2ItH11ei7KaK/q7ndqOxc/HnEmBXBKgpZnUhTzbKJiRfPhRX1//KF/MRofUIad0L9snI3
 qrLBAJBjTGcMrrc9fYIzpfZKLtU+DTX34ylv9QCQf1gZOOUyvYNYxZUKOz8QPjKq8PTx2ZH
 1n1SVtrUa5VDxnYJZ0x4w==
UI-OutboundReport: notjunk:1;M01:P0:GIlZc3KVv24=;t1dMMnP4aDlcDvDO/jXP6ipS2M3
 YHfRwIQeBVqArP/e+NecUU1XMyyT/Ym/4XRF9Ux4faD6CDAEfcPRlXtWXQZm6oXEVX9iigxPu
 0HEVcpVg5DESnyZ79laSey+4VOTksMp8+YyGvLHNl8541YitVoN5hs04BTB++smibsJXaHQXQ
 8nen4GZabKd+BAymucFKhaV5k2sfHMTfMlzaOH2M3yHa0hYEIYc7CtDRpMuodnhotyaekESOD
 S/P3dU+zwGh7T9OWAAEmq3aHhJzHPR/Iu9KgmcS8oBcPQWmUOqBBQ5fXf01lXfdyVt3sEyV72
 JNaHwzGzrYgmaqNGlLvxhJ03VsP4eP6FETaZK9GKDiq6d/RbVAwkUWsUpfL0OaVjSxW3PukzK
 rAqmNxFLskxoMqy8605VHqZiSzdtsKHelLW9g/EulNHCo5kQyKnN+iA7m7hr/PTvLamh2aaSJ
 XM+GIC9cNVbbpo+0bBdXNLeLxU22ourFfNjYvxuDLg3fjFB3qVnx1t3fKQZobNRygv1hjJnzn
 dzHFBXyl5ng6gwDr/AyDPA1Z6Ypuvff8kH+zxapAj549v2Xpa2QnxcMJLI+78IXGdl3vCxjZx
 PxtPpYhgnWepJ2oyhyelVQ4PPz63GPClYgCRDOlPeKBXTYexrKnIC0Id/+Df3wYfsYnBqOZx2
 YB5BKu8QjM1NFmb9MDQDPEsRH2VdYg38Gda5kyFUwbDrf6GtzCGFO795n7QAAg7sLeYGGiRiR
 VGOmkEO/13EHm6mCfMaEGQFZEvLhuFZ2qjjrmBEGG6q+auGfG/7OqbSsC8snbLXaRe2FFQz/O
 qxV0Wy333bcA0bVfhk/0QndZlRM+WwgTRiZdp/TxuTbrHXS2Klv9S4BCcvbY8imKl/CkKoVLD
 5fE3JD4oRLY1TLHwr5skGKpjs2H/0wbkvNiHthF4JZKOjFBmvLc3ri+fSH9i9TRH822bHBLoI
 kw3WhQ==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Paul Menzel <pmenzel@molgen.mpg.de>:
> [Cc: +regressions@, +stable@]
>
> #regzbot ^introduced: 62d89a7d49afe46e6b9bbe9e23b004ad848dbde4
>
>
> Dear Helge,
>
>
> Thank you for your prompt reply.
>
> Am 16.12.22 um 00:02 schrieb Helge Deller:
> > On 12/15/22 17:39, Paul Menzel wrote:
>
> > > Between Linux 5.10.103 and 5.10.110/5.15.77, matrixfb fails to load.
> > >
> > > ## Working:
> > >
> > > =C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0=C2=A0 0.000000] Linux version=
 5.10.103.mx64.429 (root@theinternet.molgen.mpg.de) (gcc (GCC) 7.5.0, GNU =
ld (GNU Binutils) 2.37) #1 SMP Mon Mar 7 16:41:58 CET 2022
> > > =C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0=C2=A0 0.000000] Command line:=
 BOOT_IMAGE=3D/boot/bzImage-5.10.103.mx64.429 root=3DLABEL=3Droot ro crash=
kernel=3D64G-:256M console=3DttyS0,115200n8 console=3Dtty0 init=3D/bin/sys=
temd audit=3D0 random.trust_cpu=3Don systemd.unified_cgroup_hierarchy
> > > =C2=A0=C2=A0=C2=A0=C2=A0 [=E2=80=A6]
> > > =C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0=C2=A0 0.000000] DMI: Dell Inc=
. PowerEdge R910/0KYD3D, BIOS 2.10.0 08/29/2013
> > > =C2=A0=C2=A0=C2=A0=C2=A0 [=E2=80=A6]
> > > =C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 48.045530] matroxfb: Matrox M=
GA-G200eW (PCI) detected
> > > =C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 48.054675] matroxfb: 640x480x=
8bpp (virtual: 640x13107)
> > > =C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 48.059966] matroxfb: framebuf=
fer at 0xC5000000, mapped to 0x00000000ca7238fa, size 8388608
> > >
> > > ## Non-working:
> > >
> > > ### 5.10.110
> > >
> > > =C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0=C2=A0 0.000000] Linux version=
 5.10.110.mx64.433
> > > (root@theinternet.molgen.mpg.de) (gcc (GCC) 7.5.0, GNU ld (GNU
> > > Binutils) 2.37) #1 SMP Thu Apr 14 15:28:53 CEST 2022
> > > =C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0=C2=A0 0.000000] Command line:=
 root=3DLABEL=3Droot ro crashkernel=3D64G-:256M console=3DttyS0,115200n8 c=
onsole=3Dtty0 init=3D/bin/systemd audit=3D0 random.trust_cpu=3Don systemd.=
unified_cgroup_hierarchy
> > > =C2=A0=C2=A0=C2=A0=C2=A0 [=E2=80=A6]
> > > =C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0=C2=A0 0.000000] DMI: Dell Inc=
. PowerEdge R910/0KYD3D, BIOS 2.10.0 08/29/2013
> > > =C2=A0=C2=A0=C2=A0=C2=A0 [=E2=80=A6]
> > > =C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 35.225987] matroxfb: Matrox M=
GA-G200eW (PCI) detected
> > > =C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 35.234088] matroxfb: cannot d=
etermine memory size
> > > =C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 35.238931] matroxfb: probe of=
 0000:09:03.0 failed with error -1
> > >
> > > ### 5.15.77
> > >
> > > =C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0=C2=A0 0.000000] Linux version=
 5.15.77.mx64.440 (root@theinternet.molgen.mpg.de) (gcc (GCC) 10.4.0, GNU =
ld (GNU Binutils) 2.37) #1 SMP Tue Nov 8 15:42:33 CET 2022
> > > =C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0=C2=A0 0.000000] Command line:=
 root=3DLABEL=3Droot ro crashkernel=3D64G-:256M console=3DttyS0,115200n8 c=
onsole=3Dtty0 init=3D/bin/systemd audit=3D0 random.trust_cpu=3Don systemd.=
unified_cgroup_hierarchy
> > > =C2=A0=C2=A0=C2=A0=C2=A0 [=E2=80=A6]
> > > =C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0=C2=A0 0.000000] DMI: Dell Inc=
. PowerEdge R715/0G2DP3, BIOS 1.5.2 04/19/2011
> > > =C2=A0=C2=A0=C2=A0=C2=A0 [=E2=80=A6]
> > > =C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0=C2=A0 9.436420] matroxfb: Mat=
rox MGA-G200eW (PCI) detected
> > > =C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0=C2=A0 9.444502] matroxfb: can=
not determine memory size
> > > =C2=A0=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0=C2=A0 9.449316] matroxfb: pro=
be of 0000:0a:03.0 failed with error -1
> > >
> > > We see it on several systems:
> > >
> > > =C2=A0=C2=A0=C2=A0=C2=A0 $ lspci -nn -s 0a:03.0 # Dell PowerEdge R71=
5
> > > =C2=A0=C2=A0=C2=A0=C2=A0 0a:03.0 VGA compatible controller [0300]: M=
atrox Electronics Systems Ltd. MGA G200eW WPCM450 [102b:0532] (rev 0a)
> > >
> > > =C2=A0=C2=A0=C2=A0=C2=A0 $ lspci -nn -s 09:03.0 # Dell PowerEdge R91=
0
> > > =C2=A0=C2=A0=C2=A0=C2=A0 09:03.0 VGA compatible controller [0300]: M=
atrox Electronics Systems Ltd. MGA G200eW WPCM450 [102b:0532] (rev 0a)
> > >
> > > I found some old log from April 2022, where I booted 5.10.109, and
> > > the error is not there, pointing toward the regression to be
> > > introduced between 5.10.109 and 5.10.110.
> > >
> > > ```
> > > $ git log --oneline v5.10.109..v5.10.110 --grep fbdev
>
> [=E2=80=A6]
>
> > > ```
> > >
> > > Is it worthwhile to test commit f8bf19f7f311 (video: fbdev:
> > > matroxfb: set maxvram of vbG200eW to the same as vbG200 to avoid
> > > black screen)?
> >
> > Yes, it is.
> > Please try and report back.
> > It seems to be the only relevant patch, and it fits with the name of
> > your card.
>
> I tested Linus=E2=80=99 master with commit 84e57d292203 (Merge tag
> 'exfat-for-6.2-rc1' of
> git://git.kernel.org/pub/scm/linux/kernel/git/linkinjeon/exfat) and the
> error is still there. Reverting commit fixes the issue.
>
> Tested on:
>
>     DMI: Dell Inc. PowerEdge R910/0KYD3D, BIOS 2.10.0 08/29/2013
>
> Current master:
>
>     [   36.221595] matroxfb 0000:09:03.0: vgaarb: deactivate vga console
>     [   36.228355] Console: switching to colour dummy device 80x25
>     [   36.234069] matroxfb: Matrox MGA-G200eW (PCI) detected
>     [   36.239316] PInS memtype =3D 7
>     [   36.242198] matroxfb: cannot determine memory size
>     [   36.242209] matroxfb: probe of 0000:09:03.0 failed with error -1
>
> After reverting 62d89a7d49af (video: fbdev: matroxfb: set maxvram of
> vbG200eW to the same as vbG200 to avoid black screen):
>
>     [   38.140763] matroxfb 0000:09:03.0: vgaarb: deactivate vga console
>     [   38.148057] Console: switching to colour dummy device 80x25
>     [   38.153789] matroxfb: Matrox MGA-G200eW (PCI) detected
>     [   38.159042] PInS memtype =3D 7
>     [   38.161953] matroxfb: 640x480x8bpp (virtual: 640x13107)
> 2022-12-16T12:26:11.301999+01:00 invidia kernel: [   38.167175] matroxfb=
:
> framebuffer at 0xC5000000, mapped to 0x000000006f41c38c, size 8388608
>
> > > The master commit 62d89a7d49a was added to v5.18-rc1, and was also
> > > backported to the Linux 5.15 series in 5.15.33.

Good.

Could you test if the patch below works for you as well (on top of git mas=
ter) ?
I believe the commit f8bf19f7f311 (video: fbdev: matroxfb: set maxvram of =
vbG200eW to the same as vbG200 to avoid black screen)
changed the wrong value...

If it works, can you send a patch?

Helge


diff --git a/drivers/video/fbdev/matrox/matroxfb_base.c b/drivers/video/fb=
dev/matrox/matroxfb_base.c
index 0d3cee7ae726..5192c7ac459a 100644
=2D-- a/drivers/video/fbdev/matrox/matroxfb_base.c
+++ b/drivers/video/fbdev/matrox/matroxfb_base.c
@@ -1378,8 +1378,8 @@ static struct video_board vbG200 =3D {
 	.lowlevel =3D &matrox_G100
 };
 static struct video_board vbG200eW =3D {
-	.maxvram =3D 0x100000,
-	.maxdisplayable =3D 0x800000,
+	.maxvram =3D 0x800000,
+	.maxdisplayable =3D 0x100000,
 	.accelID =3D FB_ACCEL_MATROX_MGAG200,
 	.lowlevel =3D &matrox_G100
 };

