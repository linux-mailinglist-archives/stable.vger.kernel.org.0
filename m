Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0C75FD3EA
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 06:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiJMEph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 00:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiJMEpg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 00:45:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3EF8C784D;
        Wed, 12 Oct 2022 21:45:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FED2616BC;
        Thu, 13 Oct 2022 04:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C47C43470;
        Thu, 13 Oct 2022 04:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665636328;
        bh=1zZPtIczMxHjAq3MHY4iIJHG2cg65zT4AQmHABsQBxs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PMwzx8bHOLCUrPk0zwfK0H+l/+olN2ERx/pzrS9PTBvvMoAoIjgZfQVIx0zR4yeIf
         jDUScsaLzyhmFnZwaOiwDXtemJC1cLXIwGeCCVm7NWt7U1QWqDqdJAskL3HQPp/cRm
         ovyboyUo1i5KeD25WvTBJGXANCj7IWpfPTJn6qZ4=
Date:   Thu, 13 Oct 2022 06:46:12 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Joe Perches <joe@perches.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Michael Straube <straube.linux@gmail.com>,
        Philipp Hortmann <philipp.g.hortmann@gmail.com>,
        Larry.Finger@lwfinger.net, phil@philpotter.co.uk, martin@kaiser.cx,
        paskripkin@gmail.com, gszymaszek@short.pl, fmdefrancesco@gmail.com,
        makvihas@gmail.com, saurav.girepunje@gmail.com,
        linux-staging@lists.linux.dev
Subject: Re: [PATCH AUTOSEL 5.19 01/63] staging: r8188eu: do not spam the
 kernel log
Message-ID: <Y0eYFF7Wl7Cb2hfK@kroah.com>
References: <20221013001842.1893243-1-sashal@kernel.org>
 <60af3294445ba2d2289a32ef7e429111ff476b44.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60af3294445ba2d2289a32ef7e429111ff476b44.camel@perches.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 12, 2022 at 08:08:58PM -0700, Joe Perches wrote:
> On Wed, 2022-10-12 at 20:17 -0400, Sasha Levin wrote:
> > From: Michael Straube <straube.linux@gmail.com>
> > 
> > [ Upstream commit 9a4d0d1c21b974454926c3b832b4728679d818eb ]
> > 
> > Drivers should not spam the kernel log if they work properly. Convert
> > the functions Hal_EfuseParseIDCode88E() and _netdev_open() to use
> > netdev_dbg() instead of pr_info() so that developers can still enable
> > it if they want to see this information.
> 
> Why should this be backported?

I agree, Sasha please drop this from all branches.

thanks,

greg k-h
