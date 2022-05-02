Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486B35179DC
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 00:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbiEBWVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 18:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbiEBWVV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 18:21:21 -0400
Received: from mout.web.de (mout.web.de [212.227.17.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022692AD
        for <stable@vger.kernel.org>; Mon,  2 May 2022 15:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1651529860;
        bh=J2mN6cayWguxLbNSpSdcOiiPNoLDjczpKUEz4t5MWSU=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=JQTzx8o5c7A3w3+8qjKZsMKn6fQoq8wF+wWhzTLMgQ0qNLHekq7H7no9EYPkSCH0c
         gOcKrcNqwEr7AxM6O4wT7Qc97gUqbcT/I1AetIEFbLPY4kCIl+0mfl7NIXuC97SSVG
         948vBRKTReaimjItwbo64nG2pAFqZ5rM85ZIBxqY=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from uruz.dynato.kyma ([79.245.218.86]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1Mx0Ij-1o1v6F0cPr-00yDtk; Tue, 03
 May 2022 00:17:40 +0200
Received: from [127.0.0.1]
        by uruz.dynato.kyma with esmtp (Exim 4.95)
        (envelope-from <jvpeetz@web.de>)
        id 1nleMO-0000oo-6m;
        Tue, 03 May 2022 00:17:40 +0200
Message-ID: <4bfd2811-69ec-e4ec-2957-7054a075aa50@web.de>
Date:   Tue, 3 May 2022 00:17:40 +0200
MIME-Version: 1.0
Subject: Re: Linux 5.17.5
Content-Language: en-US
To:     JoergRoedel <joro@8bytes.org>
Cc:     SuraveeSuthikulpanit <suravee.suthikulpanit@amd.com>,
        vasant.hegde@amd.com, WillDeacon <will@kernel.org>,
        stable@vger.kernel.org
References: <165106510338255@kroah.com>
 <a5c7406e-64b0-7522-fef0-27fec1ac6698@web.de> <Ym+oOjFrkdju5H6X@8bytes.org>
From:   =?UTF-8?Q?J=c3=b6rg-Volker_Peetz?= <jvpeetz@web.de>
In-Reply-To: <Ym+oOjFrkdju5H6X@8bytes.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:jTCOUTabPQFA5X+RRA8fnUhTuvWkC3HYvpiSuMFLJo/DElea2qy
 EdheOQIk5jyxRX6cf+wrIRO+gyO1weRdOvV0OwiQ7LOZXC9jtd1UB7X+jPcTIA7Q+/8H9Ep
 iDcMlafdaf7mp0eJxaA7d198rZpAnyou/xEa9dkK2HxpYYqzyKiJWV8xApUCM+RbZa3BJF7
 R6I/TXKr2TCMk7wtyCwZg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:DcJPUSAu1SE=:Ec//4p3aBZNvFOw/vDc1+Y
 0EKEfMuiC4WEetoRi16Kx4M2nUmSRz1uMkGEIgssI41WSoWofzra6ZjfKXsxQ5YZZ8W2eNi0i
 W1i738QVUvNTtsm+MB+z74n9p6hmAR/gmtMgQ731y7uvWnIBZ8zYfYN7sotHKiBs00IkPTY/K
 swJJecXwXPPch9K7OCXcuFHb/YW6Er8f7l7P2P1IzOexYWLFpZUFXXpalBKQFvevlReIwQWu6
 dAtIvoyZk3hjWxHcs6g2Ld+n/BTfTEmEz0AKpGssbrJnLbVR2JTcJMMHG+r26HeGl0Bjdv/Hd
 sHmA0I11buDpID1T9x9jbrzSZ9KxuXd1rvxsCdDBYGeYs4oshBiLvOiMjPGej5iFurV/KJYyh
 haHzsDCvwC30xVAJLWSc1keHfTt/qOVf9Hs+BBQVwssUcxgzKnx5SEZ+rRIAvfqYlszvW14fQ
 TzfhE1Ylv+Kz5PqVSss1od172GcceOgBycRf21/3EV+s+oUxsqrA1goPfOZz1z1bjlrwDETTc
 spC9K9m1yK9U4B69AmPWaUZLL7bYT0p1JfPqUy1MJY8zGyNOzz3m8uf4dJTBLQXpdDYePY7Wm
 cLph8oRrFYAt+VcafzfYrcUNbuYgXorjTZo/l9wNlZJB6J/jwZFZZkTsNQrGS/XGbJeyzZ8KL
 1MUDiH0vToGfa01xxDQ0DcvSx+r2h0pEj5zHtuL6GopbwZTfpzTdSKe5SFiqTtmUTPZ1H50R6
 hP9+ftQsThjJmbcpWwcEGDlh+aR2Dppypv5QpdvDu6YXcEXRmMj49wkzPGmwQHZIxaqsmKQaO
 tCc4OsTDkHX4/iwFYZaBmzxXqoo0r/Ye36fny1sE9cejTz7Wdft551nHuY326KxsD7HMMu6lj
 6u8WAtJ4nN9s6MnnlpIJccXV2TvNLYU8Ltu2br2jtNXO3p4vdVzMkEUdL2/TnvIQ1TTsEHCby
 by0k0SjXA19xEHOESMGfXgTSyK0ZU+tvNBDA/eJV2HfBvkmoUBY3kqI9z/BbisJcIYf4rz/zX
 M+PAFfYPooATbJn8uuHNjulJkpuXrT5iEvle6kpBTUz4U2J54uq3cjYrI75l5Wiexx8p2P383
 o+K03D82ZqlXS0=
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

no, right at the first cold boot with the patched kernel the warning appea=
red:

May  2 21:50:27 xxx kernel: WARNING: CPU: 0 PID: 1 at
drivers/iommu/amd/init.c:851 amd_iommu_enable_interrupts+0x312/0x3f0
May  2 21:50:27 xxx kernel: Modules linked in:
May  2 21:50:27 xxx kernel: CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.17=
.5 #2
May  2 21:50:27 xxx kernel: Hardware name: Micro-Star International Co., L=
td.
MS-7C94/MAG B550M MORTAR (MS-7C94), BIOS 1.94 09/23/2021
May  2 21:50:27 xxx kernel: RIP: 0010:amd_iommu_enable_interrupts+0x312/0x=
3f0
May  2 21:50:27 xxx kernel: Code: ff ff 49 8b 7f 18 89 04 24 e8 2a ff f6 f=
f 8b
04 24 e9 7b fd ff ff 0f 0b 4d 8b 3f 49 81 ff 90 15 4c 9f 0f 85 35 fd ff ff=
 eb 82
<0f> 0b 4d 8b 3f 49 81 ff 90 15 4c 9f 0f 85 21 fd ff ff e9 6b ff ff
May  2 21:50:27 xxx kernel: RSP: 0018:ffffb9ad4005fdd8 EFLAGS: 00010246
May  2 21:50:27 xxx kernel: RAX: 00000015be386e7c RBX: 0000000000000000 RC=
X:
0000000000000000
May  2 21:50:27 xxx kernel: RDX: 0000000000009e16 RSI: 0000000000009427 RD=
I:
00000015be37d066
May  2 21:50:27 xxx kernel: RBP: 0000000080000000 R08: ffffffffffffffff R0=
9:
0000000000000000
May  2 21:50:27 xxx kernel: R10: 00000000000000d1 R11: 0000000000000000 R1=
2:
000ffffffffffff8
May  2 21:50:27 xxx kernel: R13: 0800000000000000 R14: 0008000000000000 R1=
5:
ffff9a4600190000
May  2 21:50:27 xxx kernel: FS:  0000000000000000(0000)
GS:ffff9a53f1e00000(0000) knlGS:0000000000000000
May  2 21:50:27 xxx kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050=
033
May  2 21:50:27 xxx kernel: CR2: ffff9a51c9c01000 CR3: 0000000cc960a000 CR=
4:
0000000000750ef0
May  2 21:50:27 xxx kernel: PKRU: 55555554
May  2 21:50:27 xxx kernel: Call Trace:
May  2 21:50:27 xxx kernel: <TASK>
May  2 21:50:27 xxx kernel: iommu_go_to_state+0x10e0/0x138d
May  2 21:50:27 xxx kernel: ? e820__memblock_setup+0x78/0x78
May  2 21:50:27 xxx kernel: amd_iommu_init+0xa/0x20
May  2 21:50:27 xxx kernel: pci_iommu_init+0x11/0x3a
May  2 21:50:27 xxx kernel: do_one_initcall+0x47/0x180
May  2 21:50:27 xxx kernel: kernel_init_freeable+0x162/0x1a7
May  2 21:50:27 xxx kernel: ? rest_init+0xc0/0xc0
May  2 21:50:27 xxx kernel: kernel_init+0x11/0x110
May  2 21:50:27 xxx kernel: ret_from_fork+0x22/0x30
May  2 21:50:27 xxx kernel: </TASK>

For a cold boot I switch off the computer for ca. 30 seconds and switch it=
 on
again. I booted into a console where I looked out for warnings with `dmesg=
 -l
warn`. Then I tried to start X with `startx` but the screen got blocked. V=
ia ssh
I ordered `reboot`, a warm start. Then the warning didn't appear, I could =
start
X and work normally.

In 'kern.log' I also found this:

May  2 21:53:27 xxx kernel: [drm:amdgpu_job_timedout [amdgpu]] *ERROR* rin=
g gfx
timeout, signaled seq=3D16, emitted seq=3D17
May  2 21:53:27 xxx kernel: [drm:amdgpu_job_timedout [amdgpu]] *ERROR* Pro=
cess
information: process Xorg pid 1787 thread Xorg:cs0 pid 1788
May  2 21:53:27 xxx kernel: amdgpu 0000:30:00.0: amdgpu: GPU reset begin!
May  2 21:53:27 xxx kernel: amdgpu 0000:30:00.0: [drm:amdgpu_ring_test_hel=
per
[amdgpu]] *ERROR* ring kiq_2.1.0 test failed (-110)
May  2 21:53:27 xxx kernel: [drm] free PSP TMR buffer
May  2 21:53:27 xxx kernel: amdgpu 0000:30:00.0: amdgpu: MODE2 reset
May  2 21:53:27 xxx kernel: amdgpu 0000:30:00.0: amdgpu: GPU reset succeed=
ed,
trying to resume
May  2 21:53:27 xxx kernel: [drm] PCIE GART of 1024M enabled.
May  2 21:53:27 xxx kernel: [drm] PTB located at 0x000000F400900000
May  2 21:53:27 xxx kernel: [drm] PSP is resuming...
May  2 21:53:27 xxx kernel: [drm] reserve 0x400000 from 0xf4ff800000 for P=
SP TMR
May  2 21:53:27 xxx kernel: amdgpu 0000:30:00.0: amdgpu: RAS: optional ras=
 ta
ucode is not available
May  2 21:53:27 xxx kernel: amdgpu 0000:30:00.0: amdgpu: RAP: optional rap=
 ta
ucode is not available
May  2 21:53:27 xxx kernel: amdgpu 0000:30:00.0: amdgpu: SECUREDISPLAY:
securedisplay ta ucode is not available
May  2 21:53:27 xxx kernel: amdgpu 0000:30:00.0: amdgpu: SMU is resuming..=
.
May  2 21:53:27 xxx kernel: amdgpu 0000:30:00.0: amdgpu: SMU is resumed
successfully!
May  2 21:53:27 xxx kernel: [drm] DMUB hardware initialized: version=3D0x0=
101001F
May  2 21:53:28 xxx kernel: [drm] kiq ring mec 2 pipe 1 q 0
May  2 21:53:28 xxx kernel: amdgpu 0000:30:00.0: [drm:amdgpu_ring_test_hel=
per
[amdgpu]] *ERROR* ring kiq_2.1.0 test failed (-110)
May  2 21:53:28 xxx kernel: [drm:amdgpu_gfx_enable_kcq.cold [amdgpu]] *ERR=
OR*
KCQ enable failed
May  2 21:53:28 xxx kernel: [drm:amdgpu_device_ip_resume_phase2 [amdgpu]]
*ERROR* resume of IP block <gfx_v9_0> failed -110
May  2 21:53:28 xxx kernel: amdgpu 0000:30:00.0: amdgpu: GPU reset(2) fail=
ed
May  2 21:53:28 xxx kernel: amdgpu 0000:30:00.0: amdgpu: GPU reset end wit=
h ret
=3D -110
May  2 21:53:38 xxx kernel: [drm:amdgpu_job_timedout [amdgpu]] *ERROR* rin=
g gfx
timeout, signaled seq=3D17, emitted seq=3D17
May  2 21:53:38 xxx kernel: [drm:amdgpu_job_timedout [amdgpu]] *ERROR* Pro=
cess
information: process Xorg pid 1787 thread Xorg:cs0 pid 1788
May  2 21:53:38 xxx kernel: amdgpu 0000:30:00.0: amdgpu: GPU reset begin!

Thanks for your help.
Regards,
J=C3=B6rg.

JoergRoedel wrote on 02/05/2022 11:45:
> [now with Vasants correct email address]
>
> Hi J=C3=B6rg,
>
> can you please try the attached patch? It should get rid of the WARNING
> on your system.
>
> Suravee, Vasant, can you please test review the patch and report whether
> the GA log functionality is still working?
>
> Thanks,
>
> 	Joerg
>
>  From 4fee768d5c23715eae31fed3b41cdf045e099aef Mon Sep 17 00:00:00 2001
> From: Joerg Roedel <jroedel@suse.de>
> Date: Mon, 2 May 2022 11:37:43 +0200
> Subject: [PATCH] iommu/amd: Do not poll GA_LOG_RUNNING mask at boot
>
> On some hardware it takes more than a second for the hardware to get
> the GA log into running state. This is too long to poll for in the AMD
> IOMMU driver code.
>
> Instead, check whehter initialization was successful before polling
> the log for the first time.
>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>   drivers/iommu/amd/amd_iommu_types.h |  3 +++
>   drivers/iommu/amd/init.c            | 13 ++-----------
>   drivers/iommu/amd/iommu.c           | 25 ++++++++++++++++++++++++-
>   3 files changed, 29 insertions(+), 12 deletions(-)
<snip>
