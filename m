Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3424558F1E
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 02:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfF1ApD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 20:45:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbfF1ApD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Jun 2019 20:45:03 -0400
Subject: Re: [GIT PULL] AFS fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561682702;
        bh=wE0WyHlTV0mNFSx7vHFnmAbdh3OFAI5S95W9IoLnzwQ=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=mmrJ42WJWxkbmjyEzMbJGn/wMGMpym3AHje9aTVOlvqffCPfjQMAYQXaAPV+nHLrs
         CllDqABAQFb511GeQpfqGPBmTeKoeWA8GFXl0mayjINf8fiJ27SMpftfk9uBM+o8aG
         bY0d2In+WBppgENCe9lhA2bSzOZvXxzFuPd+TI+o=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <11571.1561556393@warthog.procyon.org.uk>
References: <11571.1561556393@warthog.procyon.org.uk>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <11571.1561556393@warthog.procyon.org.uk>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
 tags/afs-fixes-20190620
X-PR-Tracked-Commit-Id: 2cd42d19cffa0ec3dfb57b1b3e1a07a9bf4ed80a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cd0f3aaebc5b17e0ccb1b9ef9ae43042d075d767
Message-Id: <156168270234.1895.4402791272691293668.pr-tracker-bot@kernel.org>
Date:   Fri, 28 Jun 2019 00:45:02 +0000
To:     David Howells <dhowells@redhat.com>
Cc:     torvalds@linux-foundation.org, dhowells@redhat.com,
        iwienand@redhat.com, linux-afs@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The pull request you sent on Wed, 26 Jun 2019 14:39:53 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/afs-fixes-20190620

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cd0f3aaebc5b17e0ccb1b9ef9ae43042d075d767

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
