Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2E84616BA
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 14:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344164AbhK2NlJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 08:41:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344169AbhK2NjI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 08:39:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0705DC09B126
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 04:17:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 993B461361
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 12:17:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D71C53FAD;
        Mon, 29 Nov 2021 12:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638188250;
        bh=EszL27iOhxl8n2Fu+7SOdqS06VjlTX8Jf17VooXWrMk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I4J8XMjeQ3dVqqF4iflEdEDdENPgbp5udJRcT2vAylvMgrEJfqvDXnroTG0Dl048x
         R2bBkyY4Ul90rAV8QwGQOzfD+I/kB0jIz1ANiRHqnOwzL8fHXpziZFGc15v0RPY8kP
         f+6CEnBE8u4GTBnVNCYXuXw0G/nZw4g/0qsO5R4Y=
Date:   Mon, 29 Nov 2021 13:17:27 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracing: Check pid filtering when
 creating events" failed to apply to 5.4-stable tree
Message-ID: <YaTE14xXypwiAbch@kroah.com>
References: <16380998769827@kroah.com>
 <20211128145836.28b69d78@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211128145836.28b69d78@oasis.local.home>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 28, 2021 at 02:58:36PM -0500, Steven Rostedt wrote:
> On Sun, 28 Nov 2021 12:44:36 +0100
> <gregkh@linuxfoundation.org> wrote:
> 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > 
> > >From 6cb206508b621a9a0a2c35b60540e399225c8243 Mon Sep 17 00:00:00 2001  
> 
> And this should be good for 5.4 down to 4.4.

Now queued up,t hanks.

greg k-h
