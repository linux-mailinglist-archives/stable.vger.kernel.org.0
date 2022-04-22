Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95D5450B961
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 16:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389277AbiDVOEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 10:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344513AbiDVOEd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 10:04:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08BF55A09E
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 07:01:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9898F617D8
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 14:01:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 745B6C385A0;
        Fri, 22 Apr 2022 14:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650636099;
        bh=cVpThg/iNSFD53+S0nzilndRzf3Dve2fJ7EO3oPQtrI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oBq+Onn9yqRxPsYLgQw62SUHfR5IwMLycfpsKMR+BvoIt4b/HsnmZEue4XE25+zB6
         Eien10KOGxRxuQ71OD5feuxYKyUOwlUMa5RE+z5LH7pIMC6fICo9iqUvY/PXSI46Mf
         tBQoKnK3GMuAAZXe/Z6snysMd5DqNBwZxgcsouio=
Date:   Fri, 22 Apr 2022 16:01:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marek Vasut <marex@denx.de>
Cc:     linux-stable <stable@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: net: micrel: fix KS8851_MLL Kconfig -- missing dependency in
 5.10.112
Message-ID: <YmK1QBMkfXkNG09F@kroah.com>
References: <7f3dedb3-7d5d-dcf3-8d7f-631251173d33@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f3dedb3-7d5d-dcf3-8d7f-631251173d33@denx.de>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 22, 2022 at 12:20:31PM +0200, Marek Vasut wrote:
> Since linux-stable 5.10.112 commit:
> 
> 1ff5359afa5e ("net: micrel: fix KS8851_MLL Kconfig")
> 
> it is not possible to select KS8851_MLL symbol.
> 
> This is because the commit adds dependency on Kconfig symbol
> 
> PTP_1588_CLOCK_OPTIONAL
> 
> which was added in Linux upstream commit:
> 
> e5f31552674e ("ethernet: fix PTP_1588_CLOCK dependencies")
> 
> And the aforementioned commit is not part of stable 5.10.112.

Can you send a commit to revert this?

thanks,

greg k-h
