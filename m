Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C46E4D6A16
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 21:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731636AbfJNT3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 15:29:04 -0400
Received: from mout.gmx.net ([212.227.15.19]:60511 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730590AbfJNT3E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Oct 2019 15:29:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1571081342;
        bh=NujVOwKYbKLcy+pGT9P8wn7OM75vOYdvHSlS5uxp2GQ=;
        h=X-UI-Sender-Class:Date:From:To:Subject;
        b=ipv/1EuO+5oMCPi7E7pX3MjJYW5FAeYlD4Cht1HeNmK3Bz8jS+IE+dAMKQMWzmAVt
         xNXV2fN2M3wjTwlI5sqZcdClnbXfJfpBsz8KUq0ySq77APqNsZGVNIk5hrvA7Vrr80
         yoO8yS57+uWiClbv+/GNIFSZA9Jtm8vCvFuV90X4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from ls3530.fritz.box ([92.116.168.141]) by mail.gmx.com (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MN5iZ-1ianWt2rxt-00J0CS; Mon, 14
 Oct 2019 21:29:02 +0200
Date:   Mon, 14 Oct 2019 21:29:01 +0200
From:   Helge Deller <deller@gmx.de>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Subject: [PATCH] parisc/pci: Switch LBA PCI bus from Hard Fail to Soft Fail
 mode
Message-ID: <20191014192901.GA13704@ls3530.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Provags-ID: V03:K1:eUN0Sxq4IQ4wzqoV/tDM/zP1Jxe47m6gRcKGJ9SAWR7TWmp9MeO
 vsn/RSaMTSwpTLvV9qwPiJPBtqtDARIU7wed/L2BWChUNIHjoLqe6l+U9Kx7Wbwo2/WkYhb
 w9jt/AamZRu5bWDgMNgod4ISjpC4gKzAGTfixRgJtZ0yYWiWtqs6k8tWpJwbiWFtfXktMP/
 K83HtHLKyWPjqZye65JTw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:uK8OHdk+kbM=:72TWhIMLwEXAgB+hBwKsWS
 O9JeFh/19/VFdbDD8vHFdAKJP+VZsfu7cpNourQsU6QljDjGEEUE2cZdEGz/xEEI7FM1zrQfB
 iqRKAdHEMiXOO1HHX1q2YuqlDhAokJvfnNVTslVuudvjEjGK/xCyFKbM0gtVSYnngjdolMDaA
 EClYS+wdlc1P3j0DetoMIcLtVkZgLFMtYlQS8j3PIeps+0rdAK+rvKQVvdDg2m6U9vUF0E2rA
 GSpZ4LFfT2SWq2o4lekF1QGl0wCIknEe1aiBbPQhj/O/uzmqtvH2OT18wuozscBRVgnQFIIC9
 ijClsOI6/fZ3I+BQUoMt845VfjWwexsLmwYiKOz3Vgqdhzf16A0z8JcfFnajyHad5NaSgjPit
 Ipf+jf5RGdwyRDia+dVKGF0XWxbHl6T7LRJftjf4Mm8WDvIzRCy/z62Eh1ak75LQFw82YCjfw
 hNns3LPNv8Ia6vEB1f40AtJ9GwLMrc5LMXvmysLav4+AOrA0iqFQdOnwcQFmhgfjaWl6Jt03I
 dal0QqJJm+3a1UEBa04r4BFEm5rUzURdFPO836hUY2eD6SI3FCee6tjchoe3XEp7aPHLF9eB2
 qBO+yhT6XPnZeoCQAyQmAB0rUkBJ6nW91/kAMfbwAVTLIPO0k2b45tNC8DXALMPjLIZHK0kR9
 EqtKgc0TYvauMWN+4mcFPLJL5l706LDekbGEq3zL4t5gpr5DjogFb2ERLGTIllHdHBgRKMVw4
 F8+POiaJPK7ZLIfF4DA6O3pjix4mNVBT581CmpKaUBPRGzSYr7SkarucFim4BF9HTkk6hUhE3
 IWx+5RY6KASDeecgH371PoM38B9shT6J7azyFW+v43SLNcW4hWsuq3LIOEwy0YbFmJq0dr9MP
 Kbraz5FuvSd3VZ/9Qf7omqIyTvAGLvmPt/v9Kx2EPTD5k+I+MROPTHG7HTmtUz1xZGu+wvl/D
 ExOC7Sq9k/9OfZqWQutFKF9lRviiHM2UFd6aivb8/2zWrC+QKLYL/RqoOEB3IzYAmz+JoOQ0F
 553VUdQsvCoAY7xFoR8fDfClDl7913j66StrhkfdTCLykoeg/MA64tDyCncYqD+PbOTbZC3M4
 zgzP2EGgGM5f6Y75vfcCOhvdg7km6yhH+rSJzM63GSWhO/q9CdKs/L0mxoSkmJ/ZFNinDAt/D
 fdyXpHvBf1ERsnZpcrOotYTLyeHSxiqViTlzxw4jkBXSW1nd8QNyaeszZxq3dleg4p/CNWU7I
 z0974CRyEQEzagEIJx85dkLBP2ZsLwI5cIvqIzQ==
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear stable kernel maintainers,

can you please add the patch below into all stable kernels up until (and
including) kernel 4.16 ?

It's upstream patch b845f66f78bf which was merged in kernel 4.17.

It turned out, that this patch prevents multiple kernel crashes when
users add standard PCI cards (e.g. PCI USB cards) to parisc boxes and
expect them to simply work. Instead, without this patch, parisc kernels
prior to v4.17 will crash the box since the default PCI behaviour is to
fault if Linux drivers read/write to PCI memory regions which aren't
backed by real hardware. This happens e.g. when the Linux drivers poke
into PCI memory to check if a specific hardware revision was installed.

I got multiple reports from users which ran into this problem, and by
adding this patch to older kernels (which are still used as distribution
install kernels, e.g. v4.16 for debian) people will be able to install
Linux with such PCI cards without crashes and with working PCI cards.

Thanks!
Helge

______________

Subject: [PATCH] parisc/pci: Switch LBA PCI bus from Hard Fail to Soft Fai=
l mode

Carlo Pisani noticed that his C3600 workstation behaved unstable during he=
avy
I/O on the PCI bus with a VIA VT6421 IDE/SATA PCI card.

To avoid such instability, this patch switches the LBA PCI bus from Hard F=
ail
mode into Soft Fail mode. In this mode the bus will return -1UL for timed =
out
MMIO transactions, which is exactly how the x86 (and most other architectu=
res)
PCI busses behave.

This patch is based on a proposal by Grant Grundler and Kyle McMartin 10
years ago:
https://www.spinics.net/lists/linux-parisc/msg01027.html

Cc: Carlo Pisani <carlojpisani@gmail.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Reviewed-by: Grant Grundler <grantgrundler@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/drivers/parisc/lba_pci.c b/drivers/parisc/lba_pci.c
index 41b740aed3a3..69bd98421eb1 100644
=2D-- a/drivers/parisc/lba_pci.c
+++ b/drivers/parisc/lba_pci.c
@@ -1403,9 +1403,27 @@ lba_hw_init(struct lba_device *d)
 		WRITE_REG32(stat, d->hba.base_addr + LBA_ERROR_CONFIG);
 	}

-	/* Set HF mode as the default (vs. -1 mode). */
+
+	/*
+	 * Hard Fail vs. Soft Fail on PCI "Master Abort".
+	 *
+	 * "Master Abort" means the MMIO transaction timed out - usually due to
+	 * the device not responding to an MMIO read. We would like HF to be
+	 * enabled to find driver problems, though it means the system will
+	 * crash with a HPMC.
+	 *
+	 * In SoftFail mode "~0L" is returned as a result of a timeout on the
+	 * pci bus. This is like how PCI busses on x86 and most other
+	 * architectures behave.  In order to increase compatibility with
+	 * existing (x86) PCI hardware and existing Linux drivers we enable
+	 * Soft Faul mode on PA-RISC now too.
+	 */
         stat =3D READ_REG32(d->hba.base_addr + LBA_STAT_CTL);
+#if defined(ENABLE_HARDFAIL)
 	WRITE_REG32(stat | HF_ENABLE, d->hba.base_addr + LBA_STAT_CTL);
+#else
+	WRITE_REG32(stat & ~HF_ENABLE, d->hba.base_addr + LBA_STAT_CTL);
+#endif

 	/*
 	** Writing a zero to STAT_CTL.rf (bit 0) will clear reset signal
