Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7494FBD1C
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 15:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346491AbiDKNdP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 09:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344372AbiDKNdO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 09:33:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28E93BA6E
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 06:31:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44D78B815F0
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 13:30:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932EEC385A4;
        Mon, 11 Apr 2022 13:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649683857;
        bh=YsDIhHGPHCoL2JOhHnSuc8fSiLZmnoS5PXBgNaHYYKY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UZHDXJ8cHL0mN8IbSphozNGH+9Ibkpcn5AzaZMT7/JgXhq75g3qGl7sIRX+TCOT1W
         uFqk5vkCBanKg0YmtkOkcSztvD5c4TyZySrPZ4iNhwLIz2oxM8d5Cm2W4hGtbzH4tO
         Mw4xiPwify4FBqD0mOd1nNmRQLk9JALR5POBWY4g=
Date:   Mon, 11 Apr 2022 15:30:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yann Gautier <yann.gautier@foss.st.com>
Cc:     ulf.hansson@linaro.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] mmc: mmci: stm32: correctly check all
 elements of sg list" failed to apply to 5.4-stable tree
Message-ID: <YlQtjwDWIRUY0I0Y@kroah.com>
References: <164966239220895@kroah.com>
 <284fae86-d1a2-d4d1-6662-b52cae8aeaf3@foss.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <284fae86-d1a2-d4d1-6662-b52cae8aeaf3@foss.st.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 11, 2022 at 10:30:47AM +0200, Yann Gautier wrote:
> On 4/11/22 09:33, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Hi Greg,
> 
> The patch doesn't apply because the following one is not there:
> 127e6e98ca9b mmc: mmci_sdmmc: Replace sg_dma_xxx macros
> 
> Maybe it should have been a fix patch too.

that works, thanks!

greg k-h
