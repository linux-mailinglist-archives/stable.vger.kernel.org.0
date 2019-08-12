Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0490A896CC
	for <lists+stable@lfdr.de>; Mon, 12 Aug 2019 07:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbfHLF1e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Aug 2019 01:27:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbfHLF1e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Aug 2019 01:27:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D9232085A;
        Mon, 12 Aug 2019 05:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565587653;
        bh=+pYvhMir7f71+jVd0MPtu4CXHkUFs2h4DLeAo4o9j98=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pgYqpaiMvPmFTGYBOpCwMLxqMLXRz+0l3AIjUZjI8iOEvdIU1SA9tiYmuWSK5X32Z
         bdEnsu0KGVpCCPaDvtjcsgjoDnY4L5UKn7BzuoI8jMNrrGV1CJEgoWmIeLOEjDb03J
         SXJ+iME33jfm50CJhkbnkkJ5l90gz32AAbIoqhWc=
Date:   Mon, 12 Aug 2019 07:27:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Coly Li <colyli@suse.de>
Cc:     alexandru.ardelean@analog.com, axboe@kernel.dk, pflin@suse.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] bcache: Revert "bcache: use
 sysfs_match_string() instead of" failed to apply to 5.2-stable tree
Message-ID: <20190812052730.GA8988@kroah.com>
References: <156553570618483@kroah.com>
 <81d2423d-74dd-50ba-4a33-05306a1b13dd@suse.de>
 <20190811160959.GA8117@kroah.com>
 <005a245a-1ac5-f5f5-506c-995c003e5912@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <005a245a-1ac5-f5f5-506c-995c003e5912@suse.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 12, 2019 at 01:04:24PM +0800, Coly Li wrote:
> On 2019/8/12 12:09 上午, Greg KH wrote:
> > On Sun, Aug 11, 2019 at 11:41:57PM +0800, Coly Li wrote:
> >> On 2019/8/11 11:01 下午, gregkh@linuxfoundation.org wrote:
> >>>
> >>> The patch below does not apply to the 5.2-stable tree.
> >>> If someone wants it applied there, or to any other stable or longterm
> >>> tree, then please email the backport, including the original git commit
> >>> id to <stable@vger.kernel.org>.
> >>>
> >>> thanks,
> >>>
> >>> greg k-h
> >>
> >> Hi Greg,
> >>
> >> I will post a rebased patch for the 5.2-stable tree.
> > 
> > Is it really needed?
> > 
> > I ask because in the patch it says:
> > 
> >>> This bug was introduced in Linux v5.2, so this fix only applies to
> >>> Linux v5.2 is enough for stable tree maintainer.
> >>>
> >>> Fixes: 89e0341af082 ("bcache: use sysfs_match_string() instead of __sysfs_match_string()")
> 
> Hi Greg,
> 
> > 
> > But commit 89e0341af082 showed up in 5.3-rc1, not 5.2.
> > 
> > So why is this needed in 5.2.y?
> 
> Indeed I was not sure which version this patch was merged, so I ran,
> > git describe 89e0341af082
> v5.2-rc4-245-g89e0341af082
> 
> It seems I use git in an incorrect way. After check man git-describe I
> see '--contains' should be added (to find a tag which after/contains the
> commit),
> > git describe --contains 89e0341af082
> v5.3-rc1~164^2~57
> 
> Yes, the fixing bug is from v5.3-rc1. Please ignore the noise....

No problem, thanks for the confirmation.

greg k-h
