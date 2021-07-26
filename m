Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E9E3D52CC
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 07:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbhGZEmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 00:42:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229580AbhGZEmN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 00:42:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73BDB60E78;
        Mon, 26 Jul 2021 05:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627276961;
        bh=7VuNE40SapuFirvo2iFJbgsIEjfS892Eh8/ky0HWcYc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f7vnW0oRBpZbBvtsN2bbB7Hn3LlIFpY6jzSacS2zsAqaSATXkc43cqsLDZgh3kAqJ
         R4lcTfnFd0VZ3X5vBsxo35mYL3hw8AW+aHNIIdCwoWwRg8d5Fn6IOjDPGzzONFzihN
         r8xFpHOi8OARCV3neT5LSb562w0ATzc8lOTuDHIA=
Date:   Sun, 25 Jul 2021 22:22:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     bugs+kernel.org@dtnr.ch, dhowells@redhat.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject: Re: [patch 15/15] hugetlbfs: fix mount mode command line processing
Message-Id: <20210725222240.61b3c7b27724efa93414ac7e@linux-foundation.org>
In-Reply-To: <YPtv4E6Y/L1aGlK9@zeniv-ca.linux.org.uk>
References: <20210723154926.c6cda0f262b1990b950a5886@linux-foundation.org>
        <20210723225044.DpiHGbzxj%akpm@linux-foundation.org>
        <YPtv4E6Y/L1aGlK9@zeniv-ca.linux.org.uk>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 24 Jul 2021 01:41:52 +0000 Al Viro <viro@zeniv.linux.org.uk> wrote:

> On Fri, Jul 23, 2021 at 03:50:44PM -0700, Andrew Morton wrote:
> > From: Mike Kravetz <mike.kravetz@oracle.com>
> > Subject: hugetlbfs: fix mount mode command line processing
> > 
> > In commit 32021982a324 ("hugetlbfs: Convert to fs_context") processing of
> > the mount mode string was changed from match_octal() to fsparam_u32.  This
> > changed existing behavior as match_octal does not require octal values to
> > have a '0' prefix, but fsparam_u32 does.
> > 
> > Use fsparam_u32oct which provides the same behavior as match_octal.
> 
> Looks sane...  Which tree do you want it to go through?

It's now in mainline, with cc:stable, Fixes: 32021982a324.
