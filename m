Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 395251121CA
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 04:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfLDDOx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 22:14:53 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:48376 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726804AbfLDDOx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 22:14:53 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 885B553BE6C41356A36B;
        Wed,  4 Dec 2019 11:14:48 +0800 (CST)
Received: from [10.134.22.195] (10.134.22.195) by smtp.huawei.com
 (10.3.19.212) with Microsoft SMTP Server (TLS) id 14.3.439.0; Wed, 4 Dec 2019
 11:14:38 +0800
Subject: Re: [PATCH] erofs: zero out when listxattr is called with no xattr
To:     Gao Xiang <hsiangkao@aol.com>, <linux-erofs@lists.ozlabs.org>
CC:     LKML <linux-kernel@vger.kernel.org>,
        David Michael <fedora.dm0@gmail.com>,
        Miao Xie <miaoxie@huawei.com>, Fang Wei <fangwei1@huawei.com>,
        Wang Li <wangli74@huawei.com>,
        Gao Xiang <gaoxiang25@huawei.com>, <stable@vger.kernel.org>
References: <20191201084040.29275-1-hsiangkao.ref@aol.com>
 <20191201084040.29275-1-hsiangkao@aol.com>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <947ae429-d206-0859-ee5b-9bd37f7fd72b@huawei.com>
Date:   Wed, 4 Dec 2019 11:14:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20191201084040.29275-1-hsiangkao@aol.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.134.22.195]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019/12/1 16:40, Gao Xiang wrote:
> From: Gao Xiang <gaoxiang25@huawei.com>
> 
> As David reported [1], ENODATA returns when attempting
> to modify files by using EROFS as a overlayfs lower layer.
> 
> The root cause is that listxattr could return unexpected
> -ENODATA by mistake for inodes without xattr. That breaks
> listxattr return value convention and it can cause copy
> up failure when used with overlayfs.
> 
> Resolve by zeroing out if no xattr is found for listxattr.
> 
> [1] https://lore.kernel.org/r/CAEvUa7nxnby+rxK-KRMA46=exeOMApkDMAV08AjMkkPnTPV4CQ@mail.gmail.com
> Fixes: cadf1ccf1b00 ("staging: erofs: add error handling for xattr submodule")
> Cc: <stable@vger.kernel.org> # 4.19+
> Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>

Reviewed-by: Chao Yu <yuchao0@huawei.com>

Thanks,
