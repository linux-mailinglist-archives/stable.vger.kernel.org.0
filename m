Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1449910F4A2
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 02:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbfLCBrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 20:47:25 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:2100 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725899AbfLCBrZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Dec 2019 20:47:25 -0500
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 9EB5E4E9EF8FF711A278;
        Tue,  3 Dec 2019 09:47:22 +0800 (CST)
Received: from dggeme762-chm.china.huawei.com (10.3.19.108) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 3 Dec 2019 09:47:21 +0800
Received: from architecture4 (10.160.196.180) by
 dggeme762-chm.china.huawei.com (10.3.19.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Tue, 3 Dec 2019 09:47:21 +0800
Date:   Tue, 3 Dec 2019 09:52:41 +0800
From:   Gao Xiang <gaoxiang25@huawei.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     Gao Xiang <hsiangkao@aol.com>, Chao Yu <yuchao0@huawei.com>,
        <linux-erofs@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Miao Xie <miaoxie@huawei.com>
Subject: Re: [PATCH] erofs: zero out when listxattr is called with no xattr
Message-ID: <20191203015238.GA210859@architecture4>
References: <20191201084040.29275-1-hsiangkao@aol.com>
 <20191202221312.8F590206F0@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20191202221312.8F590206F0@mail.kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.160.196.180]
X-ClientProxiedBy: dggeme703-chm.china.huawei.com (10.1.199.99) To
 dggeme762-chm.china.huawei.com (10.3.19.108)
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Mon, Dec 02, 2019 at 10:13:11PM +0000, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: cadf1ccf1b00 ("staging: erofs: add error handling for xattr submodule").
> 
> The bot has tested the following trees: v5.4.1, v5.3.14, v4.19.87.
> 
> v5.4.1: Build OK!
> v5.3.14: Failed to apply! Possible dependencies:
>     Unable to calculate
> 
> v4.19.87: Failed to apply! Possible dependencies:
>     Unable to calculate

Because of file movement, I'll backport manually then.

Thanks,
Gao Xiang

> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?
> 
> -- 
> Thanks,
> Sasha
