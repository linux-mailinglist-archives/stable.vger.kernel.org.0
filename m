Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD0B134025
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 12:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbgAHLRt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 06:17:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:56124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728108AbgAHLRs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jan 2020 06:17:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58CE92087F;
        Wed,  8 Jan 2020 11:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578482267;
        bh=hgXupPARz/+WnBXYCcpMWO+F+6Ku0DuxSLKFEnmHNJY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qWRpWd7p9wbwOeGEwLV3cKQmbG2hxEowBBRoJCSu91ZMbE60iXSaDwmlbE7qy4lG6
         gPeobkVj+FS2z1tr8idDKrkRGran/PY2Vz3FHoDM2Gq8n6KvvuUDakGrGxxplUyXx/
         GZLz9orm/rmULaz8Gj8rxOoh6bg9YrJQAJhYk7N0=
Date:   Wed, 8 Jan 2020 11:47:55 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        syzbot+fb77e97ebf0612ee6914@syzkaller.appspotmail.com,
        Kees Cook <keescook@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 040/115] drm: limit to INT_MAX in create_blob ioctl
Message-ID: <20200108104755.GA2338370@kroah.com>
References: <20200107205240.283674026@linuxfoundation.org>
 <20200107205301.771918206@linuxfoundation.org>
 <20200108081148.GC619@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200108081148.GC619@amd>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 08, 2020 at 09:11:48AM +0100, Pavel Machek wrote:
> On Tue 2020-01-07 21:54:10, Greg Kroah-Hartman wrote:
> > From: Daniel Vetter <daniel.vetter@ffwll.ch>
> > 
> > [ Upstream commit 5bf8bec3f4ce044a223c40cbce92590d938f0e9c ]
> > 
> > The hardened usercpy code is too paranoid ever since commit 6a30afa8c1fb
> > ("uaccess: disallow > INT_MAX copy sizes")
> 
> > Code itself should have been fine as-is.
> > 
> > Link: http://lkml.kernel.org/r/20191106164755.31478-1-daniel.vetter@ffwll.ch
> > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > Reported-by: syzbot+fb77e97ebf0612ee6914@syzkaller.appspotmail.com
> > Fixes: 6a30afa8c1fb ("uaccess: disallow > INT_MAX copy sizes")
> 
> There is no such thing as commit 6a30afa8c1fb. Apparently this is
> talking about commit "6d13de1489b6bf539695f96d945de3860e6d5e17", but
> that one is not in 4.19-stable.
> 
> Do we need this in 4.19-stable?

Yes.
