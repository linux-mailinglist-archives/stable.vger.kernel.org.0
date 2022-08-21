Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8DE59B46B
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 16:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiHUO0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 10:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiHUO0O (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 10:26:14 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93681A38D;
        Sun, 21 Aug 2022 07:26:13 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 600F767373; Sun, 21 Aug 2022 16:26:10 +0200 (CEST)
Date:   Sun, 21 Aug 2022 16:26:10 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Alan J. Wylie" <alan@wylie.me.uk>
Cc:     Christoph Hellwig <hch@lst.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Regression in 5.19.0: USB errors during boot
Message-ID: <20220821142610.GA2979@lst.de>
References: <25342.20092.262450.330346@wylie.me.uk> <Yv5Q8gDvVTGOHd8k@kroah.com> <20220821062345.GA26598@lst.de> <25345.60162.942383.502797@wylie.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25345.60162.942383.502797@wylie.me.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 21, 2022 at 09:21:22AM +0100, Alan J. Wylie wrote:
> Comparing with another AMD system that doesn't show the problem,
> I see that CONFIG_GART_IOMMU is only set on the one with the problem.
> 
> The configs have just had "make oldconfig" run on them for years, I
> have no idea why one has it set.
> 
> Clearing it fixes the problem!

Thanks for confirming my suspicion.  I'd still like to fix the issue
with CONFIG_GART_IOMMU enabled once I've tracked it down.  Would you
be willing to test patches?
