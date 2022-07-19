Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF3B5798A1
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 13:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235748AbiGSLjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 07:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233786AbiGSLja (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 07:39:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA0D4198D
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 04:39:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D09E5B81A8F
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 11:39:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8161C341C6;
        Tue, 19 Jul 2022 11:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658230766;
        bh=DoK6FlFO2Cs7U8ThlYoaIZ9X1fSmKtl+5jx8vkyilbU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s1ukAgmaiLCE4QU0ojhXBawkoa/7v8ba9BKjxJZ/8dsNxt6Uc65Aw497reUkH9OaZ
         FLbv5uToNVHhFhTFey1saLe4+PU5jsIlVgK62/UA4CuNunj8i6mXgIP7EoNEgL+Cvo
         wO9JbEDrINeexvaWfcUf6kXxtBu4Pt5h29vb4k4M=
Date:   Tue, 19 Jul 2022 13:39:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     mkl@pengutronix.de, hbh25y@gmail.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] can: m_can: m_can_tx_handler(): fix use
 after free of skb" failed to apply to 5.4-stable tree
Message-ID: <YtaX65s+S41FN1jr@kroah.com>
References: <1648814538103133@kroah.com>
 <Ys8xDyCCL6WQmKYW@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ys8xDyCCL6WQmKYW@debian>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 13, 2022 at 09:54:39PM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Fri, Apr 01, 2022 at 02:02:18PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport.

all now queued up, thanks.

greg k-h
