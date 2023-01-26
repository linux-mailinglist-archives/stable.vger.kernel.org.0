Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBF6567D566
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 20:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbjAZThd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 14:37:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjAZThc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 14:37:32 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3217262249;
        Thu, 26 Jan 2023 11:37:31 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30QJTwFo030972;
        Thu, 26 Jan 2023 19:37:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=rCLiOQgZ5W2CcpkkBJonDoRIJRw4iwthIr9UcqgpBlg=;
 b=ngwsD6WnJW1Xj7LagOU+AiED5+DULo1+u8KXu+Yz7uTPeyz/D6OiSJPeQpSTg7h41SUf
 bMOoZL/5umdfULzv7lyJ8DLjzdnQA8VpOnoF22xeWiCxDJoLbNUGGiN09sHHWvRvv7ES
 bKtMGKA41lcJ7rDQVbrDzPvsutE83w5WN8htXB6dF5YrAzNWV4RSmUhslCdD1iCufTcI
 98Bt9if2J3DJxUlCxLTVLZR+GKKru18HTVplqaPhPxIcRZZXZlvSnKeikNHQzYZc/6pN
 Fkxw9nkqOGEM/JQq/+ASLPNUoMdJujb1PBGFEA4wTnEipguX85Ja3/jNLDyVNv/BYFVY Nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nbyqw86hn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Jan 2023 19:37:11 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30QJVP9Q006289;
        Thu, 26 Jan 2023 19:37:11 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nbyqw86h9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Jan 2023 19:37:11 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30QGBLvq012685;
        Thu, 26 Jan 2023 19:37:10 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([9.208.129.116])
        by ppma02wdc.us.ibm.com (PPS) with ESMTPS id 3n87p7y00e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Jan 2023 19:37:10 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30QJb9295767764
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Jan 2023 19:37:09 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E53A05805D;
        Thu, 26 Jan 2023 19:37:08 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC1AE58059;
        Thu, 26 Jan 2023 19:37:06 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 26 Jan 2023 19:37:06 +0000 (GMT)
Message-ID: <295c5915-b680-16be-3d51-b7c1d2ca5e4f@linux.ibm.com>
Date:   Thu, 26 Jan 2023 14:37:06 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3 1/2] ima: Align ima_file_mmap() parameters with
 mmap_file LSM hook
Content-Language: en-US
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>, zohar@linux.ibm.com,
        dmitry.kasatkin@gmail.com, jmorris@namei.org, serge@hallyn.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
References: <20230126163812.1870942-1-roberto.sassu@huaweicloud.com>
From:   Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <20230126163812.1870942-1-roberto.sassu@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NfNEmCmLqNI_cxjCjovshsD1QTPofcwh
X-Proofpoint-ORIG-GUID: 7wEGGLFZQHKdEFUOpYlYYau9LXYWh6df
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-26_09,2023-01-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 clxscore=1011 mlxlogscore=999 priorityscore=1501 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301260183
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/26/23 11:38, Roberto Sassu wrote:
> From: Roberto Sassu <roberto.sassu@huawei.com>
> 
> Commit 98de59bfe4b2f ("take calculation of final prot in
> security_mmap_file() into a helper") moved the code to update prot, to be
> the actual protections applied to the kernel, to a new helper called
> mmap_prot().
> 
> However, while without the helper ima_file_mmap() was getting the updated
> prot, with the helper ima_file_mmap() gets the original prot, which
> contains the protections requested by the application.
> 
> A possible consequence of this change is that, if an application calls
> mmap() with only PROT_READ, and the kernel applies PROT_EXEC in addition,
> that application would have access to executable memory without having this
> event recorded in the IMA measurement list. This situation would occur for
> example if the application, before mmap(), calls the personality() system
> call with READ_IMPLIES_EXEC as the first argument.
> 
> Align ima_file_mmap() parameters with those of the mmap_file LSM hook, so
> that IMA can receive both the requested prot and the final prot. Since the
> requested protections are stored in a new variable, and the final
> protections are stored in the existing variable, this effectively restores
> the original behavior of the MMAP_CHECK hook.
> 
And flags is being passed in preparation for IMA to meet the interface
requirements of the LSM hooks - I suppose in preparation for IMA to become an LSM.

> Cc: stable@vger.kernel.org
> Fixes: 98de59bfe4b2 ("take calculation of final prot in security_mmap_file() into a helper")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>

Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>

> ---
>   include/linux/ima.h               | 6 ++++--
>   security/integrity/ima/ima_main.c | 7 +++++--
>   security/security.c               | 7 ++++---
>   3 files changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/ima.h b/include/linux/ima.h
> index 5a0b2a285a18..d79fee67235e 100644
> --- a/include/linux/ima.h
> +++ b/include/linux/ima.h
> @@ -21,7 +21,8 @@ extern int ima_file_check(struct file *file, int mask);
>   extern void ima_post_create_tmpfile(struct user_namespace *mnt_userns,
>   				    struct inode *inode);
>   extern void ima_file_free(struct file *file);
> -extern int ima_file_mmap(struct file *file, unsigned long prot);
> +extern int ima_file_mmap(struct file *file, unsigned long reqprot,
> +			 unsigned long prot, unsigned long flags);
>   extern int ima_file_mprotect(struct vm_area_struct *vma, unsigned long prot);
>   extern int ima_load_data(enum kernel_load_data_id id, bool contents);
>   extern int ima_post_load_data(char *buf, loff_t size,
> @@ -76,7 +77,8 @@ static inline void ima_file_free(struct file *file)
>   	return;
>   }
>   
> -static inline int ima_file_mmap(struct file *file, unsigned long prot)
> +static inline int ima_file_mmap(struct file *file, unsigned long reqprot,
> +				unsigned long prot, unsigned long flags)
>   {
>   	return 0;
>   }
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index 377300973e6c..f48f4e694921 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -397,7 +397,9 @@ static int process_measurement(struct file *file, const struct cred *cred,
>   /**
>    * ima_file_mmap - based on policy, collect/store measurement.
>    * @file: pointer to the file to be measured (May be NULL)
> - * @prot: contains the protection that will be applied by the kernel.
> + * @reqprot: protection requested by the application
> + * @prot: protection that will be applied by the kernel
> + * @flags: operational flags
>    *
>    * Measure files being mmapped executable based on the ima_must_measure()
>    * policy decision.
> @@ -405,7 +407,8 @@ static int process_measurement(struct file *file, const struct cred *cred,
>    * On success return 0.  On integrity appraisal error, assuming the file
>    * is in policy and IMA-appraisal is in enforcing mode, return -EACCES.
>    */
> -int ima_file_mmap(struct file *file, unsigned long prot)
> +int ima_file_mmap(struct file *file, unsigned long reqprot,
> +		  unsigned long prot, unsigned long flags)
>   {
>   	u32 secid;
>   
> diff --git a/security/security.c b/security/security.c
> index d1571900a8c7..174afa4fad81 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -1661,12 +1661,13 @@ static inline unsigned long mmap_prot(struct file *file, unsigned long prot)
>   int security_mmap_file(struct file *file, unsigned long prot,
>   			unsigned long flags)
>   {
> +	unsigned long prot_adj = mmap_prot(file, prot);
>   	int ret;
> -	ret = call_int_hook(mmap_file, 0, file, prot,
> -					mmap_prot(file, prot), flags);
> +
> +	ret = call_int_hook(mmap_file, 0, file, prot, prot_adj, flags);
>   	if (ret)
>   		return ret;
> -	return ima_file_mmap(file, prot);
> +	return ima_file_mmap(file, prot, prot_adj, flags);
>   }
>   
>   int security_mmap_addr(unsigned long addr)
