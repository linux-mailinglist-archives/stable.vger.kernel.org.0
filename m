Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 508EB4DB810
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 19:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352838AbiCPSor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 14:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357639AbiCPSom (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 14:44:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5943FD82
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 11:43:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF987618EA
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 18:43:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22CDC340EC;
        Wed, 16 Mar 2022 18:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647456206;
        bh=PImcoXYd2WAhY3kTJbICl2J0OLX8xN8KTB5xiw+3Kyo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s+0m7s4AmJpEAP6RPaQczhpEcX1cOuUMhUr4WxIJQ8Vb5Iv3oWRwEFmX7RtSQmIPU
         kAIE2YH5Gdwd1s4fMTKRaDYHvmhP+uMyp3HIGndo8AkR+mUKVZAdIs6jZhc70AtAkr
         XLxgqssq7hlc+3HeePf1zDoSPJ50fXa6wo3aGzi/j8K3VrVfBeX5xY0pFGsOAWaeGZ
         +/PqQtxX3KS95TsRVL7qIAqlLfbRZZXOvs5fwTn1+PAGX0jDFxhw23AwbenchiaoSh
         D51B4BOKxywpNkKJ/xdKk/nsigFMXCIj81LCN5T9WavhjyG0r8ghImyEk1RuU+bwKO
         tP0eRq/sWEhTg==
Date:   Wed, 16 Mar 2022 14:43:22 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     James Morse <james.morse@arm.com>
Cc:     stable@vger.kernel.org, catalin.marinas@arm.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [stable:PATCH v5.4.184 00/22] arm64: Mitigate spectre style
 branch history side channels
Message-ID: <YjIvyndoPX88xSrX@sashalap>
References: <20220315182415.3900464-1-james.morse@arm.com>
 <YjIFE8Abn7XI+4yW@sashalap>
 <ef06416c-4636-24cb-01e7-11caab365ed6@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ef06416c-4636-24cb-01e7-11caab365ed6@arm.com>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 16, 2022 at 05:38:34PM +0000, James Morse wrote:
>Hi Sasha,
>
>On 3/16/22 3:41 PM, Sasha Levin wrote:
>>On Tue, Mar 15, 2022 at 06:23:53PM +0000, James Morse wrote:
>>>Hi Greg,
>>>
>>>Here is the state of the current v5.4 backport. Now that the 32bit
>>>code has been merged, it doesn't conflict when KVM's shared 32bit/64bit
>>>code needs to use these constants.
>>>
>>>I've fixed the two issues that were reported against the v5.10 backport.
>>>
>>>I had a go at bringing all the pre-requisites in to add proton-pack.c
>>>to v5.4. Its currently 39 patches:
>>>https://git.gitlab.arm.com/linux-arm/linux-jm.git /bhb/alternative_backport/UNTESTED/v5.4.183
>>>(or for web browsers:
>>>https://gitlab.arm.com/linux-arm/linux-jm/-/commits/bhb/alternative_backport/UNTESTED/v5.4.183/
>>>)
>>
>>I've queued it up.
>
>Just to clarify - you've queued this series that I posted, not the above 'UNTESTED' branch
>where I tried (unsuccessfully) to bring in the prerequisites.
>
>(The position of your comment made me jump!)

Yes, sorry, the series :)

-- 
Thanks,
Sasha
