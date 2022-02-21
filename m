Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93C5E4BE535
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345031AbiBUK5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 05:57:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355629AbiBUKz4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 05:55:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870342DD46
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 02:24:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41306B80F10
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 10:24:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF8FC340EB;
        Mon, 21 Feb 2022 10:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645439083;
        bh=JLuQ8E01DIaTkjyUmteVxfQjI2R13J5nf8WW9OXydc0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ce5sOiGIgsNcRtCLPunn7b2+ryaIrbjqPedP36mkvMVWQM0u5thyzMe74fq3GAhJ9
         BRSInvWEuf244bW7VQ0Fa7u24AgrcFJmZNEKKzGzB1H34Md6nWpt1b96j42wotIXKe
         aK4Hzk5yUKh6Aov/LB+bBovnmlBTBl6ULgyEOhQY=
Date:   Mon, 21 Feb 2022 11:24:39 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     daniel@iogearbox.net, andrii@kernel.org, ast@kernel.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] bpf: Fix toctou on read-only map's
 constant scalar tracking" failed to apply to 5.4-stable tree
Message-ID: <YhNoZy415MYPH+GR@kroah.com>
References: <163757721744154@kroah.com>
 <Yg5wY5FKj0ikiq+A@google.com>
 <Yg51IuzfMnU8Uo6v@kroah.com>
 <Yg6AbfbFgDqbhq0e@google.com>
 <YhNg4uM1gIN89B7U@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhNg4uM1gIN89B7U@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 21, 2022 at 09:52:34AM +0000, Lee Jones wrote:
> On Thu, 17 Feb 2022, Lee Jones wrote:
> 
> > On Thu, 17 Feb 2022, Greg KH wrote:
> > 
> > > On Thu, Feb 17, 2022 at 03:57:23PM +0000, Lee Jones wrote:
> > > > Good afternoon Daniel,
> > > > 
> > > > On Mon, 22 Nov 2021, gregkh@linuxfoundation.org wrote:
> > > > > 
> > > > > The patch below does not apply to the 5.4-stable tree.
> > > > > If someone wants it applied there, or to any other stable or longterm
> > > > > tree, then please email the backport, including the original git commit
> > > > > id to <stable@vger.kernel.org>.
> > > > 
> > > > We are in receipt of a bug report which cites this patch as the fix.
> > > 
> > > Does the bug report really say that this issue is present in the 5.4
> > > kernel tree?  Anything older?
> > 
> > Not specifically, but the commit referenced in the Fixes tag landed in
> > v5.5. and was successfully back-ported to v5.4.144.
> 
> Another potential avenue might to be revert the back-ported commit
> which caused the issue from v5.4.y.

Unless that was fixing a different issue?  I have no idea at this point
what commit you are talking about, sorry :(

greg k-h
