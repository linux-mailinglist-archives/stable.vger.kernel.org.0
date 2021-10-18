Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8516443185C
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 14:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbhJRMCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 08:02:46 -0400
Received: from uho.ysoft.cz ([81.19.3.130]:56848 "EHLO uho.ysoft.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231408AbhJRMCp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 08:02:45 -0400
Received: from [10.0.28.149] (unknown [10.0.28.149])
        by uho.ysoft.cz (Postfix) with ESMTP id 34278A636F;
        Mon, 18 Oct 2021 14:00:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ysoft.com;
        s=20160406-ysoft-com; t=1634558432;
        bh=lMB5Xe84NWFjd8HEDAS2i5V4XTzBdJOFmGVH/YeDFJM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=jno6ycjM0J+B+Ng1ndcvU3Yj1NF1t7wawbPtxJ3uM8tt0K1oH/yKX5Q04gdfzbgj7
         RIEjo8dg14z9uyEPUppG1oV58Zo2hcJPeuVkIN2W6lVbYDiQMqUhDU0nv2HzZwTdcq
         rqZinhhV/s5fqkKt6jvCx/oR6kkx2gpdSKoYCu74=
Subject: Re: [PATCH] thermal: imx: Fix temperature measurements on i.MX6 after
 alarm
To:     Petr Benes <petrben@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        linux-pm@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Amit Kucheria <amitk@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Petr_Bene=c5=a1?= <petr.benes@ysoft.com>,
        stable@vger.kernel.org
References: <20211008081137.1948848-1-michal.vokac@ysoft.com>
 <20211018112820.qkebjt2gk2w53lp5@pengutronix.de>
 <CAPwXO5Y8e8zpo_8zrfM=JFNkhKehE0mnpe8wzUzOQiifEZnx9Q@mail.gmail.com>
From:   =?UTF-8?B?TWljaGFsIFZva8OhxI0=?= <michal.vokac@ysoft.com>
Message-ID: <3960553b-2e23-a970-7df3-7b2630f11b30@ysoft.com>
Date:   Mon, 18 Oct 2021 14:00:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAPwXO5Y8e8zpo_8zrfM=JFNkhKehE0mnpe8wzUzOQiifEZnx9Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18. 10. 21 13:41, Petr Benes wrote:
> On Mon, 18 Oct 2021 at 13:28, Oleksij Rempel <o.rempel@pengutronix.de> wrote:
>>
>> Hi Michal,
>>
>> I hope you have seen this patch:
>> https://lore.kernel.org/all/20210924115032.29684-1-o.rempel@pengutronix.de/
>>
>> Are there any reason why this was ignored?
> 
> Missed completely. It looks it addresses the problem more systematically.
> Hi Oleksij,

Thank you for pointing that out. As Peter said, we missed your patch
completely. We do not have the right HW around now but we will test
the patch later today once we get the board.

I will keep you updated.
Thank you,
Michal
