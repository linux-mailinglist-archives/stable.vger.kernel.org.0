Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49797F4B4D
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732663AbfKHMQd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:16:33 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58682 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731612AbfKHMQd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 07:16:33 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA8CDl3Z054449
        for <stable@vger.kernel.org>; Fri, 8 Nov 2019 07:16:32 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w57hwhckr-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 08 Nov 2019 07:16:32 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <jwi@linux.ibm.com>;
        Fri, 8 Nov 2019 12:16:30 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 8 Nov 2019 12:16:27 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA8CGQIn18481198
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 Nov 2019 12:16:26 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C517FA4054;
        Fri,  8 Nov 2019 12:16:26 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8774EA405B;
        Fri,  8 Nov 2019 12:16:26 +0000 (GMT)
Received: from [9.152.222.69] (unknown [9.152.222.69])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  8 Nov 2019 12:16:26 +0000 (GMT)
Subject: Re: [PATCH AUTOSEL 4.19 204/205] s390/qeth: limit csum offload
 erratum to L3 devices
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        linux-s390@vger.kernel.org
References: <20191108113752.12502-1-sashal@kernel.org>
 <20191108113752.12502-204-sashal@kernel.org>
 <2e4553d6-de1f-bb61-33e4-10a5c23f0aa7@linux.ibm.com>
 <20191108120025.GM4787@sasha-vm>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Date:   Fri, 8 Nov 2019 13:16:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191108120025.GM4787@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19110812-0012-0000-0000-00000361E08A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19110812-0013-0000-0000-0000219D4507
Message-Id: <4d8f1938-af6e-7e0e-4085-2f7c53390b2d@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-08_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1031 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911080121
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08.11.19 13:00, Sasha Levin wrote:
> On Fri, Nov 08, 2019 at 12:50:24PM +0100, Julian Wiedmann wrote:
>> On 08.11.19 12:37, Sasha Levin wrote:
>>> From: Julian Wiedmann <jwi@linux.ibm.com>
>>>
>>> [ Upstream commit f231dc9dbd789b0f98a15941e3cebedb4ad72ad5 ]
>>>
>>> Combined L3+L4 csum offload is only required for some L3 HW. So for
>>> L2 devices, don't offload the IP header csum calculation.
>>>
>>
>> NACK, this has no relevance for stable.
> 
> Sure, I'll drop it.
> 
> Do you have an idea why the centos and ubuntu folks might have
> backported this commit into their kernels?
> 

No clue, I trust they have their own reasons.

