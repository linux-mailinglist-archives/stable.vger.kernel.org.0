Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02FFC5A965A
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 14:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbiIAMH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 08:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbiIAMH2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 08:07:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050C6BD4CC
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 05:07:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D2FE61E34
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 12:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D8AC433C1;
        Thu,  1 Sep 2022 12:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662034045;
        bh=3ixXHL8AA/tHayZZUX9CyzOBaXPCNj35YbsALTz3/C4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iwtkF90KK4YiAbH7iLea18fNz8oBAASHPQnf8yXMJXGIWhPwddLiM+Nt+SeKY+66b
         ke+CZApf8yBR84xNVcml4fmJD5ORZ1cBklJTv5kIFSGF5BE+uRx8YtCNdgv+5sxste
         E/5xftEp8Ngt12ZVGAFTleLz7I/GBbSY5KL0f6eE=
Date:   Thu, 1 Sep 2022 14:07:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Michael Bestas <mkbestas@gmail.com>
Cc:     hsinyi@chromium.org, rppt@linux.ibm.com, stable@vger.kernel.org,
        swboyd@chromium.org, will@kernel.org
Subject: Re: [PATCH] arm64: map FDT as RW for early_init_dt_scan()
Message-ID: <YxCge/xR2OqjZYbd@kroah.com>
References: <YxCCI2c6l8OdA4GV@kroah.com>
 <20220901105727.606047-1-mkbestas@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901105727.606047-1-mkbestas@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 01, 2022 at 01:57:27PM +0300, Michael Bestas wrote:
> On Thu, 1 Sep 2022 11:57:55 +0200
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > Both now queued up, thanks.
> >
> > greg k-h
> 
> Could you also queue the 4.9 patch or I need to send it again?
> https://lore.kernel.org/all/20220809145624.1819905-1-mkbestas@gmail.com/

Ah, thanks for pointing that out, it was long-gone from my queue.  Now
added.

greg k-h
