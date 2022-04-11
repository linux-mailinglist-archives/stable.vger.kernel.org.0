Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD974FC040
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 17:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235361AbiDKPWC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 11:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347330AbiDKPWA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 11:22:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2BAD65BE
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 08:19:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66EA561578
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 15:19:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73396C385A4;
        Mon, 11 Apr 2022 15:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649690385;
        bh=hi9eum3OD1hBLstUFbV7sMEQ92y+ycNsvwEEwzUsSdE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l2BMESHQZoA0ERaHImdN72fU9rJPvWh1VRmM8PGLMYfv8p6hBuGQZCubUHTbQc6bI
         FvIR66c97dkwQ+CbEZd1s5i3L4rlXYsX5n6kdtcdo/C2SQsDzCh6qni/fe8ru5ba4Y
         7rJ+wpYRUGwe0hklkPC3E//B10MAMyNAghzN3a50=
Date:   Mon, 11 Apr 2022 17:19:43 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        llvm@lists.linux.dev, Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: Backport of 4013e26670c5 and 60210a3d86dc for 4.9 to 5.10
Message-ID: <YlRHDw1uW4vR9s8y@kroah.com>
References: <Ykytcg+xI/MRSLue@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ykytcg+xI/MRSLue@dev-arch.thelio-3990X>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 05, 2022 at 01:58:26PM -0700, Nathan Chancellor wrote:
> Hi Greg and Sasha,
> 
> Please find attached backports for commits 4013e26670c5 ("arm64: module:
> remove (NOLOAD) from linker script") and 60210a3d86dc ("riscv module:
> remove (NOLOAD)") to 4.9 through 5.10, where applicable. They resolve a
> spew of warnings when linking modules with ld.lld. 4013e26670c5 is
> currently queued from 5.15 to 5.17 and 60210a3d86dc is queued for 5.10
> through 5.17, as that is where they applied cleanly.

If only everyone sent in patches in this style, it would make our lives
so much easier!

thanks for these, all now queued up.

greg k-h
