Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01E8A69DC41
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 09:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbjBUIlI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 03:41:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233812AbjBUIk4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 03:40:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7A930C3
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 00:40:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEB7260FB1
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 08:40:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E55C433EF;
        Tue, 21 Feb 2023 08:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676968850;
        bh=V/Gb24IDzNc2yQ01JAZB/fR9Aiiw7H02DKt1P/USX3A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gtf9z/l1b0re4nnfXJWoiUPvEqH/rD/3nrQMGt454p5chLZxX6NNTsgyviNXRsORc
         fLtchiUqHPfKnrROA6pruyOmkU7u2WCuMnZRBYz5EgEiMzbE4F8VymyZmgh+KC0/x7
         5gbmCsUpNMrEDGkU0xK/yDk1+EZB1yUD+GtqrzB8=
Date:   Tue, 21 Feb 2023 09:40:47 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tong Tiangen <tongtiangen@huawei.com>
Cc:     peterz@infradead.org, keescook@chromium.org,
        sethjenkins@google.com, Dave Hansen <dave.hansen@linux.intel.com>,
        bp@suse.de, stable@vger.kernel.org
Subject: Re: Consultation on backport 97e3d26b5e5f("x86/mm: Randomize per-cpu
 entry area") to stable
Message-ID: <Y/SDj9kdYrwoSYHh@kroah.com>
References: <2b814e48-d304-e48a-e4b4-c39a10d2dbf4@huawei.com>
 <Y/RzDvXr/iGpHl+f@kroah.com>
 <e2fea1a1-982d-20c8-d92c-bc4ed4d1d711@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e2fea1a1-982d-20c8-d92c-bc4ed4d1d711@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 21, 2023 at 03:46:27PM +0800, Tong Tiangen wrote:
> 
> 
> 在 2023/2/21 15:30, Greg KH 写道:
> > On Tue, Feb 21, 2023 at 03:19:05PM +0800, Tong Tiangen wrote:
> > > Hi peter:
> > > 
> > > Do you have any plans to backport this patch[1] to the stable branch of the
> > > lower version, such as 4.19.y ?
> > 
> > Why?  That is a new feature for 6.2 why would it be needed to fix
> > anything in really old kernels?
> 
> Hi Greg:
> 
> This patch fix CVE-2023-0597[1],

The kernel developers do not care about CVEs as they are almost always
invalid and do not mean anything, sorry.  It is well known that
companies like Red Hat use them to make up for broken internal
engineering policies.

Are you sure this really is a valid problem that must be fixed in older
kernels?

> this CVE report a flaw possibility of memory leak. And this is
> important for some products using this stable version.

What exact memory leak are you referring to?

thanks,

greg k-h
