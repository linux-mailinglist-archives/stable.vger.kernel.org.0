Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40DEE206938
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 02:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388313AbgFXAzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 20:55:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387586AbgFXAza (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 20:55:30 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFF1520738;
        Wed, 24 Jun 2020 00:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592960130;
        bh=1kVrMxBiKSycFlWt7uEzeLT5TpFlYM1CtHJfu5ByQJk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zaHROeN+UvEh5rRvaZom6G5GvzRCzzxaxpkCEu/fB4xd+VBBEuDFwi04cAAACRaU5
         q0V6zACovYPeKAKnKi2xXXIFhcYQjkDMSnkaVE1BFwxG6giHJo/pgLoiw6ZrvMMzJZ
         Wxem7uc8HBfqDpz+Dt+FwjMiXHDUGROD3uQrWXBQ=
Date:   Tue, 23 Jun 2020 20:55:28 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: Re: [PATCH 4.19 066/206] soundwire: slave: dont init debugfs on
 device registration error
Message-ID: <20200624005528.GE1931@sasha-vm>
References: <20200623195316.864547658@linuxfoundation.org>
 <20200623195320.204985936@linuxfoundation.org>
 <20200623211102.GB4401@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200623211102.GB4401@amd>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 23, 2020 at 11:11:03PM +0200, Pavel Machek wrote:
>Hi!
>
>> [ Upstream commit 8893ab5e8ee5d7c12e0fc1dca4a309475064473d ]
>>
>> The error handling flow seems incorrect, there is no reason to try and
>> add debugfs support if the device registration did not
>> succeed. Return on error.
>
>> +++ b/drivers/soundwire/slave.c
>> @@ -55,6 +55,8 @@ static int sdw_slave_add(struct sdw_bus *bus,
>>  		list_del(&slave->node);
>>  		mutex_unlock(&bus->bus_lock);
>>  		put_device(&slave->dev);
>> +
>> +		return ret;
>>  	}
>>
>>  	return ret;
>
>Mainline is significantly different here; this patch does not make
>sense in v4.19 -- as it does not do anything.

I've dropped it from 4.19, thanks!

-- 
Thanks,
Sasha
