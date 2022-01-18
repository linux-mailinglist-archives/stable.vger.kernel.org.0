Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0432A49210C
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 09:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbiARISx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 03:18:53 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1038 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231218AbiARISw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 03:18:52 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20I6Qrqh016440;
        Tue, 18 Jan 2022 08:18:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ViqkJtmDnxe4El0ZsPaatK607nUr+I3f9GvrrJSBpYQ=;
 b=B4K62Ngai+9DugK4xmzB9uyvhCTTyPP0vCttOUnnHnrT+7aVKhuUXqSlC+dhy7dssS0b
 aXJHijttMciJZ6/pYyr0GTLLRe0xrTFSbGtWr1s9x92Wu2pwenw3rrx+rnKkt1wmaSrG
 Kx7g9hIWk4N6/QrSN/faMtXTLLKas7EmuhT5ikMoXc4l1+XBTDJcBKtV9t5QjuBWS9E/
 95Z+34Ue8hd3+RNzPZeyLUh2YxGqcAhmEDRNjIxnMWYRB/dSK1KdLGRwL1Z8u+eAV+fq
 +dNQzXHOvEPi4UiR54ILVlvunohPdis5xxB7J5tLYfBGK5iDpLOHFJlThUlIAPC70q7e nw== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnr9sjhk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 08:18:47 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20I8HE1g032636;
        Tue, 18 Jan 2022 08:18:44 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3dnm6r1ugd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 08:18:44 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20I8Ifur40567110
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 08:18:41 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79E614C04E;
        Tue, 18 Jan 2022 08:18:41 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A95184C044;
        Tue, 18 Jan 2022 08:18:40 +0000 (GMT)
Received: from [9.171.19.84] (unknown [9.171.19.84])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 08:18:40 +0000 (GMT)
Message-ID: <aef11e2f-2b92-e713-a407-3bebf9b3340d@linux.ibm.com>
Date:   Tue, 18 Jan 2022 09:18:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH AUTOSEL 5.15 081/188] s390/nmi: add missing __pa/__va
 address conversion of extended save area
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>, gor@linux.ibm.com,
        egorenar@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, ebiederm@xmission.com,
        valentin.schneider@arm.com, rppt@kernel.org, iii@linux.ibm.com,
        linux-s390@vger.kernel.org
References: <20220118023152.1948105-1-sashal@kernel.org>
 <20220118023152.1948105-81-sashal@kernel.org>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220118023152.1948105-81-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IR9tHnmbM_-1mAM8vTZ4Mx35-q-bZlbx
X-Proofpoint-ORIG-GUID: IR9tHnmbM_-1mAM8vTZ4Mx35-q-bZlbx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_01,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 suspectscore=0 impostorscore=0 mlxscore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 clxscore=1031
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180048
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 18.01.22 um 03:30 schrieb Sasha Levin:
> From: Heiko Carstens <hca@linux.ibm.com>
> 
> [ Upstream commit 402ff5a3387dc8ec6987a80d3ce26b0c25773622 ]
> 
> Add missing __pa/__va address conversion of machine check extended
> save area designation, which is an absolute address.
> 

vv
> Note: this currently doesn't fix a real bug, since virtual addresses
> are indentical to physical ones.
^^

Sasha,
please note the disclaimer above. There will be plenty of such fixes
in s390 code and there is no point in backporting single fixes to stable.
It will provide no benefit on its own but adds a risk of regression.



> 
> Reported-by: Vineeth Vijayan <vneethv@linux.ibm.com>
> Tested-by: Vineeth Vijayan <vneethv@linux.ibm.com>
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/s390/kernel/machine_kexec.c |  2 +-
>   arch/s390/kernel/nmi.c           | 10 +++++-----
>   arch/s390/kernel/smp.c           |  2 +-
>   3 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/s390/kernel/machine_kexec.c b/arch/s390/kernel/machine_kexec.c
> index 0505e55a62979..a16467b3825ec 100644
> --- a/arch/s390/kernel/machine_kexec.c
> +++ b/arch/s390/kernel/machine_kexec.c
> @@ -86,7 +86,7 @@ static noinline void __machine_kdump(void *image)
>   			continue;
>   	}
>   	/* Store status of the boot CPU */
> -	mcesa = (struct mcesa *)(S390_lowcore.mcesad & MCESA_ORIGIN_MASK);
> +	mcesa = __va(S390_lowcore.mcesad & MCESA_ORIGIN_MASK);
>   	if (MACHINE_HAS_VX)
>   		save_vx_regs((__vector128 *) mcesa->vector_save_area);
>   	if (MACHINE_HAS_GS) {
> diff --git a/arch/s390/kernel/nmi.c b/arch/s390/kernel/nmi.c
> index 20f8e1868853f..3f18c1412eba3 100644
> --- a/arch/s390/kernel/nmi.c
> +++ b/arch/s390/kernel/nmi.c
> @@ -68,7 +68,7 @@ void __init nmi_alloc_boot_cpu(struct lowcore *lc)
>   {
>   	if (!nmi_needs_mcesa())
>   		return;
> -	lc->mcesad = (unsigned long) &boot_mcesa;
> +	lc->mcesad = __pa(&boot_mcesa);
>   	if (MACHINE_HAS_GS)
>   		lc->mcesad |= ilog2(MCESA_MAX_SIZE);
>   }
> @@ -94,7 +94,7 @@ static int __init nmi_init(void)
>   	__ctl_store(cr0, 0, 0);
>   	__ctl_clear_bit(0, 28); /* disable lowcore protection */
>   	/* Replace boot_mcesa on the boot CPU */
> -	S390_lowcore.mcesad = origin | mcesa_origin_lc;
> +	S390_lowcore.mcesad = __pa(origin) | mcesa_origin_lc;
>   	__ctl_load(cr0, 0, 0);
>   	return 0;
>   }
> @@ -111,7 +111,7 @@ int nmi_alloc_per_cpu(struct lowcore *lc)
>   		return -ENOMEM;
>   	/* The pointer is stored with mcesa_bits ORed in */
>   	kmemleak_not_leak((void *) origin);
> -	lc->mcesad = origin | mcesa_origin_lc;
> +	lc->mcesad = __pa(origin) | mcesa_origin_lc;
>   	return 0;
>   }
>   
> @@ -119,7 +119,7 @@ void nmi_free_per_cpu(struct lowcore *lc)
>   {
>   	if (!nmi_needs_mcesa())
>   		return;
> -	kmem_cache_free(mcesa_cache, (void *)(lc->mcesad & MCESA_ORIGIN_MASK));
> +	kmem_cache_free(mcesa_cache, __va(lc->mcesad & MCESA_ORIGIN_MASK));
>   }
>   
>   static notrace void s390_handle_damage(void)
> @@ -246,7 +246,7 @@ static int notrace s390_validate_registers(union mci mci, int umode)
>   			: "Q" (S390_lowcore.fpt_creg_save_area));
>   	}
>   
> -	mcesa = (struct mcesa *)(S390_lowcore.mcesad & MCESA_ORIGIN_MASK);
> +	mcesa = __va(S390_lowcore.mcesad & MCESA_ORIGIN_MASK);
>   	if (!MACHINE_HAS_VX) {
>   		/* Validate floating point registers */
>   		asm volatile(
> diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
> index 1a04e5bdf6555..5c3d3d8f6b5d8 100644
> --- a/arch/s390/kernel/smp.c
> +++ b/arch/s390/kernel/smp.c
> @@ -622,7 +622,7 @@ int smp_store_status(int cpu)
>   		return -EIO;
>   	if (!MACHINE_HAS_VX && !MACHINE_HAS_GS)
>   		return 0;
> -	pa = __pa(lc->mcesad & MCESA_ORIGIN_MASK);
> +	pa = lc->mcesad & MCESA_ORIGIN_MASK;
>   	if (MACHINE_HAS_GS)
>   		pa |= lc->mcesad & MCESA_LC_MASK;
>   	if (__pcpu_sigp_relax(pcpu->address, SIGP_STORE_ADDITIONAL_STATUS,
