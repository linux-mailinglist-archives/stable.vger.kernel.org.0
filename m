Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41627595903
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 12:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234804AbiHPKyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 06:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234366AbiHPKyK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 06:54:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D964F44565;
        Tue, 16 Aug 2022 03:22:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 784C76134E;
        Tue, 16 Aug 2022 10:22:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FCBBC433D7;
        Tue, 16 Aug 2022 10:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660645335;
        bh=H9sn8W3Nl/K9sZUDtrS3iVj49MLZG8SuRBSyKKzUtPM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1HciwKELvBGq1ly7f3V5Y/cVz1wkfoFVSTHRnVXCA1ZZqW0dAH39qholSTrLRUGBP
         bJqwqsRLmLOP6xY+XQSewKVR+KDdJFB9O9WQ0DPSuEsZN68WEOjR26TKoNTcQFBnc/
         S/6aE95U6/afje3h9MpcWpVuRCnhEGUIBw/j5vmY=
Date:   Tue, 16 Aug 2022 12:22:12 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Uladzislau Rezki <urezki@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.19 0246/1157] usercopy: use unsigned long instead of
 uintptr_t
Message-ID: <Yvtv1MNpJlt76uoV@kroah.com>
References: <20220815180439.416659447@linuxfoundation.org>
 <20220815180449.423777119@linuxfoundation.org>
 <YvqnPRmBDgUwKpzg@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvqnPRmBDgUwKpzg@casper.infradead.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 15, 2022 at 09:06:21PM +0100, Matthew Wilcox wrote:
> On Mon, Aug 15, 2022 at 07:53:22PM +0200, Greg Kroah-Hartman wrote:
> > From: Jason A. Donenfeld <Jason@zx2c4.com>
> > 
> > [ Upstream commit 170b2c350cfcb6f74074e44dd9f916787546db0d ]
> > 
> > A recent commit factored out a series of annoying (unsigned long) casts
> > into a single variable declaration, but made the pointer type a
> > `uintptr_t` rather than the usual `unsigned long`. This patch changes it
> > to be the integer type more typically used by the kernel to represent
> > addresses.
> > 
> > Fixes: 35fb9ae4aa2e ("usercopy: Cast pointer to an integer once")
> 
> Not sure why this needs to be backported?

Odd, shouldn't be, now dropped.

greg k-h
