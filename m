Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C564129B30
	for <lists+stable@lfdr.de>; Mon, 23 Dec 2019 22:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfLWVkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Dec 2019 16:40:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:52096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726817AbfLWVkT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Dec 2019 16:40:19 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91C5F206CB;
        Mon, 23 Dec 2019 21:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577137218;
        bh=X3NyWEI0SJTpJz3TiMVbSoP0Oa+xFcUCJzdjXt6mWpA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xQoZqM1nSZejEaD9MsUPDBDjn5WJMl37J2tkwbKuIye9b4F/9+OV8WxY0WS/fRplc
         mnsjZCKymt7hUcoHj+bokAJeEqSEGHZZXFRH/oVcNL0HfGUEKL51JEsIRqa6PSFcQH
         r6UMOTFUwnxDrg4Xvqaf70CCvgW9BBgx5RbJfLC8=
Date:   Mon, 23 Dec 2019 16:40:17 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     dan.carpenter@oracle.com, dsterba@suse.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: return error pointer from
 alloc_test_extent_buffer" failed to apply to 4.19-stable tree
Message-ID: <20191223214017.GA17708@sasha-vm>
References: <1577121159274@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1577121159274@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 23, 2019 at 12:12:39PM -0500, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From b6293c821ea8fa2a631a2112cd86cd435effeb8b Mon Sep 17 00:00:00 2001
>From: Dan Carpenter <dan.carpenter@oracle.com>
>Date: Tue, 3 Dec 2019 14:24:58 +0300
>Subject: [PATCH] btrfs: return error pointer from alloc_test_extent_buffer
>
>Callers of alloc_test_extent_buffer have not correctly interpreted the
>return value as error pointer, as alloc_test_extent_buffer should behave
>as alloc_extent_buffer. The self-tests were unaffected but
>btrfs_find_create_tree_block could call both functions and that would
>cause problems up in the call chain.
>
>Fixes: faa2dbf004e8 ("Btrfs: add sanity tests for new qgroup accounting code")
>CC: stable@vger.kernel.org # 4.4+
>Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>Reviewed-by: David Sterba <dsterba@suse.com>
>Signed-off-by: David Sterba <dsterba@suse.com>

Few conflicts on the backport mostly due to message formatting (such as
9e3d9f8462ef ("btrfs: tests: use standard error message after extent
buffer allocation failure") ). I've fixed them up and queued for
4.19-4.4.

-- 
Thanks,
Sasha
