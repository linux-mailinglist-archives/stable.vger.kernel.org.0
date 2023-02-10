Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36B27691E2B
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 12:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbjBJL0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 06:26:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbjBJL0w (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 06:26:52 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BC9E046;
        Fri, 10 Feb 2023 03:26:50 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31ABG5Pi026504;
        Fri, 10 Feb 2023 11:26:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=PDlk0D7jtHg5XdCCmFXYh2WXyS9oePq9MJwop7nyH8E=;
 b=Dw+0IO2Wj3WebNM2P3EybMOhwgqEqxww5npD6gI9tWSt+2SY4vXuXr8FJ6/+LsTys6NY
 6IoMOZ1g+wdzZnjP29hY4Agcr/8+Q1ADiUJuyNPrHq0Vg7R4g96ZcELlhU+CgaLNonbu
 IMawj03koPPHSL+4SCUkvpBtLzDnFd9H9k2jsITbflKOrMFj/rlmxWztt/w3poc10dVF
 Vdur3Z6UPDbbKY1gyOkt7rIW1mg9jaEJHqxPjy7zO68b2Okn9j8+lLFA0Bz47dEPIaS5
 BII4/Fc580tZU15egAl4qCadjpW0Fi1YZO+lr+uch72avaMQP/zrUbJ9m3p8CSqobGvN Bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nnmw707vk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Feb 2023 11:26:40 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31ABKe6b011502;
        Fri, 10 Feb 2023 11:26:40 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nnmw707us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Feb 2023 11:26:40 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31A6KK1E021016;
        Fri, 10 Feb 2023 11:26:38 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3nhemfqe0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Feb 2023 11:26:38 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31ABQZZe46006614
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 11:26:35 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CAC1720040;
        Fri, 10 Feb 2023 11:26:35 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 728752004B;
        Fri, 10 Feb 2023 11:26:33 +0000 (GMT)
Received: from [9.109.198.193] (unknown [9.109.198.193])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 10 Feb 2023 11:26:33 +0000 (GMT)
Message-ID: <c6349040-17ad-6066-0f8a-8adeb9c7b48d@linux.ibm.com>
Date:   Fri, 10 Feb 2023 16:56:31 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH AUTOSEL 6.1 18/38] powerpc/kvm: Fix unannotated
 intra-function call warning
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>, pbonzini@redhat.com,
        seanjc@google.com, npiggin@gmail.com,
        linuxppc-dev@lists.ozlabs.org,
        Sathvika Vasireddy <sv@linux.ibm.com>
References: <20230209111459.1891941-1-sashal@kernel.org>
 <20230209111459.1891941-18-sashal@kernel.org>
From:   Sathvika Vasireddy <sv@linux.ibm.com>
In-Reply-To: <20230209111459.1891941-18-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: e7Fi0IJtnkUsmDtiZRfCjIT8jVXwAPrS
X-Proofpoint-GUID: Nf9ZfHZLoL5hRe2ZmwEMvkHZ4HvWhx8g
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_06,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 priorityscore=1501 bulkscore=0
 spamscore=0 lowpriorityscore=0 clxscore=1031 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302100093
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On 09/02/23 16:44, Sasha Levin wrote:
> From: Sathvika Vasireddy <sv@linux.ibm.com>
>
> [ Upstream commit fe6de81b610e5d0b9d2231acff2de74a35482e7d ]
>
> objtool throws the following warning:
>    arch/powerpc/kvm/booke.o: warning: objtool: kvmppc_fill_pt_regs+0x30:
>    unannotated intra-function call
>
> Fix the warning by setting the value of 'nip' using the _THIS_IP_ macro,
> without using an assembly bl/mflr sequence to save the instruction
> pointer.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
> Signed-off-by: Sathvika Vasireddy <sv@linux.ibm.com>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Link: https://lore.kernel.org/r/20230128124158.1066251-1-sv@linux.ibm.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/powerpc/kvm/booke.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
> index 7b4920e9fd263..3852209989f04 100644
> --- a/arch/powerpc/kvm/booke.c
> +++ b/arch/powerpc/kvm/booke.c
> @@ -912,16 +912,15 @@ static int kvmppc_handle_debug(struct kvm_vcpu *vcpu)
>   
>   static void kvmppc_fill_pt_regs(struct pt_regs *regs)
>   {
> -	ulong r1, ip, msr, lr;
> +	ulong r1, msr, lr;
>   
>   	asm("mr %0, 1" : "=r"(r1));
>   	asm("mflr %0" : "=r"(lr));
>   	asm("mfmsr %0" : "=r"(msr));
> -	asm("bl 1f; 1: mflr %0" : "=r"(ip));
>   
>   	memset(regs, 0, sizeof(*regs));
>   	regs->gpr[1] = r1;
> -	regs->nip = ip;
> +	regs->nip = _THIS_IP_;
>   	regs->msr = msr;
>   	regs->link = lr;
>   }

Please drop this patch because objtool enablement patches for powerpc 
are not a part of kernel v6.1


Thanks,
Sathvika

