Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D153CD9C6A
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 23:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389501AbfJPVWQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:22:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729231AbfJPVWP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:22:15 -0400
Received: from localhost (li1825-44.members.linode.com [172.104.248.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2E9820854;
        Wed, 16 Oct 2019 21:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571260934;
        bh=6mK5YCbfjzFVY9oG95xIFjMmJYQk8hRst7Q+kvJXpAU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HMeXROgjdnX2bl8YNmwdBqaG/ek87rVzBQjoF/LIJOubicX+HrsF8o2iQ6d3Yzoho
         0r1qN0Qn4SNB+WeEvsNkHCU+QM2eBB++RYp0dWSmBxCUdvBfIGnFa3Nd5y5TxCwWuS
         4vtUvm5p03xbGV5jA1q4ddl4vtZcRVPJppC36w8k=
Date:   Wed, 16 Oct 2019 14:22:09 -0700
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ajay Kaher <akaher@vmware.com>
Cc:     "dchinner@redhat.com" <dchinner@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Steven Rostedt <srostedt@vmware.com>,
        Srivatsa Bhat <srivatsab@vmware.com>,
        "srivatsa@csail.mit.edu" <srivatsa@csail.mit.edu>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Srinidhi Rao <srinidhir@vmware.com>,
        Vikash Bansal <bvikas@vmware.com>,
        Anish Swaminathan <anishs@vmware.com>,
        Vasavi Sirnapalli <vsirnapalli@vmware.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [4.9.y PATCH] xfs: clear sb->s_fs_info on mount failure
Message-ID: <20191016212209.GE856391@kroah.com>
References: <1569965031-30745-1-git-send-email-akaher@vmware.com>
 <20191008174758.GA3013565@kroah.com>
 <F4C3D25C-A8FC-4A31-8CC2-1ABBA6CDF1C1@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <F4C3D25C-A8FC-4A31-8CC2-1ABBA6CDF1C1@vmware.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 09, 2019 at 05:54:36PM +0000, Ajay Kaher wrote:
> 
> 
> ﻿On 08/10/19, 11:18 PM, "Greg KH" <gregkh@linuxfoundation.org> wrote:
> 
> > On Wed, Oct 02, 2019 at 02:53:51AM +0530, Ajay Kaher wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > commit c9fbd7bbc23dbdd73364be4d045e5d3612cf6e82 upstream.
>     
> > You have sent a 4.4.y and 4.9.y, but what about 4.14.y?  I can't take
> > this patch for the older kernels without a 4.14.y patch, sorry.  We
> > don't want anyone to upgrade and then hit a fixed bug.
> 
> Sent for 4.14.y as well. Thanks for specifying about 4.14.y for this patch.

Thanks for that, now queued up for all 3 trees.

greg k-h
