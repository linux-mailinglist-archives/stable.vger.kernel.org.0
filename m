Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D720F26D0BB
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 03:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbgIQBlJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 21:41:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725858AbgIQBlI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 21:41:08 -0400
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2020 21:41:07 EDT
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 951FF2076C;
        Thu, 17 Sep 2020 01:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600306862;
        bh=OrX6m8YxPdWu8LBOXGQR6nbtrtQ8xnzMdSfG0Bwlx8o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jCFkelld6YgZXIe4JMpf7n7A8kOGwHqXO0M/BS9qU0gklNkpK/OMGUC6JrNNLSyUk
         j1vV2g9Tjgo+Z+Ixfq3dxoNZsbkCv3YFBDNDFV0wIt24KdbewLoQxA/rL/qjB1EC5L
         JEY9uDm8R/e35A6026FVqTGVC8RaPIac6jXijWNI=
Date:   Wed, 16 Sep 2020 21:41:01 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>
Subject: Re: [PATCH 4.19 09/78] iio: adc: mcp3422: fix locking on error path
Message-ID: <20200917014101.GH2431@sasha-vm>
References: <20200915140633.552502750@linuxfoundation.org>
 <20200915140634.010489871@linuxfoundation.org>
 <20200916073100.GA32537@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200916073100.GA32537@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 16, 2020 at 09:31:00AM +0200, Pavel Machek wrote:
>Hi!
>
>> [ Upstream commit a139ffa40f0c24b753838b8ef3dcf6ad10eb7854 ]
>>
>> Reading from the chip should be unlocked on error path else the lock
>> could never being released.
>>
>> Fixes: 07914c84ba30 ("iio: adc: Add driver for Microchip MCP3422/3/4 high resolution ADC")
>> Fixes: 3f1093d83d71 ("iio: adc: mcp3422: fix locking scope")
>
>Well, 3f1093d83d71 is only applied later in the stable series, so this
>introduces spurious unlock.
>
>Ideally this should go just after 3f1093d83d71 ("iio: adc: mcp3422:
>fix locking scope").

Patches rearranged, thanks!

-- 
Thanks,
Sasha
