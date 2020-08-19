Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7BEA24A0A4
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 15:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbgHSNwq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 09:52:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728119AbgHSNwo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 09:52:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E52AA204FD;
        Wed, 19 Aug 2020 13:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597845164;
        bh=AQXzKeWBzvXuVHP0MSrtfWDISiuU6TUZIMZ8zROumpw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JN2/g/ZWkXZoAuGV9Ujxlhmw6Buse9YPnU1sz5WJSYoChoH/s1Ejv0PZPVbwr6bDJ
         uabxrP+lM7z2fXeLub28JY/RgWZhAnYTlT8PiQlZa1RRf9X6LmECEezGRCF5+fVwtG
         6MiiLmp/TraVNkpmD0OGWNhxwjRdNcZlufo/yCj8=
Date:   Wed, 19 Aug 2020 15:53:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     aarcange@redhat.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com,
        songliubraving@fb.com, torvalds@linux-foundation.org,
        stable-commits@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Patch "khugepaged: khugepaged_test_exit() check
 mmget_still_valid()" has been added to the 5.8-stable tree
Message-ID: <20200819135306.GA3311904@kroah.com>
References: <1597841669128213@kroah.com>
 <alpine.LSU.2.11.2008190625060.24442@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.2008190625060.24442@eggly.anvils>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 19, 2020 at 06:32:26AM -0700, Hugh Dickins wrote:
> On Wed, 19 Aug 2020, gregkh@linuxfoundation.org wrote:
> > 
> > This is a note to let you know that I've just added the patch titled
> > 
> >     khugepaged: khugepaged_test_exit() check mmget_still_valid()
> > 
> > to the 5.8-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >      khugepaged-khugepaged_test_exit-check-mmget_still_valid.patch
> > and it can be found in the queue-5.8 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> 
> Please hold this one back for the moment: we shall want it, but syzbot
> detected one place where it can lead to a VM_BUG_ON_MM().  The fix to
> that is currently in Andrew's tree, but not yet in Linus's - when it
> gets there, I'll send you its git commit id in reply to this mail.
> 
> This patch failed to apply to earlier releases: I'll send the fixup for
> those at that time.  (Fixups for another patch to follow later today.)

Now dropped, thanks!

greg k-h
