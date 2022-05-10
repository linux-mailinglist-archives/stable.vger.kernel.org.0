Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A9A52123A
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 12:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239862AbiEJKcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 06:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239870AbiEJKca (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 06:32:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E4E2016CA
        for <stable@vger.kernel.org>; Tue, 10 May 2022 03:28:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 926DBB81CAC
        for <stable@vger.kernel.org>; Tue, 10 May 2022 10:28:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51D7C385A6;
        Tue, 10 May 2022 10:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652178510;
        bh=SMI5Ltfb9KzjselD1N2dqFWtZ5GQ1HK3wkT2rCAMn5I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gMAdx12r+yuu7YD6borPFbyLLBD3xHWeADQbNvY1EQ0lld+C38WnReiO6tLjmbuUP
         kAlauC0A2WR55quHhLY9eSF7yp6nxElufy2jZUg0aUbnBDy3bIQ2FBQjqvc4u+GLt1
         91p67hpOagZa/ORUQkW+fQ0rusQZg/Y7nLnfhuIk=
Date:   Tue, 10 May 2022 12:28:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Helge Deller <deller@gmx.de>
Cc:     dave.anglin@bell.net, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] Revert "parisc: Mark sched_clock unstable
 only if clocks are" failed to apply to 5.15-stable tree
Message-ID: <Yno+S6K5xbkczT9c@kroah.com>
References: <16520837712276@kroah.com>
 <Ynk/VkI7WQcf9bmw@p100>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ynk/VkI7WQcf9bmw@p100>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 09, 2022 at 06:20:38PM +0200, Helge Deller wrote:
> Hi Greg,
> 
> * gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>:
> >
> > The patch below does not apply to the 5.15-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Please apply below patch instead to v5.15-stable.

Now applied, thanks.

greg k-h
