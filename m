Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDBD1244CDA
	for <lists+stable@lfdr.de>; Fri, 14 Aug 2020 18:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbgHNQlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Aug 2020 12:41:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728099AbgHNQlK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Aug 2020 12:41:10 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90F08204EA;
        Fri, 14 Aug 2020 16:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597423269;
        bh=r065Fc6/kveunjeBivhUiJNvoQb6mZEJzetgtLOkzR0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LqbjOE8NeByEGscA0BNEJxXxBB+ezknYjLgVDsmLt8YvcpchKNlNwSDjVWMFucanX
         JVvz5nd1P+XkcL1zCZWALh0qE9yYhozkotyMXyDuwSjKureY4h5sk3rC8KrcRrDU1N
         zKaKGoEil1fdTvbAgQgjpZpOeRvC4tcJEPF+Cqt4=
Date:   Fri, 14 Aug 2020 12:41:08 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        gregkh@linuxfoundation.org, tj@kernel.org, lizefan@huawei.com,
        xiyou.wangcong@gmail.com
Subject: Re: [PATCH stable-4.19] cgroup: add missing skcd->no_refcnt check in
 cgroup_sk_clone()
Message-ID: <20200814164108.GR2975990@sasha-vm>
References: <20200813203342.1120351-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200813203342.1120351-1-yangyingliang@huawei.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 13, 2020 at 08:33:42PM +0000, Yang Yingliang wrote:
>Add skcd->no_refcnt check which is missed when backporting
>ad0f75e5f57c ("cgroup: fix cgroup_sk_alloc() for sk_clone_lock()").
>
>This patch is needed in stable-4.9, stable-4.14 and stable-4.19.
>
>Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

I've queued up this and the 4.14 & 4.9 backports, thanks!

-- 
Thanks,
Sasha
