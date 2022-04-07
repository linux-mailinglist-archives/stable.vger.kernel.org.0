Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23FEE4F758C
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 08:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232845AbiDGGCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 02:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238644AbiDGGCi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 02:02:38 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D742FFDB;
        Wed,  6 Apr 2022 23:00:36 -0700 (PDT)
Received: from [192.168.100.1] ([82.142.17.26]) by mrelayeu.kundenserver.de
 (mreue009 [213.165.67.103]) with ESMTPSA (Nemesis) id
 1M6DSi-1neVz01lE0-006grO; Thu, 07 Apr 2022 08:00:10 +0200
Message-ID: <198be9ea-a8c2-0f9e-6ae5-a7358035def4@vivier.eu>
Date:   Thu, 7 Apr 2022 08:00:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v16 1/4] tty: goldfish: introduce
 gf_ioread32()/gf_iowrite32()
Content-Language: fr
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        linux-m68k@lists.linux-m68k.org,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        linux-rtc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Alessandro Zummo <a.zummo@towertech.it>, stable@vger.kernel.org
References: <20220406201523.243733-1-laurent@vivier.eu>
 <20220406201523.243733-2-laurent@vivier.eu> <Yk5tNOPE4b2QbHLG@kroah.com>
From:   Laurent Vivier <laurent@vivier.eu>
In-Reply-To: <Yk5tNOPE4b2QbHLG@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:5cWmnnYDJufcUa3X22Vbqh4rcKN+LFRmgKjDgc/0+672+P3hWzN
 ARqb/oWIb+/kWgoDr7YcEmrPb/SGD84dgrexGNAQ1Q0hI9qRXue86iqHi4Cq9GTo6rO9JUK
 3gn41cqduSgCqcmo+xr1awqnQj+XsU9vsMZJMnAUC0CR1OBPE1JZYT8iuZfJ8/GtOQFhRq3
 86yW4PM8v6RJXH/03xaQQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ATlYoBjlPYI=:m3bzbW28a0/UV1CUXxl/8l
 r26uwHgSlt3Scb0rDufdtShxvKamu9CxmaiURzhu8Pxxyvf4+fdr2uvVESZ+dPWGMr0VGN8hK
 4cog7eSfoSf21BYBto+Kej4yPuJi7mSGDwQF1ncoBUOJyJzEG4j3TxNUzyDfCktKfMqAE2UCB
 pHgOCU607t9inU1U23+nS3y13b7L8j+dRmfd4iXJ3Ani/H7BCDpnFCqOP0258Om9bQVDFloKd
 /VyOe75oyseVYxxQtWURFRDLw4b3LfZJt9CyOWFl2Zuxcft6iWUS9p8ybxmjjnmcXtEDzhQlF
 V/xLoza5swZkKAqCWBXtzBfYz71+ow108Iz6GdME7ktRtUwO9TrnkMqOW9HUrCf0+NWjkJN+P
 aL6PffLIFrs0sZ2uLr8f9MS84UvKPCq54DtapWykRbdzWgo9NsFWbGg/2qRgUh+tXf058mHaw
 rPhN9I8ZcdU23dtHoo5AabTXqYmY5QLiivL6XO46GsnTP/JWB20DSeSBdqSGfM1/+HjGb+7wX
 4i3qeQtqhRp1X1+EmC0sgm3i39Gds2Kzuk5h3WThzvAauYSfTJ4rZ+XjCn0uR6CqrFc+czdzu
 4FvKqAT5jk7rSGvRAbIV9wCf5Ew47WGgZYwxcUiqwu60fErYGfJm7O70USGX373y1OdcuhQgc
 5SoOliC8Nkuqaw/UWWLnQyiet/mhj/Gszs9zVaThYs93M5cpWuRXj/QCQt19vYw1VEl8=
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 07/04/2022 à 06:48, Greg KH a écrit :
> On Wed, Apr 06, 2022 at 10:15:20PM +0200, Laurent Vivier wrote:
>> Revert
>> commit da31de35cd2f ("tty: goldfish: use __raw_writel()/__raw_readl()")
>>
>> and define gf_ioread32()/gf_iowrite32() to be able to use accessors
>> defined by the architecture.
>>
>> Cc: stable@vger.kernel.org # v5.11+
>> Fixes: da31de35cd2f ("tty: goldfish: use __raw_writel()/__raw_readl()")
>> Signed-off-by: Laurent Vivier <laurent@vivier.eu>
>> Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> ---
>>   drivers/tty/goldfish.c   | 20 ++++++++++----------
>>   include/linux/goldfish.h | 15 +++++++++++----
>>   2 files changed, 21 insertions(+), 14 deletions(-)
>>
> 
> Why is this a commit for the stable trees?  What bug does it fix?  You
> did not describe the problem in the changelog text at all, this looks
> like a housekeeping change only.

Arnd asked for that in:

   Re: [PATCH v11 2/5] tty: goldfish: introduce gf_ioread32()/gf_iowrite32()
   https://lore.kernel.org/lkml/CAK8P3a1oN8NrUjkh2X8jHQbyz42Xo6GSa=5n0gD6vQcXRjmq1Q@mail.gmail.com/

Thanks,
Laurent
