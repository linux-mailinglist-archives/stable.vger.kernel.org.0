Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC1A014C4AF
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 03:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgA2CpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 21:45:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:60756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726346AbgA2CpF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 21:45:05 -0500
Subject: Re: [GIT PULL][PATCH] tracing/kprobes: Have uname use __get_str() in
 print_fmt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580265905;
        bh=AT0h+mnfFFcJ/JNRcIWbcJaljJIc1TSno9x3KbxAA+8=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=FXcFlxuJ9/Pfq2SHdVrBU8rbMfBsGYV+rsbkdXZwDbZSNJp/Ez4dEamWEKn82vmzH
         Z+xljXEqBkbVBcYkvzomEWJe3eZbWVDHPuAMd3EIW4SPjHmQxioSRgt0l2KMDfyw4Y
         rbq08MXKMaI0ONe3hSltZkIzTUEvOlvUahotPmtQ=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200127110449.512c13a1@gandalf.local.home>
References: <20200127110449.512c13a1@gandalf.local.home>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200127110449.512c13a1@gandalf.local.home>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
 trace-v5.5-rc7
X-PR-Tracked-Commit-Id: 20279420ae3a8ef4c5d9fedc360a2c37a1dbdf1b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a78416d97425551b6790dc56626ac5c87415f3fc
Message-Id: <158026590524.23129.16214822288417115433.pr-tracker-bot@kernel.org>
Date:   Wed, 29 Jan 2020 02:45:05 +0000
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Thomas Richter <tmricht@linux.ibm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The pull request you sent on Mon, 27 Jan 2020 11:04:49 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git trace-v5.5-rc7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a78416d97425551b6790dc56626ac5c87415f3fc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
