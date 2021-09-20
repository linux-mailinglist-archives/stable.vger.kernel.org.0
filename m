Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE3EC4111E3
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 11:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbhITJ2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 05:28:12 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63664 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232897AbhITJ2L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 05:28:11 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18K6LDeQ005531;
        Mon, 20 Sep 2021 05:26:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=x9dqw3sgaIja7h8RxzrxXHI7I4FsA4/B/BOuhV8Izao=;
 b=fPo5KV+CgQscPrL06yLAd/kgbypqLCtqJQKYH1qkkKmBh76hadslNy+NQEgdJlBIYssH
 51KFWt0AU6348buDlaL/nI9RmzaIfWrAL/lMGyaDbwXKTuzk5pvj7EMjwd7t5qXvfpCC
 QVVP2I4BZsYgvOXiFd6AbsgAuEE0YSnb5E8XKLbr4GA6V/pHmx/6MpMAll8VrA9MK36Z
 xIMdL3brIunMmmkfgXdQqQ6WLpz4ACe2DIzopK5Uk4QmzJu/9i1bLtIxD9rIS53eaDKX
 NqnACS6Ed3wtotGcgrIlVpqLprarGrklkG75a/pfBvvATUBwaWLXRfFbKS5mNSGBt2/z /w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b5w785bdk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 05:26:33 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18K9HE75032199;
        Mon, 20 Sep 2021 05:26:32 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b5w785bcx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 05:26:32 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18K9D8Qi016928;
        Mon, 20 Sep 2021 09:26:30 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3b57r8e8qw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 09:26:29 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18K9QRHI64225546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 09:26:27 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67C5B42056;
        Mon, 20 Sep 2021 09:26:27 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80AC542049;
        Mon, 20 Sep 2021 09:26:26 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.145.153.169])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 20 Sep 2021 09:26:26 +0000 (GMT)
Date:   Mon, 20 Sep 2021 12:26:24 +0300
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     Mike Galbraith <efault@gmx.de>
Cc:     linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
        marmarek@invisiblethingslab.com, Juergen Gross <jgross@suse.com>,
        Borislav Petkov <bp@suse.de>, stable@vger.kernel.org,
        x86@kernel.org
Subject: Re: [tip: x86/urgent] x86/setup: Call early_reserve_memory() earlier
Message-ID: <YUhTwPhva5olB87d@linux.ibm.com>
References: <20210914094108.22482-1-jgross@suse.com>
 <163178944634.25758.17304720937855121489.tip-bot2@tip-bot2>
 <4422257385dbee913eb5270bda5fded7fbb993ab.camel@gmx.de>
 <YUdtm8hVH0ps18BK@linux.ibm.com>
 <fc21617d65338078366e70704eb55789a810e45e.camel@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc21617d65338078366e70704eb55789a810e45e.camel@gmx.de>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zM9K5r-HBDCwr73iehWSlG2TJXATOSBZ
X-Proofpoint-ORIG-GUID: sirwv8Acx_-XsMO1x2LP7r_pjxpKUbnv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-20_05,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 mlxscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=999 impostorscore=0
 malwarescore=0 bulkscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109200055
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, Sep 20, 2021 at 02:56:15AM +0200, Mike Galbraith wrote:
> On Sun, 2021-09-19 at 20:04 +0300, Mike Rapoport wrote:
> >
> > Can you please send the boot log of a working kernel up to
> >
> > "Memory: %luK/%luK available"
> >
> > line for both of them?
> 
> Desktop box:
> [    0.000000] microcode: microcode updated early to revision 0x28, date = 2019-11-12
> [    0.000000] Linux version 5.15.0.g02770d1-tip (root@homer) (gcc (SUSE Linux) 7.5.0, GNU ld (GNU Binutils; SUSE Linux Enterprise 15) 2.35.1.20201123-7.18) #46 SMP Sun Sep 19 18:42:41 CEST 2021
> [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-5.15.0.g02770d1-tip root=UUID=891c2a1f-cc1a-464b-a529-ab6add65aa21 scsi_mod.use_blk_mq=1 ftrace_dump_on_oops skew_tick=1 nortsched nodelayacct audit=0 cgroup_disable=memory cgroup_hide=all mitigations=off noresume panic=60 ignore_loglevel showopts crashkernel=204M

Thanks!
Can't say anything caught my eye, except the early microcode update.
Just to rule that out, can you try booting without the early microcode
update?

And, to check Juergen's suggestion about failure in
memblock_x86_reserve_range_setup_data(), can you try this patch on top of
the failing tip:

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 25425edc81a4..78162d9e90cf 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -716,8 +716,6 @@ static void __init early_reserve_memory(void)
 	if (efi_enabled(EFI_BOOT))
 		efi_memblock_x86_reserve_range();
 
-	memblock_x86_reserve_range_setup_data();
-
 	reserve_ibft_region();
 	reserve_bios_regions();
 	trim_snb_memory();
@@ -888,6 +886,8 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	x86_configure_nx();
 
+	memblock_x86_reserve_range_setup_data();
+
 	parse_early_param();
 
 #ifdef CONFIG_MEMORY_HOTPLUG

-- 
Sincerely yours,
Mike.
