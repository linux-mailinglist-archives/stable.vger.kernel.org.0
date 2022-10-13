Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEDA5FDE15
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 18:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbiJMQSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 12:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiJMQSR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 12:18:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D4F1372AB
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 09:18:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96FF0B81F3E
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 16:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2051C433D6;
        Thu, 13 Oct 2022 16:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665677894;
        bh=QQyaWuQMwDz2CRy/2TxSS30YGMy5eb8BiiNyKbbYiHg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=in8plOt4ft+MOtpcpKJK6J8zZOgwjGIDQ2Uu0iSYi2ru9ggbTf0ETMkg4GwnGCl8r
         Rgzet+wteCbDeZoIZUNiK3tkkZNzsfJmzggp1i5prDQ0MWIRNUiqFw6Dhpi+ozmobn
         g1lkK9ARInzrlglXrQMoXMTZrTYlCfPqBXFltvBs=
Date:   Thu, 13 Oct 2022 18:18:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH stable 0/3] recent failed backports for the rng
Message-ID: <Y0g6bYnxyNNX5WC6@kroah.com>
References: <20221013153654.1397691-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013153654.1397691-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 13, 2022 at 09:36:51AM -0600, Jason A. Donenfeld wrote:
> Hi Greg,
> 
> You just sent me an automated email about these failing, so here they
> are backported. 

Backported where?  Patch 1 is already in 5.10 and newer, does this one
work in older?

And 2 and 3 for all branches?

confused,

greg k-h
