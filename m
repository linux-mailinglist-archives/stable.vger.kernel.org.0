Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D4D59AEAF
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 16:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346367AbiHTOdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 10:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346217AbiHTOdm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 10:33:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F321014D08;
        Sat, 20 Aug 2022 07:33:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FC8BB80CAD;
        Sat, 20 Aug 2022 14:33:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E952AC433D6;
        Sat, 20 Aug 2022 14:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661006018;
        bh=/7B/Xs/HCL3KwHGK4v8gKrA+qwU9VsmeusLYvJqdSBs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pYA1RNwP46Oqkl4EvxCL/VVLLVJ6SXm1Xo9I897g3uyZ+Y2f7a86kcbLRMsYOMlDo
         1fM9SkM7uvbsSbbCormVLazdZfOfxVnbD3k417++h3CdEbt4h0ptK066T0VFtGQrt7
         WnzmwPJRzL21+MmBBGNmSApBBiMoMQ1gvJHHjrTU6tQt6jBHhXrvm8F17SUddtPDjH
         4dBzSYMPrvy/kSHPjgmOSSaV9TJPwFWzp014kIZG4mkU1ZH8bEoz1qkcvzG5Emo6gE
         XYC62n8OH6f14eywKUEkQWkWh49qSM5ojIJG5K/Cr6aGxcEYQBSGrRAC2fl7QeksFM
         VUcMtQB3UpaCQ==
Date:   Sat, 20 Aug 2022 10:33:36 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Conor.Dooley@microchip.com
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        gregkh@linuxfoundation.org, Brice.Goglin@inria.fr,
        sudeep.holla@arm.com, Daire.McNamara@microchip.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, linux-riscv@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.19 08/48] riscv: dts: microchip: Add mpfs'
 topology information
Message-ID: <YwDwwEXgGundXB1X@sashalap>
References: <20220814161943.2394452-1-sashal@kernel.org>
 <20220814161943.2394452-8-sashal@kernel.org>
 <eeee7a72-8200-a374-8038-405605e0c290@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <eeee7a72-8200-a374-8038-405605e0c290@microchip.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 14, 2022 at 04:31:08PM +0000, Conor.Dooley@microchip.com wrote:
>On 14/08/2022 17:19, Sasha Levin wrote:
>> From: Conor Dooley <conor.dooley@microchip.com>
>>
>> [ Upstream commit 88d319c6abaeb37f0e2323275eaf57a8388e0265 ]
>>
>> The mpfs has no cpu-map node, so tools like hwloc cannot correctly
>> parse the topology. Add the node using the existing node labels.
>>
>+CC Greg
>
>Hey Sasha,
>Technically this is an optional property so I didn't mark any of
>the patches as CC: stable as they not really fixes. The plan to is
>to fix the hwloc problem at the source rather than papering over it
>with the dts:
>https://lore.kernel.org/linux-riscv/20220715175155.3567243-1-mail@conchuod.ie/
>
>Those patches are delayed until after -rc1 as they weren't reviewed
>from the riscv side prior to the arm64 tree closing, but the plan is
>to backport those instead.
>
>I suppose there's no harm having these too, but I'll leave that up
>to the better judgement of others... What do you (plural) think?

I'll just drop these. Feel free to send us a note when the fix is
ready...

-- 
Thanks,
Sasha
