Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0164CB095
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 22:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbiCBVCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 16:02:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245052AbiCBVCq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 16:02:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC09DCE36;
        Wed,  2 Mar 2022 13:02:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BDE2B82232;
        Wed,  2 Mar 2022 21:02:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800FAC004E1;
        Wed,  2 Mar 2022 21:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646254920;
        bh=BTjzQHSYWCshwUjWSLiGwYl2m1K3Lc1r61aRCYDDDFU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K1VxEbkhggIXEiDHyWapXwKbWID3xQNOT3yuuCe+WG2K9ZTkqDcW85KmXfA7Jq449
         i8pHsjDKky1fVa6uog1wYVdG31bzTWIucZxTLMs/L22tpis17R7GboiSBBJM/9bngB
         9fy8bkDhl9KOFdhS7TtF+hbaKFgjrHTznL3HtTBtI3LGgEEevgp5XadOgnLwt1IgEe
         tPj+UHoe9ZLquzvj/Cl7wPL7dLmvJV6BX49XoOfsctEhe2Hw3cHbQoj8EcD0djW57f
         wbPV7dQuGjutR1LzZH4Nik61fa5xGJShJMmxD3Kro4X59utEu5V+dm1wVOBAuAkypc
         DzLHvEv7cG3xg==
Date:   Wed, 2 Mar 2022 16:01:56 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wolfram Sang <wsa@kernel.org>,
        krzysztof.kozlowski@canonical.com, semen.protsenko@linaro.org,
        robh@kernel.org, yangyicong@hisilicon.com, geert+renesas@glider.be,
        sven@svenpeter.dev, jie.deng@intel.com, bence98@sch.bme.hu,
        lukas.bulwahn@gmail.com, linux-i2c@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 12/13] i2c: qup: allow COMPILE_TEST
Message-ID: <Yh/bRJv7utMEXHnZ@sashalap>
References: <20220223023152.242065-1-sashal@kernel.org>
 <20220223023152.242065-12-sashal@kernel.org>
 <20220224224126.GC6522@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220224224126.GC6522@duo.ucw.cz>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 24, 2022 at 11:41:26PM +0100, Pavel Machek wrote:
>Hi!
>
>> [ Upstream commit 5de717974005fcad2502281e9f82e139ca91f4bb ]
>>
>> Driver builds fine with COMPILE_TEST. Enable it for wider test coverage
>> and easier maintenance.
>
>I believe this does not fix a bug and so is not suitable for stable.

It does not, but it helps us catch bugs we otherwise wouldn't have.

-- 
Thanks,
Sasha
