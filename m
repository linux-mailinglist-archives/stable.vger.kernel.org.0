Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB7360001C
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 16:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiJPO44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 10:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiJPO4z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 10:56:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67A63B95D;
        Sun, 16 Oct 2022 07:56:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A3B860BC8;
        Sun, 16 Oct 2022 14:56:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D71BC433D6;
        Sun, 16 Oct 2022 14:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665932213;
        bh=57qM6HUpaEnGUo3CmkaIDIQQ+FdtDErLhqmXmdgGouY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GTCEbDvQN5b0Cxrjai8wcPGCbVFxD6K8xrzw9IHgoMYZZ5busluWSPPwCDiAe2LbA
         UI/KkIiohnw2WQH9gUTFfQPN1LI2NFM5jG4OeShcwbcdvcbJRHOnur5JObVa8OnwwA
         YrQmPSygUoeAaJ/phz9tEBcdtFqGCUdcx+Lhoxdc=
Date:   Sun, 16 Oct 2022 16:57:40 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Michael Straube <straube.linux@gmail.com>,
        Philipp Hortmann <philipp.g.hortmann@gmail.com>,
        Larry.Finger@lwfinger.net, phil@philpotter.co.uk, martin@kaiser.cx,
        paskripkin@gmail.com, gszymaszek@short.pl, fmdefrancesco@gmail.com,
        makvihas@gmail.com, saurav.girepunje@gmail.com,
        linux-staging@lists.linux.dev
Subject: Re: [PATCH AUTOSEL 5.19 01/63] staging: r8188eu: do not spam the
 kernel log
Message-ID: <Y0wb5PymD6w7/wgk@kroah.com>
References: <20221013001842.1893243-1-sashal@kernel.org>
 <60af3294445ba2d2289a32ef7e429111ff476b44.camel@perches.com>
 <Y0eYFF7Wl7Cb2hfK@kroah.com>
 <Y0wH1wFepv3pCyaG@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0wH1wFepv3pCyaG@sashalap>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 16, 2022 at 09:32:07AM -0400, Sasha Levin wrote:
> On Thu, Oct 13, 2022 at 06:46:12AM +0200, Greg Kroah-Hartman wrote:
> > On Wed, Oct 12, 2022 at 08:08:58PM -0700, Joe Perches wrote:
> > > On Wed, 2022-10-12 at 20:17 -0400, Sasha Levin wrote:
> > > > From: Michael Straube <straube.linux@gmail.com>
> > > >
> > > > [ Upstream commit 9a4d0d1c21b974454926c3b832b4728679d818eb ]
> > > >
> > > > Drivers should not spam the kernel log if they work properly. Convert
> > > > the functions Hal_EfuseParseIDCode88E() and _netdev_open() to use
> > > > netdev_dbg() instead of pr_info() so that developers can still enable
> > > > it if they want to see this information.
> > > 
> > > Why should this be backported?
> > 
> > I agree, Sasha please drop this from all branches.
> 
> I'll drop it, but for the record: I've been picking up patches that help
> with log spam like any other regular fixes. Being on the receiving end
> of spammy kernel code and making debugging issues much harder, I think
> it's as important (if not more) than some other classes of fixes we pick
> up.

Ah, ok, fair enough.  You can leave this one in your queue if you still
have it around.

thanks,

greg k-h
