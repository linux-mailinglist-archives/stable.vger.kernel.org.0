Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA8D837BC03
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 13:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhELLpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 07:45:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19260 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230037AbhELLpe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 07:45:34 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14CBXSe9058925;
        Wed, 12 May 2021 07:44:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=r+EDVRMNo2k85t80QtDBYTVJ8F5/RxCOrsZVcdx21pw=;
 b=Td2xCCntBgGStBbf3a849XVA9oGcF22Ank+QXNkoUOsNzRxQQiLRk6+uiZtpjN58dGbI
 mI/7eMzd3yeRst+5Z8x8tMSermjwjY49wrhc1Mfcn3grWo0NNljYiegJYZCHIfX2VAs+
 kR/8BOwJbFijDw6HLsyvBJertx0zlXhIWgYHDH8e4JiYEFdowU07xA4gXsFX5XI6kHyz
 +POe6TMwFlYq4sjavXBnKj3eH0LJD4Y4uKv9gwXkCo0tDkczchAob18wRELX+mQkLJLX
 spy/GYcb0+ZvOER31Rh+DTo9xLNk6PXh1w8+qsRL/EJp6GB5d6LfG0M9zBbEd4U9EtkM XQ== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38ge6b0d42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 May 2021 07:44:26 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14CBiO8F017802;
        Wed, 12 May 2021 11:44:24 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 38dj9895y4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 May 2021 11:44:24 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14CBhswi34341170
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 11:43:54 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 905C8AE057;
        Wed, 12 May 2021 11:44:21 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65033AE055;
        Wed, 12 May 2021 11:44:21 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.73.206])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 12 May 2021 11:44:21 +0000 (GMT)
Subject: Re: FAILED: patch "[PATCH] KVM: s390: split
 kvm_s390_logical_to_effective" failed to apply to 4.9-stable tree
To:     gregkh@linuxfoundation.org, imbrenda@linux.ibm.com
Cc:     stable@vger.kernel.org
References: <1620814886253179@kroah.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <6a509e34-9016-7250-9df5-027d967bb098@de.ibm.com>
Date:   Wed, 12 May 2021 13:44:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <1620814886253179@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: b-VvneUGSYwkLxbK0dYQYAE1fMDuOHiD
X-Proofpoint-GUID: b-VvneUGSYwkLxbK0dYQYAE1fMDuOHiD
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-12_06:2021-05-12,2021-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 suspectscore=0 clxscore=1015 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105120085
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12.05.21 12:21, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 

Please drop the other 3 kvm: s390: patches then for 4.9, as the kernel will not
compile without this until we have a backport for this.

> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
>  From f85f1baaa18932a041fd2b1c2ca6cfd9898c7d2b Mon Sep 17 00:00:00 2001
> From: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Date: Tue, 2 Mar 2021 13:36:44 +0100
> Subject: [PATCH] KVM: s390: split kvm_s390_logical_to_effective
> 
> Split kvm_s390_logical_to_effective to a generic function called
> _kvm_s390_logical_to_effective. The new function takes a PSW and an address
> and returns the address with the appropriate bits masked off. The old
> function now calls the new function with the appropriate PSW from the vCPU.
> 
> This is needed to avoid code duplication for vSIE.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: stable@vger.kernel.org # for VSIE: correctly handle MVPG when in VSIE
> Link: https://lore.kernel.org/r/20210302174443.514363-2-imbrenda@linux.ibm.com
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> 
> diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
> index f4c51756c462..2d8631a1f23e 100644
> --- a/arch/s390/kvm/gaccess.h
> +++ b/arch/s390/kvm/gaccess.h
> @@ -36,6 +36,29 @@ static inline unsigned long kvm_s390_real_to_abs(struct kvm_vcpu *vcpu,
>   	return gra;
>   }
>   
> +/**
> + * _kvm_s390_logical_to_effective - convert guest logical to effective address
> + * @psw: psw of the guest
> + * @ga: guest logical address
> + *
> + * Convert a guest logical address to an effective address by applying the
> + * rules of the addressing mode defined by bits 31 and 32 of the given PSW
> + * (extendended/basic addressing mode).
> + *
> + * Depending on the addressing mode, the upper 40 bits (24 bit addressing
> + * mode), 33 bits (31 bit addressing mode) or no bits (64 bit addressing
> + * mode) of @ga will be zeroed and the remaining bits will be returned.
> + */
> +static inline unsigned long _kvm_s390_logical_to_effective(psw_t *psw,
> +							   unsigned long ga)
> +{
> +	if (psw_bits(*psw).eaba == PSW_BITS_AMODE_64BIT)
> +		return ga;
> +	if (psw_bits(*psw).eaba == PSW_BITS_AMODE_31BIT)
> +		return ga & ((1UL << 31) - 1);
> +	return ga & ((1UL << 24) - 1);
> +}
> +
>   /**
>    * kvm_s390_logical_to_effective - convert guest logical to effective address
>    * @vcpu: guest virtual cpu
> @@ -52,13 +75,7 @@ static inline unsigned long kvm_s390_real_to_abs(struct kvm_vcpu *vcpu,
>   static inline unsigned long kvm_s390_logical_to_effective(struct kvm_vcpu *vcpu,
>   							  unsigned long ga)
>   {
> -	psw_t *psw = &vcpu->arch.sie_block->gpsw;
> -
> -	if (psw_bits(*psw).eaba == PSW_BITS_AMODE_64BIT)
> -		return ga;
> -	if (psw_bits(*psw).eaba == PSW_BITS_AMODE_31BIT)
> -		return ga & ((1UL << 31) - 1);
> -	return ga & ((1UL << 24) - 1);
> +	return _kvm_s390_logical_to_effective(&vcpu->arch.sie_block->gpsw, ga);
>   }
>   
>   /*
> 
