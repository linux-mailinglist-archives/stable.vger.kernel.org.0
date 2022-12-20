Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 077306525E3
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 18:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbiLTR6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 12:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiLTR6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 12:58:18 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA53110F;
        Tue, 20 Dec 2022 09:58:17 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKHigZJ013863;
        Tue, 20 Dec 2022 17:58:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=S+cv01ZXn+4HkS6yZHMHKwmMupnoVrSE6vH4stXWWik=;
 b=tkajb6jrthLVZiH4PsjHsX/fLIBBTqYEqoQlnySCm1HWRNTlBGg2jC9BXgh6/CFaxEp1
 EXUvUmF161JDyuO8L/MlQj2U/fMNSYL+FzL+R4WR17z3nDHwntEcfL/5UShiEPQ041fS
 93KsjMSyWokml2zgxymDIq/Rdz+7A7MmIwQs3V6o7PMHtS2usTlhYgEOSpywbNrWjCTu
 j73jWgGoek1oQTgMPAMbUm9m8/GE+2kVtuVTv6fRKLkreRDVo3eG8+SwaAOqR7sp2KNx
 TXaeVEWn4inS6IPc8BEuOevl9tZZ7J/EPW5nWOe2fTPTBp3vqBS5g8P8WOaVitPJi8fs AA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkhq98a3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:58:13 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BKHkRuX019106;
        Tue, 20 Dec 2022 17:58:12 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkhq98a2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:58:12 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BK61aUk014068;
        Tue, 20 Dec 2022 17:58:10 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3mh6yw4cg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:58:10 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BKHw85i26280326
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 17:58:08 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55DEC20043;
        Tue, 20 Dec 2022 17:58:08 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 20B6020040;
        Tue, 20 Dec 2022 17:58:08 +0000 (GMT)
Received: from [9.171.170.120] (unknown [9.171.170.120])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 20 Dec 2022 17:58:08 +0000 (GMT)
Message-ID: <45e1f493-785b-4d59-c566-570a6d8cd744@linux.ibm.com>
Date:   Tue, 20 Dec 2022 18:57:49 +0100
Subject: Re: [PATCH v2] gcov: Add support for checksum field
Content-Language: en-US
From:   Peter Oberparleiter <oberpar@linux.ibm.com>
To:     Rickard Andersson <rickaran@axis.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     rickard314.andersson@gmail.com, mliska@suse.cz,
        Jesper.Nilsson@axis.com, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221220102318.3418501-1-rickaran@axis.com>
 <22a981c2-2896-bc2e-115c-f1d85c0084bd@linux.ibm.com>
In-Reply-To: <22a981c2-2896-bc2e-115c-f1d85c0084bd@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mosDr5zQPDKmNguIhJE_-okppsxJn7v5
X-Proofpoint-ORIG-GUID: VvIBmN2ytctPPrU05Zywj0ig1Nj0Fb11
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-20_06,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 impostorscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212200146
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20.12.2022 18:53, Peter Oberparleiter wrote:
> On 20.12.2022 11:23, Rickard Andersson wrote:
>> From: Rickard x Andersson <rickaran@axis.com>
>>
>> In GCC version 12.1 a checksum field was added.
>>
>> This patch fixes a kernel crash occurring during boot when
>> using gcov-kernel with GCC version 12.2. The crash occurred on
>> a system running on i.MX6SX.
>>
>> Fixes: 977ef30a7d88 ("gcov: support GCC 12.1 and newer compilers")
>> Signed-off-by: Rickard x Andersson <rickaran@axis.com>
>> Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
>> Tested-by: Peter Oberparleiter <oberpar@linux.ibm.com>
>> Cc: <stable@vger.kernel.org>
> 
> Thank you for the fix!
> 
> Andrew, could you pick this up via your tree?

Oh, I forgot to add Martin's R-B from the v1 review (see [1]), so please
include:

Reviewed-By: Martin Liska <mliska@suse.cz>

https://lore.kernel.org/lkml/20221219150621.3310033-1-rickaran@axis.com/t/#mc2625879466e8af245cbebcc99acc4b8dd0b8cdc

> 
>> ---
>>  kernel/gcov/gcc_4_7.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/kernel/gcov/gcc_4_7.c b/kernel/gcov/gcc_4_7.c
>> index c699feda21ac..04880d8fba25 100644
>> --- a/kernel/gcov/gcc_4_7.c
>> +++ b/kernel/gcov/gcc_4_7.c
>> @@ -85,6 +85,7 @@ struct gcov_fn_info {
>>   * @version: gcov version magic indicating the gcc version used for compilation
>>   * @next: list head for a singly-linked list
>>   * @stamp: uniquifying time stamp
>> + * @checksum: unique object checksum
>>   * @filename: name of the associated gcov data file
>>   * @merge: merge functions (null for unused counter type)
>>   * @n_functions: number of instrumented functions
>> @@ -97,6 +98,10 @@ struct gcov_info {
>>  	unsigned int version;
>>  	struct gcov_info *next;
>>  	unsigned int stamp;
>> + /* Since GCC 12.1 a checksum field is added. */
>> +#if (__GNUC__ >= 12)
>> +	unsigned int checksum;
>> +#endif
>>  	const char *filename;
>>  	void (*merge[GCOV_COUNTERS])(gcov_type *, unsigned int);
>>  	unsigned int n_functions;
> 

-- 
Peter Oberparleiter
Linux on IBM Z Development - IBM Germany R&D

