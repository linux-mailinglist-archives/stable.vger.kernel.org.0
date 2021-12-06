Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A808A46AA11
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243604AbhLFVXT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:23:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350387AbhLFVXT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:23:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A16C0613F8;
        Mon,  6 Dec 2021 13:19:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dOFxYCtm3wUSPpVE0rq2J6M8PSW2ZRyy5Qu839JhE0Q=; b=BQfv1I/2cQtmvYRtpwwCJHkU9l
        uLCZjMOsDgm5+QGw+B8Mz0u8MveBqqK06IolC2eY03Jiv6Irwu7SXGT0HE4LwlOsBnLg2mHycTlVc
        qmKWuj4XJpteN3ihBvH+AioLT7ghsSwa3oLvgGX62QemiRFv9vUFyj3XtMRQ4BGp6S9JLdqiTrMUX
        HHpgMQ9HhIkKEGBJgkzF+N4gsrJmgDHr5DfuQNdn8a3U+Zhha5N/DwaxioP0/X+XSqSDysGUXpHtp
        V0GS/vIN35BsnBPuOkQotNz1vRHE/FsonXJzMSHF1DRoWg/RXLUxxNYmZWWFqobVVbRrkIhp81znV
        AiTQwVvg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1muLOk-006GvQ-VR; Mon, 06 Dec 2021 21:19:47 +0000
Date:   Mon, 6 Dec 2021 21:19:46 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.15 13/24] tools: Fix math.h breakage
Message-ID: <Ya5+ckVw3ZYjdNDJ@casper.infradead.org>
References: <20211206211230.1660072-1-sashal@kernel.org>
 <20211206211230.1660072-13-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206211230.1660072-13-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 06, 2021 at 04:12:18PM -0500, Sasha Levin wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> [ Upstream commit d6e6a27d960f9f07aef0b979c49c6736ede28f75 ]
> 
> Commit 98e1385ef24b ("include/linux/radix-tree.h: replace kernel.h with
> the necessary inclusions") broke the radix tree test suite in two
> different ways; first by including math.h which didn't exist in the
> tools directory, and second by removing an implicit include of
> spinlock.h before lockdep.h.  Fix both issues.

I'm confused.  Was 98e1385ef24b backported to v5.15?  I don't see it
in linux-5.15.y, and I don't know why it would be considered a stable
backport candidate.  If not, why would this patch be needed?
