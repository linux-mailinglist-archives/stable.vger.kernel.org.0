Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDF31150B7
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 13:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbfLFM60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 07:58:26 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:7396 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfLFM60 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Dec 2019 07:58:26 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dea50600000>; Fri, 06 Dec 2019 04:58:08 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 06 Dec 2019 04:58:25 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 06 Dec 2019 04:58:25 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 6 Dec
 2019 12:58:25 +0000
Received: from [10.21.133.51] (172.20.13.39) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 6 Dec 2019
 12:58:23 +0000
Subject: Re: stable request: 5.4.y: arm64: tegra: Fix 'active-low' warning for
 Jetson
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
References: <16724779-0514-ca92-58b2-95f4e244c6f7@nvidia.com>
 <28364ffa-586e-bdcd-acf3-119742c92185@nvidia.com>
 <20191206122335.GA1339268@kroah.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <61c527a5-7999-b3da-5b87-37e48f51ef5f@nvidia.com>
Date:   Fri, 6 Dec 2019 12:58:21 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191206122335.GA1339268@kroah.com>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1575637088; bh=qIeX4xg/7qhskydJEZIdD+fWbuKx0/Jpr807Lh03HZY=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=VnmpbZBV3oxqao/aUb6X2flWH/8ZeDrkD73YUKEShAA7Y5fNH0ODTftFh3knvSleu
         yRhtNm6gHI761Tq5X1AOxjPUxAiSPBz7sVcP2BeYbdWYrcre0js0Zi0vOG1xKIWf2F
         m8ZvvbYVpWSDS2PvW0PtGwTlo0PEz8IpIQqVqmhL/8EzHFdhztjscnG2G0OYZjeZbX
         T5cAfkdMj51JD+epbAMJv20QjUUgG4AaB9IqFKmBmtmWLooBAoXfA7g/IHy6zcUAyx
         k8BegOJwvB0lZWLjy1z5UJkUVveh3LNv8bSClVFPlBoECa//TdqiyMWUA1F7dxxpqK
         81krf5ImitomA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 06/12/2019 12:23, Greg Kroah-Hartman wrote:
> On Fri, Dec 06, 2019 at 11:04:38AM +0000, Jon Hunter wrote:
>>
>> On 06/12/2019 10:55, Jon Hunter wrote:
>>> External email: Use caution opening links or attachments
>>
>> Sorry ignore the above nonsense. Looks like a nice new 'feature' that
>> was sprung on us. I should be able to get this removed for future.
> 
> Odd, I don't see that on your email at all, perhaps you got it on the
> return to you?

Yes turns out it is just on inbound mail, so you would not have seen it.
I just need to ensure I strip it, but I think I can opt out of it
completely.

Jon

-- 
nvpublic
