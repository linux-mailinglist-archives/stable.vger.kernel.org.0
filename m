Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFE754833B
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 11:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbiFMJaU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 05:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbiFMJaT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 05:30:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33A91838E
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 02:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FFAB61361
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 09:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D22FC34114;
        Mon, 13 Jun 2022 09:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655112617;
        bh=Ks10NwWQsD2lF2HjxHpwmCsX4YYlOZ6KZXK3H5Nq+2Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WXQQfuBMYYsCLG4O6Eyc5SrX92YlqQD3xzwLaUweJiXyrICQV1P9dc1BPm6d7nLZ8
         HjM3c3h9jHTIi8N36xngivZTbDddVXXOWa76A4jC3k+JagDdgXTxl5Vi29uCW2nEgo
         HOe5u8N30nEiKbX0oz5azME4JU99VV+JGwQCcocY=
Date:   Mon, 13 Jun 2022 11:30:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        linux-stable <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: Boot stalls in v4.9.y to v5.4.y stable queues
Message-ID: <YqcDppXaXeGymyu0@kroah.com>
References: <20220610000555.GA2492906@roeck-us.net>
 <CANn89iKZqfKQrJLZbjnngHjSx_AoyUHMmOwK5aek4jDVNyj77g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKZqfKQrJLZbjnngHjSx_AoyUHMmOwK5aek4jDVNyj77g@mail.gmail.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 09, 2022 at 06:59:59PM -0700, Eric Dumazet wrote:
> On Thu, Jun 9, 2022 at 5:05 PM Guenter Roeck <linux@roeck-us.net> wrote:
> >
> > Hi,
> >
> > all stable release queues from v4.9.y up to v5.4.y have boot stall
> > problems. The culprit is the backport of commit d7ea0d9df2a6 ("net:
> > remove two BUG() from skb_checksum_help()"), specifically the following
> > code.
> >
> 
> Not sure why this patch has been backported.
> 
> It had no Fixes: tag, and was not a stable candidate.

Now dropped thanks.

greg k-h
