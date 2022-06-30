Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC8D561914
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 13:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbiF3L0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 07:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232953AbiF3L0i (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 07:26:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D2D4507B
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 04:26:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C435B82A2D
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 11:26:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55D8C3411E;
        Thu, 30 Jun 2022 11:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656588395;
        bh=4LR3kERKhBJjCuTNAMyf6YQeWDoIch6xgumEFksPYH4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z7o4G9sdMZ6wAp6oh8xbjht/LrVMqik+CNAHNM4uIxPxS+dw7KHnWpplt0UqDWnjz
         o/uRMAMFfAGfY2VqwN3lZBeXB5NNibvKSGqDgIAyGZdtxp/Q9tZaokN4UDhCbMI53Z
         1HHgS5X+EcXZ2bUgYgOnaeZ9X+txal+4BgJ7JIZc=
Date:   Thu, 30 Jun 2022 13:26:32 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: Apply 1e70212e031528918066a631c9fdccda93a1ffaa to 5.18
Message-ID: <Yr2IaHyNrpwnkTgo@kroah.com>
References: <Yrnvm6mwtaiKu6Rj@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yrnvm6mwtaiKu6Rj@dev-arch.thelio-3990X>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 27, 2022 at 10:57:47AM -0700, Nathan Chancellor wrote:
> Hi Greg and Sasha,
> 
> Please apply commit 1e70212e0315 ("hinic: Replace memcpy() with direct
> assignment") to 5.18. It fixes a warning visible when building arm64 and
> x86_64 allmodconfig with clang 14 and newer (and possibly other
> architectures but I didn't check). This will allow CONFIG_WERROR to
> remain enabled when building arm64 and x86_64 kernels with clang on 5.15
> and 5.18 (other architectures and newer versions are getting there).
> 
> This change shouldn't be problematic in older kernels but the warning it
> fixes won't be visible without the new FORTIFY_SOURCE changes that
> landed in 5.18, so I wouldn't worry about backporting it further.

Now queued up, thanks.

greg k-h
