Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E65B05F4457
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 15:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiJDNiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 09:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiJDNiw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 09:38:52 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E6B4DB67;
        Tue,  4 Oct 2022 06:38:51 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Mhf1R2JBdz4xH3;
        Wed,  5 Oct 2022 00:38:51 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
In-Reply-To: <828f6a64eeb51ce9abfa1d4e84c521a02fecebb8.1663606875.git.christophe.leroy@csgroup.eu>
References: <828f6a64eeb51ce9abfa1d4e84c521a02fecebb8.1663606875.git.christophe.leroy@csgroup.eu>
Subject: Re: [PATCH v2 01/19] powerpc/Kconfig: Fix non existing CONFIG_PPC_FSL_BOOKE
Message-Id: <166488992106.779920.10288779645906817787.b4-ty@ellerman.id.au>
Date:   Wed, 05 Oct 2022 00:25:21 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 19 Sep 2022 19:01:25 +0200, Christophe Leroy wrote:
> CONFIG_PPC_FSL_BOOKE doesn't exist. Should be CONFIG_FSL_BOOKE.
> 
> 

Applied to powerpc/next.

[01/19] powerpc/Kconfig: Fix non existing CONFIG_PPC_FSL_BOOKE
        https://git.kernel.org/powerpc/c/d1203f32d86987a3ccd7de9ba2448ba12d86d125
[02/19] powerpc/64e: Tie PPC_BOOK3E_64 to PPC_E500MC
        https://git.kernel.org/powerpc/c/0069f3d14e7a656ba9d7dbaac72659687fdbf43c
[03/19] powerpc/64e: Remove unnecessary #ifdef CONFIG_PPC_FSL_BOOK3E
        https://git.kernel.org/powerpc/c/b6100bedf1f9aea264757ac4a56eb1d8b04b9356
[04/19] powerpc/cputable: Remove __machine_check_early_realmode_p{7/8/9} prototypes
        https://git.kernel.org/powerpc/c/afd2288a4c7d3400a53cb29616742f4395a809a1
[05/19] powerpc/cputable: Move __cpu_setup() prototypes out of cputable.h
        https://git.kernel.org/powerpc/c/76b719881a26fec3b77652134f19cf1dfcc96318
[06/19] powerpc/cputable: Split cpu_specs[] out of cputable.h
        https://git.kernel.org/powerpc/c/e320a76db4b02e1160eb4bfb17d8d1bc57979955
[07/19] powerpc: Remove CONFIG_FSL_BOOKE
        https://git.kernel.org/powerpc/c/dfc3095cec27f402c183da920f4733785e4c873d
[08/19] powerpc/cputable: Split cpu_specs[] for mpc85xx and e500mc
        https://git.kernel.org/powerpc/c/d7216567c65cbed655f9bf87ef906f9246d6f698
[09/19] powerpc: Remove CONFIG_PPC_BOOK3E
        https://git.kernel.org/powerpc/c/e0d68273d7069537701bb91c51d90d1e12aacc33
[10/19] powerpc: Remove redundant selection of E500 and E500MC
        https://git.kernel.org/powerpc/c/1df399012b6ab0b24466a0675710a53e3feb000f
[11/19] powerpc: Change CONFIG_E500 to CONFIG_PPC_E500
        https://git.kernel.org/powerpc/c/688de017efaab8a7764ab2c05ce7128d0361023b
[12/19] Documentation: Rename PPC_FSL_BOOK3E to PPC_E500
        https://git.kernel.org/powerpc/c/404a5e72f4dfd80dda6a3e9edd18012f79287bff
[13/19] watchdog: booke_wdt: Replace PPC_FSL_BOOK3E by PPC_E500
        https://git.kernel.org/powerpc/c/ec65560ad84d9d2eb98cf864e3b530856cafd233
[14/19] powerpc: Remove CONFIG_PPC_FSL_BOOK3E
        https://git.kernel.org/powerpc/c/3e7318584dfec11992f3ac45658c4bc1210b3778
[15/19] powerpc: Remove CONFIG_PPC_BOOK3E_MMU
        https://git.kernel.org/powerpc/c/aa5f59df201dd350f7c291c845ac8b62c0d0edd5
[16/19] powerpc: Replace PPC_85xx || PPC_BOOKE_64 by PPC_E500
        https://git.kernel.org/powerpc/c/772fd56deca62628c638d1a9bd2d34cbd371bb81
[17/19] powerpc: Simplify redundant Kconfig tests
        https://git.kernel.org/powerpc/c/73d11498793f495d64230308afa50905f012f080
[18/19] powerpc: Cleanup idle for e500
        https://git.kernel.org/powerpc/c/6556fd1a1e9fcd180348c4368d2387bdc6a17613
[19/19] powerpc: Remove impossible mmu_psize_defs[] on nohash
        https://git.kernel.org/powerpc/c/605ba9ee8aaabc77178b369ec6f773616089020d

cheers
