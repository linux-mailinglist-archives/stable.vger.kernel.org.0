Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A669509CC4
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 11:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345543AbiDUJz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 05:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343806AbiDUJzz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 05:55:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8771025581
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 02:53:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E076E61892
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 09:53:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0799C385A5;
        Thu, 21 Apr 2022 09:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650534785;
        bh=5NYSt0Y6XiXZOhV8X7wDEHk5/bmkOr5hbXh5bggitns=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hgbKPOOyteRpqC4ef69G6yCdZgETa3tKRtYORMUUPNg5Uv2jCebDRp1foVpPxtbZo
         WK2GjUPhNs65Wrb+ddL0+vjpoSvuJSXA4wlJB7YidQg8hAPYxT4SXaKYza1GKgCKFD
         KKCKWCd9XoD1ceD/3Dq0qKaAwgjsnJr2yy+Q9OPg=
Date:   Thu, 21 Apr 2022 11:53:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     bristot@kernel.org, zanussi@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracing: Have traceon and traceoff
 trigger honor the instance" failed to apply to 4.14-stable tree
Message-ID: <YmEpfpcbjNI7zSTz@kroah.com>
References: <1646029977161194@kroah.com>
 <20220420132426.46ef21f1@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420132426.46ef21f1@gandalf.local.home>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 20, 2022 at 01:24:26PM -0400, Steven Rostedt wrote:
> On Mon, 28 Feb 2022 07:32:57 +0100
> <gregkh@linuxfoundation.org> wrote:
> 
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> This should work for 4.14 (I tested it for one machine).

Now queued up, thanks.

greg k-h
