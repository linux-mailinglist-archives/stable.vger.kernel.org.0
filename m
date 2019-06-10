Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6EA3B45A
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 14:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389255AbfFJMIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 08:08:10 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:49785 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389229AbfFJMIK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 08:08:10 -0400
X-Greylist: delayed 639 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Jun 2019 08:08:09 EDT
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id x5ABv6k4002979;
        Mon, 10 Jun 2019 13:57:06 +0200
Date:   Mon, 10 Jun 2019 13:57:06 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>,
        Borislav Petkov <bp@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alec Ari <neotheuser@gmail.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 4.9 59/83] Revert "x86/build: Move _etext to actual end
 of .text"
Message-ID: <20190610115706.GA2975@1wt.eu>
References: <20190609164127.843327870@linuxfoundation.org>
 <20190609164132.916806087@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190609164132.916806087@linuxfoundation.org>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 09, 2019 at 06:42:29PM +0200, Greg Kroah-Hartman wrote:
> This reverts commit 392bef709659abea614abfe53cf228e7a59876a4.
> 
> It seems to cause lots of problems when using the gold linker, and no
> one really needs this at the moment, so just revert it from the stable
> trees.

Ah great, I just wrote a report after a build failure upgrading to
4.9.180 due to this one. It fails with older binutils (2.22 for me).
I'm cancelling my e-mail now seeing it's already known :-)

I can try some patches if original authors want to try another variant
of this patch later.

Cheers,
Willy
