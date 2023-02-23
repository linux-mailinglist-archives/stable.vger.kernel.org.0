Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1106A04FE
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 10:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjBWJgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 04:36:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233105AbjBWJgT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 04:36:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C358515EF
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 01:35:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75EF661629
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 09:35:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC835C433EF;
        Thu, 23 Feb 2023 09:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677144935;
        bh=PPW4ovevPOYy+ixLQRF8QjDSD29QNIbuuE0De3uCRRE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ThcmPSp3vyqNZfBMq1IvoCOirvCqkBZHmw05n6pyrgMx6wZNTTZKY/JFhn2G3iu+S
         AlpmLsVZAyONn4sLWNdMquftMBgvu7f5ZqZmZJIb+H/3dxZcaVqaNVBI7TiJ5V0VO1
         UPjeCrT8hqf4mb48iqEthdvgtfWstAPkh86XZBFM=
Date:   Thu, 23 Feb 2023 10:35:32 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        stable@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: static call fixes for clang's conditional tail calls (6.2 and
 6.1)
Message-ID: <Y/czZBVqsaG/P8iU@kroah.com>
References: <Y/Uf9WUi/rANmOk8@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/Uf9WUi/rANmOk8@dev-arch.thelio-3990X>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 21, 2023 at 12:48:05PM -0700, Nathan Chancellor wrote:
> Hi Greg and Sasha,
> 
> Please consider applying the following commits to 6.2 (they apply
> cleanly with some fuzz for me):
> 
> db7adcfd1cec ("x86/alternatives: Introduce int3_emulate_jcc()")
> ac0ee0a9560c ("x86/alternatives: Teach text_poke_bp() to patch Jcc.d32 instructions")
> 923510c88d2b ("x86/static_call: Add support for Jcc tail-calls")
> 
> I have attached backports to 6.1.
> 
> Without these changes, kernels built with any version of clang using -Os
> or clang 17.0.0 (tip of tree) at any kernel-supported optimization level
> do not boot. This has been tested by people affected by this problem,
> see https://github.com/ClangBuiltLinux/linux/issues/1774 for more info.
> 
> If there are any problems, please let me know.
> 
> Cheers,
> Nathan



All now queued up,t hanks.

greg k-h
