Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 895E451C31
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 22:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730440AbfFXUVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 16:21:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbfFXUVw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 16:21:52 -0400
Received: from localhost (unknown [167.220.24.221])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6755E20645;
        Mon, 24 Jun 2019 20:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561407711;
        bh=/rV1TlvYuXOK2sFci2/p6W21rW/APz4/kUsj3EobUV4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2VPaEOiYLx/B1U7xl+3URPJW/PCnea+Hoo4lmR8kq/6n244//CX5FcosNOr1Dj3oq
         kZ/WOwKR+mt0aTbDmzXkGDY61uNn7Pw8n0E1ZmPY1FmKSwRlrgS69rOqWLgsC9nNQT
         I7qwRnBg2lc/TFX9Q7IzCpvfO5IQUktLdI8ucdSE=
Date:   Mon, 24 Jun 2019 16:21:50 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ajay Kaher <akaher@vmware.com>
Cc:     aarcange@redhat.com, jannh@google.com, oleg@redhat.com,
        peterx@redhat.com, rppt@linux.ibm.com, jgg@mellanox.com,
        mhocko@suse.com, jglisse@redhat.com, akpm@linux-foundation.org,
        mike.kravetz@oracle.com, viro@zeniv.linux.org.uk,
        riandrews@android.com, arve@android.com, yishaih@mellanox.com,
        dledford@redhat.com, sean.hefty@intel.com,
        hal.rosenstock@gmail.com, matanb@mellanox.com, leonro@mellanox.com,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        srivatsab@vmware.com, amakhalov@vmware.com
Subject: Re: [PATCH v4 0/3] [v4.9.y] coredump: fix race condition between
 mmget_not_zero()/get_task_mm() and core dumping
Message-ID: <20190624202150.GC3881@sasha-vm>
References: <1561410186-3919-1-git-send-email-akaher@vmware.com>
 <1561410186-3919-4-git-send-email-akaher@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1561410186-3919-4-git-send-email-akaher@vmware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 25, 2019 at 02:33:06AM +0530, Ajay Kaher wrote:
>coredump: fix race condition between mmget_not_zero()/get_task_mm()
>and core dumping
>
>[PATCH v4 1/3]:
>Backporting of commit 04f5866e41fb70690e28397487d8bd8eea7d712a upstream.
>
>[PATCH v4 2/3]:
>Extension of commit 04f5866e41fb to fix the race condition between
>get_task_mm() and core dumping for IB->mlx4 and IB->mlx5 drivers.
>
>[PATCH v4 3/3]
>Backporting of commit 59ea6d06cfa9247b586a695c21f94afa7183af74 upstream.
>
>[diff from v3]:
>- added [PATCH v4 3/3]

Why do all the patches have the same subject line?

I guess it's correct for the first one, but can you explain what's up
with #2 and #3?

If the second one isn't upstream, please explain in detail why not and
how 4.9 differs from upstream so that it requires a custom backport.

The third one just looks like a different patch altogether with a wrong
subject line?

--
Thanks,
Sasha
