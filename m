Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3DF247360
	for <lists+stable@lfdr.de>; Sun, 16 Jun 2019 08:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725888AbfFPGsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jun 2019 02:48:23 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:18624 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725882AbfFPGsX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 16 Jun 2019 02:48:23 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id CCD58D0E11060586B1D7;
        Sun, 16 Jun 2019 14:48:03 +0800 (CST)
Received: from [10.151.23.176] (10.151.23.176) by smtp.huawei.com
 (10.3.19.208) with Microsoft SMTP Server (TLS) id 14.3.439.0; Sun, 16 Jun
 2019 14:47:57 +0800
Subject: Re: [PATCH v3 1/2] staging: erofs: add requirements field in
 superblock
To:     Sasha Levin <sashal@kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20190613083541.67091-1-gaoxiang25@huawei.com>
 <20190615221606.1C12F2183F@mail.kernel.org>
From:   Gao Xiang <gaoxiang25@huawei.com>
Message-ID: <8ba384bd-44ea-2261-4f49-da354298edf6@huawei.com>
Date:   Sun, 16 Jun 2019 14:47:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190615221606.1C12F2183F@mail.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.151.23.176]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On 2019/6/16 6:16, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: ba2b77a82022 staging: erofs: add super block operations.
> 
> The bot has tested the following trees: v5.1.9, v4.19.50.
> 
> v5.1.9: Failed to apply! Possible dependencies:
>     Unable to calculate
> 
> v4.19.50: Failed to apply! Possible dependencies:
>     Unable to calculate
> 
> 
> How should we proceed with this patch?

I will manually make patches for v5.1.9 and v4.19.50
after it gets merged.

Thanks,
Gao Xiang

> 
> --
> Thanks,
> Sasha
> 
