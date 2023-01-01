Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5052065A95C
	for <lists+stable@lfdr.de>; Sun,  1 Jan 2023 09:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjAAIrk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Jan 2023 03:47:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjAAIrj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Jan 2023 03:47:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4D25FAB
        for <stable@vger.kernel.org>; Sun,  1 Jan 2023 00:47:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 524AFB80979
        for <stable@vger.kernel.org>; Sun,  1 Jan 2023 08:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56EA2C433D2;
        Sun,  1 Jan 2023 08:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672562854;
        bh=HKpsKhy/dCpiJQYRQrwMbTczZ40RIfjYhMPyFKoAzgE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L+2s807nJqxOpk0Gp29URM6WThhGsfsXsbM/0D3gLg/sMreb76kN93WkX4QS8Srwj
         05zlDr+zmEPEmGTzGPzOL2ArjfOQcNTJMkXFiw+2wZNuPnyvTyThooIS8KBLhMd5MH
         v7ZM4Q/g1CE4hGUzUgzW4iDo78+Wv8cBfoa4hL70=
Date:   Sun, 1 Jan 2023 09:47:31 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?utf-8?Q?=C5=81ukasz_Kalam=C5=82acki?= <lukasz@pm.kalamlacki.eu>
Cc:     Willy Tarreau <w@1wt.eu>, stable@vger.kernel.org
Subject: Re: Cannot compile 6.1.2 kernel release
Message-ID: <Y7FIo0Eup6TKswTA@kroah.com>
References: <b0ef1e48-ca8d-9a5e-6e21-688711dab650@pm.kalamlacki.eu>
 <20230101065337.GA20539@1wt.eu>
 <d3f0d0a5-a15f-9735-5f12-b1c00a474531@pm.kalamlacki.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d3f0d0a5-a15f-9735-5f12-b1c00a474531@pm.kalamlacki.eu>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 01, 2023 at 08:14:12AM +0000, Łukasz Kalamłacki wrote:
> 
> On 1.01.2023 07:53, Willy Tarreau wrote:
> > On Sat, Dec 31, 2022 at 04:58:51PM +0000, Lukasz Kalamlacki wrote:
> >> Hey,
> >>
> >>
> >> Do you have an issue compiling 6.1.2 linux kernel?
> >>
> >> I cannot compile it.
> > For me it compiles and boots. You'll need to share your config and error
> > report if you want to get some help.
> >
> > Willy
> 
> I was trying to compile on Debian Bullseye where default gcc is version
> 10, when I upgraded gcc to version 12 from sid repo i Was able to
> compile too. On stable Debian without addition during compile
> "segmentation fault" occurs at the compilation of cx8-i2c.c file. You
> can try on kvm or virtualbox this compilation.

Sounds like a gcc bug you should be notifying the gcc developers about.

good luck!

greg k-h
