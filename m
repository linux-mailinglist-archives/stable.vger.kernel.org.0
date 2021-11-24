Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78DA745B55A
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 08:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241065AbhKXHbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 02:31:55 -0500
Received: from mout.gmx.net ([212.227.17.22]:58031 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241030AbhKXHbz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 02:31:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1637738920;
        bh=IMUp4Ztgn3b+6L4MDjD7KSSA5ldvAI9KNoDlsmCRQuY=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:Date;
        b=VMsKqHx3Iqow+NYGUL3sFwKmqEYrl5EdIYKJ9TE6iLWyaAFSYpDWi5SwrYTRig5Bn
         FhKeVrkbMWdCESMskie2dyCeMMrETjseL/cwn2XQPKaiFuLrmtEKh2tpxv910H2L3e
         RLfQoflSl79uoRUjxAirJu++rH8aCMvDRyzhmGmM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from machineone ([84.190.131.218]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MrhUK-1mJjff3rzo-00nlp6; Wed, 24
 Nov 2021 08:28:39 +0100
Message-ID: <924175a188159f4e03bd69908a91e606b574139b.camel@gmx.de>
Subject: [REGRESSION] Kernel 5.15 reboots / freezes upon ifup/ifdown
From:   Stefan Dietrich <roots@gmx.de>
To:     stable@vger.kernel.org
Cc:     regressions@lists.linux.dev
Date:   Wed, 24 Nov 2021 08:28:39 +0100
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:h/1nXgH+kMZMSQs2ptkxS15s5grYstyOohZUefaC+dPvCLM02SE
 zA6X/Y6MRru9ExGG7uI97zJ1wMtR0NL33a0fAY6mZkMpmwzJtKDUk7eKC/dBc7Hjrf/oirX
 jBL7ImIJSX37a+wABC5UtYshKnZIvDCuzzsEeCIV+VF8mmgeAEnR792EBHMV0KW2NVtdcD9
 rvJGaUkjfHDOUxp1dP2zg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:9wyMni8/+3M=:Xv6VeU2vp78HC8IKLd7sSp
 u9W9rxP0ZVztbu/R48Kf3CEU0lG56VYxEheGp3f1Lj+5+YC87pmwJspunOG4YVrcSPjcJm7A5
 GZ9JNCD3k9Vh/lGzVC/9Om/J2R8rZgEsqluG8xuvpkx8etaOPd7qcE/vD2q1QHK6TcrBIDvGS
 dr0VVSTbMNxdAJW7VB8KP5jNPg9I012KQe0ubYqgjvVguf2p0YdIHBQlAu9p6i+wmD3JLJnV7
 bY0HS6sqdDkljFsHz85mGQAKNMNKzGa+Agf3G9dU8q3xwwaYepSo8jcitB4nchpMM8dkFoIPp
 y9e5t8840vlt/82Hv69+QZ/5cVSNn/kFU5Ezg1Pl2+dwmurMVHFUjNFWg/9sgDcrM0sAuSZOR
 TT/Ak+IrHU9/CjEni2C+4zZMcW1tn48zOBZ4eE3tKKjLbU60TGlqw1H092FLLcWASwl244drP
 plTkhP5fyHAyiu41t5JQGebJUtyd9B0n+i/mSOUqyyF6mDaiDvP0EUKtIP6LXWj8KmgJuZfvn
 TM/gz76oevQymw90wm3fcK88fS6lqHvwSk8PRDXsI6LjAWRCaPQHEfqwULVgHgin2fEfD1Bjq
 d6E2y7krAvXp0+ziB0yGLvyN3dfUHviQaK77ryjd5M70uxq5QYxVNRJfEqiVFEuztxg9Ta4fu
 vUkC5mnVcBqu2Xs9gEj8vnx+o/vSz4AXfXMbEA3xxaCcZ0dLfF13WM7FIIp2cBcOiTWiTg8Yz
 13DmL3dYzKLZYJqVODEUN2g3cWlQxKc7ItD/onBMD2fGRYes3YroLzMB2IH7PRh4wUgX2HxF4
 j4afc75kEqLuJvFioIRRi4PCYTcEOsnRwEAXznr/b7MaEUV9wTfSZGYdDlmTsNk3T/rYHyPvv
 AcqQGQPyjdi+SRtYrLbhbNX4kKZq4nEt5CwGHY+5DkKhqFC1lzHloxrguLgGEmV9qrLJWrSVk
 V9yl73+DHC1N6Gw8+whB/46KucVyiAXyjAeWdWxmsUZaeLKCwQhHDh96uhEb2CkmtnKw0Rv3T
 /mLYbiflpEqr3cIi8qEI0M3ZNjzTT4/puvJNGfmo9h9Hpi4lLhPRW40wU2zYhGB0Tw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Summary: When attempting to rise or shut down a NIC manually or via
network-manager under 5.15, the machine reboots or freezes.

Occurs with: 5.15.4-051504-generic and earlier 5.15 mainline (
https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.15.4/) as well as
liquorix flavours.
Does not occur with: 5.14 and 5.13 (both with various flavours)


Hi all,

I'm experiencing a severe bug that causes the machine to reboot or
freeze when trying to login and/or rise/shutdown a NIC. Here's a brief
description of scenarios I've tested:

Scenario 1: enp6s0 managed manually using /etc/networking/interfaces,
DHCP
a. Issuing ifdown enp6s0 in terminal will throw
	"/etc/resolvconf/update.d/libc: Warning: /etc/resolv.conf is
	not a symbolic link to /run/resolvconf/resolv.conf"
and cause the machine to reboot after ~10s of showing a blinking cursor

b. Issuing shutdown -h now or trying to shutdown/reboot machine via
GUI:
shutdown will stop on "stop job is running for ifdown enp6s0" and after
approx. 10..15s the countdown freezes. Repeated ALT-SysReq-REISUB does
not reboot the machine, a hard reset is required.

=2D-

Scenario 2: enp6s0 managed manually using /etc/networking/interfaces,
STATIC
a. Issuing ifdown enp6s0 in terminal will throw
	"send_packet: Operation not permitted
	dhclient.c:3010: Failed to send 300 byte long packet over
	fallback interface."
and cause the machine to reboot after ~10s of blinking cursor.

b. Issuing shutdown -h now or trying to shutdown or reboot machine via
GUI: shutdown will stop on "stop job is running for ifdown enp6s0" and
after approx. 10..15s the countdown freezes. Repeated ALT-SysReq-REISUB
does not reboot the machine, a hard reset is required.

=2D-

Scenario 3: enp6s0 managed by network manager
a. After booting and logging in either via GUI or TTY, the display will
stay blank and only show a blinking cursor and then freeze after
5..10s. ALT-SysReq-REISUB does not reboot the machine, a hard reset is
required.

=2D-

Here's a snippet from the journal for Scenario 1a:

Nov 21 10:39:25 computer sudo[5606]:    user : TTY=3Dpts/0 ;
PWD=3D/home/user ; USER=3Droot ; COMMAND=3D/usr/sbin/ifdown enp6s0
Nov 21 10:39:25 computer sudo[5606]: pam_unix(sudo:session): session
opened for user root by (uid=3D0)
=2D- Reboot --
Nov 21 10:40:14 computer systemd-journald[478]: Journal started

=2D-

I'm running Alder Lake i9 12900K but I have E-cores disabled in BIOS.
Here are some more specs with working kernel:

$ inxi -bxz
System:    Kernel: 5.14.0-19.2-liquorix-amd64 x86_64 bits: 64 compiler:
N/A Desktop: Xfce 4.16.3
           Distro: Ubuntu 20.04.3 LTS (Focal Fossa)
Machine:   Type: Desktop System: ASUS product: N/A v: N/A serial: N/A
           Mobo: ASUSTeK model: ROG STRIX Z690-A GAMING WIFI D4 v: Rev
1.xx serial: <filter>
           UEFI [Legacy]: American Megatrends v: 0707 date: 11/10/2021
CPU:       8-Core: 12th Gen Intel Core i9-12900K type: MT MCP arch: N/A
speed: 5381 MHz max: 3201 MHz
Graphics:  Device-1: NVIDIA vendor: Gigabyte driver: nvidia v: 470.86
bus ID: 01:00.0
           Display: server: X.Org 1.20.11 driver: nvidia tty: N/A
           Message: Unable to show advanced data. Required tool glxinfo
missing.
Network:   Device-1: Intel vendor: ASUSTeK driver: igc v: kernel port:
4000 bus ID: 06:00.0


Please advice how I may assist in debugging!

Thanks.

