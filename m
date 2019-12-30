Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91BBE12CD09
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 06:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbfL3Foa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 00:44:30 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42590 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbfL3Foa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Dec 2019 00:44:30 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ilnqf-0005Om-SW; Mon, 30 Dec 2019 05:44:14 +0000
Date:   Mon, 30 Dec 2019 05:44:13 +0000
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
Message-ID: <20191230054413.GX4203@ZenIV.linux.org.uk>
References: <20191230052036.8765-1-cyphar@cyphar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191230052036.8765-1-cyphar@cyphar.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 30, 2019 at 04:20:35PM +1100, Aleksa Sarai wrote:

> A reasonably detailed explanation of the issues is provided in the patch
> itself, but the full traces produced by both the oopses and deadlocks is
> included below (it makes little sense to include them in the commit since we
> are disabling this feature, not directly fixing the bugs themselves).
> 
> I've posted this as an RFC on whether this feature should be allowed at
> all (and if anyone knows of legitimate uses for it), or if we should
> work on fixing these other kernel bugs that it exposes.

Umm...  Are all of those traces
	a) reproducible on mainline and
	b) reproducible as the first oopsen?

As it is, quite a few might be secondary results of earlier memory
corruption...
