Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB8F37DCB6
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 15:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbfHANmh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 09:42:37 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3695 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725804AbfHANmh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Aug 2019 09:42:37 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 9FAD7908283F2FD034D5;
        Thu,  1 Aug 2019 21:42:19 +0800 (CST)
Received: from [127.0.0.1] (10.202.227.238) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Thu, 1 Aug 2019
 21:42:12 +0800
Subject: Re: [PATCH v4 2/5] lib: logic_pio: Avoid possible overlap for
 unregistering regions
To:     Sasha Levin <sashal@kernel.org>, <xuwei5@huawei.com>
References: <1564493396-92195-3-git-send-email-john.garry@huawei.com>
 <20190801133134.BF4AD2173E@mail.kernel.org>
CC:     <bhelgaas@google.com>, <linuxarm@huawei.com>,
        <stable@vger.kernel.org>
From:   John Garry <john.garry@huawei.com>
Message-ID: <380ba7ed-d425-3787-a1f3-17babaa8a11e@huawei.com>
Date:   Thu, 1 Aug 2019 14:42:08 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.3.0
MIME-Version: 1.0
In-Reply-To: <20190801133134.BF4AD2173E@mail.kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.238]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/08/2019 14:31, Sasha Levin wrote:
> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v5.2.4, v5.1.21, v4.19.62, v4.14.134, v4.9.186, v4.4.186.
>
> v5.2.4: Build OK!
> v5.1.21: Build OK!
> v4.19.62: Build OK!
> v4.14.134: Failed to apply! Possible dependencies:
>     031e3601869c ("lib: Add generic PIO mapping method")
>
> v4.9.186: Failed to apply! Possible dependencies:
>     031e3601869c ("lib: Add generic PIO mapping method")
>
> v4.4.186: Failed to apply! Possible dependencies:
>     031e3601869c ("lib: Add generic PIO mapping method")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?
>

Please only consider for v4.19.x, v5.1.x, and v5.2.x stable trees, same 
for all patches in the patchset.

Thanks,
John

> --
> Thanks,
> Sasha
>
> .
>


