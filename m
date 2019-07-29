Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 759B0791DF
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 19:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbfG2RSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 13:18:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:36504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726601AbfG2RSJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 13:18:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2298206BA;
        Mon, 29 Jul 2019 17:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564420688;
        bh=y23elv1xmvtw/E0XxADHx3fIXUIN3hC0WNMRmn8d0iY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UQOQPOIONDlHRZqBbKSk7qeZAOT33ZnkXEnwhQtgV8Z/yHboS52Nayvkik37q2GpR
         W2tb++4djspuR7cVBsP58H899mzUOC5i8rqk2PmDsSzvpzBoLswZjm0dq0D610SOc/
         emkIRQfHpuJd11cdT7QzraVdMxwBI7ai/r1z6/sI=
Date:   Mon, 29 Jul 2019 19:18:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dmitry Safonov <dima@arista.com>
Cc:     baolu.lu@linux.intel.com, dwmw2@infradead.org, joro@8bytes.org,
        jroedel@suse.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] iommu/vt-d: Don't queue_iova() if there
 is no flush queue" failed to apply to 4.9-stable tree
Message-ID: <20190729171806.GA15717@kroah.com>
References: <1564417154125183@kroah.com>
 <15add355-84d9-69f2-8939-adbf430f8e4f@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15add355-84d9-69f2-8939-adbf430f8e4f@arista.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 29, 2019 at 05:50:35PM +0100, Dmitry Safonov wrote:
> Hi Greg,
> 
> On 7/29/19 5:19 PM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> It's not needed for v4.9 stable tree [as pointed by tag's comment line]:
> 
> > Cc: <stable@vger.kernel.org> # 4.14+
> 
> If there is any better way to inform where a commit should be
> backported, please let me know.

That is correct, as this commit (13cf01744608 ("iommu/vt-d: Make use of
iova deferred flushing")) did originally show up in 4.14:
	$ git describe --contains 13cf01744608
v4.14-rc1~72^2^14~3

But, that commit ended up in a stable release, the 4.9.104 release.

Oh.  nope, crap, my fault, my scripts pick up the fact that we refer to
commit 13cf01744608 in a 4.9 commit, but only the fact that it is _not_
in the 4.9.y tree.

Sorry, my fault, scripts are only so good at times.

> I'll send v4.19 -stable patch shortly..
> And will prepare v4.14 patch (as we don't have v4.14 release, I need to
> actually port it).

Thanks for doing the backport, and sorry for the 4.9.y noise, you were
right here, my scripts were wrong.

greg k-h
