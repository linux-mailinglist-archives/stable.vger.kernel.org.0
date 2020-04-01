Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC67419B4F4
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 19:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727723AbgDARzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 13:55:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726974AbgDARzl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 13:55:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBCE720719;
        Wed,  1 Apr 2020 17:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585763741;
        bh=PO+CfaeLhp/aOikVQUgrnUs0hXxuqGk+YncI5MT0P5E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vCEqsYQLpNmyFJNh7P9xl/B6g5mpj8GmjYy6ekQLVAtfZFs6S/PXSOC5JkD2fFKwE
         981shgS/HaDBKKTx32mkSFl/zROxHYqgxoAz4EBHxNGfpNaSE+H5C1FIlAzve/0Zrw
         TKZZxiB0mFGEkeLz7+8+SYdCd3MJ246V5UeoiD3w=
Date:   Wed, 1 Apr 2020 19:55:37 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Giuliano Procida <gprocida@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: backport request for use-after-free blk_mq_queue_tag_busy_iter
Message-ID: <20200401175537.GC2586614@kroah.com>
References: <CAGvU0HkVUE_mQY8AUjieRcRrD38gdJRE+CbDuenMxnU6DAFOSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGvU0HkVUE_mQY8AUjieRcRrD38gdJRE+CbDuenMxnU6DAFOSA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 01, 2020 at 05:47:02PM +0000, Giuliano Procida wrote:
> This issue was found in 4.14 and is present in earlier kernels.
> 
> Please backport
> 
> f5bbbbe4d635 blk-mq: sync the update nr_hw_queues with
> blk_mq_queue_tag_busy_iter
> 530ca2c9bd69 blk-mq: Allow blocking queue tag iter callbacks
> 
> onto the stable branches that don't have these. The second is a fix
> for the first. Thank you.
> 
> 4.19.y and later - commits already present
> 4.14.y - f5bbbbe4d635 doesn't patch cleanly but it's still
> straightforward, just drop the comment and code mentioning switching
> to 'none' in the trailing context
> 4.9.y - ditto
> 4.4.y - there was a refactoring of the code in commit
> 0bf6cd5b9531bcc29c0a5e504b6ce2984c6fd8d8 making this non-trivial
> 3.16.y - ditto
> 
> I am happy to try to produce clean patches, but it may be a day or so.

Clean patches would be good, as there are -rcs out right now so I can't
do anything until they are released in a few days.

thanks,

greg k-h
