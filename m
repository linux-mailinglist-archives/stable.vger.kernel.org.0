Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 012582C688D
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 16:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730487AbgK0PPQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 10:15:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:46626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730443AbgK0PPQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Nov 2020 10:15:16 -0500
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D1B022240;
        Fri, 27 Nov 2020 15:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606490116;
        bh=vJAr0hxztQGeWyx7dqFwxGzLl4IL+hZOUOvxW5TKA80=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xJzeg6IBoRoghrYPouFkyfBjlHsUJ/3U4oIBbUtIgR8OCIPxN2SUUjthLw+tLr0Mk
         PMI55rh0MOgjaVp8aJdmZbP4MD7SdmjH0Y77n56buqkIg0RIs9XBh13fb44Lfn2xF5
         XjfmfG15dJVe4v9Zc4YIM1REpTOUQueAnxytnPC4=
Date:   Fri, 27 Nov 2020 16:15:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        Yoon Jungyeon <jungyeon@gatech.edu>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Su Yue <suy.fnst@cn.fujitsu.com>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: few missing fixes for 4.14-stable
Message-ID: <X8EYAR+hSif7u8vW@kroah.com>
References: <20201127111117.dgvegz3h53rqjsgz@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127111117.dgvegz3h53rqjsgz@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 27, 2020 at 11:11:17AM +0000, Sudip Mukherjee wrote:
> Hi Greg, Sasha,
> 
> These were missing in 4.14-stable. Please apply to your queue.
> 
> 80e46cf22ba0 ("btrfs: tree-checker: Enhance chunk checker to validate chunk profile")
> 005d67127fa9 ("btrfs: adjust return values of btrfs_inode_by_name")
> 6bf9e4bd6a27 ("btrfs: inode: Verify inode mode to avoid NULL pointer dereference")
> 
> The second one in only needed to make the backporting of third easier.

Now queued up, thanks.

gre gk-h
