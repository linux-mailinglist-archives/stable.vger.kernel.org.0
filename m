Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66FB7177279
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 10:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgCCJdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 04:33:54 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10716 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728257AbgCCJdy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 04:33:54 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id BBD64EAA445E9F78AB98;
        Tue,  3 Mar 2020 17:33:51 +0800 (CST)
Received: from [10.134.22.195] (10.134.22.195) by smtp.huawei.com
 (10.3.19.213) with Microsoft SMTP Server (TLS) id 14.3.439.0; Tue, 3 Mar 2020
 17:33:44 +0800
Subject: Re: [PATCH v2 1/3] erofs: correct the remaining shrink objects
To:     Gao Xiang <gaoxiang25@huawei.com>, <linux-erofs@lists.ozlabs.org>
CC:     LKML <linux-kernel@vger.kernel.org>, Miao Xie <miaoxie@huawei.com>,
        <stable@vger.kernel.org>
References: <20200226081008.86348-1-gaoxiang25@huawei.com>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <a5973527-b3ba-6743-44b4-8735643a07b5@huawei.com>
Date:   Tue, 3 Mar 2020 17:33:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20200226081008.86348-1-gaoxiang25@huawei.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.134.22.195]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/2/26 16:10, Gao Xiang wrote:
> The remaining count should not include successful
> shrink attempts.
> 
> Fixes: e7e9a307be9d ("staging: erofs: introduce workstation for decompression")
> Cc: <stable@vger.kernel.org> # 4.19+
> Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>

Reviewed-by: Chao Yu <yuchao0@huawei.com>

Thanks,
