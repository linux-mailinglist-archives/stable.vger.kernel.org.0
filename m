Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47DB54BCE18
	for <lists+stable@lfdr.de>; Sun, 20 Feb 2022 12:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiBTLFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Feb 2022 06:05:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiBTLFi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Feb 2022 06:05:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A5F43AC5;
        Sun, 20 Feb 2022 03:05:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4B686114C;
        Sun, 20 Feb 2022 11:05:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D878C340E8;
        Sun, 20 Feb 2022 11:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645355117;
        bh=x9J+ZOe2edxPaBXq7MDasjcZNR3NhXOu1vA+wgVP93U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NYE1ADu8MGRD9Rpyc9dccMIA2QJqdOKiJc0511rAQeBxW0NhWeRdD+UJIWhwhpYeJ
         57XcLgYRkxJyCDjeyycJzYl2gpY/gFDpZ23yhfgfIQb71r4Fd+lcyiSsE5DTsWNRuS
         rZz0DR5zJ8dkdX0sCox4UejhTFVSCW+yrPmt/JvvJ7iZBEBiLkcBOmNG7YwPhfhK7V
         rnxmSJz5wxje8fUq36yRLVjUPb10XAqTaFW0wmOrTRnKcyIFYqGRA2K7pbZpbwqAB/
         pT0fEbFabrQM5GigdLgeSGP+aIjZINCogcliCt4G73ajobWvCqC7PeXaM7CXdUpJcw
         ZoqSWaVOucVQw==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nLk1i-0093l2-OP; Sun, 20 Feb 2022 11:05:14 +0000
MIME-Version: 1.0
Date:   Sun, 20 Feb 2022 11:05:14 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>,
        Anup Patel <anup@brainfault.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Samuel Holland <samuel@sholland.org>,
        Thomas Gleixner <tglx@linutronix.de>, paul.walmsley@sifive.com,
        aou@eecs.berkeley.edu, linux-riscv@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 4.19 03/11] irqchip/sifive-plic: Add missing
 thead,c900-plic match string
In-Reply-To: <20220220095431.GA5251@amd>
References: <20220215153104.581786-1-sashal@kernel.org>
 <20220215153104.581786-3-sashal@kernel.org> <20220220095431.GA5251@amd>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <d587e3c4e85b54e941be732aeff35125@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: pavel@ucw.cz, sashal@kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, guoren@linux.alibaba.com, anup@brainfault.org, palmer@dabbelt.com, samuel@sholland.org, tglx@linutronix.de, paul.walmsley@sifive.com, aou@eecs.berkeley.edu, linux-riscv@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-02-20 09:54, Pavel Machek wrote:
> Hi!
> 
>> [ Upstream commit 1d4df649cbb4b26d19bea38ecff4b65b10a1bbca ]
>> 
>> The thead,c900-plic has been used in opensbi to distinguish
>> PLIC [1]. Although PLICs have the same behaviors in Linux,
>> they are different hardware with some custom initializing in
>> firmware(opensbi).
>> 
>> Qute opensbi patch commit-msg by Samuel:
>> 
>>   The T-HEAD PLIC implementation requires setting a delegation bit
>>   to allow access from S-mode. Now that the T-HEAD PLIC has its own
>>   compatible string, set this bit automatically from the PLIC driver,
>>   instead of reaching into the PLIC's MMIO space from another driver.
>> 
>> [1]: 
>> https://github.com/riscv-software-src/opensbi/commit/78c2b19218bd62653b9fb31623a42ced45f38ea6
>> 
> 
> The "thead,c900-plic" string is added into single place in the
> kernel. This means that a) it will probably not do anything useful in
> -stable kernels and b) it is certainly missing documentation etc.
> 
> In mainline, string is documented in
> Documentation/devicetree/bindings/interrupt-controller/sifive,plic-1.0.0.yaml

(b) is certainly true. And to make the above comment useful, the missing
patch is 321a8be37e1a ("dt-bindings: update riscv plic compatible
string").

Regarding (a), the DT is provided by the firmware (as it should
be on any reasonable platform). As such, no need for this string to be
mentioned anywhere else but in the documentation.

Now, the real question is where there is any point in backporting
this to such an old kernel, as this HW is unlikely to ever run it.

         M.
-- 
Jazz is not dead. It just smells funny...
