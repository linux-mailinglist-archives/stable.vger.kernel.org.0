Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7D7797CBF
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 16:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbfHUOYa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 10:24:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728724AbfHUOYa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Aug 2019 10:24:30 -0400
Received: from [192.168.0.101] (unknown [180.111.132.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A46DB22D6D;
        Wed, 21 Aug 2019 14:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566397468;
        bh=9ksBVq9fAhzcjSVB61cJ1f0+9AqNBnX70fl6ffNSxOM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=j20Sm2jz1Cmc2mvnqzcuD6jFCrpjk7WWTUoUgOs4WLl5/tUYXz9HEX5cM4RBVk8MM
         L0n9ZiqxCoNdk+ZcltFzlDnyBGUlRhNm+zXZO3v1Q2PFYhqiq0dknjNY9vqVIjM2Eo
         2inn4NWkmYr1TWDl8VfjXaMs5cM1pHivqiORkjWk=
Subject: Re: [PATCH v2 5/6] staging: erofs: detect potential multiref due to
 corrupted images
To:     Gao Xiang <gaoxiang25@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     devel@driverdev.osuosl.org, Miao Xie <miaoxie@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>, weidu.du@huawei.com,
        linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        stable@vger.kernel.org
References: <20190821021942.GA14087@kroah.com>
 <20190821140152.229648-1-gaoxiang25@huawei.com>
From:   Chao Yu <chao@kernel.org>
Message-ID: <e0f76952-2fcf-5d62-d318-f13077913af0@kernel.org>
Date:   Wed, 21 Aug 2019 22:24:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190821140152.229648-1-gaoxiang25@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019-8-21 22:01, Gao Xiang wrote:
> As reported by erofs-utils fuzzer, currently, multiref
> (ondisk deduplication) hasn't been supported for now,
> we should forbid it properly.
> 
> Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
> Cc: <stable@vger.kernel.org> # 4.19+
> Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>

Reviewed-by: Chao Yu <yuchao0@huawei.com>

Thanks,
