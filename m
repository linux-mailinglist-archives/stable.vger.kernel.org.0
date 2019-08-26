Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13B649C6F2
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 03:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbfHZBS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Aug 2019 21:18:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbfHZBS6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 25 Aug 2019 21:18:58 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4FFF20815;
        Mon, 26 Aug 2019 01:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566782338;
        bh=MUto3VK8MW2mh1szq87mCcOX0K6X6aJUyF8meo8NWvs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vMRxAu3TFpRct9ZFh/d0fNdEF4NmfSD6UoGMg67TJSXgVkHaUOrP/nR63qYWyEbLf
         QVXkyqqNBoi4dMUAyJJysVKIf0qiybF8bM8a12zkGCpqOcBO1tjaBlMHtP+xy4M1xV
         xWrqBRKSBkGbdKdKNnaq4lzK+y1p9BIodA8T55ZM=
Date:   Sun, 25 Aug 2019 21:18:56 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Zubin Mithra <zsm@chromium.org>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        groeck@chromium.org, bristot@redhat.com, tj@kernel.org,
        lizefan@huawei.com, hannes@cmpxchg.org, juri.lelli@arm.com,
        rostedt@goodmis.org
Subject: Re: [PATCH 4.4.y] cgroup: Disable IRQs while holding css_set_lock
Message-ID: <20190826011856.GD5281@sasha-vm>
References: <20190823174421.81149-1-zsm@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190823174421.81149-1-zsm@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 23, 2019 at 10:44:21AM -0700, Zubin Mithra wrote:
>@@ -2149,7 +2155,6 @@ out_free:
>
> 	if (ret)
> 		return ERR_PTR(ret);
>-

Where did this come from?

> 	dentry = kernfs_mount(fs_type, flags, root->kf_root,
> 				CGROUP_SUPER_MAGIC, &new_sb);
> 	if (IS_ERR(dentry) || !new_sb)

--
Thanks,
Sasha
