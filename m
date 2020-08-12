Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2366B2423E7
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 04:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgHLCBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 22:01:09 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:41904 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726235AbgHLCBJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Aug 2020 22:01:09 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B315B9617494B5F5982D;
        Wed, 12 Aug 2020 10:01:05 +0800 (CST)
Received: from [10.164.122.247] (10.164.122.247) by smtp.huawei.com
 (10.3.19.214) with Microsoft SMTP Server (TLS) id 14.3.487.0; Wed, 12 Aug
 2020 10:01:04 +0800
Subject: Re: [PATCH] erofs: avoid duplicated permission check for "trusted."
 xattrs
To:     Gao Xiang <hsiangkao@redhat.com>, <linux-erofs@lists.ozlabs.org>
CC:     LKML <linux-kernel@vger.kernel.org>, Chao Yu <chao@kernel.org>,
        Hongyu Jin <hongyu.jin@unisoc.com>, <stable@vger.kernel.org>
References: <20200811070020.6339-1-hsiangkao@redhat.com>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <18a6a9b7-5967-1929-920a-e34e446944ac@huawei.com>
Date:   Wed, 12 Aug 2020 10:01:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20200811070020.6339-1-hsiangkao@redhat.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.164.122.247]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/8/11 15:00, Gao Xiang wrote:
> Don't recheck it since xattr_permission() already
> checks CAP_SYS_ADMIN capability.
> 
> Just follow 5d3ce4f70172 ("f2fs: avoid duplicated permission check for "trusted." xattrs")
> 
> Reported-by: Hongyu Jin <hongyu.jin@unisoc.com>
> [ Gao Xiang: since it could cause some complex Android overlay
>    permission issue as well on android-5.4+, so it'd be better to
>    backport to 5.4+ rather than pure cleanup on mainline. ]
> Cc: <stable@vger.kernel.org> # 5.4+
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Reviewed-by: Chao Yu <yuchao0@huawei.com>

Thanks,
