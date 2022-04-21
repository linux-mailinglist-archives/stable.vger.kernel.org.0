Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70B75509CE3
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 11:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387935AbiDUJ5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 05:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387943AbiDUJ5A (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 05:57:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E402825C59
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 02:54:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8099561896
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 09:54:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F43C385A1;
        Thu, 21 Apr 2022 09:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650534850;
        bh=aNxCv+0kUaca8R8YtXWIoQyIh4LnWQhtOZOMnATbHb8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bI34nEFnyOWye1p38OctiwLs+ghfYaBbIsxNeKV10P3D8UjR7cvF9vZCLmgTZjLdV
         GtYHPMbxtkHbsnQ9xSpECVp8L3x+RGbnuNQfveAUiodeI0Rusuu0xPa7btlGe/v83i
         2G6lqaTyP/xUoGXSXpd6GIXE3MTO5PykHa9Prb7k=
Date:   Thu, 21 Apr 2022 11:54:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     bristot@kernel.org, zanussi@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracing: Dump stacktrace trigger to the
 corresponding" failed to apply to 4.14-stable tree
Message-ID: <YmEpwIlIfF9Jlttw@kroah.com>
References: <1646033429886@kroah.com>
 <20220420203609.3bd98d39@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420203609.3bd98d39@gandalf.local.home>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 20, 2022 at 08:36:09PM -0400, Steven Rostedt wrote:
> On Mon, 28 Feb 2022 08:30:29 +0100
> <gregkh@linuxfoundation.org> wrote:
> 
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> >
> 
> The following should work for 4.14. Again, 4.9 and earlier requires a lot
> more work than I have time for.

All now queued up, thanks.

greg k-h
