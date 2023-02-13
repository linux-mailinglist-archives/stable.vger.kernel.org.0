Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C520D6945CC
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 13:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjBMMb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 07:31:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjBMMb4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 07:31:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C133A115
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 04:31:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63CE160BEA
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 12:31:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D49BC433D2;
        Mon, 13 Feb 2023 12:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676291512;
        bh=pOkhng9aBIf2TIwr0IzFJKNfoyNxh0i9ZJ+asCRRCck=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VnqFC7ZrMj+xmoHwPJkWbJfUl4Y3g+SviXcKxICq9AhN7i4myVwX8OSVzvAxrd1QT
         qPkSj5dyBnK+f0sH/Bja7uBvKiuGZwPTmIviMcLkSZNAMpKFqD/sQdD+N6v7/CO3nR
         WJ/D4pALGEJxjSiIuXyxDxrdwp67T6N9PLg525ok=
Date:   Mon, 13 Feb 2023 13:31:49 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xinghui Li <korantwork@gmail.com>
Cc:     peterz@infradead.org, jpoimboe@redhat.com, tglx@linutronix.de,
        stable@vger.kernel.org, x86@kernel.org, alexs@kernel.org
Subject: Re: [bug report]warning about entry_64.S from objtool in v5.4 LTS
Message-ID: <Y+ottclebGlehBWU@kroah.com>
References: <CAEm4hYXr28O8TOmZWEKfp-00Y9R7Ky7C6X3JTtfm-0AD42KbrA@mail.gmail.com>
 <Y+CSwTDESQjTzS8S@kroah.com>
 <CAEm4hYW-LzXbf-ZrsG59LrHB067NhuYkRSLzsd8RBfwzA8z1mg@mail.gmail.com>
 <Y+DK4fP/u7iYi7Kt@kroah.com>
 <CAEm4hYW+p3CdbPkKK8Aiv-ofisQbsBr3xv8Ne9D6QJXeOC9T9Q@mail.gmail.com>
 <Y+H1HRqfnULl/B9f@kroah.com>
 <CAEm4hYXnX=E55CQ9Ts5E1Z7pBLRnH91fckMvVO-xmnaT0++JFA@mail.gmail.com>
 <Y+H+LDbPoN2JDE2X@kroah.com>
 <CAEm4hYX3q=zRFYO68UXYmtnA-ZcVXX_rsnka-eR0--wYdNgHzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEm4hYX3q=zRFYO68UXYmtnA-ZcVXX_rsnka-eR0--wYdNgHzw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 13, 2023 at 08:20:03PM +0800, Xinghui Li wrote:
> However, for conservative reasons, parts of our customers are opposed
> to making significant upgrades to the products.

Your customers are not concervative at all if they are consuming the
RETBLEED and other Spectre-like fixes into your kernels.  Those are
major changes as you can see (affecting every single file you build), so
the "do not change anything" argument does not make any sense here,
right?

> Meanwhile, for commercial purposes, we are committed to maintaining
> the products we sell over a period of time.
> For the above reasons, we also maintain older versions of the product,
> so we will fix/report the issues in older kernels just like this time.

That's great, but some help in fixing this reported issue would also be
most appreciated, as you are the best one to test and verify the fix.

thanks,

greg k-h
