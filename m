Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 990575FE004
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbiJMSCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbiJMSC0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:02:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34391E09F3;
        Thu, 13 Oct 2022 11:02:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB58AB8204F;
        Thu, 13 Oct 2022 17:58:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729ADC433D7;
        Thu, 13 Oct 2022 17:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665683911;
        bh=gykBv/voDOLMOmDi5TXZDsNMZpz9IcOKM8hem8HE/MY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q2ipYTHM/k3OfNAL4J7NWE26Vp29G7I69XXySU+uqE51XLQTUDYSeERtUNnN6uv+j
         hICsC7VpdWUZ5ucxI92rqkM2KJjcqNt5Hnht2RtNwO2xRKhXiz9byk9qPH1lJ9VOQV
         FVdoRyvHn/59oSm4/Xcdhn7jtoy2gLf4OBCG055FBjqgOfqWqrrEmkWKd3sdgfKke9
         DJJSE1Pyd4HX+Gk/SPQBBRPd3OgmNYMl7rExCkrbofTFiXlRNT/ZoYUSo9nZuIINhp
         S+n8FUnb1mi8rSpeBqP5NLb6TDghw5hjOW6C1aofnFFyFPEMsER4sPYC3Xt351zqng
         wYgOy2nA38lAQ==
Date:   Thu, 13 Oct 2022 13:58:30 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>, will@kernel.org,
        shuah@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 15/46] kselftest/arm64: Allow larger buffers
 in get_signal_context()
Message-ID: <Y0hRxpVqigP4amOD@sashalap>
References: <20221011145015.1622882-1-sashal@kernel.org>
 <20221011145015.1622882-15-sashal@kernel.org>
 <Y0WGCuHDriRctkeL@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y0WGCuHDriRctkeL@sirena.org.uk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 11, 2022 at 04:04:42PM +0100, Mark Brown wrote:
>On Tue, Oct 11, 2022 at 10:49:43AM -0400, Sasha Levin wrote:
>> From: Mark Brown <broonie@kernel.org>
>>
>> [ Upstream commit 38150a6204c731a4846786682e500d132571fd82 ]
>>
>> In order to allow testing of signal contexts that overflow the base signal
>> frame allow callers to pass the buffer size for the user context into
>> get_signal_context(). No functional change.
>
>This doesn't obviously make sense independently, even by the relaxed
>standards stable uses these days?

I can drop this one, or, are there maybe additional patches we do want
to take?

-- 
Thanks,
Sasha
