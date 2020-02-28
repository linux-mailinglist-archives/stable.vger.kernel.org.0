Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBC9173158
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 07:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgB1GvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 01:51:10 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:46902 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725943AbgB1GvK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 01:51:10 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9C3BC72F8D68D18826AE;
        Fri, 28 Feb 2020 14:51:03 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Fri, 28 Feb 2020
 14:50:53 +0800
To:     <gregkh@linuxfoundation.org>, <sashal@kernel.org>,
        <stable@vger.kernel.org>
CC:     <joe@perches.com>, <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Subject: Request to backport "irqchip/gic-v3-its: Fix misuse of GENMASK macro"
Message-ID: <47617046-53ba-ed7f-ccbb-5c7c09426552@huawei.com>
Date:   Fri, 28 Feb 2020 14:50:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Sasha,

Could you please help to backport the upstream commit
20faba848752901de23a4d45a1174d64d2069dde ("irqchip/gic-v3-its: Fix
misuse of GENMASK macro") to the stable linux-4.19 tree since it's
definitely a fix for 4.19. Note that it's not needed for other stable
trees.

I've tried and it can be applied to 4.19.106 cleanly.


Thanks,
Zenghui

