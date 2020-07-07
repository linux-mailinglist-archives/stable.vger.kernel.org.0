Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95DBA217975
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 22:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbgGGUeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 16:34:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728347AbgGGUeE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 16:34:04 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AA81206E2;
        Tue,  7 Jul 2020 20:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594154044;
        bh=22247wNSUaVMbBxUM4HAY4IX0OgMCfGAtnzOBJT9N5c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EvIgD2qRQFfglKXfInCCRBKgY2It04EIB3ttX9LKmCYvkuqpUU8rpL4QlEI4QrVAN
         vXVo0lvxVpllhYrN0bx4ecHr97N1CMSSE0oB/WfEO0gIhFzvUhgKk3epwL52vbrxHa
         Eq+SwfiLSPFmuF7hrio/XCB2NnIRZXrG7p1vX20c=
Date:   Tue, 7 Jul 2020 13:34:02 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>,
        stable@vger.kernel.org,
        syzbot+4a88b2b9dc280f47baf4@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/6] fs/minix: check return value of sb_getblk()
Message-ID: <20200707203402.GB3426938@gmail.com>
References: <20200628060846.682158-1-ebiggers@kernel.org>
 <20200628060846.682158-2-ebiggers@kernel.org>
 <20200707122612.249699c3f136968dd6782452@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707122612.249699c3f136968dd6782452@linux-foundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 07, 2020 at 12:26:12PM -0700, Andrew Morton wrote:
> On Sat, 27 Jun 2020 23:08:40 -0700 Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > sb_getblk() can fail, so check its return value.
> > 
> > This fixes a NULL pointer dereference.
> > 
> > Reported-by: syzbot+4a88b2b9dc280f47baf4@syzkaller.appspotmail.com
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Cc: stable@vger.kernel.org
> > Originally-from: Qiujun Huang <anenbupt@gmail.com>
> 
> Originally-from: isn't really a thing.  Did the original come with a
> signed-off-by:?
> 

Yes it did.  Qiujun's patch was
https://lkml.kernel.org/lkml/20200323125700.7512-1-hqjagain@gmail.com
But I basically started from scratch anyway and my patch ended up different,
so I didn't leave the original "Author:".  Feel free to adjust the patch.

- Eric
