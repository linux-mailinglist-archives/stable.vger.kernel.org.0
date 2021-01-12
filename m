Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51F42F2CD2
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 11:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404257AbhALK2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 05:28:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbhALK2A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 05:28:00 -0500
Received: from mail.kapsi.fi (mail.kapsi.fi [IPv6:2001:67c:1be8::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4128C061786;
        Tue, 12 Jan 2021 02:27:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
         s=20161220; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:Reply-To:Cc:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ymsxLNEL8SmpBc0tYMCk4QgW+WBQ2EizgNwC30fBRJY=; b=DotkCVHcf/A6zEoUmGuuhdFBYZ
        Wwfv+xvu5Y4DL/oQrqlcNARktuVwd6bsQJ43FywUFn/qwQNf3p1GnVvaslZBulW4WzYH0kSaiPzVV
        OWPY3aea5ic6QBSbbj6q8Lg835ifWxtoavbWgQYVEjvT58NqiBVFvK74FeLzYBQ0HCJUcqRrCoG0/
        KmgnE00d0go0XJUngeVborSFikijzW2J8qriC0+Qdz/GlUxPhcRQu2ZmJIw81O/PgiDQtuXCHq6Y6
        wepRxd6PxOa94IkRV49+w8ACD9dCgyg3s712jdj8VNTCANm5SsXEIZfLR3B2Tm2JrxsvRDxwltiz2
        WIFfzh3w==;
Received: from dsl-hkibng22-54f986-236.dhcp.inet.fi ([84.249.134.236] helo=[192.168.1.10])
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <cyndis@kapsi.fi>)
        id 1kzGtS-0000GL-8p; Tue, 12 Jan 2021 12:27:18 +0200
Subject: Re: [PATCH v2] i2c: tegra-bpmp: ignore DMA safe buffer flag
To:     Wolfram Sang <wsa@kernel.org>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        thierry.reding@gmail.com, jonathanh@nvidia.com, talho@nvidia.com,
        linux-i2c@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Muhammed Fazal <mfazale@nvidia.com>,
        stable@vger.kernel.org
References: <20210111155816.3656820-1-mperttunen@nvidia.com>
 <20210111214221.GF17475@kunai>
 <92fb3f30-a08c-eb42-0741-affc3ceae0c0@kapsi.fi> <20210112102605.GB973@kunai>
From:   Mikko Perttunen <cyndis@kapsi.fi>
Message-ID: <5003e6eb-4048-edae-adb3-19711a96e9c7@kapsi.fi>
Date:   Tue, 12 Jan 2021 12:27:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20210112102605.GB973@kunai>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 84.249.134.236
X-SA-Exim-Mail-From: cyndis@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/12/21 12:26 PM, Wolfram Sang wrote:
> 
>>> I wonder if bailing out on an unknown flag shouldn't be revisited in
>>> general? I mean this will happen again when a new I2C_M_* flag is
>>> introduced.
>>>
>>
>> If it's guaranteed that any new flags are optional to handle by the driver,
>> than that is certainly better. I'll post a v3 with that approach.
> 
> If there will be a new flag, it is highly likely that it will handle
> some corner case which only gets applied when there is a I2C_FUNC_* flag
> guarding it. If the new flag turns out to be mandatory, the (poor)
> author needs to check with all existing drivers anyhow.
> 

Yep, I suppose that is true :)

I just sent out the v3.

thanks!
Mikko
