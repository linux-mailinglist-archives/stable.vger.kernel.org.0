Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A40BA12E10C
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 00:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbgAAXk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 18:40:26 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59804 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727429AbgAAXk0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jan 2020 18:40:26 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1imnb0-000JcJ-0Q; Wed, 01 Jan 2020 23:40:10 +0000
Date:   Wed, 1 Jan 2020 23:40:09 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Aleksa Sarai <cyphar@cyphar.com>
Cc:     David Howells <dhowells@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
Message-ID: <20200101234009.GB8904@ZenIV.linux.org.uk>
References: <20191230052036.8765-1-cyphar@cyphar.com>
 <20191230054413.GX4203@ZenIV.linux.org.uk>
 <20191230054913.c5avdjqbygtur2l7@yavin.dot.cyphar.com>
 <20191230072959.62kcojxpthhdwmfa@yavin.dot.cyphar.com>
 <20200101004324.GA11269@ZenIV.linux.org.uk>
 <20200101005446.GH4203@ZenIV.linux.org.uk>
 <20200101030815.GA17593@ZenIV.linux.org.uk>
 <20200101144407.ugjwzk7zxrucaa6a@yavin.dot.cyphar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200101144407.ugjwzk7zxrucaa6a@yavin.dot.cyphar.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 02, 2020 at 01:44:07AM +1100, Aleksa Sarai wrote:

> Thanks, this fixes the issue for me (and also fixes another reproducer I
> found -- mounting a symlink on top of itself then trying to umount it).
> 
> Reported-by: Aleksa Sarai <cyphar@cyphar.com>
> Tested-by: Aleksa Sarai <cyphar@cyphar.com>

Pushed into #fixes.

> As for the original topic of bind-mounting symlinks -- given this is a
> supported feature, would you be okay with me sending an updated
> O_EMPTYPATH series?

Post it on fsdevel; I'll need to reread it anyway to say anything useful...
