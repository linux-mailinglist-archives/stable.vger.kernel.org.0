Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49EB16B5129
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 20:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbjCJTwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 14:52:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbjCJTwm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 14:52:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5AE117FCC
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 11:52:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88BE661D4C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 19:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6EAC433EF;
        Fri, 10 Mar 2023 19:52:39 +0000 (UTC)
Date:   Fri, 10 Mar 2023 14:52:37 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     akpm@linux-foundation.org, mhiramat@kernel.org,
        yujie.liu@intel.com, zhengyejian1@huawei.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracing: Free buffers when a used
 dynamic event is removed" failed to apply to 4.19-stable tree
Message-ID: <20230310145237.154f4c3f@gandalf.local.home>
In-Reply-To: <Y4zMB/CCg63nyugh@kroah.com>
References: <167006641591124@kroah.com>
        <20221203173655.1b1b2fac@gandalf.local.home>
        <Y4xYg2i7lS6z3eIe@kroah.com>
        <20221204111451.2741a499@gandalf.local.home>
        <Y4zMB/CCg63nyugh@kroah.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 4 Dec 2022 17:34:15 +0100
Greg KH <gregkh@linuxfoundation.org> wrote:

> > > > > Depends-on: 5448d44c38557 ("tracing: Add unified dynamic event framework")    
> > > > 
> > > > ^^^    
> > > 
> > > Did you just make up a new field?  We have a documented way to show
> > > dependancies for stable patches, please let's not create a new one :(  
> > 
> > Ug, I've seen this tag used before: 
> > 
> >  example:  e3f0c638f428fd66b5871154b62706772045f91a
> > 
> > And just assumed that was the method. I guess I should have looked deeper.
> >   

I may need to denote patches again that are to be marked for stable but
depend on other commits. I'm looking for the "proper" way to do this so
that your scripts pick this up.

I searched Documentation for "depends" and the only thing I see in there is
in Documentation/process/submitting-patches.rst:

   If one patch depends on another patch in order for a change to be
   complete, that is OK.  Simply note **"this patch depends on patch X"**
   in your patch description.

But that looks to be used for a patch that depends on some other patch in
the series. I'm doing something that will depend on an existing commit. And
do your scripts pick up on that line anyway?

Where's this documented way to show dependencies for stable patches?

-- Steve

