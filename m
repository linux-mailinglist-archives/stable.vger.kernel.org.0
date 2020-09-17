Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9553D26DC7B
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 15:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgIQNIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 09:08:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21152 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727052AbgIQNIi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Sep 2020 09:08:38 -0400
X-Greylist: delayed 3999 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 09:08:38 EDT
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08HBWANL175921;
        Thu, 17 Sep 2020 08:01:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=xkhbtwxwiJ5oxSi+vXXQzqn/Hqfn4aHBAZBrlhH489g=;
 b=PjBj6GFWY99P8ZypO2Ap/cLOL89ZQ022gEBKoOipoNdy3/YMewYWK4ByuGnPwOrNOnEc
 8+Qc+xrayhaZseX/MicDnULjzVp5MAXByxEL/1IQc37zURf8EDj8fVXcPG+rny23q0US
 2ns9Va9OWqVe9Z3mFTW2s2BxBudFQsueY0nUIaDijYx5B/tdwIejmmu8te4C1OUQ1ZzL
 O1nJe5b52pJM84JggIWCUNWg2idpCG7Pm/5BOuyvMUtREpp1mfWc2KCds6uOocVsVG46
 4MUhZnAhsHUYGsMhQicLFEN2/+1IKTg3KzWDMDlE9OUq4QdfeGVA1vEn6/bgSYGQx4D3 bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33m6ufh4wd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 08:01:22 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08HBWJqM177301;
        Thu, 17 Sep 2020 08:01:21 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33m6ufh4t5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 08:01:21 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08HBxA2H006051;
        Thu, 17 Sep 2020 12:01:18 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 33k65v128x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 12:01:18 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08HC1FI729098486
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 12:01:15 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4D2011C05E;
        Thu, 17 Sep 2020 12:01:15 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3160611C06F;
        Thu, 17 Sep 2020 12:01:14 +0000 (GMT)
Received: from sig-9-65-208-105.ibm.com (unknown [9.65.208.105])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Sep 2020 12:01:14 +0000 (GMT)
Message-ID: <5bbf2169cfa38bb7a3d696e582c1de954a82d5c6.camel@linux.ibm.com>
Subject: Re: [PATCH v2 07/12] evm: Introduce EVM_RESET_STATUS atomic flag
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>, mjg59@google.com,
        John Johansen <john.johansen@canonical.com>
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, silviu.vlasceanu@huawei.com,
        stable@vger.kernel.org
Date:   Thu, 17 Sep 2020 08:01:13 -0400
In-Reply-To: <20200904092643.20013-3-roberto.sassu@huawei.com>
References: <20200904092339.19598-1-roberto.sassu@huawei.com>
         <20200904092643.20013-3-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-17_08:2020-09-16,2020-09-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 mlxlogscore=999 bulkscore=0 spamscore=0 malwarescore=0 impostorscore=0
 adultscore=0 suspectscore=3 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170085
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Cc'ing John Johansen]

Hi Roberto,

On Fri, 2020-09-04 at 11:26 +0200, Roberto Sassu wrote:
> When EVM_ALLOW_METADATA_WRITES is set, EVM allows any operation on
> metadata. Its main purpose is to allow users to freely set metadata when
> they are protected by a portable signature, until the HMAC key is loaded.
> 
> However, IMA is not notified about metadata changes and, after the first
> successful appraisal, always allows access to the files without checking
> metadata again.
> 
> This patch introduces the new atomic flag EVM_RESET_STATUS in
> integrity_iint_cache that is set in the EVM post hooks and cleared in
> evm_verify_hmac(). IMA checks the new flag in process_measurement() and if
> it is set, it clears the appraisal flags.
> 
> Although the flag could be cleared also by evm_inode_setxattr() and
> evm_inode_setattr() before IMA sees it, this does not happen if
> EVM_ALLOW_METADATA_WRITES is set. Since the only remaining caller is
> evm_verifyxattr(), this ensures that IMA always sees the flag set before it
> is cleared.
> 
> This patch also adds a call to evm_reset_status() in
> evm_inode_post_setattr() so that EVM won't return the cached status the
> next time appraisal is performed.
> 
> Cc: stable@vger.kernel.org # 4.16.x
> Fixes: ae1ba1676b88e ("EVM: Allow userland to permit modification of EVM-protected metadata")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>  security/integrity/evm/evm_main.c | 17 +++++++++++++++--
>  security/integrity/ima/ima_main.c |  8 ++++++--
>  security/integrity/integrity.h    |  1 +
>  3 files changed, 22 insertions(+), 4 deletions(-)
> 
> diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
> index 4e9f5e8b21d5..05be1ad3e6f3 100644
> --- a/security/integrity/evm/evm_main.c
> +++ b/security/integrity/evm/evm_main.c
> @@ -221,8 +221,15 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
>  		evm_status = (rc == -ENODATA) ?
>  				INTEGRITY_NOXATTRS : INTEGRITY_FAIL;
>  out:
> -	if (iint)
> +	if (iint) {
> +		/*
> +		 * EVM_RESET_STATUS can be cleared only by evm_verifyxattr()
> +		 * when EVM_ALLOW_METADATA_WRITES is set. This guarantees that
> +		 * IMA sees the EVM_RESET_STATUS flag set before it is cleared.
> +		 */
> +		clear_bit(EVM_RESET_STATUS, &iint->atomic_flags);
>  		iint->evm_status = evm_status;

True IMA is currently the only caller of evm_verifyxattr() in the
upstreamed kernel, but it is an exported function, which may be called
from elsewhere.  The previous version crossed the boundary between EVM
& IMA with EVM modifying the IMA flag directly.  This version assumes
that IMA will be the only caller.  Otherwise, I like this version.

Mimi

> +	}
>  	kfree(xattr_data);
>  	return evm_status;
>  }
> @@ -418,8 +425,12 @@ static void evm_reset_status(struct inode *inode)
>  	struct integrity_iint_cache *iint;
>  
>  	iint = integrity_iint_find(inode);
> -	if (iint)
> +	if (iint) {
> +		if (evm_initialized & EVM_ALLOW_METADATA_WRITES)
> +			set_bit(EVM_RESET_STATUS, &iint->atomic_flags);
> +
>  		iint->evm_status = INTEGRITY_UNKNOWN;
> +	}
>  }
>  
>  /**
> @@ -513,6 +524,8 @@ void evm_inode_post_setattr(struct dentry *dentry, int ia_valid)
>  	if (!evm_key_loaded())
>  		return;
>  
> +	evm_reset_status(dentry->d_inode);
> +
>  	if (ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID))
>  		evm_update_evmxattr(dentry, NULL, NULL, 0);
>  }

