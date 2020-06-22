Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7338820404F
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 21:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgFVT2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 15:28:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9776 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728068AbgFVT2W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 15:28:22 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MJ3Xte040410;
        Mon, 22 Jun 2020 15:28:21 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31t02gcctq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 15:28:20 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05MJ3dEj040633;
        Mon, 22 Jun 2020 15:28:20 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31t02gcctb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 15:28:20 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05MJKTEs032724;
        Mon, 22 Jun 2020 19:28:18 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 31sa37uv0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 19:28:18 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05MJSFg865863762
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Jun 2020 19:28:15 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8626211C05C;
        Mon, 22 Jun 2020 19:28:15 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C21511C058;
        Mon, 22 Jun 2020 19:28:14 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.202.125])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 22 Jun 2020 19:28:14 +0000 (GMT)
Message-ID: <1592854093.4987.15.camel@linux.ibm.com>
Subject: Re: [PATCH v2] ima: move APPRAISE_BOOTPARAM dependency on
 ARCH_POLICY to runtime
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Bruno Meneguele <bmeneg@redhat.com>,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     erichte@linux.ibm.com, nayna@linux.ibm.com, stable@vger.kernel.org
Date:   Mon, 22 Jun 2020 15:28:13 -0400
In-Reply-To: <20200622172754.10763-1-bmeneg@redhat.com>
References: <20200622172754.10763-1-bmeneg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_11:2020-06-22,2020-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 phishscore=0 adultscore=0 clxscore=1011 cotscore=-2147483648 mlxscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006220123
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-06-22 at 14:27 -0300, Bruno Meneguele wrote:
> IMA_APPRAISE_BOOTPARAM has been marked as dependent on !IMA_ARCH_POLICY in
> compile time, enforcing the appraisal whenever the kernel had the arch
> policy option enabled.
> 
> However it breaks systems where the option is actually set but the system
> wasn't booted in a "secure boot" platform. In this scenario, anytime the
> an appraisal policy (i.e. ima_policy=appraisal_tcb) is used it will be
> forced, giving no chance to the user set the 'fix' state (ima_appraise=fix)
> to actually measure system's files.
> 
> This patch remove this compile time dependency and move it to a runtime
> decision, based on the arch policy loading failure/success.
> 
> Cc: stable@vger.kernel.org
> Fixes: d958083a8f64 ("x86/ima: define arch_get_ima_policy() for x86")
> Signed-off-by: Bruno Meneguele <bmeneg@redhat.com>
> ---
> changes from v1:
> 	- removed "ima:" prefix from pr_info() message
> 
>  security/integrity/ima/Kconfig      | 2 +-
>  security/integrity/ima/ima_policy.c | 8 ++++++--
>  2 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
> index edde88dbe576..62dc11a5af01 100644
> --- a/security/integrity/ima/Kconfig
> +++ b/security/integrity/ima/Kconfig
> @@ -232,7 +232,7 @@ config IMA_APPRAISE_REQUIRE_POLICY_SIGS
>  
>  config IMA_APPRAISE_BOOTPARAM
>  	bool "ima_appraise boot parameter"
> -	depends on IMA_APPRAISE && !IMA_ARCH_POLICY
> +	depends on IMA_APPRAISE
>  	default y
>  	help
>  	  This option enables the different "ima_appraise=" modes
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index e493063a3c34..c876617d4210 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -733,11 +733,15 @@ void __init ima_init_policy(void)
>  	 * (Highest priority)
>  	 */
>  	arch_entries = ima_init_arch_policy();
> -	if (!arch_entries)
> +	if (!arch_entries) {
>  		pr_info("No architecture policies found\n");
> -	else
> +	} else {
> +		/* Force appraisal, preventing runtime xattr changes */
> +		pr_info("setting IMA appraisal to enforced\n");
> +		ima_appraise = IMA_APPRAISE_ENFORCE;
>  		add_rules(arch_policy_entry, arch_entries,
>  			  IMA_DEFAULT_POLICY | IMA_CUSTOM_POLICY);
> +	}
>  
>  	/*
>  	 * Insert the builtin "secure_boot" policy rules requiring file

CONFIG_IMA_APPRAISE_BOOTPARAM controls the "ima_appraise" mode bits.  
The mode bits are or'ed with the MODULES, FIRMWARE, POLICY, and KEXEC
bits, which have already been set in ima_init_arch_policy().

From ima.h:
/* Appraise integrity measurements */
#define IMA_APPRAISE_ENFORCE    0x01
#define IMA_APPRAISE_FIX        0x02
#define IMA_APPRAISE_LOG        0x04
#define IMA_APPRAISE_MODULES    0x08
#define IMA_APPRAISE_FIRMWARE   0x10
#define IMA_APPRAISE_POLICY     0x20
#define IMA_APPRAISE_KEXEC      0x40

As Nayna pointed out, only when an architecture specific "secure boot"
policy is loaded, is this applicable. 

Mimi

