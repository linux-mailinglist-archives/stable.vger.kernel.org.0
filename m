Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCE2184A1E
	for <lists+stable@lfdr.de>; Fri, 13 Mar 2020 16:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgCMPBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Mar 2020 11:01:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbgCMPBH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Mar 2020 11:01:07 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AE9A206FA;
        Fri, 13 Mar 2020 15:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584111666;
        bh=go0P9fgXXPo35byt8AV+LGj/xg18Op3eY2CFhsORJbE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K8rHC7e/bxxQzKqrId1m+K6LiZKbq8lWuCi+yqYhcaquiz7IwFvkE+RyrH5wmKj+K
         3PM2wJT/oiPPYgA904Uke6d4R4y/gv9hly5h282sNqtwBzQ8k2YwnM1AHtyuC1vInn
         5AA/nxabwg1lwVt/qWLsvpxMKNnkjPhdQ1La/phw=
Date:   Fri, 13 Mar 2020 11:01:05 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>, stable@vger.kernel.org,
        Robert Richter <rrichter@marvell.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio: thunderx: fix irq_request_resources
Message-ID: <20200313150105.GF1349@sasha-vm>
References: <1583941433-15876-1-git-send-email-tharvey@gateworks.com>
 <CACRpkdb3VzOFmnZkXXopsbKAAiQ9nzsqm6fMpcsCfmuvmaeOmg@mail.gmail.com>
 <CAJ+vNU0U9jKDoZLBdC2aRrCCQkKmWATk6G6XAzQcF03tQY9r8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAJ+vNU0U9jKDoZLBdC2aRrCCQkKmWATk6G6XAzQcF03tQY9r8g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 12, 2020 at 10:16:40AM -0700, Tim Harvey wrote:
>On Thu, Mar 12, 2020 at 6:42 AM Linus Walleij <linus.walleij@linaro.org> wrote:
>>
>> On Wed, Mar 11, 2020 at 4:43 PM Tim Harvey <tharvey@gateworks.com> wrote:
>>
>> > If there are no parent resources do not call irq_chip_request_resources_parent
>> > at all as this will return an error.
>> >
>> > This resolves a regression where devices using a thunderx gpio as an interrupt
>> > would fail probing.
>> >
>> > Fixes: 0d04d0c ("gpio: thunderx: Use the default parent apis for {request,release}_resources")
>> > Signed-off-by: Tim Harvey <tharvey@gateworks.com>
>>
>> This patch does not apply to the mainline kernel or v5.6-rc1.
>>
>> Please verify:
>> 1. If the problem is still in v5.6 (we refactored the driver to
>>    use GPIOLIB_IRQCHIP)
>
>Linus,
>
>Sorry, another issue was keeping me from being able to boot 5.6-rc but
>that's now understood and I can confirm the issue is not present in
>v5.6-rc5
>
>>
>> 2. If not, only propose it for linux-stable v5.5 etc.
>>
>
>Yes, needs to be applied to v5.2, v5.3, v5.4, v5.5. I cc'd stable. If
>I need to re-submit please let me know.
>
>Cc: stable@vger.kernel.org

Linus, could you ack this patch for stable?

-- 
Thanks,
Sasha
