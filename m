Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C17AB5662EA
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 08:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiGEGCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 02:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiGEGCI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 02:02:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694F5D133
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 23:02:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA4BB6119C
        for <stable@vger.kernel.org>; Tue,  5 Jul 2022 06:02:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005ACC341C7;
        Tue,  5 Jul 2022 06:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657000927;
        bh=gNiDAzlrK+Aj/EYm+DIzDx8Te69W/dkkQKCqwBFl3gE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KHbZEx/xBqhnjqhT/+ZFysb09JP/ztXi0dl7EszweBW1Yrc/FVcOwFhROqhUhoeSD
         nWGrSqL2vMy72um1cYEf/zBqB3cUEmQ9vsdwXNUYwXkAMQM+yWDVRILfowXtkNxPPT
         JDXe8YdO6SNLIdDDm2IYS5n1mNWyERDpnqEB2ozw=
Date:   Tue, 5 Jul 2022 08:02:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     katrinzhou@tencent.com, dsahern@kernel.org, edumazet@google.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ipv6/sit: fix ipip6_tunnel_get_prl return
 value" failed to apply to 4.9-stable tree
Message-ID: <YsPT2t9mPPMv0fZF@kroah.com>
References: <16569413791787@kroah.com>
 <20220704194048.47867c80@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220704194048.47867c80@kernel.org>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 04, 2022 at 07:40:48PM -0700, Jakub Kicinski wrote:
> On Mon, 04 Jul 2022 15:29:39 +0200 gregkh@linuxfoundation.org wrote:
> > The patch below does not apply to the 4.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > From adabdd8f6acabc0c3fdbba2e7f5a2edd9c5ef22d Mon Sep 17 00:00:00 2001
> > From: katrinzhou <katrinzhou@tencent.com>
> > Date: Tue, 28 Jun 2022 11:50:30 +0800
> > Subject: [PATCH] ipv6/sit: fix ipip6_tunnel_get_prl return value
> 
> FWIW you just need to pull in the nop refactor from commit 284fda1eff8a
> ("sit: use min") for this one to apply.

Thanks, that worked.

greg k-h
