Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E32B53CC1E
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 17:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245406AbiFCPPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 11:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245407AbiFCPO5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 11:14:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59605047D
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 08:14:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA460B82260
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 15:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E7BC385A9;
        Fri,  3 Jun 2022 15:14:53 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="j1BAf5il"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654269292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YYoo0Bfrri5xfzweI7/ZRvrMTAZMKnGsIaLyY7OX2FQ=;
        b=j1BAf5ildIXmkNoC1a8iIp42PfgBfZxsfMNSxjnlIBTt1SlJQ087M8wh8HwlnYH+jLqlCu
        o9Wmm/iF4Sp8vsGjvahgdRdcGzHBGLJQ1pHPUKjP0j4wh6bi3U6CfZaXLUzeV7CtbWWo+B
        x5xUL3rGC3wnKsDt8LS7slwWN45QA4k=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e555d402 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 3 Jun 2022 15:14:51 +0000 (UTC)
Date:   Fri, 3 Jun 2022 17:14:48 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH stable 5.15.y 0/5] missing random.c-related stable patches
Message-ID: <YpolaDt+5doc7cOz@zx2c4.com>
References: <20220602202327.281510-1-Jason@zx2c4.com>
 <YpofLWgbLysxkgb3@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YpofLWgbLysxkgb3@kroah.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 03, 2022 at 04:48:13PM +0200, Greg KH wrote:
> On Thu, Jun 02, 2022 at 10:23:22PM +0200, Jason A. Donenfeld wrote:
> > Hi Greg,
> > 
> > I forgot two things when doing the 5.15 backport. The first is a patch
> > from Justin fixing a bug in some of the lib/crypto Kconfig changes,
> > which Pablo (CC'd) pointed out was missed. The second is that the
> > backport of 5acd35487dc9 ("random: replace custom notifier chain with
> > standard one") isn't quite right without Nicolai's patches there too,
> > since the drbg module is removable.
> > 
> > I'll continue to monitor all the channels I possibly can for chatter
> > about problems, but so far this is all I've run into.
> 
> All now queued up, thanks.

Thanks. Note that the 5.10 patchset I posted is identical to this one,
except I made sure patch 1/5 applies. Just cherry picking the 5.15 has a
trivial conflict to fix up.

Jason
