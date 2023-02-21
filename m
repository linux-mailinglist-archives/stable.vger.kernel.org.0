Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D90E69DE04
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 11:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbjBUKk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 05:40:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233689AbjBUKk5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 05:40:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069CB23C51
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 02:40:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B54ECB80E6B
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 10:40:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ADE9C433EF;
        Tue, 21 Feb 2023 10:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676976052;
        bh=euG6qmX3qXNcOUQbGi8M4TJwTBu5PUtgSfTJld+fp04=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CayqX9ihwjNNe+/UvcGIUV0JnA0PDeDIMChWJAE36PgWXJyJwL/3XefKNFH1Ite1d
         uurQ2y7gHkkgCXyGUoCEcDvwXpq6fqwgycSsqqdphXXz6nRao3zzwyPZWy7DtEN+da
         26esaeu2Izp9aYbtZFSdatTUk+eWf3Btckr4sVGM=
Date:   Tue, 21 Feb 2023 11:40:49 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tong Tiangen <tongtiangen@huawei.com>
Cc:     peterz@infradead.org, keescook@chromium.org,
        sethjenkins@google.com, Dave Hansen <dave.hansen@linux.intel.com>,
        bp@suse.de, stable@vger.kernel.org
Subject: Re: Consultation on backport 97e3d26b5e5f("x86/mm: Randomize per-cpu
 entry area") to stable
Message-ID: <Y/SfsU6rS0qraYhk@kroah.com>
References: <2b814e48-d304-e48a-e4b4-c39a10d2dbf4@huawei.com>
 <Y/RzDvXr/iGpHl+f@kroah.com>
 <e2fea1a1-982d-20c8-d92c-bc4ed4d1d711@huawei.com>
 <Y/SDj9kdYrwoSYHh@kroah.com>
 <2c56661c-d2ca-d1b0-da69-89a5e1f3e67f@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2c56661c-d2ca-d1b0-da69-89a5e1f3e67f@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 21, 2023 at 05:19:42PM +0800, Tong Tiangen wrote:
> 
> 
> 在 2023/2/21 16:40, Greg KH 写道:
> > On Tue, Feb 21, 2023 at 03:46:27PM +0800, Tong Tiangen wrote:
> > > 
> > > 
> > > 在 2023/2/21 15:30, Greg KH 写道:
> > > > On Tue, Feb 21, 2023 at 03:19:05PM +0800, Tong Tiangen wrote:
> > > > > Hi peter:
> > > > > 
> > > > > Do you have any plans to backport this patch[1] to the stable branch of the
> > > > > lower version, such as 4.19.y ?
> > > > 
> > > > Why?  That is a new feature for 6.2 why would it be needed to fix
> > > > anything in really old kernels?
> > > 
> > > Hi Greg:
> > > 
> > > This patch fix CVE-2023-0597[1],
> > 
> > The kernel developers do not care about CVEs as they are almost always
> > invalid and do not mean anything,
> 
> Ok, thanks.
> 
> 
> > sorry.  It is well known that, companies like Red Hat use them to make
> > up for broken internal engineering policies.
> 
> Yeah, For company's internal engineering policies, the CVE with certain
> impact must be repaired.

So you are letting an opaque US government agency, and random third
party companies, dictate your company's internal engineering policies
and resource allocations?  That feels very very odd and ripe for abuse.

Also note that MITRE refuses to allocate CVEs for many real kernel
issues for unknown reasons, (i.e. they reject all of my requests), so
you are getting only a small subset of real issues here.

Also, how do you handle revocation of CVEs that are obviously invalid
and/or don't actually do anything (like this one?)

> > Are you sure this really is a valid problem that must be fixed in older
> > kernels?
> > 
> > > this CVE report a flaw possibility of memory leak. And this is
> > > important for some products using this stable version.
> > 
> > What exact memory leak are you referring to?
> 
> Sorry for Inaccurate description, the memory leak means: a potential
> security risk of kernel memory information disclosure caused by no
> randomization of the exception stacks.

And are you sure this can really happen?  Have you proven this?

And why is this really an issue, KASR is a known-week-defense and almost
useless against local attacks.

Anyway, please provide working patches if you think this really is an
issue.

And please revisit your company's policies, they do not seem very sane :)

thanks,

greg k-h
