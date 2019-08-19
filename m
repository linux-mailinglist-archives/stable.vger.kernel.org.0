Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38635927C0
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 16:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbfHSO6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 10:58:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbfHSO6J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Aug 2019 10:58:09 -0400
Received: from [192.168.0.101] (unknown [180.111.132.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F9E12082A;
        Mon, 19 Aug 2019 14:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566226688;
        bh=30KXwFIbBf11OqNG82++ljRpNTjhb/YlByVeH2DvVjY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=e5cgjRL4TTBuhsXHXIIXE72dDJYCh1Conr5rBZPraLrYdJ7VKbKaG9gghWkaTL60a
         p6UYq+npZCh4Ng4iSSFyOWV6aMHyJALe8FKZDTo7/2+fB12WMZ67Flyv/4TnIaI7/r
         y7fXeIvuwEB7dkT9G9Ma+/UMVs/NQHKmX9QR+PAA=
Subject: Re: [PATCH 6/6] staging: erofs: avoid endless loop of invalid
 lookback distance 0
To:     Gao Xiang <gaoxiang25@huawei.com>, Chao Yu <yuchao0@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-fsdevel@vger.kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>, linux-erofs@lists.ozlabs.org,
        Miao Xie <miaoxie@huawei.com>, weidu.du@huawei.com,
        Fang Wei <fangwei1@huawei.com>, stable@vger.kernel.org
References: <20190819080218.GA42231@138>
 <20190819103426.87579-1-gaoxiang25@huawei.com>
 <20190819103426.87579-7-gaoxiang25@huawei.com>
From:   Chao Yu <chao@kernel.org>
Message-ID: <a8454de9-dbee-c69c-5763-1648df730211@kernel.org>
Date:   Mon, 19 Aug 2019 22:58:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190819103426.87579-7-gaoxiang25@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019-8-19 18:34, Gao Xiang wrote:
> As reported by erofs-utils fuzzer, Lookback distance should
> be a positive number, so it should be actually looked back
> rather than spinning.
> 
> Fixes: 02827e1796b3 ("staging: erofs: add erofs_map_blocks_iter")
> Cc: <stable@vger.kernel.org> # 4.19+
> Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>

Reviewed-by: Chao Yu <yuchao0@huawei.com>

Thanks,
