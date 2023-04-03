Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED97F6D454F
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 15:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbjDCNKe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 09:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbjDCNKd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 09:10:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22E610CA
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 06:10:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 806AEB81730
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 13:10:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD06C433EF;
        Mon,  3 Apr 2023 13:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680527430;
        bh=+XMhlJ6B6/JoiM301xK+wOAuQ3ns372ggG3qHw1fsjs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wT6PEA8l0N3Z6hXWsL0tfQb8+PSNuKt/EsGQ1pgxBlF8neMJEpyd+Txxyltb49rUs
         ZVPcoSfKKx2v6El0cEzJjCqrrd8qtJdYeDLv1ejcTIGXR/y5uglZ7XS9tPpcUqV94+
         0x9Wry97Eus5KY/2jR8Tlsko5gMnnQ/RTQqAMfu4=
Date:   Mon, 3 Apr 2023 15:10:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH for 4.14, 4.19] usb: host: ohci-pxa27x: Fix and & vs |
 typo
Message-ID: <2023040321-plausibly-violet-0aa0@gregkh>
References: <20230330051649.431149-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330051649.431149-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 30, 2023 at 02:16:49PM +0900, Nobuhiro Iwamatsu wrote:
> From: Dan Carpenter <dan.carpenter@oracle.com>
> 
> commit 0709831a50d31b3caf2237e8d7fe89e15b0d919d upstream.
> 
> The code is supposed to clear the RH_A_NPS and RH_A_PSM bits, but it's
> a no-op because of the & vs | typo.  This bug predates git and it was
> only discovered using static analysis so it must not affect too many
> people in real life.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> Link: https://lore.kernel.org/r/20190817065520.GA29951@mwanda
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
> ---
>  drivers/usb/host/ohci-pxa27x.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Now queued up, thanks.

greg k-h
