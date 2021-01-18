Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975E82F9E0C
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 12:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390112AbhARLYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:24:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390146AbhARLXL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jan 2021 06:23:11 -0500
Received: from mail.kapsi.fi (mail.kapsi.fi [IPv6:2001:67c:1be8::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB928C061573;
        Mon, 18 Jan 2021 03:22:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
         s=20161220; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=aUlcPf/jHMTuCu5fOX4kjclkFtZwtbh8tbGRwleHuOI=; b=iRHygFCUFFEBW4fRU5BK5d9p5+
        KALLc1HznvK1PuBZk8EEN8GSm7+2PoKxy0Zr8i/7LT3kPL28KkT4qdpywH1/puJnnv0g/20B/M3rj
        zWgmiWc+PPxmAxVxABpdMhfqQlYJEI7AQqxd01mQvNGgFk7hJlHO7efIzdMJYCWv9BMdgcSpb89OY
        AE3sz+eoROQuOt48zeDgTWVsgDJXYbwSWSrjYnTownPdt5E+UQWzZSX4nus8W3RXjQQnWZSRDpfl6
        llzE3QfPbup2Hc4MIAkOcH+0SEt2g0IoJS9IQFysDkh7AWyaXv3txbauHYnXx/dFQSBDWvMvnzpQc
        iYTnSOBw==;
Received: from dsl-hkibng22-54f986-236.dhcp.inet.fi ([84.249.134.236] helo=[192.168.1.10])
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <cyndis@kapsi.fi>)
        id 1l1Sc7-0002u2-0x; Mon, 18 Jan 2021 13:22:27 +0200
Subject: Re: [PATCH v3] i2c: bpmp-tegra: Ignore unknown I2C_M flags
To:     Wolfram Sang <wsa@kernel.org>,
        Mikko Perttunen <mperttunen@nvidia.com>
Cc:     thierry.reding@gmail.com, jonathanh@nvidia.com, talho@nvidia.com,
        linux-i2c@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20210112102225.3737326-1-mperttunen@nvidia.com>
 <20210117112003.GB1983@ninjato>
From:   Mikko Perttunen <cyndis@kapsi.fi>
Message-ID: <99326ffc-7590-84ce-dfa7-7c09bc17ca31@kapsi.fi>
Date:   Mon, 18 Jan 2021 13:22:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210117112003.GB1983@ninjato>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 84.249.134.236
X-SA-Exim-Mail-From: cyndis@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/17/21 1:20 PM, Wolfram Sang wrote:
> On Tue, Jan 12, 2021 at 12:22:25PM +0200, Mikko Perttunen wrote:
>> In order to not to start returning errors when new I2C_M flags are
>> added, change behavior to just ignore all flags that we don't know
>> about. This includes the I2C_M_DMA_SAFE flag that already exists.
>>
>> Cc: stable@vger.kernel.org # v4.19+
>> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> 
> Applied to for-current, thanks! I added also this sentence from v2 to
> the description to justify stable: "but causes -EINVAL to be returned
> for valid transactions."

Thanks!

> 
> Also, this driver has no dedicated maintainer. Is there someone up for
> this task? There is probably little to do and it will speed up patch
> acceptance because I pick patches once the driver maintainer is happy.
> 

I think it falls under the 'TEGRA ARCHITECTURE SUPPORT' wildcard 
(Thierry and Jon). Do we need a more specific maintainer entry?

If it's helpful to Thierry and Jon, I guess I could pick it up.

Mikko
