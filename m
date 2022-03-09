Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A46204D3D30
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 23:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233488AbiCIWl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 17:41:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232287AbiCIWl3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 17:41:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB8C12220D;
        Wed,  9 Mar 2022 14:40:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB97E61C3A;
        Wed,  9 Mar 2022 22:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CFE6C340E8;
        Wed,  9 Mar 2022 22:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646865629;
        bh=qKJFJE0ylst9VCwNi3R9jMlbmYDqv0ekKnolKkzO0J8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iR6I9vK25qveU36llBpLd6G4GOfTeg0ZJyrtvmQ0/XnYuH88hrkSliPLtbNlYCkwC
         ZVca7aZWcix+AsJKYPZljLtfxjImoQbNs592naBXzz8F7N7lmsOzauWPH1nmk7exJ9
         g+YPsByx2uLoyNF0VaalW0D9H8U0S1tHzIn7YJTI=
Date:   Wed, 9 Mar 2022 23:40:24 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        llvm@lists.linux.dev, stable <stable@vger.kernel.org>
Subject: Re: [PATCH] ARM: Do not use NOCROSSREFS directive with ld.lld
Message-ID: <Yiks2B/4Ouetagmk@kroah.com>
References: <20220309220726.1525113-1-nathan@kernel.org>
 <CAHk-=wi23APrArHX7bcrvKBDZYpHXbeyEW7dRsirwoSPCKgqJg@mail.gmail.com>
 <YikqFxHP+Y+lecbX@kroah.com>
 <CAHk-=whAL3L9gTPp5y7-dweM1xrOA+7aCtG9BvbeQk6Gaz-1UA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whAL3L9gTPp5y7-dweM1xrOA+7aCtG9BvbeQk6Gaz-1UA@mail.gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 09, 2022 at 02:31:24PM -0800, Linus Torvalds wrote:
> On Wed, Mar 9, 2022 at 2:28 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > What about this one too:
> >         https://lore.kernel.org/r/20220309191633.2307110-1-nathan@kernel.org
> >
> > it should fix a arm64 build with clang.
> 
> Heh. That one just came as a pull from Catalin. It's now commit 52c9f93a9c48..

Great!
