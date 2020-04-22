Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A26EF1B39F1
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 10:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbgDVIVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 04:21:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46350 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgDVIVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 04:21:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M8IlmG071282
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 08:21:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : references
 : to : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=de3B1TCMmHVqWH2ye4jmWt2kAUbmaYAhw3P2xiOC8qI=;
 b=b6loV39AnGCwKa8AUN0IyPVsaZwTTQ10wOUE+p3iip1h5SeBq2Mi96rX0ncWVXQRsAKe
 z77ZcSN4xSuQsJT1QNPPf+2nleouWiyb/o5D3g/GiEH/rd0bHk7c0g69CE0oHlhqUCb9
 CHnhBTLbtIFWhko9mdDsgIMbBINucJeK9g+v0rVWjgRRcapc/mcByVZ+cjdU5ktYyB+l
 OBScub7oKX9xkToGyeiDUsDsx/H0efeeKSGEwbJd4DdZ/OacDhXtVn8tZJbEKDPT8gRB
 64ti2+CKnx/lCjVydkUs1S2CJ25L6SIDe8WqxewBvofCNAtsJM7gU6DtfeGGtqD0FsZl Yg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30jhyc0464-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 08:21:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M88NRB082723
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 08:21:28 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30gb1j14ud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 08:21:28 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03M8LRxZ029853
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 08:21:27 GMT
Received: from [10.175.2.238] (/10.175.2.238)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Apr 2020 01:21:27 -0700
Subject: Fwd: Re: [PATCH AUTOSEL 5.6 082/129] compiler.h: fix error in
 BUILD_BUG_ON() reporting
References: <9b7c57b0-4441-12a1-420d-684a84e97ba0@oracle.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
From:   Vegard Nossum <vegard.nossum@oracle.com>
X-Forwarded-Message-Id: <9b7c57b0-4441-12a1-420d-684a84e97ba0@oracle.com>
Message-ID: <05565e26-e472-67e5-34e9-c466457a0db3@oracle.com>
Date:   Wed, 22 Apr 2020 10:21:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <9b7c57b0-4441-12a1-420d-684a84e97ba0@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220066
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 clxscore=1011 suspectscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220066
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi,

There is no point in taking this patch on any stable kernel as it's just
improving a build error diagnostic message.


Vegard

On 4/15/20 1:33 PM, Sasha Levin wrote:
> From: Vegard Nossum <vegard.nossum@oracle.com>
> 
> [ Upstream commit af9c5d2e3b355854ff0e4acfbfbfadcd5198a349 ]
> 
> compiletime_assert() uses __LINE__ to create a unique function name.  This
> means that if you have more than one BUILD_BUG_ON() in the same source
> line (which can happen if they appear e.g.  in a macro), then the error
> message from the compiler might output the wrong condition.
> 
> For this source file:
> 
> 	#include <linux/build_bug.h>
> 
> 	#define macro() \
> 		BUILD_BUG_ON(1); \
> 		BUILD_BUG_ON(0);
> 
> 	void foo()
> 	{
> 		macro();
> 	}
> 
> gcc would output:
> 
> ./include/linux/compiler.h:350:38: error: call to `__compiletime_assert_9' declared with attribute error: BUILD_BUG_ON failed: 0
>    _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
> 
> However, it was not the BUILD_BUG_ON(0) that failed, so it should say 1
> instead of 0. With this patch, we use __COUNTER__ instead of __LINE__, so
> each BUILD_BUG_ON() gets a different function name and the correct
> condition is printed:
> 
> ./include/linux/compiler.h:350:38: error: call to `__compiletime_assert_0' declared with attribute error: BUILD_BUG_ON failed: 1
>    _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
> 
> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> Reviewed-by: Daniel Santos <daniel.santos@pobox.com>
> Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: Joe Perches <joe@perches.com>
> Link: http://lkml.kernel.org/r/20200331112637.25047-1-vegard.nossum@oracle.com
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   include/linux/compiler.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index 5e88e7e33abec..034b0a644efcc 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -347,7 +347,7 @@ static inline void *offset_to_ptr(const int *off)
>    * compiler has support to do so.
>    */
>   #define compiletime_assert(condition, msg) \
> -	_compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
> +	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>   
>   #define compiletime_assert_atomic_type(t)				\
>   	compiletime_assert(__native_word(t),				\
> 

