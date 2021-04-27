Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D12136C763
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 15:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236173AbhD0N6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 09:58:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236074AbhD0N6D (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Apr 2021 09:58:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B61A161185;
        Tue, 27 Apr 2021 13:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619531839;
        bh=KRTJMygiwaqRkkL2+r2JI2hKSCPlirPvmGAa2Rq/VNc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WWi6KY1lz8i8x7s0FqjcvpYPMEFwI4VSAvr/vFtJIz6tzAO5fWR/yjr/Yl8LzjPqQ
         Hj7NBGAOhIysaQgCrbzzrKfk1KbbIoa1bp3hnW3XS/D0/hFJ/vaZcfH403dykYZeFS
         ngR8IDE1HhLG3N1WMMW9WXhtfxqi0lL6gYG+GYfY=
Date:   Tue, 27 Apr 2021 15:57:16 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     linux-kernel@vger.kernel.org, Wenwen Wang <wang6495@umn.edu>,
        stable@vger.kernel.org
Subject: Re: [PATCH 187/190] Revert "ALSA: control: fix a redundant-copy
 issue"
Message-ID: <YIgYPJppESvcLbLY@kroah.com>
References: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
 <20210421130105.1226686-188-gregkh@linuxfoundation.org>
 <s5h5z0fa9dc.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h5z0fa9dc.wl-tiwai@suse.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 21, 2021 at 06:30:07PM +0200, Takashi Iwai wrote:
> On Wed, 21 Apr 2021 15:01:02 +0200,
> Greg Kroah-Hartman wrote:
> > 
> > This reverts commit 3f12888dfae2a48741c4caa9214885b3aaf350f9.
> > 
> > Commits from @umn.edu addresses have been found to be submitted in "bad
> > faith" to try to test the kernel community's ability to review "known
> > malicious" changes.  The result of these submissions can be found in a
> > paper published at the 42nd IEEE Symposium on Security and Privacy
> > entitled, "Open Source Insecurity: Stealthily Introducing
> > Vulnerabilities via Hypocrite Commits" written by Qiushi Wu (University
> > of Minnesota) and Kangjie Lu (University of Minnesota).
> > 
> > Because of this, all submissions from this group must be reverted from
> > the kernel tree and will need to be re-reviewed again to determine if
> > they actually are a valid fix.  Until that work is complete, remove this
> > change to ensure that no problems are being introduced into the
> > codebase.
> > 
> > Cc: Wenwen Wang <wang6495@umn.edu>
> > Cc: <stable@vger.kernel.org>
> > Cc: Takashi Iwai <tiwai@suse.de>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This one is, unlike other patches I've been involved with, about the
> ALSA core code, and this change is likely worth to keep.
> 
> The code change is correct, and even though it's really a minor issue,
> an optimization is right.

Thanks for the review, now dropped.

greg k-h
