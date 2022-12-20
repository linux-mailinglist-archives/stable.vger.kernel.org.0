Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90C946525D4
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 18:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbiLTRy0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 12:54:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiLTRyZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 12:54:25 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E162865DB;
        Tue, 20 Dec 2022 09:54:24 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKHhbrS025375;
        Tue, 20 Dec 2022 17:54:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=K6TTv6Wy5iMjG3NldPXdah0kMw4suzOvdHwCh1UyfJ4=;
 b=GAk2BHJfFWBQRvJGacpWNUJnEE09zzpKGZfBPbBUYmOtP8QFkr9ae99oX8m4grWXqWnq
 d8bqniMzbyl4vFFTMHjoludF6VwQtALe54lW1Vr9XvozIINjW4Xaw8ZJHWv60I1j0GK7
 edvG+7dlWRoSxkx3+pa9TZuo30YVnaf+bOaxOt2H2baAFV85mCr/KdX+1rRdygk0b3rj
 BQue4bHhFpBb9aX5RAHpZdlPzqzzZBrPw0QZbbrBRMeWL+ykRCSJMLglbs10rcqxy8uJ
 JZvTnp05kzoP7fU9zqeUSaIbdln+fWPNzGGGirFFaGOvXPgYhoAmMZqCeXoQAdF5Q6FR cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkhpyr8j2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:54:19 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BKHhgxV025964;
        Tue, 20 Dec 2022 17:54:18 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkhpyr8hd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:54:18 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BK2b0uc031759;
        Tue, 20 Dec 2022 17:54:16 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3mh6yw35m4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:54:16 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BKHsEVM47841558
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 17:54:14 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5594320043;
        Tue, 20 Dec 2022 17:54:14 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C308120040;
        Tue, 20 Dec 2022 17:54:12 +0000 (GMT)
Received: from [9.171.170.120] (unknown [9.171.170.120])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 20 Dec 2022 17:54:12 +0000 (GMT)
Message-ID: <22a981c2-2896-bc2e-115c-f1d85c0084bd@linux.ibm.com>
Date:   Tue, 20 Dec 2022 18:53:53 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v2] gcov: Add support for checksum field
To:     Rickard Andersson <rickaran@axis.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     rickard314.andersson@gmail.com, mliska@suse.cz,
        Jesper.Nilsson@axis.com, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221220102318.3418501-1-rickaran@axis.com>
Content-Language: en-US
From:   Peter Oberparleiter <oberpar@linux.ibm.com>
In-Reply-To: <20221220102318.3418501-1-rickaran@axis.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2IGTKjfofqA9QIiCTRAD_GnqvLzzcziX
X-Proofpoint-GUID: DcnKJYy7h_NyPg9Wb7f6t7cZuxnMkLMG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-20_06,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212200146
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20.12.2022 11:23, Rickard Andersson wrote:
> From: Rickard x Andersson <rickaran@axis.com>
> 
> In GCC version 12.1 a checksum field was added.
> 
> This patch fixes a kernel crash occurring during boot when
> using gcov-kernel with GCC version 12.2. The crash occurred on
> a system running on i.MX6SX.
> 
> Fixes: 977ef30a7d88 ("gcov: support GCC 12.1 and newer compilers")
> Signed-off-by: Rickard x Andersson <rickaran@axis.com>
> Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
> Tested-by: Peter Oberparleiter <oberpar@linux.ibm.com>
> Cc: <stable@vger.kernel.org>

Thank you for the fix!

Andrew, could you pick this up via your tree?

> ---
>  kernel/gcov/gcc_4_7.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/kernel/gcov/gcc_4_7.c b/kernel/gcov/gcc_4_7.c
> index c699feda21ac..04880d8fba25 100644
> --- a/kernel/gcov/gcc_4_7.c
> +++ b/kernel/gcov/gcc_4_7.c
> @@ -85,6 +85,7 @@ struct gcov_fn_info {
>   * @version: gcov version magic indicating the gcc version used for compilation
>   * @next: list head for a singly-linked list
>   * @stamp: uniquifying time stamp
> + * @checksum: unique object checksum
>   * @filename: name of the associated gcov data file
>   * @merge: merge functions (null for unused counter type)
>   * @n_functions: number of instrumented functions
> @@ -97,6 +98,10 @@ struct gcov_info {
>  	unsigned int version;
>  	struct gcov_info *next;
>  	unsigned int stamp;
> + /* Since GCC 12.1 a checksum field is added. */
> +#if (__GNUC__ >= 12)
> +	unsigned int checksum;
> +#endif
>  	const char *filename;
>  	void (*merge[GCOV_COUNTERS])(gcov_type *, unsigned int);
>  	unsigned int n_functions;

-- 
Peter Oberparleiter
Linux on IBM Z Development - IBM Germany R&D

