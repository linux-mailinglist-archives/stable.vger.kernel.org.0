Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78D98137C95
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 10:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbgAKJVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 04:21:08 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:35278 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728346AbgAKJVI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 04:21:08 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id CE33C95F6F3EEA29214B;
        Sat, 11 Jan 2020 17:21:05 +0800 (CST)
Received: from [10.134.22.195] (10.134.22.195) by smtp.huawei.com
 (10.3.19.203) with Microsoft SMTP Server (TLS) id 14.3.439.0; Sat, 11 Jan
 2020 17:20:59 +0800
Subject: Re: [PATCH] erofs: fix out-of-bound read for shifted uncompressed
 block
To:     Gao Xiang <gaoxiang25@huawei.com>
CC:     <linux-erofs@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>, "Chao Yu" <chao@kernel.org>,
        Miao Xie <miaoxie@huawei.com>, Fang Wei <fangwei1@huawei.com>,
        <stable@vger.kernel.org>
References: <20200107022546.19432-1-gaoxiang25@huawei.com>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <c16271f7-6056-9347-45c8-25fa1b145b88@huawei.com>
Date:   Sat, 11 Jan 2020 17:20:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20200107022546.19432-1-gaoxiang25@huawei.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.134.22.195]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/1/7 10:25, Gao Xiang wrote:
> rq->out[1] should be valid before accessing. Otherwise,
> in very rare cases, out-of-bound dirty onstack rq->out[1]
> can equal to *in and lead to unintended memmove behavior.
> 
> Fixes: 7fc45dbc938a ("staging: erofs: introduce generic decompression backend")
> Cc: <stable@vger.kernel.org> # v5.3+
> Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>

Reviewed-by: Chao Yu <yuchao0@huawei.com>

Thanks,
