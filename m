Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1BB053DB7D
	for <lists+stable@lfdr.de>; Sun,  5 Jun 2022 15:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243790AbiFENNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jun 2022 09:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233071AbiFENNo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jun 2022 09:13:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9663E30554;
        Sun,  5 Jun 2022 06:13:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8031EB80D6C;
        Sun,  5 Jun 2022 13:13:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19BDFC385A5;
        Sun,  5 Jun 2022 13:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654434819;
        bh=3gGqiMBbXGxl3q4yQTV4NpmAtxp/iBlB95Ney2h/cMA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fvU75XAA2vEmCMdWAnT6Sh0TXPgodeguA501Rc2xGvDE+asBuIa75JtWMnA1MgbJm
         c/nw58DHlxd/cE1pq6lJHImsgpcG4uZ/EDzbM8j9lnpOL631AIREfUs1LORtyRu7L4
         jiXBjxRIna3go0Oqugujalv0t4rKYd9/PHL/ooHSDkxL434khZJXJfFb54oRNZBiE9
         FGOYBIzIMYqyRzpETrgNufosY6PbQ27ZNp5FACC8lM4llTBUFV3CBNKQXfGuJapcyx
         P+ZSVRKHLG7mzbyGpBOxZ7O/UxsXsZdjz7GyhvgCJ4FnnFBdHS2Zu6lkcDiAmFEIsp
         nfjbLPbHLZAEg==
Date:   Sun, 5 Jun 2022 09:13:37 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Catalin Marinas <catalin.marinas@arm.com>, will@kernel.org,
        maz@kernel.org, mark.rutland@arm.com, vladimir.murzin@arm.com,
        joey.gouly@arm.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.18 063/159] arm64/sme: Add ID_AA64SMFR0_EL1 to
 __read_sysreg_by_encoding()
Message-ID: <YpysAawJlYpkIurm@sashalap>
References: <20220530132425.1929512-1-sashal@kernel.org>
 <20220530132425.1929512-63-sashal@kernel.org>
 <YpTR7/g7R73RCJBj@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YpTR7/g7R73RCJBj@sirena.org.uk>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 30, 2022 at 04:17:19PM +0200, Mark Brown wrote:
>On Mon, May 30, 2022 at 09:22:48AM -0400, Sasha Levin wrote:
>> From: Mark Brown <broonie@kernel.org>
>>
>> [ Upstream commit 8a58bcd00e2e8d46afce468adc09fcd7968f514c ]
>>
>> We need to explicitly enumerate all the ID registers which we rely on
>> for CPU capabilities in __read_sysreg_by_encoding(), ID_AA64SMFR0_EL1 was
>> missed from this list so we trip a BUG() in paths which rely on that
>> function such as CPU hotplug. Add the register.
>
>> +	read_sysreg_case(SYS_ID_AA64SMFR0_EL1);
>
>This won't build on v5.18 since it does not contain SME support
>and therefore lacks the definition for the SME feature register.

Dropped, thanks!

-- 
Thanks,
Sasha
