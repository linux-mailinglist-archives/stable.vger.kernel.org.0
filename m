Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B2A30C500
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 17:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236094AbhBBQIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 11:08:50 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64362 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235046AbhBBQGp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 11:06:45 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 112G2AkK086551;
        Tue, 2 Feb 2021 11:05:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=9Nvfbq8RELq9EmVutufU6qd0yY2fdjpjBdYd4tfLcKc=;
 b=tNlz1M52TXHXKSHzXMccQZHrt1oAaJLefHtzy5ZwfL4X0mrGLUdep1NhEBUaa9ilVvq5
 T0wJLwTvC5T1Qsi8VX3Y60GKnosnQeJr/6biWCvE3EsErlJq/ekP1s4LjsctkyfwletX
 tT9DJxZt0yDtiSHw0gw5tQUrdYINd/kyoGD/zzhWt6GWvpEgTBVFy3xoQrPByfdpHgR0
 VMnHxNywCjHSTxTpbjJ2XaXszjspERIKYH0cFYmdHsTIvHzgx+AVOkh2fON0Kvbfkn4J
 Mz2TogUtHUNNNoNv40rJo9nEV+Lke08y7JBx298vxDxFLBZKkOz+CnZB1mwvgWCQIOtC PQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36f9u6rbjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Feb 2021 11:05:40 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 112G2O9H088248;
        Tue, 2 Feb 2021 11:05:39 -0500
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36f9u6rbfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Feb 2021 11:05:39 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 112Fa7T0031991;
        Tue, 2 Feb 2021 16:05:38 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04dal.us.ibm.com with ESMTP id 36ex3nncmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Feb 2021 16:05:38 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 112G5bnY33030562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Feb 2021 16:05:37 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 262E5124055;
        Tue,  2 Feb 2021 16:05:37 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2024D12405A;
        Tue,  2 Feb 2021 16:05:37 +0000 (GMT)
Received: from sbct-3.pok.ibm.com (unknown [9.47.158.153])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  2 Feb 2021 16:05:37 +0000 (GMT)
Subject: Re: [PATCH] tpm: WARN_ONCE() -> pr_warn_once() in tpm_tis_status()
To:     jarkko@kernel.org, linux-integrity@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Wang Hai <wanghai38@huawei.com>
References: <20210202153317.57749-1-jarkko@kernel.org>
From:   Stefan Berger <stefanb@linux.ibm.com>
Message-ID: <3936843b-c0da-dd8c-8aa9-90aa3b49d525@linux.ibm.com>
Date:   Tue, 2 Feb 2021 11:05:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210202153317.57749-1-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-02_07:2021-02-02,2021-02-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1011
 impostorscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102020106
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/2/21 10:33 AM, jarkko@kernel.org wrote:
> From: Jarkko Sakkinen <jarkko@kernel.org>
>
> An unexpected status from TPM chip is not irrecovable failure of the
> kernel. It's only undesirable situation. Thus, change the WARN_ONCE
> instance inside tpm_tis_status() to pr_warn_once().
>
> In addition: print the status in the log message because it is actually
> useful information lacking from the existing log message.
>
> Suggested-by:  Guenter Roeck <linux@roeck-us.net>
> Cc: stable@vger.kernel.org
> Fixes: 6f4f57f0b909 ("tpm: ibmvtpm: fix error return code in tpm_ibmvtpm_probe()")
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
>   drivers/char/tpm/tpm_tis_core.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> index 431919d5f48a..21f67c6366cb 100644
> --- a/drivers/char/tpm/tpm_tis_core.c
> +++ b/drivers/char/tpm/tpm_tis_core.c
> @@ -202,7 +202,7 @@ static u8 tpm_tis_status(struct tpm_chip *chip)
>   		 * acquired.  Usually because tpm_try_get_ops() hasn't
>   		 * been called before doing a TPM operation.
>   		 */
> -		WARN_ONCE(1, "TPM returned invalid status\n");
> +		pr_warn_once("TPM returned invalid status: 0x%x\n", status);
>   		return 0;
>   	}
>   

Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>

