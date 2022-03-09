Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5DC4D3D10
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 23:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbiCIWgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 17:36:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232562AbiCIWgT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 17:36:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96B31216A8;
        Wed,  9 Mar 2022 14:35:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51D0BB8240E;
        Wed,  9 Mar 2022 22:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073C8C340E8;
        Wed,  9 Mar 2022 22:35:15 +0000 (UTC)
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Nathan Chancellor <nathan@kernel.org>,
        Will Deacon <will@kernel.org>
Cc:     linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] arm64: Do not include __READ_ONCE() block in assembly files
Date:   Wed,  9 Mar 2022 22:35:13 +0000
Message-Id: <164686530868.2021143.5226596562469342998.b4-ty@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220309191633.2307110-1-nathan@kernel.org>
References: <20220309191633.2307110-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 9 Mar 2022 12:16:34 -0700, Nathan Chancellor wrote:
> When building arm64 defconfig + CONFIG_LTO_CLANG_{FULL,THIN}=y after
> commit 558c303c9734 ("arm64: Mitigate spectre style branch history side
> channels"), the following error occurs:
> 
>   <instantiation>:4:2: error: invalid fixup for movz/movk instruction
>    mov w0, #ARM_SMCCC_ARCH_WORKAROUND_3
>    ^
> 
> [...]

Applied to arm64 (for-next/spectre-bhb), thanks!

[1/1] arm64: Do not include __READ_ONCE() block in assembly files
      https://git.kernel.org/arm64/c/52c9f93a9c48

-- 
Catalin

