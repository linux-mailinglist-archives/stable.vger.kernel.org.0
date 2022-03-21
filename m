Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19D3A4E243E
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 11:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346263AbiCUKYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 06:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346203AbiCUKYR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 06:24:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9952FA76DD
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 03:22:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B6DB61333
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 10:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C7EC340E8;
        Mon, 21 Mar 2022 10:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647858171;
        bh=mZuKaRCi7Z0xaXMkoYFPuvue3l8GDqrAU7ReDon4BFk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wX0uyiuJ09FdjNnwBw/EMrxs3BlLUhgQL2j/h0H138D0EFnLLjWmjsOx443J9aXGi
         7T1y68gDFHqi+YagOcV2RddH7T3pEcLsrYP2QH1u2taMDaBAbNcXapEOHxMJh7trT3
         6NoaL3klhEQZCocPfJOOf8EsL+WHCx/uzrCWAyXw=
Date:   Mon, 21 Mar 2022 11:22:48 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     stable@vger.kernel.org, tglx@linutronix.de
Subject: Re: The linux-5.17.y tag looks bogus.
Message-ID: <YjhR+FI3CWeZ3Db0@kroah.com>
References: <YjhPvcJ9opIrx+ua@linutronix.de>
 <YjhQuSYxLBVc+kJC@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjhQuSYxLBVc+kJC@kroah.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 21, 2022 at 11:17:29AM +0100, Greg KH wrote:
> On Mon, Mar 21, 2022 at 11:13:17AM +0100, Sebastian Andrzej Siewior wrote:
> > Hi,
> > 
> > I just noticed that the stable repository has the linux-5.17.y tag and
> > no branch with the linux-5.17.y name. That tag looks like a copy of
> > Linus' v5.17.
> > 
> > I guess this is a mistake. On my side git refused to push the
> > linux-5.17.y branch because it already had a tag with the same name.
> 
> I have not created the 5.17.y branch yet.
> 
> What tag are you seeing?

Ah, I see that now.  That's odd.  I've deleted it, I don't know how that
got created, maybe our scripts messed up.  Something went "odd" on the
release that git.kernel.org told me about, but I have to wait until some
people wake up in the Americas before I can figure out what actually
happened.

thanks,

greg k-h
