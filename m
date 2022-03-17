Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1A4D4DC38C
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 11:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbiCQKFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 06:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232314AbiCQKFp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 06:05:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501F01DBABC
        for <stable@vger.kernel.org>; Thu, 17 Mar 2022 03:04:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA2D561774
        for <stable@vger.kernel.org>; Thu, 17 Mar 2022 10:04:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A75C340EC;
        Thu, 17 Mar 2022 10:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647511468;
        bh=im11g4E6OxZVbBblZrxq+dKXqA39I3MANqwlRD0bQKw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b3hL4deK0C9l59x3g2CLsOxjqpU+jpdg8Yj5UDfsw1XC42YkB3m19At04/aSTCWX6
         LzCtn4RTJfHtUWHhIkQnFayjb0awWp5CgEY+L8OsqWTK6VpEJwsJgBuTdkZt7xfGTP
         y43wkMjgYs/gVJR8IFELuLRXey6fHot0cHRkxtws=
Date:   Thu, 17 Mar 2022 11:04:20 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Borislav Petkov <bp@suse.de>
Cc:     peterz@infradead.org, mbenes@suse.cz, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/module: Fix the paravirt vs
 alternative order" failed to apply to 5.15-stable tree
Message-ID: <YjMHpBrbz63hOL2e@kroah.com>
References: <1647245046133115@kroah.com>
 <YjCy1FHTo6Cpw8Hk@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjCy1FHTo6Cpw8Hk@zn.tnic>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 15, 2022 at 04:37:56PM +0100, Borislav Petkov wrote:
> On Mon, Mar 14, 2022 at 09:04:06AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.15-stable tree.
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
> > From 5adf349439d29f92467e864f728dfc23180f3ef9 Mon Sep 17 00:00:00 2001
> 
> I guess something like this:
> 

Thanks for the backport, now queued up!

greg k-h
