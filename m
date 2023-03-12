Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4C96B6325
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 05:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbjCLEcv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 23:32:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCLEcu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 23:32:50 -0500
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 413A6410A6;
        Sat, 11 Mar 2023 20:32:49 -0800 (PST)
Received: (from willy@localhost)
        by mail.home.local (8.17.1/8.17.1/Submit) id 32C4WWwc032722;
        Sun, 12 Mar 2023 05:32:32 +0100
Date:   Sun, 12 Mar 2023 05:32:32 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <ZA1V4MbG6U3wP6q6@1wt.eu>
References: <ZATC3djtr9/uPX+P@duo.ucw.cz>
 <ZAewdAql4PBUYOG5@gmail.com>
 <ZAwe95meyCiv6qc4@casper.infradead.org>
 <ZAyK0KM6JmVOvQWy@sashalap>
 <20230311161644.GH860405@mit.edu>
 <ZAy+3f1/xfl6dWpI@sol.localdomain>
 <ZAzJltJaydwjCN6E@1wt.eu>
 <ZAzVbzthi8IfptFZ@sol.localdomain>
 <ZAzghyeiac3Zh8Hh@1wt.eu>
 <ZAzqSeus4iqCOf1O@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAzqSeus4iqCOf1O@sol.localdomain>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 11, 2023 at 12:53:29PM -0800, Eric Biggers wrote:
> I'll try to put something together, despite all the pushback I'm getting.

Thanks.

> But
> by necessity it will be totally separate from the current stable scripts, as it
> seems there is no practical way for me to do it otherwise,

It's better that way anyway. Adding diversity to the process is important
if we want to experiment with multiple approaches. What matters is to
have multiple inputs on list of patches.

> given that the
> current stable process is not properly open and lacks proper leadership.

Please, really please, stop looping on this. I think it was already
explained quite a few times that the process is mostly human, and that
it's very difficult to document what has to be done. It's a lot of work
based on common sense, intuition and experience which helps solving each
an every individual case. The scripts that help are public, the rest is
just experience. It's not fair to say that some people do not follow an
open process while they're using their experience and intuition. They're
not machines.

Thanks,
Willy
