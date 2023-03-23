Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05A746C720C
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 22:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjCWVAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 17:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbjCWVA2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 17:00:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3ABDE38C;
        Thu, 23 Mar 2023 14:00:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70FF4B82271;
        Thu, 23 Mar 2023 21:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 09242C4339B;
        Thu, 23 Mar 2023 21:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679605221;
        bh=qz9uUNeJqZdiJlk66x6Wzj9ssG31ZuZs/3b6NtQinPE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VQDGvG0nMfeA/pF4tJWDj0mxY0iow9oifsGHClP9HZgYgROWBf1LBJ1mkJQvjYMwm
         sZyDqUoQReYbPP81QT/S5AjcBasEEXxUV43ftrRrMcYsGUQKJ2qphI80iHmc0F1TG1
         JvCy/2e4rS4FUPpT2QD+f71ixU+K0K5c7JA0ghzuahIMDH0j2qKpOSlTDr3wQH8cdO
         aliTjnwoIAZ8ZmqexUo4kP4OBq5cIuhgjE2TXjgKZc4rt03mMWAWihQqNTNFAVDf1h
         fV4wz9gNsJvnfDHtPS8p92eKBvNREv/nNbZ9QzWkqkBM7SlvjzaWkErMZEtcxTnQZ7
         tQMvaHAFoKb8A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DD26BE61B87;
        Thu, 23 Mar 2023 21:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] riscv: Handle zicsr/zifencei issues between clang and
 binutils
From:   patchwork-bot+linux-riscv@kernel.org
Message-Id: <167960522090.10481.16047974592958596683.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Mar 2023 21:00:20 +0000
References: <20230313-riscv-zicsr-zifencei-fiasco-v1-1-dd1b7840a551@kernel.org>
In-Reply-To: <20230313-riscv-zicsr-zifencei-fiasco-v1-1-dd1b7840a551@kernel.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     linux-riscv@lists.infradead.org, paul.walmsley@sifive.com,
        palmer@dabbelt.com, aou@eecs.berkeley.edu,
        conor.dooley@microchip.com, ndesaulniers@google.com,
        trix@redhat.com, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev,
        stable@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello:

This patch was applied to riscv/linux.git (fixes)
by Palmer Dabbelt <palmer@rivosinc.com>:

On Mon, 13 Mar 2023 16:00:23 -0700 you wrote:
> There are two related issues that appear in certain combinations with
> clang and GNU binutils.
> 
> The first occurs when a version of clang that supports zicsr or zifencei
> via '-march=' [1] (i.e, >= 17.x) is used in combination with a version
> of GNU binutils that do not recognize zicsr and zifencei in the
> '-march=' value (i.e., < 2.36):
> 
> [...]

Here is the summary with links:
  - riscv: Handle zicsr/zifencei issues between clang and binutils
    https://git.kernel.org/riscv/c/e89c2e815e76

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


