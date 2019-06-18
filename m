Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A10544AA43
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 20:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730102AbfFRSur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 14:50:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22582 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729642AbfFRSur (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jun 2019 14:50:47 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5IImAUS072795
        for <stable@vger.kernel.org>; Tue, 18 Jun 2019 14:50:46 -0400
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t75c70r21-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 18 Jun 2019 14:50:44 -0400
Received: from localhost
        by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <haren@linux.vnet.ibm.com>;
        Tue, 18 Jun 2019 19:50:43 +0100
Received: from b03cxnp08025.gho.boulder.ibm.com (9.17.130.17)
        by e32.co.us.ibm.com (192.168.1.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 18 Jun 2019 19:50:39 +0100
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5IIochP29229434
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 18:50:39 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DEE7C6E050;
        Tue, 18 Jun 2019 18:50:38 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA5E16E054;
        Tue, 18 Jun 2019 18:50:36 +0000 (GMT)
Received: from [9.70.82.143] (unknown [9.70.82.143])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jun 2019 18:50:36 +0000 (GMT)
Date:   Tue, 18 Jun 2019 11:49:36 -0700
From:   Haren Myneni <haren@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To:     Michael Ellerman <mpe@ellerman.id.au>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [EXTERNAL] Re: crypto/NX: Set receive window credits to max number
 of CRBs in RxFIFO
References: <1560587942.17547.18.camel@hbabu-laptop> <87ef3royva.fsf@concordia.ellerman.id.au>
In-Reply-To: <87ef3royva.fsf@concordia.ellerman.id.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19061818-0004-0000-0000-0000151DD526
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011286; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01219860; UDB=6.00641670; IPR=6.01001001;
 MB=3.00027363; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-18 18:50:42
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061818-0005-0000-0000-00008C219623
Message-Id: <5D093240.1060506@linux.vnet.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-18_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906180148
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/18/2019 05:35 AM, Michael Ellerman wrote:
> Haren Myneni <haren@linux.vnet.ibm.com> writes:
>>     
>> System gets checkstop if RxFIFO overruns with more requests than the
>> maximum possible number of CRBs in FIFO at the same time. So find max
>> CRBs from FIFO size and set it to receive window credits.
>>    
>> CC: stable@vger.kernel.org # v4.14+
>> Signed-off-by:Haren Myneni <haren@us.ibm.com>
> 
> It's helpful to mention the actual commit that's fixed, so that people
> with backports can join things up, so should that be:
> 
>   Fixes: b0d6c9bab5e4 ("crypto/nx: Add P9 NX support for 842 compression engine")
> 
> ???

Sorry, Yes, We use 1K for Rx window credits in b0d6c9bab5e41d07f (crypto/nx: Add P9 NX support for 842 compression engine). But credits should be based on FIFO size. 

I will repost the patch.  

> 
> cheers
> 
>> diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
>> index 4acbc47..e78ff5c 100644
>> --- a/drivers/crypto/nx/nx-842-powernv.c
>> +++ b/drivers/crypto/nx/nx-842-powernv.c
>> @@ -27,8 +27,6 @@
>>  #define WORKMEM_ALIGN	(CRB_ALIGN)
>>  #define CSB_WAIT_MAX	(5000) /* ms */
>>  #define VAS_RETRIES	(10)
>> -/* # of requests allowed per RxFIFO at a time. 0 for unlimited */
>> -#define MAX_CREDITS_PER_RXFIFO	(1024)
>>  
>>  struct nx842_workmem {
>>  	/* Below fields must be properly aligned */
>> @@ -812,7 +810,11 @@ static int __init vas_cfg_coproc_info(struct device_node *dn, int chip_id,
>>  	rxattr.lnotify_lpid = lpid;
>>  	rxattr.lnotify_pid = pid;
>>  	rxattr.lnotify_tid = tid;
>> -	rxattr.wcreds_max = MAX_CREDITS_PER_RXFIFO;
>> +	/*
>> +	 * Maximum RX window credits can not be more than #CRBs in
>> +	 * RxFIFO. Otherwise, can get checkstop if RxFIFO overruns.
>> +	 */
>> +	rxattr.wcreds_max = fifo_size / CRB_SIZE;
>>  
>>  	/*
>>  	 * Open a VAS receice window which is used to configure RxFIFO
> 

