Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFFE504E62
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 11:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbiDRJct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 05:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiDRJct (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 05:32:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB76A15FFE
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 02:30:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76EDC6118F
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 09:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514CCC385A8;
        Mon, 18 Apr 2022 09:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650274209;
        bh=HbzV6yufxAh5iDtggW7509Z475MyhN0TNaCym2qH9lI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SZAoAX9vYwG3Jr4dqR0xX4hy8r9T0YCpnwOjFrnp568ds9uN39m8XJTU2vAii13vP
         /GeM2/kzgk6qLgL16LEELdeznqpQ4BWeuCV3rlVoqa1mae10VkhIthLPvkJ9ayDYrF
         hyFj0Oh3vqlM52MLqYhnWa1aAIiKa+mFcjBlHzDE=
Date:   Mon, 18 Apr 2022 11:30:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     keescook@chromium.org, pageexec@freemail.hu, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] gcc-plugins: latent_entropy: use
 /dev/urandom" failed to apply to 4.9-stable tree
Message-ID: <Yl0vnls++OCbpGzX@kroah.com>
References: <16502694453885@kroah.com>
 <Yl0rFqfaETxNfTgh@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yl0rFqfaETxNfTgh@zx2c4.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 18, 2022 at 11:12:11AM +0200, Jason A. Donenfeld wrote:
> Hi Greg,
> 
> On Mon, Apr 18, 2022 at 10:10:45AM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > From c40160f2998c897231f8454bf797558d30a20375 Mon Sep 17 00:00:00 2001
> 
> Apparently on 4.9.y, applying this commit cleanly also requires
> 5a45a4c5c3f5e36a03770deb102ca6ba256ff3d7 to be cherry picked first.

That worked, thanks!
