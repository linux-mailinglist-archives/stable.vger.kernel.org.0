Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9F5191E55
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 02:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbgCYBB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 21:01:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727113AbgCYBB7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 21:01:59 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81CD12074D;
        Wed, 25 Mar 2020 01:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585098118;
        bh=ovfkJFB2DYsz/CCHB12CqfAc9GhTB1icby3oAVda+mU=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=Zssf4V4GV8eFt3y2pUout+pIDYkr0A7KWpf9/7qMV6fbUKPosd/69cOjUVrQ6EKye
         iyH1UgmKSCYZ0zHVELNQaAZ/8ItKjgREMibxvyciX1Z+4/QUxBhAS7oyXhyleDLzBz
         utidJJCndSMGCayrRmh933nY+lD5uTTZhGxc8pU4=
Date:   Wed, 25 Mar 2020 01:01:57 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Yihao Wu <wuyihao@linux.alibaba.com>
To:     "J . Bruce Fields" <bfields@fieldses.org>
Cc:     linux-nfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] nfsd: fix race between cache_clean and cache_purge
In-Reply-To: <5eed50660eb13326b0fbf537fb58481ea53c1acb.1585043174.git.wuyihao@linux.alibaba.com>
References: <5eed50660eb13326b0fbf537fb58481ea53c1acb.1585043174.git.wuyihao@linux.alibaba.com>
Message-Id: <20200325010158.81CD12074D@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

The bot has tested the following trees: v5.5.11, v5.4.27, v4.19.112, v4.14.174, v4.9.217, v4.4.217.

v5.5.11: Build OK!
v5.4.27: Build OK!
v4.19.112: Failed to apply! Possible dependencies:
    1863d77f15da ("SUNRPC: Replace the cache_detail->hash_lock with a regular spinlock")

v4.14.174: Failed to apply! Possible dependencies:
    1863d77f15da ("SUNRPC: Replace the cache_detail->hash_lock with a regular spinlock")

v4.9.217: Failed to apply! Possible dependencies:
    1863d77f15da ("SUNRPC: Replace the cache_detail->hash_lock with a regular spinlock")
    2b477c00f3bd ("svcrpc: free contexts immediately on PROC_DESTROY")
    471a930ad7d1 ("SUNRPC: Drop all entries from cache_detail when cache_purge()")

v4.4.217: Failed to apply! Possible dependencies:
    1863d77f15da ("SUNRPC: Replace the cache_detail->hash_lock with a regular spinlock")
    2b477c00f3bd ("svcrpc: free contexts immediately on PROC_DESTROY")
    471a930ad7d1 ("SUNRPC: Drop all entries from cache_detail when cache_purge()")
    d8d29138b17c ("sunrpc: remove 'inuse' flag from struct cache_detail.")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
