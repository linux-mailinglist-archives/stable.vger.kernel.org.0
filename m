Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3B65EBAA9
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 08:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiI0GbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 02:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiI0GbI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 02:31:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE6090811;
        Mon, 26 Sep 2022 23:31:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B07F9B819CA;
        Tue, 27 Sep 2022 06:31:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033DCC4347C;
        Tue, 27 Sep 2022 06:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664260263;
        bh=wUd05ZMtrzG2JapTfKgG4cD0+3UZkyeQPhw+AsgVJ38=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R6+BRoYQFeO2spfMDsKTKVKUtDe5QyBP6ltwAUOVMu+3XSZz9y0CzZLYwPGa4ZkU5
         Bxl7Ikr2p245BLXUFnDcCTuy+XNkzEceZ07Z6nQIK1nX3Ps29XQpxL7mdAg4oHGMSJ
         YSQ/qh8Q8c0Y2JgEJSzk6QnwzggqBDFEcgeBTR0s=
Date:   Tue, 27 Sep 2022 08:31:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oliver Neukum <oneukum@suse.com>,
        Jean-Francois Le Fillatre <jflf_kernel@gmx.com>,
        stable <stable@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.19 014/207] Revert "usb: add quirks for Lenovo OneLink+
 Dock"
Message-ID: <YzKYyDaTsoX1RliA@kroah.com>
References: <20220926100806.522017616@linuxfoundation.org>
 <20220926100807.118539823@linuxfoundation.org>
 <d9d9651b-2561-03ce-8076-5b471929ff2d@kernel.org>
 <YzKOdhT7jTXwCaG8@kroah.com>
 <5ce2a0bd-d39a-71d7-2327-3850dfdd646c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ce2a0bd-d39a-71d7-2327-3850dfdd646c@kernel.org>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 27, 2022 at 08:18:26AM +0200, Jiri Slaby wrote:
> On 27. 09. 22, 7:47, Greg Kroah-Hartman wrote:
> > On Tue, Sep 27, 2022 at 07:23:46AM +0200, Jiri Slaby wrote:
> > > I wonder, does it make sense to queue the commit (as 011/207) and
> > > immediately its revert (the patch below) in a single release? I doubt
> > > that...
> > > 
> > > The same holds for 012 (patch) + 015 (revert).
> > 
> > Yes it does, otherwise tools will pick up "hey, you forgot this patch
> > that should have been applied here!" all the time.  Having the patch,
> > and the revert, in the tree prevents that from happening.
> 
> It'd be fairly easy to fix the tools not to pick up reverted commits, right?

Not really as they are usually quite "far" away from the original
commits.

But hey, if you have some scripts that can find all of that, I'm all for
it, the ones I have right now don't account for this.

thanks,

greg k-h
