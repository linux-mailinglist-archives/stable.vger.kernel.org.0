Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65D891130D3
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 18:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbfLDRbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 12:31:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:59880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726934AbfLDRby (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 12:31:54 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD24F207DD;
        Wed,  4 Dec 2019 17:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575480714;
        bh=BeNSKBo/GycF17w8rifKyZRZy3IIqqs1MKc6Ut0i4vo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ty+2jsibgIPWWQyuXslqlCSdFJ94m3sVYxzSlY4vg/7Xfk/11AiPNOSalqubbxg6T
         Juzgh2od4jCipKnQ3kuCVd+51Cf5erIIZVXISiiYyBmm5YqHO6oClsSsijKP3y5/N2
         qLlWkXS3jKLFPgbz7wNJo2HcD8a75fvVsF4tOYyo=
Date:   Wed, 4 Dec 2019 18:31:52 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     yu kuai <yukuai3@huawei.com>
Cc:     stable@vger.kernel.org, hughd@google.com, viro@zeniv.linux.org.uk,
        yi.zhang@huawei.com, zhengbin13@huawei.com, houtao1@huawei.com
Subject: Re: [4.19.y PATCH] tmpfs: fix unable to remount nr_inodes from
 limited to unlimited
Message-ID: <20191204173152.GA3630950@kroah.com>
References: <20191204131137.10388-1-yukuai3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191204131137.10388-1-yukuai3@huawei.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 04, 2019 at 09:11:37PM +0800, yu kuai wrote:
> tmpfs support 'size', 'nr_blocks' and 'nr_inodes' mount options. mount or
> remount them to zero means unlimited. 'size' and 'br_blocks' can remount
> from limited to unlimited, while 'nr_inodes' can't.
> 
> The problem is fixed since upstream commit 0b5071dd323d ("
> shmem_parse_options(): use a separate structure to keep the results"). But
> in order to backport it, the amount of related patches need to backport is
> huge. 
> 
> So, I made some local changes to fix the problem.
> 
> Signed-off-by: yu kuai <yukuai3@huawei.com>
> ---
>  mm/shmem.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
