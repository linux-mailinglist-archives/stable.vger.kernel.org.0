Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53DE550C878
	for <lists+stable@lfdr.de>; Sat, 23 Apr 2022 10:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233836AbiDWJBV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Apr 2022 05:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233695AbiDWJBU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Apr 2022 05:01:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC4F5595
        for <stable@vger.kernel.org>; Sat, 23 Apr 2022 01:58:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68D6A60C2B
        for <stable@vger.kernel.org>; Sat, 23 Apr 2022 08:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F66C385A0;
        Sat, 23 Apr 2022 08:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650704302;
        bh=QcRyOsL5NR28fUSkrPb7O6WoZTMTBNkZEmycrL8Vheo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0aEPjJmqTi9RaXIC7Y/ghpyy75epegnjCfQ0wrS5gkW3m45Q2UJshsFHIQixius+o
         BaRE/wrarAwZHab7eFgx0iNV4VIvh2DRM5UAf59ZkfmSffrjKj+a2/61gaT+8YjC7D
         2SWneTMO0ulsIzzFBrEDm0LR4ZSJFXJ1xRQN5XTo=
Date:   Sat, 23 Apr 2022 10:58:19 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>
Subject: Re: Request to cherry-pick c89dffc70b34 to 4.14, 4.19, and 5.4.
Message-ID: <YmO/q+Qz3/Nufk+9@kroah.com>
References: <20220423010706.79913-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220423010706.79913-1-kuniyu@amazon.co.jp>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 23, 2022 at 10:07:06AM +0900, Kuniyuki Iwashima wrote:
> Hi maintainers,
> 
> Upstream commit 01770a166165 ("tcp: fix race condition when creating child
> sockets from syncookies") is planned to be backported to 4.14, 4.19 and
> 5.4:
> 
>   https://marc.info/?l=linux-stable-commits&m=165063781908608&w=3
>   https://marc.info/?l=linux-stable-commits&m=165063781708604&w=3
>   https://marc.info/?l=linux-stable-commits&m=165063781708603&w=3
> 
> Another commit c89dffc70b34 ("tcp: Fix potential use-after-free due to
> double kfree()") has a Fixes tag for it, so please backport this also.

Ick, that commit does not apply cleanly.  The people who wanted
01770a166165 should also provide a working version of this fix as well.

thanks,

greg k-h
