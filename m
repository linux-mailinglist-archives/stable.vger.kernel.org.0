Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5F4527328
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 18:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbiENQt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 12:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbiENQtz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 12:49:55 -0400
X-Greylist: delayed 160 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 14 May 2022 09:49:53 PDT
Received: from cmx-torrgo002.bell.net (mta-tor-005.bell.net [209.71.212.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3115838BE3;
        Sat, 14 May 2022 09:49:53 -0700 (PDT)
X-RG-CM-BuS: 0
X-RG-CM-SC: 0
X-RG-CM: Clean
X-Originating-IP: [70.50.7.94]
X-RG-Env-Sender: dave.anglin@bell.net
X-RG-Rigid: 627A10BA00D03C0E
X-CM-Envelope: MS4xfOMksjxXwfninAMIQkKQ8I3+iKJe36nzEYaOMmmL1RXS+HofnHnXhpck5vKZalp96pCLurQiSV3iyCcOottdqlLLF3/Cmk7/bVinaRHpPgGr+O4H/Jce
 KR+vV+QHQkTy9Gicdu9o1YQYBHPv0KYRELMWNElwSBcHl4Ebck1reHtFe0Gx8md7sfRMsRzNmqrkZN1X6OHXmNIy+eFD9xO9M2olESEgs0tOpWkMaSeyWHIA
 C1TKQJtGASCEXUWJbZD/9Tw4vR6DhUIKiAgYbBj+5xBtq/v9ghAukFH68IKk2jEwFDPMViVQIrVHCKThKL0JjVkO/HOPnTXuzgF6qDTrHJd8zOZnPSdishDn
 NBdJglJSNkI4PYKPP6DamhKu9RL7F46RcrT25JKq527355RvUYTbu8HFS5pAxHq509SL7Ecn
X-CM-Analysis: v=2.4 cv=G99/r/o5 c=1 sm=1 tr=0 ts=627fdd04
 a=9k1bCY7nR7m1ZFzoCuQ56g==:117 a=9k1bCY7nR7m1ZFzoCuQ56g==:17
 a=IkcTkHD0fZMA:10 a=FBHGMhGWAAAA:8 a=48wWPq5cR6GzFqV75LMA:9 a=QEXdDO2ut3YA:10
 a=9gvnlMMaQFpL9xblJ6ne:22
Received: from [192.168.2.49] (70.50.7.94) by cmx-torrgo002.bell.net (5.8.807) (authenticated as dave.anglin@bell.net)
        id 627A10BA00D03C0E; Sat, 14 May 2022 12:47:00 -0400
Message-ID: <a3fe40b5-b88e-4d01-0209-6d26b2d384bd@bell.net>
Date:   Sat, 14 May 2022 12:47:00 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH AUTOSEL 5.17 21/21] Revert "parisc: Fix patch code locking
 and flushing"
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, Helge Deller <deller@gmx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        James.Bottomley@hansenpartnership.com, linux-parisc@vger.kernel.org
References: <20220510154340.153400-1-sashal@kernel.org>
 <20220510154340.153400-21-sashal@kernel.org>
 <37d6bcac-bca4-06a6-ecab-bf83bd3468cd@gmx.de> <Yn/X0quyI58WVTfJ@sashalap>
From:   John David Anglin <dave.anglin@bell.net>
In-Reply-To: <Yn/X0quyI58WVTfJ@sashalap>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-05-14 12:24 p.m., Sasha Levin wrote:
> On Tue, May 10, 2022 at 05:49:31PM +0200, Helge Deller wrote:
>> Hello Sascha,
>>
>> please drop this patch from all your stable-series queues....
>> It shouldn't be backported.
>
> I've dropped it, but... why?
It exposed a problem in the kernel flush code for PA 1.x machines. The patch works okay on
all PA 2.0 machines.  It also works on PA 1.x machines when flush_cache_all is used to flush
changes to memory.

Helge is investigating PA 1.x problem.

-- 
John David Anglin  dave.anglin@bell.net

