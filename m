Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B93846B6321
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 05:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjCLEXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 23:23:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCLEXa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 23:23:30 -0500
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8982C1CBE8;
        Sat, 11 Mar 2023 20:23:26 -0800 (PST)
Received: (from willy@localhost)
        by mail.home.local (8.17.1/8.17.1/Submit) id 32C4N9TO032648;
        Sun, 12 Mar 2023 05:23:09 +0100
Date:   Sun, 12 Mar 2023 05:23:09 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <ZA1TrYKwd6TKOnS8@1wt.eu>
References: <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <ZATC3djtr9/uPX+P@duo.ucw.cz>
 <ZAewdAql4PBUYOG5@gmail.com>
 <ZAwe95meyCiv6qc4@casper.infradead.org>
 <ZAyK0KM6JmVOvQWy@sashalap>
 <20230311161644.GH860405@mit.edu>
 <ZAy+3f1/xfl6dWpI@sol.localdomain>
 <ZAzH8Ve05SRLYPnR@sashalap>
 <ZAzh7l8qWtkeh/KK@sol.localdomain>
 <ZAzsV5qkfxu3nxjv@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAzsV5qkfxu3nxjv@sashalap>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 11, 2023 at 04:02:15PM -0500, Sasha Levin wrote:
> Maybe I'm putting words in Greg's mouth, but I think we both would
> ideally want to standardize around a single set of tools and scripts,
> it's just the case that both of us started with different set of
> problems we were trying to solve, and so our tooling evolved
> independently.

I'm not even sure this is strictly necessary. When I started jumping
on 2.6 Greg told me "now you have to follow the new process involving
a first preview release", and that completely changed the way I was
dealing with fixes in 2.4. I then tried to adopt Greg's scripts, and
when you do that you instantly figure that different people are at
ease with different parts of the process, and over time I started to
keep a collection of hacked scripts that would simplify certain parts
of the process for me (stuff as stupid as creating directories having
the kernel name in hard-coded paths in my work directory, or converting
the "cherry-picked from" to the "upstream commit" format, etc).

Your biggest difficulty probably is to find people willing and able to
help, and while you should definitely show them your collection of tools
to help them get started, these can also be frightening for newcomers or
possibly not much useful to them if they come from a different background.

Cheers,
Willy
