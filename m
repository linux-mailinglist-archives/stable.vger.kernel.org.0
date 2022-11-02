Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAD5D615729
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 02:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiKBBxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 21:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiKBBxh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 21:53:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18ACF02E
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 18:53:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DF55617A6
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 01:53:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B8CC433C1;
        Wed,  2 Nov 2022 01:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667354015;
        bh=txmFiwqTnXen5ZWb4YrWN2nwGKgorOHvTUD3UBj8ctk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nX9lfjnQNHKrMjPfkLPwe6vrUQJFze7sDCV6VrNUxow1BTYzp9MkDBm3SC/ONm6M8
         vpvV4G2nN4sq5Bwvgav8wKUf1n7yvn6bB7dcj76yllhwUNteeCHo8H7BEWRLXC+DwK
         3ItQd88OICf/37Vg/gHk2oYUHxho9XCxgNL3R1fc=
Date:   Wed, 2 Nov 2022 02:54:28 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Meena Shanmugam <meenashanmugam@google.com>
Cc:     stable@vger.kernel.org, kuniyu@amazon.com
Subject: Re: [PATCH 5.15 0/1] Request to backport 3c52c6bb831f to 5.15.y
Message-ID: <Y2HN1GqHkxgogvJY@kroah.com>
References: <20221101005202.50231-1-meenashanmugam@google.com>
 <Y2F0ct7Dk9Npxrta@kroah.com>
 <CAMdnWFBSu87S4v=RVu0Y8RBau_=WiPkXf35tzpwd37rNn1-ZLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMdnWFBSu87S4v=RVu0Y8RBau_=WiPkXf35tzpwd37rNn1-ZLg@mail.gmail.com>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 01, 2022 at 01:55:21PM -0700, Meena Shanmugam wrote:
> On Tue, Nov 1, 2022 at 12:32 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Nov 01, 2022 at 12:52:01AM +0000, Meena Shanmugam wrote:
> > > The commit 3c52c6bb831f (tcp/udp: Fix memory leak in
> > > ipv6_renew_options()) fixes a memory leak reported by syzbot. This seems
> > > to be a good candidate for the stable trees. This patch didn't apply cleanly
> > > in 5.15 kernel, since release_sock() calls are changed to
> > > sockopt_release_sock() in the latest kernel versions.
> > >
> > > Kuniyuki Iwashima (1):
> > >   tcp/udp: Fix memory leak in ipv6_renew_options().
> > >
> > >  net/ipv6/ipv6_sockglue.c | 7 +++++++
> > >  1 file changed, 7 insertions(+)
> >
> > Can you provide a working version for 6.0.y first?  We can not have
> > people upgrading to newer kernels and having a regression.
> >
> > thanks,
> >
> > greg k-h
> 
> I have submitted the patch for 6.0.y as well.
> https://lore.kernel.org/all/20221101200505.291406-2-meenashanmugam@google.com/

Wonderful, all now queued up, thanks.

greg k-h
