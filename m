Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDF746AB6E8
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 08:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjCFHWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 02:22:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjCFHWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 02:22:23 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864FF1E9D5
        for <stable@vger.kernel.org>; Sun,  5 Mar 2023 23:22:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CB9FFCE0A1C
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 07:22:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DFBC433D2;
        Mon,  6 Mar 2023 07:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678087333;
        bh=f6OBuwyTKZ0LqOs70jjgaYC41BcWuKLVe9wKMHfU6BM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hYfZcC+PK2LG2C2h6ZjAdO+ANiWBXKuSdklkD1F1U1kXbfFrbKVHFxXEaJ5+DKVGR
         GNRWDrby6TxO0aOx2au1iEctgm+q+ACFR1cof27L8IOSMLjDKufzBWcY/6xBl4OjT0
         y5E5liUOIXxAq5Il/kffoz6Wwp/Dlr63aYxWe+xA=
Date:   Mon, 6 Mar 2023 08:22:10 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        Alper Nebi Yasak <alpernebiyasak@gmail.com>
Subject: Re: Please backport e6acaf25cba1 ("firmware: coreboot: framebuffer:
 Ignore reserved pixel color bits") to stable series back in 6.1.y
Message-ID: <ZAWUovEJVNOc9D+K@kroah.com>
References: <ZAMYKRtk89lBUk3b@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAMYKRtk89lBUk3b@eldamar.lan>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 04, 2023 at 11:06:33AM +0100, Salvatore Bonaccorso wrote:
> Hi stable maintainers,
> 
> The following bugfix was in meanwhile applied to mainline, and I would
> like to request to backport it at lest back to 6.1.y. I do not know if
> it is needed earlier as well, Alper, any input on this?
> 
> We will want to pick it as well to properly support ChromeOS boards,
> cf. https://salsa.debian.org/kernel-team/linux/-/merge_requests/652

Now queued up, thanks.

greg k-h
