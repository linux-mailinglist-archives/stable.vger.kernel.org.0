Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0FE951AB
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 01:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbfHSXfI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 19:35:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728351AbfHSXfH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Aug 2019 19:35:07 -0400
Subject: Re: [GIT PULL] signal: Allow cifs and drbd to receive their
 terminating signals
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566257707;
        bh=1GTf0DUmCNG7jWtw7ITXRRhv6CDLU7nXtAtPg8JJq78=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=QGLIacvFvQcMzDzL6cBTrvM2O2n93EVNCmGdpsWOVaeQXnefhh6fFuy0gLfcmtEP6
         p/utnwOz3U1hcQ1EBfxkyo9WLjroDXXwvm65Hm4Rk740GbvL4PPaekfjgoUTfIIdp8
         GJUhy9gyl3SA7KH4EjOgXScfwFN5VCBOuKirr6+Q=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <87ftlwke3u.fsf_-_@xmission.com>
References: <20190729083248.30362-1-christoph.boehmwalder@linbit.com>
 <1761552.9xIroHqhk7@fat-tyre>
 <1fcbb94c5f264c17af3394807438ad50@AcuMS.aculab.com>
 <2789113.VEJ2NpTmzX@fat-tyre> <87k1bclpmt.fsf_-_@xmission.com>
 <20190819083759.73ee5zct4yxbyyfd@gintonic.linbit>
 <87ftlwke3u.fsf_-_@xmission.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <87ftlwke3u.fsf_-_@xmission.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git
 siginfo-linus
X-PR-Tracked-Commit-Id: 33da8e7c814f77310250bb54a9db36a44c5de784
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 287c55ed7df531c30f7a5093120339193dc7f166
Message-Id: <156625770729.9031.17087152821165802570.pr-tracker-bot@kernel.org>
Date:   Mon, 19 Aug 2019 23:35:07 +0000
To:     ebiederm@xmission.com (Eric W. Biederman)
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        David Laight <David.Laight@aculab.com>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Jeff Layton <jlayton@primarydata.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Christoph =?utf-8?Q?B=C3=B6hmwalder?= 
        <christoph.boehmwalder@linbit.com>, Oleg Nesterov <oleg@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The pull request you sent on Mon, 19 Aug 2019 17:03:01 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git siginfo-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/287c55ed7df531c30f7a5093120339193dc7f166

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
