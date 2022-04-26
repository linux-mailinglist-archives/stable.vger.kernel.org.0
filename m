Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73ABE50F1D5
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 09:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiDZHNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 03:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343638AbiDZHNE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 03:13:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D95E37BC7
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 00:09:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5509C61588
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 07:09:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35348C385A4;
        Tue, 26 Apr 2022 07:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650956996;
        bh=GBhttIEFhrTK+Q3myBAaVRF933WhtGcFusfspbHjc0g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WpWzgC84Ysf1cvMJKgQM421Js943qUtR+pujtGePEXGQcGNvBeDbt5yifdXnJ2Avy
         esLhLm7BywQMBflVGD5a5oWjUpzq8huTXY6ffDtXI9Y1lNgM43uoiq0v6c2m7YqJVo
         tux94EiqEBApk6t7mYrG/iCH5nfetE+RSniGgAHo=
Date:   Tue, 26 Apr 2022 09:09:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marek Vasut <marex@denx.de>
Cc:     stable@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH] Revert "net: micrel: fix KS8851_MLL Kconfig"
Message-ID: <Ymeawd480IRlLFRT@kroah.com>
References: <20220425214859.256650-1-marex@denx.de>
 <YmeTKshiEUDB2hN0@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmeTKshiEUDB2hN0@kroah.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 26, 2022 at 08:37:30AM +0200, Greg KH wrote:
> On Mon, Apr 25, 2022 at 11:48:59PM +0200, Marek Vasut wrote:
> > This reverts commit 1ff5359afa5ec0dd09fe76183dc4fa24b50e4125.
> > 
> > The upstream commit c3efcedd272a ("net: micrel: fix KS8851_MLL Kconfig")
> > depends on e5f31552674e ("ethernet: fix PTP_1588_CLOCK dependencies")
> > which is not part of Linux 5.10.y . Revert the aforementioned commit to
> > prevent breakage in 5.10.y .
> 
> As the original change went into 4.9.311, 4.14.276, 4.19.239, and
> 5.4.190, is this change also needed in those branches?

The answer to that seems yes, so I'll go queue this up everywhere.

thanks,

greg k-h
