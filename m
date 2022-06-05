Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A317153DBB5
	for <lists+stable@lfdr.de>; Sun,  5 Jun 2022 15:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236175AbiFENjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jun 2022 09:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbiFENiz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jun 2022 09:38:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6882253A;
        Sun,  5 Jun 2022 06:38:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42EB360F03;
        Sun,  5 Jun 2022 13:38:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F2DC385A5;
        Sun,  5 Jun 2022 13:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654436333;
        bh=dOP6WV1PB9DEnflGLpFvz3Gzod/6sFdv+px60DLgVAI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=enVB8Km+mpNKPw/Mwc5T24lYHhyFNt5bs3qJ48k4qohnBsljE9SMLu2p79GhLimY+
         fZyMWW0EMWajMtLEhx1liakrVolTPuzlp8rhOTo8WhnzXTkkitzcU+u7pb7mhgilhS
         CP4S/rizEeGhz4fD/R9HGBmDamuKw24p3kvpgbGMrPFQAh7P3xW/plNoPnJLouBWYQ
         M7mG9gs6jzfdOFAV6j9yDBRPUB7Ff6TTC8bBeh8qQy0yGC6ZGDCWZvjQtW/goOH60G
         fMALaCrIaLTt11ZnkHSS4JFIcOv4+7Oyc2u7gipYUCRWgpVQXXul2sMo4HUESO5gIW
         EXN2YCd1YiuMg==
Date:   Sun, 5 Jun 2022 09:38:52 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Joey Gouly <joey.gouly@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>, will@kernel.org,
        broonie@kernel.org, alexandru.elisei@arm.com, mark.rutland@arm.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.18 15/49] arm64: Expand ESR_ELx_WFx_ISS_TI to
 match its ARMv8.7 definition
Message-ID: <Ypyx7Flp1BhA8plw@sashalap>
References: <20220601135214.2002647-1-sashal@kernel.org>
 <20220601135214.2002647-15-sashal@kernel.org>
 <877d605rrw.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <877d605rrw.wl-maz@kernel.org>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 01, 2022 at 04:26:27PM +0100, Marc Zyngier wrote:
>On Wed, 01 Jun 2022 14:51:39 +0100,
>Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Marc Zyngier <maz@kernel.org>
>>
>> [ Upstream commit 6a437208cb942a2dd98f7e1c3fd347ed3d425ffc ]
>>
>> Starting with FEAT_WFXT in ARMv8.7, the TI field in the ISS
>> that is reported on a WFx trap is expanded by one bit to
>> allow the description of WFET and WFIT.
>>
>> Special care is taken to exclude the WFxT bit from the mask
>> used to match WFI so that it also matches WFIT when trapped from
>> EL0.
>>
>> Reviewed-by: Joey Gouly <joey.gouly@arm.com>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
>> Link: https://lore.kernel.org/r/20220419182755.601427-2-maz@kernel.org
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Please do not backport this patch. It achieves nothing on its own, and
>the kernel isn't broken without it.

I'll drop this and the other ones you've pointed out.

>Also, please do not AUTOSEL KVM/arm64 patches that are not tagged with
>a Cc stable.

Happily!

-- 
Thanks,
Sasha
