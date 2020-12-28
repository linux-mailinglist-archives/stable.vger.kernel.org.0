Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E732E6A7A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 20:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729127AbgL1T3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 14:29:25 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57422 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728025AbgL1T3Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 14:29:25 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BSJ2Je4093091;
        Mon, 28 Dec 2020 14:28:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Rpn4lp3SUOk2YDd86lH3fnWtn2BSZNIwtJDTL4FJsaE=;
 b=h5F0QAKrFAED+I59GtQ/Zv8B18CbkY/hJGSMx9ROPZu3RDTdLjm+jk1bUrMu2Q7T3jVI
 9e76Y67b/r5Fu19ShN+vuFv8GvSKWf0NsxGBgWKdLs0qy2qgkTnv7BKRNS1+sz3+wHOk
 6DTrzBF9TfdTcZEKezGVZjZmwok5oYfkLxWtmVfF8UjiIlFmr5rQSdSULgiyBDqESQy7
 KAfCVxbdWtDyhmJfpqc4WpN7PHegr2m/Dtu5F1Vo7afkGb1iGskHfWl2/rEfO5LKUuFA
 7wkIp9/lSBaee8eXpxJaVtf/ED4qKGlorEBvjJ42Shz4zmEnUnFxVFU4iKdAs9ekhPiQ TQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35qm69hn29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Dec 2020 14:28:41 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BSJRXSA174570;
        Mon, 28 Dec 2020 14:28:41 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35qm69hn21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Dec 2020 14:28:41 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BSJSaZI007668;
        Mon, 28 Dec 2020 19:28:40 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03wdc.us.ibm.com with ESMTP id 35qkjg8nvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Dec 2020 19:28:40 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BSJSd7j23790032
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Dec 2020 19:28:39 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97A342805A;
        Mon, 28 Dec 2020 19:28:39 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 546A728058;
        Mon, 28 Dec 2020 19:28:39 +0000 (GMT)
Received: from [9.80.236.243] (unknown [9.80.236.243])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 28 Dec 2020 19:28:39 +0000 (GMT)
Subject: Re: [PATCH AUTOSEL 5.7 03/30] ima: extend boot_aggregate with kernel
 measurements
To:     Mimi Zohar <zohar@linux.ibm.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Maurizio Drocco <maurizio.drocco@ibm.com>,
        Bruno Meneguele <bmeneg@redhat.com>,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org
References: <20200708154116.3199728-1-sashal@kernel.org>
 <20200708154116.3199728-3-sashal@kernel.org>
 <1594224793.23056.251.camel@linux.ibm.com>
 <20200709012735.GX2722994@sasha-vm>
 <5b8dcdaf66fbe2a39631833b03772a11613fbbbf.camel@linux.ibm.com>
 <20201211031008.GN489768@sequoia>
 <659c09673affe9637a5d1391c12af3aa710ba78a.camel@linux.ibm.com>
 <76710d8ec58c440ed7a7b446696b8659f694d0db.camel@HansenPartnership.com>
 <05266e520f62276b07e76aab177ea6db47916a7f.camel@linux.ibm.com>
From:   Ken Goldman <kgold@linux.ibm.com>
Message-ID: <fccbb614-3a73-651d-b2f4-fb98ff4022f5@linux.ibm.com>
Date:   Mon, 28 Dec 2020 14:28:38 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <05266e520f62276b07e76aab177ea6db47916a7f.camel@linux.ibm.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-28_17:2020-12-28,2020-12-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 priorityscore=1501 mlxscore=0 suspectscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1031 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012280113
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/12/2020 9:22 PM, Mimi Zohar wrote:
> Ok.   Going forward, it sounds like we need to define a new
> "boot_aggregate" record.  One that contains a version number and PCR
> mask.

Just BTW, there is a TCG standard for a TPM 2.0 PCR mask that works
well.

There is also a standard for an event log version number.  It is
the first event of a TPM 2.0 event log.  It is strange.

One useful field, though, is a mapping between the algorithm ID (e.g.,
sha256 is 0x000b) and the digest size (e.g., 32 bytes).  This permits
a parser to parse a log even when it encounters an unknown digest
algorithm.



