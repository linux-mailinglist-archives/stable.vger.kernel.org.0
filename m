Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CACA3395941
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 12:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbhEaKyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 06:54:33 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2799 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbhEaKyc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 06:54:32 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FtsT55ZNjzWqGV;
        Mon, 31 May 2021 18:48:09 +0800 (CST)
Received: from dggema764-chm.china.huawei.com (10.1.198.206) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 31 May 2021 18:52:50 +0800
Received: from [10.174.185.179] (10.174.185.179) by
 dggema764-chm.china.huawei.com (10.1.198.206) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 31 May 2021 18:52:49 +0800
Subject: Re: FAILED: patch "[PATCH] KVM: arm64: Commit pending PC adjustemnts
 before returning to" failed to apply to 5.12-stable tree
To:     <gregkh@linuxfoundation.org>, <maz@kernel.org>,
        <alexandru.elisei@arm.com>
CC:     <stable@vger.kernel.org>
References: <162237159654109@kroah.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <0d9f123c-e9f7-7481-143d-efd488873082@huawei.com>
Date:   Mon, 31 May 2021 18:52:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <162237159654109@kroah.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggema764-chm.china.huawei.com (10.1.198.206)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 2021/5/30 18:46, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.12-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Indeed this patch should be applied to the 5.12-stable tree, together
with other 2 patches, in order.

[1/3] f5e30680616a ("KVM: arm64: Move __adjust_pc out of line")
[2/3] 26778aaa134a ("KVM: arm64: Commit pending PC adjustemnts before 
returning to userspace")
[3/3] e3e880bb1518 ("KVM: arm64: Resolve all pending PC updates before 
immediate exit")

Patch #1 has been applied cleanly onto linux-stable-rc/linux-5.12.y.
It's just fine. It's expected that there's no functional change with
patch #1.

Patch #2 (this patch) can be applied by manually resolving the conflict.
I can send a patch for it if Marc doesn't get enough bandwidth.

Patch #3 has been applied in a wrong way [*]. I'll reply to it so that
you can drop it from the current stable queue.

Thanks,
Zenghui

[*] https://www.spinics.net/lists/stable-commits/msg200513.html
