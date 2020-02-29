Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5F36174417
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 02:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbgB2BNA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 20:13:00 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:40648 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726046AbgB2BM7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 20:12:59 -0500
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 259E8AE0469AE690B3C0;
        Sat, 29 Feb 2020 09:12:57 +0800 (CST)
Received: from dggeme762-chm.china.huawei.com (10.3.19.108) by
 DGGEMM402-HUB.china.huawei.com (10.3.20.210) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 29 Feb 2020 09:12:56 +0800
Received: from architecture4 (10.160.196.180) by
 dggeme762-chm.china.huawei.com (10.3.19.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Sat, 29 Feb 2020 09:12:56 +0800
Date:   Sat, 29 Feb 2020 09:11:26 +0800
From:   Gao Xiang <gaoxiang25@huawei.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     Chao Yu <yuchao0@huawei.com>, <linux-erofs@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Miao Xie <miaoxie@huawei.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] erofs: correct the remaining shrink objects
Message-ID: <20200229011126.GA103844@architecture4>
References: <20200226081008.86348-1-gaoxiang25@huawei.com>
 <20200228194452.17C3F2469D@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200228194452.17C3F2469D@mail.kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.160.196.180]
X-ClientProxiedBy: dggeme718-chm.china.huawei.com (10.1.199.114) To
 dggeme762-chm.china.huawei.com (10.3.19.108)
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Fri, Feb 28, 2020 at 07:44:50PM +0000, Sasha Levin wrote:
> Hi
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag
> fixing commit: e7e9a307be9d ("staging: erofs: introduce workstation for decompression").
> 
> The bot has tested the following trees: v5.5.6, v5.4.22, v4.19.106.
> 
> v5.5.6: Build OK!
> v5.4.22: Failed to apply! Possible dependencies:
>     bda17a4577da ("erofs: remove dead code since managed cache is now built-in")
> 
> v4.19.106: Failed to apply! Possible dependencies:
>     05f9d4a0c8c4 ("staging: erofs: use the new LZ4_decompress_safe_partial()")
>     0a64d62d5399 ("staging: erofs: fixed -Wmissing-prototype warnings by making functions static.")
>     14f362b4f405 ("staging: erofs: clean up internal.h")
>     152a333a5895 ("staging: erofs: add compacted compression indexes support")
>     22fe04a77d10 ("staging: erofs: clean up shrinker stuffs")
>     3b423417d0d1 ("staging: erofs: clean up erofs_map_blocks_iter")
>     5fb76bb04216 ("staging: erofs: cleanup `z_erofs_vle_normalaccess_readpages'")
>     6e78901a9f23 ("staging: erofs: separate erofs_get_meta_page")
>     7dd68b147d60 ("staging: erofs: use explicit unsigned int type")
>     7fc45dbc938a ("staging: erofs: introduce generic decompression backend")
>     89fcd8360e7b ("staging: erofs: change 'unsigned' to 'unsigned int'")
>     8be31270362b ("staging: erofs: introduce erofs_grab_bio")
>     ab47dd2b0819 ("staging: erofs: cleanup z_erofs_vle_work_{lookup, register}")
>     bda17a4577da ("erofs: remove dead code since managed cache is now built-in")
>     d1ab82443bed ("staging: erofs: Modify conditional checks")
>     e7dfb1cff65b ("staging: erofs: fixed -Wmissing-prototype warnings by moving prototypes to header file.")
>     f0950b02a74c ("staging: erofs: Modify coding style alignments")

I will manually backport this if it can not be automatically applied.

Thanks,
Gao Xiang

> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?
> 
> -- 
> Thanks
> Sasha
