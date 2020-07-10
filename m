Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B25321BC22
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 19:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbgGJRXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 13:23:43 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25512 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726950AbgGJRXm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 13:23:42 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06AGXXIK035408;
        Fri, 10 Jul 2020 13:23:32 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 326j83u61m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Jul 2020 13:23:31 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06AGsp6t109873;
        Fri, 10 Jul 2020 13:23:31 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 326j83u60m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Jul 2020 13:23:31 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06AHGIBY017599;
        Fri, 10 Jul 2020 17:23:29 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 326bc30t54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Jul 2020 17:23:28 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06AHNQ2461735024
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jul 2020 17:23:26 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15FA44C046;
        Fri, 10 Jul 2020 17:23:26 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9DD254C044;
        Fri, 10 Jul 2020 17:23:24 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.206.93])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 10 Jul 2020 17:23:24 +0000 (GMT)
Message-ID: <1594401804.14405.8.camel@linux.ibm.com>
Subject: Re: [PATCH v5] ima: move APPRAISE_BOOTPARAM dependency on
 ARCH_POLICY to runtime
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Bruno Meneguele <bmeneg@redhat.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-integrity@vger.kernel.org
Cc:     erichte@linux.ibm.com, nayna@linux.ibm.com, stable@vger.kernel.org
Date:   Fri, 10 Jul 2020 13:23:24 -0400
In-Reply-To: <20200709164647.45153-1-bmeneg@redhat.com>
References: <20200709164647.45153-1-bmeneg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-10_10:2020-07-10,2020-07-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1011 malwarescore=0 phishscore=0 lowpriorityscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007100111
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-07-09 at 13:46 -0300, Bruno Meneguele wrote:
> APPRAISE_BOOTPARAM has been marked as dependent on !ARCH_POLICY in compile
> time, enforcing the appraisal whenever the kernel had the arch policy option
> enabled.

> However it breaks systems where the option is set but the system didn't
> boot in a "secure boot" platform. In this scenario, anytime an appraisal
> policy (i.e. ima_policy=appraisal_tcb) is used it will be forced, without
> giving the user the opportunity to label the filesystem, before enforcing
> integrity.
> 
> Considering the ARCH_POLICY is only effective when secure boot is actually
> enabled this patch remove the compile time dependency and move it to a
> runtime decision, based on the secure boot state of that platform.

Perhaps we could simplify this patch description a bit?

The IMA_APPRAISE_BOOTPARAM config allows enabling different
"ima_appraise=" modes - log, fix, enforce - at run time, but not when
IMA architecture specific policies are enabled.  This prevents
properly labeling the filesystem on systems where secure boot is
supported, but not enabled on the platform.  Only when secure boot is
enabled, should these IMA appraise modes be disabled.

This patch removes the compile time dependency and makes it a runtime
decision, based on the secure boot state of that platform.

<snip>

> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> index a9649b04b9f1..884de471b38a 100644
> --- a/security/integrity/ima/ima_appraise.c
> +++ b/security/integrity/ima/ima_appraise.c
> @@ -19,6 +19,11 @@
>  static int __init default_appraise_setup(c

> har *str)
>  {
>  #ifdef CONFIG_IMA_APPRAISE_BOOTPARAM
> +	if (arch_ima_get_secureboot()) {
> +		pr_info("appraise boot param ignored: secure boot enabled");

Instead of a generic statement, is it possible to include the actual
option being denied?  Perhaps something like: "Secure boot enabled,
ignoring %s boot command line option"

Mimi

> +		return 1;
> +	}
> +
>  	if (strncmp(str, "off", 3) == 0)
>  		ima_appraise = 0;
>  	else if (strncmp(str, "log", 3) == 0)

