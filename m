Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C79462556A2
	for <lists+stable@lfdr.de>; Fri, 28 Aug 2020 10:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbgH1Inw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Aug 2020 04:43:52 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.66]:41999 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726643AbgH1Inr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Aug 2020 04:43:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1598604223; i=@ts.fujitsu.com;
        bh=NoPGa03jBYvqxAYb4MkGSj3h6KKqasrXLhk97t5j04k=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=a4vOXb0gI4sa5fqVBrvoh9Ywz58pHsY4r6/BC1NtHoaqLuh/chv3H5kjE84wQxckL
         LkYpb0h1otE+4VMAo+ikXt6xxVr04eVT2ewBIXICz8EMF4ZM/jr38qqN919GQevd14
         qhecKpqVB4MwV49JYOw2fTOGwv3Yb9JW33YHWaGxeQo4PhxdubQra4FX8MhsHdECOl
         d///+n2Fl6AmXi3u+m4O7IzofjroB5hLi6avtDj/kyjVxT0+xpvT2RzeBFipiDFTi6
         fO8DvVY9KB+q/mlpis7Q+aJPIQHdiuXo0zOr59uLVmDmUUxNl5vl7vMSkkgRMCRbPz
         kwJnMzEPy20Cg==
Received: from [100.112.199.63] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-2.bemta.az-b.eu-west-1.aws.symcld.net id 70/E1-29177-FB3C84F5; Fri, 28 Aug 2020 08:43:43 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRWlGSWpSXmKPExsViZ8MxVXf/YY9
  4g0+/mC0OL3zDZNF9fQebxYy2MIvlx/8xWfyddIPVYsHGR4wWrUvfMjmwe+ycdZfd43HPGTaP
  j09vsXh83iQXwBLFmpmXlF+RwJrxbZlvwQGOiun397M2MP5n62Lk4hASmMwoceXBSRYIp59RY
  t6nC4xdjJwcwgJOEs8vPAerEhE4wigxvbubBSTBLOAqsfjgPCYQW0igUmLbnfusIDabgIHEik
  n3wWp4BRwlLi2YyAZiswioSszpuA1Uw8EhKhAu8WyFP0SJoMTJmU/AyjkF3CQe/+pnhRhvJjF
  v80NmCFtc4taT+UwQtrzE9rdzmCcw8s9C0j4LScssJC2zkLQsYGRZxWieVJSZnlGSm5iZo2to
  YKBraGika2hppmtmopdYpZukl1qqW55aXKJrqJdYXqxXXJmbnJOil5dasokRGBMpBUccdjDef
  /1B7xCjJAeTkihv5UGPeCG+pPyUyozE4oz4otKc1OJDjDIcHEoSvGaHgHKCRanpqRVpmTnA+I
  RJS3DwKInwhoCkeYsLEnOLM9MhUqcYFaXEea1AEgIgiYzSPLg2WEq4xCgrJczLyMDAIMRTkFq
  Um1mCKv+KUZyDUUmY9wDIZTyZeSVw018BLWYCWjw3zBVkcUkiQkqqgcnjhpDkmjd8j3Ld2E41
  q1tKyL+9YlgYfsF8ucCa2zHego+/Lr1b0ma25ArTS+0Iu1h/9zOLmx/OzHfhF3i9Rkxhp8S+S
  p4KjvkqhydbMj9Zo8zB43uUv2ryvX/BIRek7p/eqWJwfprF7igZVn7O/M95eb8sl3O7ej6/8u
  K0CstBS8+7Qin7Pq0PWmVwvNwv2GVjQL/oPetpbRO3HJa0P/SW53BmrPveCTysG2dx5G48JFv
  aE9G5fm8kj/0xnQlnNu1M27azzJmj0KLBP0ZHIHF+mHmXznzWkovvg3e4bFoj0DfJUkP0zZ7N
  Wq6Ziis+rZguxn77yrIQqdw6/p15+xjdzq0wkKmuL7raXNg6W4mlOCPRUIu5qDgRACto/2KEA
  wAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-21.tower-291.messagelabs.com!1598604222!1078297!1
X-Originating-IP: [62.60.8.149]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 19891 invoked from network); 28 Aug 2020 08:43:42 -0000
Received: from unknown (HELO mailhost2.uk.fujitsu.com) (62.60.8.149)
  by server-21.tower-291.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 28 Aug 2020 08:43:42 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost2.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 07S8haNj023812;
        Fri, 28 Aug 2020 09:43:36 +0100
Received: from [172.17.39.90] (unknown [172.17.39.90])
        by x-serv01 (Postfix) with ESMTP id B369B202FF;
        Fri, 28 Aug 2020 10:43:33 +0200 (CEST)
Subject: Re: [PATCH v2 0/2] scsi: target: tcmu: fix crashes on ARM
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        stable@vger.kernel.org
Cc:     JiangYu <lnsyyj@hotmail.com>, Daniel Meyerholt <dxm523@gmail.com>
References: <20200618131632.32748-1-bstroesser@ts.fujitsu.com>
 <159262354735.7800.15424809109743064228.b4-ty@oracle.com>
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Message-ID: <ec08c542-5903-4ebd-d18e-9c9b2f067eb6@ts.fujitsu.com>
Date:   Fri, 28 Aug 2020 10:43:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <159262354735.7800.15424809109743064228.b4-ty@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I'm adding stable@vger.kernel.org

On 2020-06-20 05:26, Martin K. Petersen wrote:
> On Thu, 18 Jun 2020 15:16:30 +0200, Bodo Stroesser wrote:
> 
>> This small series of patches consists of:
>>     [PATCH 1/2 v2] scsi: target: tcmu: Optimize use of flush_dcache_page
>>     [PATCH 2/2 v2] scsi: target: tcmu: Fix crash in tcmu_flush_dcache_range
>>
>> Together with commit
>>     8c4e0f212398 scsi: target: tcmu: Fix size in calls to tcmu_flush_dcache_range
>> these patches fix crashes in tcmu on ARM.
>>
>> [...]
> 
> Applied to 5.9/scsi-queue, thanks!
> 
> [1/2] scsi: target: tcmu: Optimize use of flush_dcache_page
>        https://git.kernel.org/mkp/scsi/c/3c58f737231e
> [2/2] scsi: target: tcmu: Fix crash in tcmu_flush_dcache_range on ARM
>        https://git.kernel.org/mkp/scsi/c/3145550a7f8b
> 

Patch 2/2 of this series already made it into 5.8, (5.7,) 5.4 and 4.19,
but patch 1/2 was not added yet. The crash will be fixed with with both
patches only. So please consider adding patch 1/2 also. The full commit
is 3c58f737231e2c8cbf543a09d84d8c8e80e05e43

Thank you
Bodo
