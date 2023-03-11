Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 070936B6076
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 21:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjCKUUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 15:20:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCKUUG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 15:20:06 -0500
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 912062A155;
        Sat, 11 Mar 2023 12:20:05 -0800 (PST)
Received: (from willy@localhost)
        by mail.home.local (8.17.1/8.17.1/Submit) id 32BKJs0Z030455;
        Sat, 11 Mar 2023 21:19:54 +0100
Date:   Sat, 11 Mar 2023 21:19:54 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <ZAzianzvIOUrH5pr@1wt.eu>
References: <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <ZATC3djtr9/uPX+P@duo.ucw.cz>
 <ZAewdAql4PBUYOG5@gmail.com>
 <ZAwe95meyCiv6qc4@casper.infradead.org>
 <ZAyK0KM6JmVOvQWy@sashalap>
 <20230311161644.GH860405@mit.edu>
 <ZAy+3f1/xfl6dWpI@sol.localdomain>
 <ZAzJltJaydwjCN6E@1wt.eu>
 <ZAzVbzthi8IfptFZ@sol.localdomain>
 <ZAzafagDchRQRxWi@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAzafagDchRQRxWi@sol.localdomain>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 11, 2023 at 11:46:05AM -0800, Eric Biggers wrote:
> (And please note, the key word here is *confidence*.  We all agree that it's
> never possible to be absolutely 100% sure whether a commit is appropriate for
> stable or not.  That's a red herring.

In fact even developers themselves sometimes don't know, and even when they
know, sometimes they know after committing it. Many times we've found that
a bug was accidently resolved by a small change. Just for this it's important
to support a post-merge analysis.

> And I would assume, or at least hope, that the neural network thing being used
> for AUTOSEL outputs a confidence rating and not just a yes/no answer.  If it
> actually just outputs yes/no, well how is anyone supposed to know that and fix
> that, given that it does not seem to be an open source project?)

Honestly I don't know. I ran a few experiments with natural language
processors such as GPT-3 on commit messages which contained human-readable
instructions, and asking "what am I expected to do with these patches", and
seeing the bot respond "you should backport them to this version, change
this and that in that version, and preliminary take that patch". It
summarized extremely well the instructions delivered by the developer,
which is awesome, but was not able to provide any form of confidence
level. I don't know what Sasha uses but wouldn't be surprised it shares
some such mechanisms and that it might not always be easy to get such a
confidence level. But I could be wrong.

Willy
