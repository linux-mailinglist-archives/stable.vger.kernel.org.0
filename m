Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E145860CCF3
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 15:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232643AbiJYNGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 09:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232742AbiJYNFk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 09:05:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C703DBEF98;
        Tue, 25 Oct 2022 06:05:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63DE96191A;
        Tue, 25 Oct 2022 13:05:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B5EC433D7;
        Tue, 25 Oct 2022 13:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666703124;
        bh=FDe6m6QlcLbWnaKlTQUhMFyatNbXwjKUoB6NPqJNUgc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pwJEv3+PD07K1lB6BjbPz9XuGZd2pbCJcMryfa0qMp3D1PUapMOVZW1f4z3NjSBai
         6PLFEFz6QVmR1AXsOj7m3RrZueyaOVXt2o4ilFtuJXSqZ+gD3frRP95SCGysn5/U98
         fO7xXwvO0AwJT+iPxfR7jVtQ3mZS1Xbwl0hmKndw=
Date:   Tue, 25 Oct 2022 15:05:22 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 301/390] ARM: decompressor: Include
 .data.rel.ro.local
Message-ID: <Y1ffEnoLjJ47M6zg@kroah.com>
References: <20221024113022.510008560@linuxfoundation.org>
 <20221024113035.833900007@linuxfoundation.org>
 <20221024184103.GA26813@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024184103.GA26813@duo.ucw.cz>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 24, 2022 at 08:41:03PM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Kees Cook <keescook@chromium.org>
> > 
> > [ Upstream commit 1b64daf413acd86c2c13f5443f6b4ef3690c8061 ]
> > 
> > The .data.rel.ro.local section has the same semantics as .data.rel.ro
> > here, so include it in the .rodata section of the decompressor.
> > Additionally since the .printk_index section isn't usable outside of
> > the core kernel, discard it in the decompressor. Avoids these warnings:
> > 
> > arm-linux-gnueabi-ld: warning: orphan section `.data.rel.ro.local' from `arch/arm/boot/compressed/fdt_rw.o' being placed in section `.data.rel.ro.local'
> > arm-linux-gnueabi-ld: warning: orphan section `.printk_index' from
> > `arch/arm/boot/compressed/fdt_rw.o' being placed in section
> > `.printk_index'
> 
> There's no printk_index in 5.10., so I'm not sure we should be
> applying it here.

Good point, now dropped.

greg k-h
