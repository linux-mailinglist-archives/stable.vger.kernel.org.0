Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD101469552
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 12:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235915AbhLFL65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 06:58:57 -0500
Received: from mout.gmx.net ([212.227.15.19]:53787 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233520AbhLFL65 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Dec 2021 06:58:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1638791727;
        bh=mJRdrFpukZJ/AfNWxtYbl5SqWrOFwL8sznkhmBbl64w=;
        h=X-UI-Sender-Class:Date:From:To:Subject;
        b=Hz5DT4ygNcqTtQmIeda79k66aDFzssq95EbpoQxmEKObZROb1f9fd52Dp0jJWoZLh
         YQgAAmLU0EoxL/jWK/LNZ5HhWtC2eyvcDjaIsc9TjmYXbMax0YyK1hPfNUbvHxCGc+
         gFpAZ4XNOIShQ+JKtOHGrMVvZpq93PcXERPjFYIA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from ls3530 ([92.116.133.142]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MMGN2-1nBBVZ1RWY-00JIJS; Mon, 06
 Dec 2021 12:55:27 +0100
Date:   Mon, 6 Dec 2021 12:55:18 +0100
From:   Helge Deller <deller@gmx.de>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] parisc stable patch: parisc: Mark cr16 CPU clocksource
 unstable on all SMP machines
Message-ID: <Ya36JqHtMQv/H2Z4@ls3530>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Provags-ID: V03:K1:GjAcSGBZxEmqmjXfXGRGzukqUTOaTTkQMi1N1I7NBVam2wIJ5xe
 M7akOZRESSnELXLH4E1J1hGviNwj0o3AvVMcuPGufClByw4XLStUdwpF2EM93ho6G0YfSth
 DGh4uJ2gGBd82NKwPCy/aErkjqW/xSIb4aKnA/eUZjaATOV8WtYvxJXvx+GM2Gb0jc2YBco
 iMmXx0IAoqF6oSyumBlHw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ltAUOY5f9+A=:s2Y3+n7f8LsQZ9FEotZPtK
 awvobNgTm02p+mnIfUUuSoc0g/EdLHCG7nhFgTp4nlYWk63JRAvM0DAIQZyqKlV5W/wuiEYIF
 ZlkuFPZBjMsu0JqzsMo6AcXAFhe3xJezqZbE/QGztEwm44bp8/2Ee5f7XWcbMvIzHPVm+J28s
 v1Z60JHF3+2p1G1ooo7FpLsXSrJlVrcr4XQjiVJ3SFE/VjLma4rIchKkLLapHJsnrDOAbuhkL
 eaA7Lz4Kb91+47aLAo5pElvXA0ukmeO8ItvAFnegBto5GTifxPUqVtB8lr48K+NKiWTJtOIBJ
 xYbDVat5m7iS2pZ6Ubno6kApJlPniQA6DpRPyviqWwyXiLGKWHYvCdUFGwK4XUfHAnbx7AY4h
 Zk01NX4HxKuOBBaGGNnRKaonxKZxQ23/vFW6rT+Fql9VUPI/DGpo5Uyvjatpqc4ICjYySxL1z
 XLF0veN46bQbEdoImyBM+ndkjc1QvwwEM9K32vAD4iPt7LsKhMPaLIjH7NimqwXUnuLMui5ny
 Y0EWaVGylfxISib93j0+moP5k0whv13tI7yFFEf6yvojSi9ZZQKuHB6bhiONVSoiI+H6JzWoB
 RR0/iGoK7T7qAV7NIfr5e6ZpAK5psEcPLVBGNMmlR2ZYzf0a7dcpDzVYUjGfO8mP1H77oBTJ9
 NI1YzAxavkudCBbdhgrVfT+NBWbpiuNePkqO4Kh79uJQHxPQxN7JsBA1ZCrLfh6KtgOwtuDYb
 GR/MFpti5yxprfBTMPPfqzFtDwOJQdhW9tGyF/QVQIHvIJf08i+MUo+k7CL59x9lbNS2+o4B/
 U8I6xLPL/6xN98815RlmvPouUhQxbwdh75ffx0czkKD5uI8hEa6XlRS67BnelgKH/SQuIZ1zL
 wbA/fevdib1RmafgTLe0/V9JwaRtgiAj1g8rY0UbtVVfPjKsc7BErmZsLtWB4n9jqFyUbkQwp
 3Gv2TGuYpvSDr3IfPTX/51RnlsJxseaGvPAdBnzsm5w1Y93WCdYjZhdz7/t9bE1zzp552gCmx
 Aat8x1Cxk+7N5BzbhnKTSX9gjqidlnCdgtD6wZk6FiWHIWMxmH+LTCPWWH/k3awokWUpGqhZe
 N0NmvwPoUJOLgk=
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello stable team,

can you please apply this patch to stable kernels from v4.14 up to v5.14 (=
both including).

It's a backport of upstream commit:
  commit afdb4a5b1d340e4afffc65daa21cc71890d7d589
  parisc: Mark cr16 CPU clocksource unstable on all SMP machines

The upstream commit doesn't apply cleanly to those kernels, so this
patch has been adjusted so that it now applies.

Thanks!
Helge

=2D------------
Author: Helge Deller <deller@gmx.de>
Date:   Sat Dec 4 21:21:46 2021 +0100

parisc: Mark cr16 CPU clocksource unstable on all SMP machines

In commit c8c3735997a3 ("parisc: Enhance detection of synchronous cr16
clocksources") I assumed that CPUs on the same physical core are syncronou=
s.
While booting up the kernel on two different C8000 machines, one with a
dual-core PA8800 and one with a dual-core PA8900 CPU, this turned out to b=
e
wrong. The symptom was that I saw a jump in the internal clocks printed to=
 the
syslog and strange overall behaviour.  On machines which have 4 cores (2
dual-cores) the problem isn't visible, because the current logic already m=
arked
the cr16 clocksource unstable in this case.

This patch now marks the cr16 interval timers unstable if we have more tha=
n one
CPU in the system, and it fixes this issue.

Fixes: c8c3735997a3 ("parisc: Enhance detection of synchronous cr16 clocks=
ources")
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # v5.15+

diff --git a/arch/parisc/kernel/time.c b/arch/parisc/kernel/time.c
index 08e4d480abe1..f26c9f466cdd 100644
=2D-- a/arch/parisc/kernel/time.c
+++ b/arch/parisc/kernel/time.c
@@ -249,27 +249,13 @@ void __init time_init(void)
 static int __init init_cr16_clocksource(void)
 {
 	/*
-	 * The cr16 interval timers are not syncronized across CPUs on
-	 * different sockets, so mark them unstable and lower rating on
-	 * multi-socket SMP systems.
+	 * The cr16 interval timers are not syncronized across CPUs, even if
+	 * they share the same socket.
 	 */
 	if (num_online_cpus() > 1 && !running_on_qemu) {
-		int cpu;
-		unsigned long cpu0_loc;
-		cpu0_loc =3D per_cpu(cpu_data, 0).cpu_loc;
-
-		for_each_online_cpu(cpu) {
-			if (cpu =3D=3D 0)
-				continue;
-			if ((cpu0_loc !=3D 0) &&
-			    (cpu0_loc =3D=3D per_cpu(cpu_data, cpu).cpu_loc))
-				continue;
-
-			clocksource_cr16.name =3D "cr16_unstable";
-			clocksource_cr16.flags =3D CLOCK_SOURCE_UNSTABLE;
-			clocksource_cr16.rating =3D 0;
-			break;
-		}
+		clocksource_cr16.name =3D "cr16_unstable";
+		clocksource_cr16.flags =3D CLOCK_SOURCE_UNSTABLE;
+		clocksource_cr16.rating =3D 0;
 	}

 	/* XXX: We may want to mark sched_clock stable here if cr16 clocks are
