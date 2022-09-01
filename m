Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C64D5A9372
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 11:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233324AbiIAJn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 05:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232685AbiIAJnj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 05:43:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6045827DD1
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 02:43:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEB1961A1B
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 09:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6ED0C433D7;
        Thu,  1 Sep 2022 09:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662025417;
        bh=h5zINJ/azmGRhVts8BjJnsuTyIz9ZZsD38VBHHDZAAU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yn+kwQqZ5Z6cyQxK9fOMRp1dJbdAmdnMwDQklvMVFA6NKKBStAIoDn5yQyfZ0hTLD
         YtN/rTLn4FwLFehF7PopahxVqFCacikChrCNkZZe/BTsKH4MkSKPh4mZku5hiblAIW
         T9jgy7Xho+oLdps6ZJUyawvYs8zE2upssTplUNZU=
Date:   Thu, 1 Sep 2022 11:43:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     peterz@infradead.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/nospec: Fix i386 RSB stuffing" failed
 to apply to 5.10-stable tree
Message-ID: <YxB+xgcz9QD5BK77@kroah.com>
References: <166176181110563@kroah.com>
 <3e14d81d0576aed9583d07fbd14e6a502f2d4739.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e14d81d0576aed9583d07fbd14e6a502f2d4739.camel@decadent.org.uk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 29, 2022 at 04:04:58PM +0200, Ben Hutchings wrote:
> On Mon, 2022-08-29 at 10:30 +0200, gregkh@linuxfoundation.org wrote:
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> 
> You need commit 4e3aa9238277 "x86/nospec: Unwreck the RSB stuffing"
> before this one.  I've attached the backport of that for 5.10.  I
> haven't checked the older branches.

Great, thanks, this worked.  But the backport did not apply to 4.19, so
I will need that in order to take this one as well.

thanks,

greg k-h
