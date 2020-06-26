Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D1120B62A
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 18:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgFZQrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 12:47:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46522 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727861AbgFZQrK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jun 2020 12:47:10 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QGVkkl143474;
        Fri, 26 Jun 2020 12:47:04 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31vtt4h9fs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Jun 2020 12:47:04 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05QGka62011958;
        Fri, 26 Jun 2020 12:47:04 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31vtt4h9fh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Jun 2020 12:47:04 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05QGiPUB027046;
        Fri, 26 Jun 2020 16:47:03 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04wdc.us.ibm.com with ESMTP id 31uuryn9kx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Jun 2020 16:47:03 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05QGl3UV53870928
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Jun 2020 16:47:03 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0884C112069;
        Fri, 26 Jun 2020 16:47:03 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A449B112063;
        Fri, 26 Jun 2020 16:47:02 +0000 (GMT)
Received: from sbct-3.pok.ibm.com (unknown [9.47.158.153])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 26 Jun 2020 16:47:02 +0000 (GMT)
Subject: Re: [PATCH] tpm: Define TPM2_SPACE_BUFFER_SIZE to replace the use of
 PAGE_SIZE
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-integrity@vger.kernel.org
Cc:     stable@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20200626143436.396889-1-jarkko.sakkinen@linux.intel.com>
From:   Stefan Berger <stefanb@linux.ibm.com>
Message-ID: <35184081-6f01-e13c-1b87-7c7d83d075c0@linux.ibm.com>
Date:   Fri, 26 Jun 2020 12:47:02 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200626143436.396889-1-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_08:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 impostorscore=0 spamscore=0 cotscore=-2147483648
 clxscore=1011 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006260112
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/26/20 10:34 AM, Jarkko Sakkinen wrote:
> The size of the buffers for storing context's and sessions can vary from
> arch to arch as PAGE_SIZE can be anything between 4 kB and 256 kB (the
> maximum for PPC64). Define a fixed buffer size set to 16 kB. This should
> be enough for most use with three handles (that is how many we allow at
> the moment).
>
> Reported-by: Stefan Berger <stefanb@linux.ibm.com>
> Cc: stable@vger.kernel.org
> Fixes: 745b361e989a ("tpm: infrastructure for TPM spaces")
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>   drivers/char/tpm/tpm2-space.c | 27 ++++++++++++++++-----------
>   1 file changed, 16 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
> index 982d341d8837..9bef646093d1 100644
> --- a/drivers/char/tpm/tpm2-space.c
> +++ b/drivers/char/tpm/tpm2-space.c
> @@ -15,6 +15,8 @@
>   #include <asm/unaligned.h>
>   #include "tpm.h"
>   
> +#define TPM2_SPACE_BUFFER_SIZE		16384 /* 16 kB */
> +
>   enum tpm2_handle_types {
>   	TPM2_HT_HMAC_SESSION	= 0x02000000,
>   	TPM2_HT_POLICY_SESSION	= 0x03000000,
> @@ -40,11 +42,11 @@ static void tpm2_flush_sessions(struct tpm_chip *chip, struct tpm_space *space)
>   
>   int tpm2_init_space(struct tpm_space *space)
>   {
> -	space->context_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
> +	space->context_buf = kzalloc(TPM2_SPACE_BUFFER_SIZE, GFP_KERNEL);
>   	if (!space->context_buf)
>   		return -ENOMEM;
>   
> -	space->session_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
> +	space->session_buf = kzalloc(TPM2_SPACE_BUFFER_SIZE, GFP_KERNEL);
>   	if (space->session_buf == NULL) {
>   		kfree(space->context_buf);
>   		return -ENOMEM;
> @@ -311,8 +313,10 @@ int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u8 *cmd,
>   	       sizeof(space->context_tbl));
>   	memcpy(&chip->work_space.session_tbl, &space->session_tbl,
>   	       sizeof(space->session_tbl));
> -	memcpy(chip->work_space.context_buf, space->context_buf, PAGE_SIZE);
> -	memcpy(chip->work_space.session_buf, space->session_buf, PAGE_SIZE);
> +	memcpy(chip->work_space.context_buf, space->context_buf,
> +	       TPM2_SPACE_BUFFER_SIZE);
> +	memcpy(chip->work_space.session_buf, space->session_buf,
> +	       TPM2_SPACE_BUFFER_SIZE);
>   
>   	rc = tpm2_load_space(chip);
>   	if (rc) {
> @@ -492,8 +496,8 @@ static int tpm2_save_space(struct tpm_chip *chip)
>   			continue;
>   
>   		rc = tpm2_save_context(chip, space->context_tbl[i],
> -				       space->context_buf, PAGE_SIZE,
> -				       &offset);
> +				       space->context_buf,
> +				       TPM2_SPACE_BUFFER_SIZE, &offset);
>   		if (rc == -ENOENT) {
>   			space->context_tbl[i] = 0;
>   			continue;
> @@ -509,9 +513,8 @@ static int tpm2_save_space(struct tpm_chip *chip)
>   			continue;
>   
>   		rc = tpm2_save_context(chip, space->session_tbl[i],
> -				       space->session_buf, PAGE_SIZE,
> -				       &offset);
> -
> +				       space->session_buf,
> +				       TPM2_SPACE_BUFFER_SIZE, &offset);
>   		if (rc == -ENOENT) {
>   			/* handle error saving session, just forget it */
>   			space->session_tbl[i] = 0;
> @@ -557,8 +560,10 @@ int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
>   	       sizeof(space->context_tbl));
>   	memcpy(&space->session_tbl, &chip->work_space.session_tbl,
>   	       sizeof(space->session_tbl));
> -	memcpy(space->context_buf, chip->work_space.context_buf, PAGE_SIZE);
> -	memcpy(space->session_buf, chip->work_space.session_buf, PAGE_SIZE);
> +	memcpy(space->context_buf, chip->work_space.context_buf,
> +	       TPM2_SPACE_BUFFER_SIZE);
> +	memcpy(space->session_buf, chip->work_space.session_buf,
> +	       TPM2_SPACE_BUFFER_SIZE);


work_space.session_buf and context_buf also need allocation changes, 
otherwise we read from a smaller buffer here. See comment to other patch 
about tpm-chip.c .


>   
>   	return 0;
>   out:


