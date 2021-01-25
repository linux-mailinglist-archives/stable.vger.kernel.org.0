Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A15323032BE
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727292AbhAZEiX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:38:23 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:11489 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726823AbhAYJzp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 04:55:45 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DPPj60jNnzjD82;
        Mon, 25 Jan 2021 17:30:02 +0800 (CST)
Received: from [10.174.176.185] (10.174.176.185) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Mon, 25 Jan 2021 17:31:07 +0800
Subject: Re: [PATCH 3/4] ubifs: Update directory size when creating whiteouts
To:     Richard Weinberger <richard.weinberger@gmail.com>
CC:     Richard Weinberger <richard@nod.at>,
        <linux-mtd@lists.infradead.org>, David Gstir <david@sigma-star.at>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
References: <20210122212229.17072-1-richard@nod.at>
 <20210122212229.17072-4-richard@nod.at>
 <5b51ff9c-8f5e-c348-5195-c0a0bf60b746@huawei.com>
 <cca6ac4f-4739-76be-9b48-b3643017a556@huawei.com>
 <CAFLxGvyHL5AMWcfLQg2fS6Nbp255yjve5nJ83ELYHnPhKp6Wxw@mail.gmail.com>
From:   Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <45bacc97-5fe0-baed-ce6a-321f15406575@huawei.com>
Date:   Mon, 25 Jan 2021 17:31:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAFLxGvyHL5AMWcfLQg2fS6Nbp255yjve5nJ83ELYHnPhKp6Wxw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.185]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

在 2021/1/25 15:55, Richard Weinberger 写道:

> 
> The idea was that in the !whiteout case, sz_change is always 0.
> 
Oh, sz_change was initialized to 0, I missed it.
Thanks.

