Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E63781210
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 08:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbfHEGC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 02:02:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725951AbfHEGC1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 02:02:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B36B206C1;
        Mon,  5 Aug 2019 06:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564984945;
        bh=yQX7YAlJ45FZwBgTl9rdH0N9X0UpxWT3t+wfvZobwSM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zSXgYL75mNTG7YL12V8C5eDoiC89Hf9Kaiia7s6JjkSUHCF3x6/Ak018i3ohQQ3O1
         C+6GAAKghAvtLBKxUDxhRUd0DUmvkM7dGI43mf/Q1DPFk7szO3cfjFWxrD2gdHXb7D
         6dlcetc0SFH7Yf9LWrJm/9N7xnUQ/WeVSCP7gH38=
Date:   Mon, 5 Aug 2019 08:02:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ajay Kaher <akaher@vmware.com>
Cc:     aarcange@redhat.com, jannh@google.com, oleg@redhat.com,
        peterx@redhat.com, rppt@linux.ibm.com, jgg@mellanox.com,
        mhocko@suse.com, srinidhir@vmware.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        amakhalov@vmware.com, sean.hefty@intel.com, srivatsa@csail.mit.edu,
        srivatsab@vmware.com, devel@driverdev.osuosl.org,
        linux-rdma@vger.kernel.org, bvikas@vmware.com, dledford@redhat.com,
        riandrews@android.com, hal.rosenstock@gmail.com,
        vsirnapalli@vmware.com, leonro@mellanox.com, jglisse@redhat.com,
        viro@zeniv.linux.org.uk, yishaih@mellanox.com, matanb@mellanox.com,
        stable@vger.kernel.org, arve@android.com,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, mike.kravetz@oracle.com
Subject: Re: [PATCH v6 0/3] [v4.9.y] coredump: fix race condition between
 mmget_not_zero()/get_task_mm() and core dumping
Message-ID: <20190805060223.GA4947@kroah.com>
References: <1564891168-30016-1-git-send-email-akaher@vmware.com>
 <1564891168-30016-4-git-send-email-akaher@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564891168-30016-4-git-send-email-akaher@vmware.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 04, 2019 at 09:29:28AM +0530, Ajay Kaher wrote:
> coredump: fix race condition between mmget_not_zero()/get_task_mm()
> and core dumping
> 
> [PATCH v5 1/3]:
> Backporting of commit 04f5866e41fb70690e28397487d8bd8eea7d712a upstream.
> 
> [PATCH v5 2/3]:
> Extension of commit 04f5866e41fb to fix the race condition between
> get_task_mm() and core dumping for IB->mlx4 and IB->mlx5 drivers.
> 
> [PATCH v5 3/3]
> Backporting of commit 59ea6d06cfa9247b586a695c21f94afa7183af74 upstream.
> 
> [diff from v5]:
> - Recreated [PATCH v6 1/3], to solve patch apply error.

Now queued up, let's see what breaks :)

thanks,

greg k-h
