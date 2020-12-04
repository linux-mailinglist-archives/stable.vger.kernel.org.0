Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 902AD2CE5B8
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 03:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgLDCal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 21:30:41 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8245 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbgLDCal (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 21:30:41 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CnGql6kHqzkl5H;
        Fri,  4 Dec 2020 10:29:23 +0800 (CST)
Received: from huawei.com (10.174.176.134) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Fri, 4 Dec 2020
 10:29:51 +0800
From:   Liu Zixian <liuzixian4@huawei.com>
To:     <akpm@linux-foundation.org>
CC:     <david@redhat.com>, <hushiyuan@huawei.com>, <jgg@ziepe.ca>,
        <linmiaohe@huawei.com>, <linux-mm@kvack.org>,
        <liuzixian4@huawei.com>, <louhongxiang@huawei.com>,
        <stable@vger.kernel.org>
Subject: Re: Re: [PATCH v2] fix mmap return value when vma is merged after call_mmap()
Date:   Fri, 4 Dec 2020 10:29:50 +0800
Message-ID: <20201204022950.1696-1-liuzixian4@huawei.com>
X-Mailer: git-send-email 2.21.0.windows.1
In-Reply-To: <20201203142537.c69ab696573e63d54becff07@linux-foundation.org>
References: <20201203142537.c69ab696573e63d54becff07@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.176.134]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Has this bug actually been observed at runtime, or is it a theoretical
> from-code-inspection thing?

We have a driver which changes vm_flags, and this bug is found by our testcases.

Thanks to everyone for your review and email instructions, I will do better next time.
