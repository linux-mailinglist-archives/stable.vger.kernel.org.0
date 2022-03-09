Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84E124D3CEC
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 23:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237519AbiCIW3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 17:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237226AbiCIW3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 17:29:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B55A2119848;
        Wed,  9 Mar 2022 14:28:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51C4A61B83;
        Wed,  9 Mar 2022 22:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 217F9C340E8;
        Wed,  9 Mar 2022 22:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646864925;
        bh=53qItwjn/BOmlYHVisMW1+2o9gev8Fumk6b56V5DF4s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IHRpf7i80XWydJ7OMX3De3fLyunRWD7QtdlZ6l02HGYZrNTOnP4QZIqRwHM49ALsE
         OWJzWlKOaGmo1H2LAqUxjZlSh5FMvqHpPYIaL1WEGCat/6g32JdGUIcwQk05Gjck7p
         fogirSCWlWD+hpKX+jV9ZPAzTuRSychthC1+rL4w=
Date:   Wed, 9 Mar 2022 23:28:39 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        llvm@lists.linux.dev, stable <stable@vger.kernel.org>
Subject: Re: [PATCH] ARM: Do not use NOCROSSREFS directive with ld.lld
Message-ID: <YikqFxHP+Y+lecbX@kroah.com>
References: <20220309220726.1525113-1-nathan@kernel.org>
 <CAHk-=wi23APrArHX7bcrvKBDZYpHXbeyEW7dRsirwoSPCKgqJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wi23APrArHX7bcrvKBDZYpHXbeyEW7dRsirwoSPCKgqJg@mail.gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 09, 2022 at 02:15:23PM -0800, Linus Torvalds wrote:
> On Wed, Mar 9, 2022 at 2:11 PM Nathan Chancellor <nathan@kernel.org> wrote:
> >
> > It would be nice if this could be applied directly to unblock our CI if
> > there are no objections.
> 
> Applied.
> 
> Greg - yet another small fixup. It's commit 36168e387fa7 in my tree.

Thanks will go queue that up now.

What about this one too:
	https://lore.kernel.org/r/20220309191633.2307110-1-nathan@kernel.org

it should fix a arm64 build with clang.

thanks,

greg k-h
