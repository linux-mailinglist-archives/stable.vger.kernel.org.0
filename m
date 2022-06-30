Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED9B561B4E
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 15:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234701AbiF3N3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234793AbiF3N3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:29:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE9C340F0;
        Thu, 30 Jun 2022 06:29:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6637B82AC8;
        Thu, 30 Jun 2022 13:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E820DC34115;
        Thu, 30 Jun 2022 13:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656595781;
        bh=KCrRHfeUIe7MZHkiyxpR0lqhs4cXEpAMVLMgYUHAIPw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aq8HZROPgd+KjNLt+UwrqG3NATB9mfD3hiMxLEsOhjtXVvigeIHldTp8ABPOxSSTB
         gYqYjxnfZaxgWLpjwvQJveEtiUSaU8hmei5hjLquladnpQ11liLgM7BtwRvoav2j0H
         MAFa2FlNc7iBfFy35tqu2aHLrlf8j9b0hsOtx0Y4=
Date:   Thu, 30 Jun 2022 15:29:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     stable@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Tony Lindgren <tony@atomide.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Stefan Agner <stefan@agner.ch>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Andre Przywara <andre.przywara@arm.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jian Cai <caij2003@gmail.com>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        "open list:OMAP2+ SUPPORT" <linux-omap@vger.kernel.org>,
        "open list:CLANG/LLVM BUILD SUPPORT" 
        <clang-built-linux@googlegroups.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH stable 5.4 00/11] ARM 32-bit build with Clang IAS
Message-ID: <Yr2lNs0tnFyHmm9d@kroah.com>
References: <20220629180227.3408104-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629180227.3408104-1-f.fainelli@gmail.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 29, 2022 at 11:02:16AM -0700, Florian Fainelli wrote:
> Hi,
> 
> This patch series is a collection of clean cherry picks into the 5.4
> kernel allowing us to use the Clang integrated assembler to build the
> ARM 32-bit kernel.
> 
> This is useful in order to have proper build and runtime coverage of the
> stable kernel(s).

Odd, but ok, if this helps you out.  Now queued up.

greg k-h
