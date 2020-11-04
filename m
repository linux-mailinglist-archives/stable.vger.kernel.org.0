Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E49C2A5B76
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 02:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbgKDBGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 20:06:05 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:7455 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728301AbgKDBGE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 20:06:04 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CQpPN0WwHzhgP2;
        Wed,  4 Nov 2020 09:06:00 +0800 (CST)
Received: from [10.136.114.67] (10.136.114.67) by smtp.huawei.com
 (10.3.19.209) with Microsoft SMTP Server (TLS) id 14.3.487.0; Wed, 4 Nov 2020
 09:05:56 +0800
Subject: Re: [PATCH 1/4] erofs: fix setting up pcluster for temporary pages
To:     Gao Xiang <hsiangkao@aol.com>, <linux-erofs@lists.ozlabs.org>
CC:     Chao Yu <chao@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Gao Xiang <hsiangkao@redhat.com>, <stable@vger.kernel.org>
References: <20201022145724.27284-1-hsiangkao.ref@aol.com>
 <20201022145724.27284-1-hsiangkao@aol.com>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <f1f24a38-97f7-e9cf-03c8-2c95814b98a3@huawei.com>
Date:   Wed, 4 Nov 2020 09:05:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20201022145724.27284-1-hsiangkao@aol.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.136.114.67]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/10/22 22:57, Gao Xiang wrote:
> From: Gao Xiang <hsiangkao@redhat.com>
> 
> pcluster should be only set up for all managed pages instead of
> temporary pages. Since it currently uses page->mapping to identify,
> the impact is minor for now.
> 
> Fixes: 5ddcee1f3a1c ("erofs: get rid of __stagingpage_alloc helper")
> Cc: <stable@vger.kernel.org> # 5.5+
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Reviewed-by: Chao Yu <yuchao0@huawei.com>

Thanks,
