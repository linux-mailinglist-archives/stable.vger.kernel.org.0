Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0F574CB08B
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 22:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239372AbiCBVCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 16:02:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbiCBVCJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 16:02:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CE0D2069;
        Wed,  2 Mar 2022 13:01:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED85FB81FB1;
        Wed,  2 Mar 2022 21:01:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373FAC340EF;
        Wed,  2 Mar 2022 21:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646254882;
        bh=pZMMoaiSp8YleU3wN8sImtSMq9BxXGCX7Zfl1Pe7QD8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oYHdl47qdJ+kPW01KWr5eEu+Mly9YCoqjHEDPP/7ln9wzjC7sUYr8ECtKDmp4LNPT
         V3LZeSHIziSS+35f93pNcO2bfp+VDl4UMIwiP/br0by18qcdB3dTeJzfXD4AkAnNNq
         Niryo7xgV0bWZDYJ5L/LrvltT9FwYU4nmvLZA8AIrBuXBNjntd5yJjAH3F49vwaJUc
         WLj2av77MnSA/DVioCN8VafQ4OZRBXuM7vboDaiyXgdYZyOkmjSxlW3FgDrTPtkZpH
         DQ7LfkIJ7FyumKIlr9uVc5b0US6149uLdQirmA5QwMRmV7m3fKC0d8S/y/T3X6Rbx5
         lj+iTtYNI54hA==
Date:   Wed, 2 Mar 2022 16:01:18 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        shuah@kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 09/13] selftests/ftrace: Do not trace
 do_softirq because of PREEMPT_RT
Message-ID: <Yh/bHmpENqn1x7kK@sashalap>
References: <20220223023152.242065-1-sashal@kernel.org>
 <20220223023152.242065-9-sashal@kernel.org>
 <20220224224622.GD6522@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220224224622.GD6522@duo.ucw.cz>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 24, 2022 at 11:46:22PM +0100, Pavel Machek wrote:
>On Tue 2022-02-22 21:31:48, Sasha Levin wrote:
>> From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>>
>> [ Upstream commit 6fec1ab67f8d60704cc7de64abcfd389ab131542 ]
>>
>> The PREEMPT_RT patchset does not use do_softirq() function thus trying
>> to filter for do_softirq fails for such kernel:
>>
>>   echo do_softirq
>>   ftracetest: 81: echo: echo: I/O error
>>
>> Choose some other visible function for the test.  The function does not
>> have to be actually executed during the test, because it is only testing
>> filter API interface.
>
>This needs -rt patch even on mainline, right?
>
>It is certainly not needed in -stable branches.

I'll drop it, thanks.

-- 
Thanks,
Sasha
