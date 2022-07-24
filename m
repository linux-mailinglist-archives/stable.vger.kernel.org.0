Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA31E57F56E
	for <lists+stable@lfdr.de>; Sun, 24 Jul 2022 16:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbiGXOKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jul 2022 10:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiGXOKV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jul 2022 10:10:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EA4FD00
        for <stable@vger.kernel.org>; Sun, 24 Jul 2022 07:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0BFA61119
        for <stable@vger.kernel.org>; Sun, 24 Jul 2022 14:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3045C3411E;
        Sun, 24 Jul 2022 14:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658671819;
        bh=h/4+ymqx1PHAtHXmR0+rM7rjlR7IX8/h9TXId5gZYHc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JwlDuJXPOVaVs2bmffafNEZy2NxuFKycXEU/v3xCaK1dKPZ+eM7R75cipQRcmCxZx
         6bJyettJRwnnD49lUfoBWR0eyfqLQ5AVu5cdcSu0AR9Yb9LaNdYESQe9wIQDvKeT3y
         Nlu6Y/gsCwzhYOt8rScxzOLkdQQ5Gl/ZuAOIsP8U=
Date:   Sun, 24 Jul 2022 16:10:15 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: request for stable inclusion of per-file labelling for bpffs.
Message-ID: <Yt1Sxxrh+p1lSSHV@kroah.com>
References: <CANP3RGcZqbYnK=DV00yDi0JVj58oSZ100KjJ8tCeLtgTrGn3pQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANP3RGcZqbYnK=DV00yDi0JVj58oSZ100KjJ8tCeLtgTrGn3pQ@mail.gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 24, 2022 at 01:49:42AM -0700, Maciej Żenczykowski wrote:
> Could the following 1-liner be pulled into LTS please?
> It should easily - if not quite trivially - apply to 4.9/4.14/4.19/5.4
> LTS trees.

As it does not cleanly apply, can you provide a working backport so that
we know it is the correct placement of this if statement addition, as it
seems not to be the same in all of the stable trees.

And bpffs is in all of these old kernel releases, right?

thanks,

greg k-h
