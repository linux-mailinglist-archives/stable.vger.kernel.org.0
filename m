Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13FCE8FD61
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 10:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbfHPIMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 04:12:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727122AbfHPIMP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Aug 2019 04:12:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B40021655;
        Fri, 16 Aug 2019 08:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565943134;
        bh=5yl8SISuD6M0MkJkW+bqzIjHJWlXPU5dB12YNrXITe8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DbXAw9lBflo993t/+ekxNS8oR4dh0CjzFRrGweM9OgfvZ5kxm+XdOYgSyo9L1Euqb
         2VMS3mNNYgtZgTrFcHBbFrztyxQmW2+n6N+uYpnIzYmiySz6xu+KiZ9yCR6m7S6iAR
         AIvFWOjf8E+Rs1kLzHFxGrBZLNlkmETVZePMOKh0=
Date:   Fri, 16 Aug 2019 10:12:11 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        stable@vger.kernel.org, Mark Ray <mark.ray@hpe.com>
Subject: Re: [PATCH] blk-mq: remove blk_mq_hw_sysfs_cpus
Message-ID: <20190816081211.GA7007@kroah.com>
References: <20190816074849.7197-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190816074849.7197-1-ming.lei@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 16, 2019 at 03:48:49PM +0800, Ming Lei wrote:
> It is reported that sysfs buffer overflow can be triggered in case
> of too many CPU cores(>841 on 4K PAGE_SIZE) when showing CPUs in
> blk_mq_hw_sysfs_cpus_show().
> 
> This info isn't useful, given users may retrieve the CPU list
> from sw queue entries under same kobject dir, so far not see
> any active users.
> 
> So remove the entry as suggested by Greg.
> 
> Cc: stable@vger.kernel.org
> Cc: Mark Ray <mark.ray@hpe.com>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Fixes: 676141e48af7("blk-mq: don't dump CPU -> hw queue map on driver load")
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  block/blk-mq-sysfs.c | 23 -----------------------
>  1 file changed, 23 deletions(-)


Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
