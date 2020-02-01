Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF5914FA2F
	for <lists+stable@lfdr.de>; Sat,  1 Feb 2020 20:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgBATZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Feb 2020 14:25:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:44370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbgBATZP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Feb 2020 14:25:15 -0500
Subject: Re: [GIT PULL] small SMB3 fix for stable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580585114;
        bh=7IeGbr88xPxfAlsmvZYtOueWgWLzVV8Rhk3GwYQGS8k=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=VPibsYMCguCX74umyl2gdMFwI1ZwtO77Hc0F0PfZeN3lk4hJNknvkP6RLMPKEcQZ1
         Q53KnRiFnUEhMDGCs+UQk+62Dv6uLNDb3AEPXCqGXlVHtzwBI3RHJgSq/e/wbG/8a2
         Xedsj3631A2tkBiPWJzvSkdzX1cL+NFd8HpAHoj8=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mt-Q1_ZBJmC+8jr5gJhr-NmUGG933y0gc+_1DVWTJUVZQ@mail.gmail.com>
References: <CAH2r5mt-Q1_ZBJmC+8jr5gJhr-NmUGG933y0gc+_1DVWTJUVZQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mt-Q1_ZBJmC+8jr5gJhr-NmUGG933y0gc+_1DVWTJUVZQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git
 tags/5.6-rc-small-smb3-fix-for-stable
X-PR-Tracked-Commit-Id: b581098482e6f177a4f64ea021fd5a9327ea08d5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 94f2630b18975bb56eee5d1a36371db967643479
Message-Id: <158058511480.16683.1703962010950781039.pr-tracker-bot@kernel.org>
Date:   Sat, 01 Feb 2020 19:25:14 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Stable <stable@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The pull request you sent on Sat, 1 Feb 2020 12:40:31 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.6-rc-small-smb3-fix-for-stable

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/94f2630b18975bb56eee5d1a36371db967643479

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
