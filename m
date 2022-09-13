Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7EB85B6867
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 09:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbiIMHMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 03:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiIMHMR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 03:12:17 -0400
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB58E20F76
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 00:12:14 -0700 (PDT)
Received: from [89.101.222.236] (helo=phil.localnet)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1oY05E-0003Bu-4I; Tue, 13 Sep 2022 09:11:48 +0200
From:   Heiko Stuebner <heiko@sntech.de>
To:     atishp@atishpatra.org, Conor Dooley <mail@conchuod.ie>
Cc:     ajones@ventanamicro.com, anup@brainfault.org,
        conor.dooley@microchip.com, jrtc27@jrtc27.com,
        linux-riscv@lists.infradead.org, lkp@intel.com,
        mchitale@ventanamicro.com, nathan@kernel.org, palmer@rivosinc.com,
        stable@vger.kernel.org, Atish Patra <atishp@rivosinc.com>
Subject: Re: [PATCH v4] RISC-V: Clean up the Zicbom block size probing
Date:   Tue, 13 Sep 2022 09:11:45 +0200
Message-ID: <8114822.T7Z3S40VBb@phil>
In-Reply-To: <20220912224800.998121-1-mail@conchuod.ie>
References: <20220912224800.998121-1-mail@conchuod.ie>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Dienstag, 13. September 2022, 00:48:01 CEST schrieb Conor Dooley:
> From: Palmer Dabbelt <palmer@rivosinc.com>
> 
> This fixes two issues: I truncated the warning's hart ID when porting to
> the 64-bit hart ID code, and the original code's warning handling could
> fire on an uninitialized hart ID.
> 
> The biggest change here is that riscv_cbom_block_size is no longer
> initialized, as IMO the default isn't sane: there's nothing in the ISA
> that mandates any specific cache block size, so falling back to one will
> just silently produce the wrong answer on some systems.  This also
> changes the probing order so the cache block size is known before
> enabling Zicbom support.
> 
> CC: stable@vger.kernel.org
> CC: Andrew Jones <ajones@ventanamicro.com>
> CC: Heiko Stuebner <heiko@sntech.de>
> CC: Atish Patra <atishp@rivosinc.com>
> Fixes: 3aefb2ee5bdd ("riscv: implement Zicbom-based CMO instructions + the t-head variant")
> Fixes: 1631ba1259d6 ("riscv: Add support for non-coherent devices using zicbom extension")
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Conor Dooley <conor.dooley@microchip.com>
> Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
> [Conor: fixed the redefinition errors]
> Tested-by: Conor Dooley <conor.dooley@microchip.com>
> Signed-off-by: Conor Dooley <conor.dooley@microchip.com>

Reviewed-by: Heiko Stuebner <heiko@sntech.de>



