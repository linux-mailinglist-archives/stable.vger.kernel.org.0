Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94C1B2FB38
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 13:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbfE3LyM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 07:54:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54956 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727123AbfE3LyL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 07:54:11 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4UBq1FY059585
        for <stable@vger.kernel.org>; Thu, 30 May 2019 07:54:10 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2stdknugkr-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 30 May 2019 07:54:10 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <zohar@linux.ibm.com>;
        Thu, 30 May 2019 12:54:08 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 30 May 2019 12:54:04 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4UBs3xg32375016
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 May 2019 11:54:03 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 599C611C04C;
        Thu, 30 May 2019 11:54:03 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3E1E11C058;
        Thu, 30 May 2019 11:54:01 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.80.109])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 May 2019 11:54:01 +0000 (GMT)
Subject: Re: [PATCH v2 3/3] ima: show rules with IMA_INMASK correctly
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        dmitry.kasatkin@huawei.com, mjg59@google.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, silviu.vlasceanu@huawei.com,
        stable@vger.kernel.org
Date:   Thu, 30 May 2019 07:53:51 -0400
In-Reply-To: <20190529133035.28724-4-roberto.sassu@huawei.com>
References: <20190529133035.28724-1-roberto.sassu@huawei.com>
         <20190529133035.28724-4-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19053011-0008-0000-0000-000002EBEDCC
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19053011-0009-0000-0000-00002258C21E
Message-Id: <1559217231.4008.4.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-30_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905300090
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2019-05-29 at 15:30 +0200, Roberto Sassu wrote:
> Show the '^' character when a policy rule has flag IMA_INMASK.
> 
> Fixes: 80eae209d63ac ("IMA: allow reading back the current IMA policy")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> Cc: stable@vger.kernel.org

Thanks, queued.

> ---
>  security/integrity/ima/ima_policy.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index e0cc323f948f..ae4034f041c4 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -1146,10 +1146,10 @@ enum {
>  };
>  
>  static const char *const mask_tokens[] = {
> -	"MAY_EXEC",
> -	"MAY_WRITE",
> -	"MAY_READ",
> -	"MAY_APPEND"
> +	"^MAY_EXEC",
> +	"^MAY_WRITE",
> +	"^MAY_READ",
> +	"^MAY_APPEND"
>  };
>  
>  #define __ima_hook_stringify(str)	(#str),
> @@ -1209,6 +1209,7 @@ int ima_policy_show(struct seq_file *m, void *v)
>  	struct ima_rule_entry *entry = v;
>  	int i;
>  	char tbuf[64] = {0,};
> +	int offset = 0;
>  
>  	rcu_read_lock();
>  
> @@ -1232,15 +1233,17 @@ int ima_policy_show(struct seq_file *m, void *v)
>  	if (entry->flags & IMA_FUNC)
>  		policy_func_show(m, entry->func);
>  
> -	if (entry->flags & IMA_MASK) {
> +	if ((entry->flags & IMA_MASK) || (entry->flags & IMA_INMASK)) {
> +		if (entry->flags & IMA_MASK)
> +			offset = 1;
>  		if (entry->mask & MAY_EXEC)
> -			seq_printf(m, pt(Opt_mask), mt(mask_exec));
> +			seq_printf(m, pt(Opt_mask), mt(mask_exec) + offset);
>  		if (entry->mask & MAY_WRITE)
> -			seq_printf(m, pt(Opt_mask), mt(mask_write));
> +			seq_printf(m, pt(Opt_mask), mt(mask_write) + offset);
>  		if (entry->mask & MAY_READ)
> -			seq_printf(m, pt(Opt_mask), mt(mask_read));
> +			seq_printf(m, pt(Opt_mask), mt(mask_read) + offset);
>  		if (entry->mask & MAY_APPEND)
> -			seq_printf(m, pt(Opt_mask), mt(mask_append));
> +			seq_printf(m, pt(Opt_mask), mt(mask_append) + offset);
>  		seq_puts(m, " ");
>  	}
>  

