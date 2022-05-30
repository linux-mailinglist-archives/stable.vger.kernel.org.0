Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25FC953792B
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 12:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiE3Ki0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 06:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiE3KiZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 06:38:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FFD66AF5
        for <stable@vger.kernel.org>; Mon, 30 May 2022 03:38:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E05361118
        for <stable@vger.kernel.org>; Mon, 30 May 2022 10:38:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D006C385B8;
        Mon, 30 May 2022 10:38:22 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="oDK6VtTS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1653907100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qRSZID129VEkHWHAF62Ys/Cq17mLXjqI82iXrPMLk3M=;
        b=oDK6VtTS7Hai8PtX17dUfydB8iCXwoRPjJjZgBv451B5jgDizMoyJJx78XzFOpsnAnmtro
        l0YOd4Uf1q6uyK0y+VyOd0cSFstMggcI8wUoD3vVuklRmZvmVzmJrbFTrlhHfS8ercyQxJ
        u+fK79zZ564+hFZ1rjc4u0xyK68qh9c=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0beb848d (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 30 May 2022 10:38:19 +0000 (UTC)
Date:   Mon, 30 May 2022 12:38:15 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     sashal@kernel.org, stable@vger.kernel.org
Subject: Re: random.c backports for 5.18, 5.17, 5.15, and prior
Message-ID: <YpSel6PD4eKSToi8@zx2c4.com>
References: <YouECCoUA6eZEwKf@zx2c4.com>
 <YouNwkU/8+hRwz9s@kroah.com>
 <YpR8SHUGRFNyWEaT@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YpR8SHUGRFNyWEaT@kroah.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Greg,

On Mon, May 30, 2022 at 10:11:52AM +0200, Greg KH wrote:
> For 5.4 I just don't think it's worth the trouble.  Devices based on
> that old kernel aren't going to want to deal with the churn like this,
> and being forced to add the WG code to it also seems like a lot of
> unnecessary work for everyone (including yourself.)
> 
> But, I do know that a lot of Android devices are still relying on 5.4,
> they already have WG in their kernels so overall this might be a smaller
> diff for them?
> 
> I don't really know, do you have any people/companies/devices using 5.4
> that would want this all added that you can show it is worth it for?

I think if it's in 5.10, it makes sense to at least try to get it into
5.4 and below for the same reasons. I'm traveling over the next week or
so, but I think I'll attempt to do a straight backport of it (sans-wg)
like I did for 5.10. As mentioned, it's harder, but that doesn't mean
it's impossible. I might give up in exasperation or perhaps find it too
onerous. But hopefully I'll be able to reuse the work I did for the
Android wg backports. Anyway, no guarantees -- it's not a trivial walk
in the park -- but I'll give it a shot and let you know if I can make it
work.

Jason
