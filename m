Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3620E306E16
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 08:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbhA1HFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 02:05:17 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:11456 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231442AbhA1HFN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 02:05:13 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DRBJf30QpzjBjN;
        Thu, 28 Jan 2021 15:03:30 +0800 (CST)
Received: from [10.136.110.154] (10.136.110.154) by smtp.huawei.com
 (10.3.19.210) with Microsoft SMTP Server (TLS) id 14.3.498.0; Thu, 28 Jan
 2021 15:04:27 +0800
Subject: Re: [f2fs-dev] [PATCH] f2fs: flush data when enabling checkpoint back
To:     Jaegeuk Kim <jaegeuk@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-f2fs-devel@lists.sourceforge.net>, <kernel-team@android.com>
CC:     <stable@vger.kernel.org>
References: <20210127014434.3431893-1-jaegeuk@kernel.org>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <bf5760eb-cdc4-fb41-41cc-03496b6727fe@huawei.com>
Date:   Thu, 28 Jan 2021 15:04:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20210127014434.3431893-1-jaegeuk@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.136.110.154]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/1/27 9:44, Jaegeuk Kim wrote:
> During checkpoint=disable period, f2fs bypasses all the synchronous IOs such as
> sync and fsync. So, when enabling it back, we must flush all of them in order
> to keep the data persistent. Otherwise, suddern power-cut right after enabling
> checkpoint will cause data loss.
> 
> Fixes: 4354994f097d ("f2fs: checkpoint disabling")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Reviewed-by: Chao Yu <yuchao0@huawei.com>

Thanks,
