Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D053E1B3A9B
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 10:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725810AbgDVIxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 04:53:44 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54130 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725786AbgDVIxo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 04:53:44 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M8qfQH130259;
        Wed, 22 Apr 2020 08:53:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=6DEFYlsRRG2SzwL1Y9o2kEQ/FIaKCy30P9fUvWjBmlQ=;
 b=anqbXe5CFtn/2TNqAMPExqrYy4pHNEs4I668P5/sAHSe/ZNqRxGG96vS40lCVcN/WWGH
 JS13s/P+leo/tsGs7GVqyQ5EK/UIzR8yOGlamOAijLL4H7qbyLM17KkpplOELkXKHjUp
 Ucjm2SMifB8cGNAN7WiPQm1w05RBuCslBQ99IAbMPVb5JSbTRFzu6tQJWsVbvFoi3XX6
 Y+9voKyeNWyIFXVrivOuN7DEV5ZifzlmgHAMPsTMjffifsrYQ1MvzICNyRwVhyf8B3Bn
 7AiJZ9CmbCfIaRGXYXLLpM6xxZPtiRlwPLGPqErmoh2eAgdh5e6EtW4MWNG07D/xO0B3 mA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30jhyc0bsc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 08:53:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M8pgdh163385;
        Wed, 22 Apr 2020 08:53:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30gb3tk5wk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 08:53:39 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03M8rdiM016813;
        Wed, 22 Apr 2020 08:53:39 GMT
Received: from [10.175.2.238] (/10.175.2.238)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Apr 2020 01:53:38 -0700
Subject: Re: Fwd: Re: [PATCH AUTOSEL 5.6 082/129] compiler.h: fix error in
 BUILD_BUG_ON() reporting
To:     Greg KH <greg@kroah.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <9b7c57b0-4441-12a1-420d-684a84e97ba0@oracle.com>
 <05565e26-e472-67e5-34e9-c466457a0db3@oracle.com>
 <20200422083446.GA3039100@kroah.com>
From:   Vegard Nossum <vegard.nossum@oracle.com>
Message-ID: <aea96721-4b51-ff0c-3da9-660e318654b4@oracle.com>
Date:   Wed, 22 Apr 2020 10:53:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200422083446.GA3039100@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220071
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 clxscore=1011 suspectscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220071
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 4/22/20 10:34 AM, Greg KH wrote:
> On Wed, Apr 22, 2020 at 10:21:23AM +0200, Vegard Nossum wrote:
>>
>> Hi,
>>
>> There is no point in taking this patch on any stable kernel as it's just
>> improving a build error diagnostic message.
> 
> build error messages are nice to have be correct, don't you think?
> 
> Seems like a valid fix for me.
> 
> thanks,
> 
> greg k-h
> 

The patch will break on gcc 4.2 and earlier, so if the older stable
kernels support those then people might be surprised. The mainline patch
was deemed fine since gcc 4.6 is required. More info here:
<https://lkml.org/lkml/2020/3/31/1477>

If no stable kernel is built with gcc <= 4.2 then you can disregard this.

I think the patch also doesn't really satisfy the following criteria
from stable_kernel_rules.txt:

  - "It must fix a real bug that bothers people": It bothered me (and I
ran into the bug) on mainline, but that was while writing brand new code
that used BUILD_BUG_ON(). Presumably these things will not fire on
existing kernel code.

  - "It must fix a problem that causes a build error ...": It doesn't fix
any of the things listed, not even a build error, just a _diagnostic_
for an incredibly rare case of a rare kind of build error.

In the end, I am not personally opposed to having the patch in stable,
but it seems to go against everything I've ever heard about stable rules
so I'm a bit surprised when you take it anyway. I think it might reduce
people's trust in stable kernels if any random weird patch is taken
uncritically when even the patch author points out that it doesn't fit
the criteria!


Vegard
