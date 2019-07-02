Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF735D2D6
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 17:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbfGBP22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 11:28:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49472 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727010AbfGBP22 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 11:28:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x62FOJLt159850;
        Tue, 2 Jul 2019 15:27:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=Sk1VVbY07rQZ5y4KHjvVKWCOHvjzB5kFnUcVYEmCVjA=;
 b=dVHGuN8yjD9MHMIXJa46Gh2FXAdCgFLRdPIwdEtlDQIHRaEE4sAVgkjz/cDULTCjfpHW
 N9O2Z+Y+FygLlUEktsJ0gpM5OhMMUHXJg4iRF17FvDsjQqZ930a0Hx79kU50TkQK8PsM
 TTiifKLqfl4Tx51MwiCgN8/HoqZVDYfZQGhJg3j3slP+jq93MNb4VNMdxCOvzqn7xzlo
 u4FuVuXH4X+KaLjO4GZN98Jw7mrdn1vbI97S08YMp8trNi8alljweNb2/IXYhphB1E+L
 bpI5Awq3btI0TTPQ0Pm1bF7mC4Gl7YU37/vzjCfGZMSvrqovvYyx9CsH7PlxPovIvJ4e 1A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2te5tbmcy4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jul 2019 15:27:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x62FI8tZ163587;
        Tue, 2 Jul 2019 15:27:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2tebaku4mk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jul 2019 15:27:56 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x62FRsG8025450;
        Tue, 2 Jul 2019 15:27:55 GMT
Received: from [10.30.3.6] (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jul 2019 08:27:54 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 2/3] KVM: nVMX: allow setting the VMFUNC controls MSR
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <1562079876-20756-3-git-send-email-pbonzini@redhat.com>
Date:   Tue, 2 Jul 2019 18:27:49 +0300
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <3E09BABA-FADF-41AD-8524-68A587197DBC@oracle.com>
References: <1562079876-20756-1-git-send-email-pbonzini@redhat.com>
 <1562079876-20756-3-git-send-email-pbonzini@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9306 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=851
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907020166
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9306 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=903 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907020167
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On 2 Jul 2019, at 18:04, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> Allow userspace to set a custom value for the VMFUNC controls MSR, as =
long
> as the capabilities it advertises do not exceed those of the host.
>=20
> Fixes: 27c42a1bb ("KVM: nVMX: Enable VMFUNC for the L1 hypervisor", =
2017-08-03)
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Liran Alon <liran.alon@oracle.com>

> ---
> arch/x86/kvm/vmx/nested.c | 5 +++++
> 1 file changed, 5 insertions(+)
>=20
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index c4e29ef0b21e..163d226efa96 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1234,6 +1234,11 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 =
msr_index, u64 data)
> 	case MSR_IA32_VMX_VMCS_ENUM:
> 		vmx->nested.msrs.vmcs_enum =3D data;
> 		return 0;
> +	case MSR_IA32_VMX_VMFUNC:
> +		if (data & ~vmx->nested.msrs.vmfunc_controls)
> +			return -EINVAL;
> +		vmx->nested.msrs.vmfunc_controls =3D data;
> +		return 0;
> 	default:
> 		/*
> 		 * The rest of the VMX capability MSRs do not support =
restore.
> --=20
> 1.8.3.1
>=20
>=20

