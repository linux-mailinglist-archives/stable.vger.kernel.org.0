Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B662CB288
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 02:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgLBBw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 20:52:57 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8177 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727941AbgLBBw5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 20:52:57 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Cm25F4pjhz15VC3;
        Wed,  2 Dec 2020 09:51:45 +0800 (CST)
Received: from [10.136.114.67] (10.136.114.67) by smtp.huawei.com
 (10.3.19.210) with Microsoft SMTP Server (TLS) id 14.3.487.0; Wed, 2 Dec 2020
 09:52:04 +0800
Subject: Re: [f2fs-dev] [PATCH] f2fs: init dirty_secmap incorrectly
To:     Jack Qiu <jack.qiu@huawei.com>,
        <linux-f2fs-devel@lists.sourceforge.net>
CC:     <stable@vger.kernel.org>
References: <20201201074547.1872-1-jack.qiu@huawei.com>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <e2f5f972-7333-9758-22f5-e9413a37e703@huawei.com>
Date:   Wed, 2 Dec 2020 09:52:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20201201074547.1872-1-jack.qiu@huawei.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.136.114.67]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/12/1 15:45, Jack Qiu wrote:
> section is dirty, but dirty_secmap may not set
> 
> Reported-by: Jia Yang <jiayang5@huawei.com>
> Fixes: da52f8ade40b ("f2fs: get the right gc victim section when section
> has several segments")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Jack Qiu <jack.qiu@huawei.com>

Reviewed-by: Chao Yu <yuchao0@huawei.com>

Thanks,
