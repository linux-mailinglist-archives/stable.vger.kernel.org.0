Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD78F53857E
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 17:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235771AbiE3PxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 11:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242819AbiE3Pwi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 11:52:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2948BDA00;
        Mon, 30 May 2022 08:25:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EB1061050;
        Mon, 30 May 2022 15:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5206FC385B8;
        Mon, 30 May 2022 15:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653924344;
        bh=O+hU68gl2+Hq+XBPyYhDfKRG6FwWm8EiSR/+SfKEaiI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k2BFQTagxI7oHvtdvDPWS1q2+w9+U3WBjiKfvXNjrxAVTYvu1vTt7iJIyJRC9/qb/
         pQLRtVtFYGHuyS4RnGsNhMkvmS5NQ46uLg+b6V1tzra0EgClMbmEfkeBIvyyRncyDh
         MAkS4X0QI3B71VlgplPvNOr69iOxc0LSyQe44kh0=
Date:   Mon, 30 May 2022 17:25:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Keith Packard <keithpac@amazon.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH AUTOSEL 5.18 147/159] ARM: 9201/1: spectre-bhb: rely on
 linker to emit cross-section literal loads
Message-ID: <YpTh9dan5lJgH2aL@kroah.com>
References: <20220530132425.1929512-1-sashal@kernel.org>
 <20220530132425.1929512-147-sashal@kernel.org>
 <CAMj1kXGAuKTqV0S4jxticZJp7ChtqqeXjn7SV1E83p5yVE1pkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXGAuKTqV0S4jxticZJp7ChtqqeXjn7SV1E83p5yVE1pkw@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 30, 2022 at 03:32:47PM +0200, Ard Biesheuvel wrote:
> AUTONAK
> 
> As discussed before, please disregard all patches authored by me when
> running the bot.

Ok, but why wasn't this spectre-bhb commit asked to be backported to
stable in the first place?  Do older kernels not need these types of
fixes?

thanks,

greg k-h
