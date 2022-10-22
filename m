Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2AB3608AA8
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 11:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbiJVJEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 05:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235030AbiJVJDU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 05:03:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829B02FA5C9;
        Sat, 22 Oct 2022 01:18:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 067F260ADC;
        Sat, 22 Oct 2022 08:15:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC49C43470;
        Sat, 22 Oct 2022 08:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666426520;
        bh=bVwuHeyD6NBbvbw/CTdPYwlqiQGkMoa5incPyO51BKQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MRFmoRbI59ENHf6UMBZKAQrxouJc4uJwAqmTb+8OXfd8EhjZWHMcIwGQ3ZBEaEIJV
         cIS+w0m8fbri1SdENSXiflOKcdrPBn7u6LGCJO5AGydXM8rcKJbypUU0ZuQQYVqVrt
         7ExI4dXjD5EhLbkC2D9J8IZDgrLmpfVX+BdgmEWg=
Date:   Sat, 22 Oct 2022 09:36:29 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Evgenii Stepanov <eugenis@google.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm64/mm: Consolidate TCR_EL1 fields
Message-ID: <Y1OdfXuLmp/gr1Z4@kroah.com>
References: <20221021222811.2366215-1-eugenis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021222811.2366215-1-eugenis@google.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 21, 2022 at 03:28:11PM -0700, Evgenii Stepanov wrote:
> From: Anshuman Khandual <anshuman.khandual@arm.com>
> 
> commit e921da6bc7cac5f0e8458fe5df18ae08eb538f54 upstream.
> 
> This renames and moves SYS_TCR_EL1_TCMA1 and SYS_TCR_EL1_TCMA0 definitions
> into pgtable-hwdef.h thus consolidating all TCR fields in a single header.
> This does not cause any functional change.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> Link: https://lore.kernel.org/r/1643121513-21854-1-git-send-email-anshuman.khandual@arm.com
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/include/asm/pgtable-hwdef.h | 2 ++
>  arch/arm64/include/asm/sysreg.h        | 4 ----
>  arch/arm64/mm/proc.S                   | 2 +-
>  3 files changed, 3 insertions(+), 5 deletions(-)

What stable kernel branch(es) do you want this applied to?

thanks,

greg k-h
