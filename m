Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDD51150E4
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 14:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbfLFNQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 08:16:22 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:14425 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbfLFNQV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Dec 2019 08:16:21 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dea549f0000>; Fri, 06 Dec 2019 05:16:15 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 06 Dec 2019 05:16:20 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 06 Dec 2019 05:16:20 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 6 Dec
 2019 13:16:19 +0000
Received: from [10.21.133.51] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 6 Dec 2019
 13:16:18 +0000
Subject: Re: stable request: 5.4.y: arm64: tegra: Fix 'active-low' warning for
 Jetson
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
References: <16724779-0514-ca92-58b2-95f4e244c6f7@nvidia.com>
 <20191206125334.GA1361962@kroah.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <ee190492-5af8-7ef1-5524-4f260d64094d@nvidia.com>
Date:   Fri, 6 Dec 2019 13:16:15 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191206125334.GA1361962@kroah.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1575638175; bh=fBEZGD9gtKtPMA5VVRXvkw+tooYcTl65EnJoJBPA0rI=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=AKMQ57BzzDGA46wFMUEEvoOiw2NlOfzk90WCosFB4cZLJ6azVjOu5lwmRQaI4UJ97
         ROS8eLrDrod+R3gHDDRZ5dE/FE/cUauZywQIj6OEj3M1oAanC4Io+UQ+fVu139KVmb
         d+XxMyfxYQ6nRR9rVaMCeSSPuNo3WuYNBGAwRXAp37UKBm7od6l1Jn8qfSCTFCgkmW
         DUXX2rPQKVd+EmE7rjkNUFtaP5AK8oif5IT6ArmL7lRZCuddTvI6ETRwGP1z43NdqT
         mzQ67RMzbKOOj3HdqRDXHqH5XRtPVRRzD8rtpcbMJ1FyCAQ1Ilj+BeR00px8be44Aq
         7UGVgcbT0Y82A==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 06/12/2019 12:53, Greg Kroah-Hartman wrote:
> On Fri, Dec 06, 2019 at 10:55:17AM +0000, Jon Hunter wrote:
>> Hi Greg,
>>
>> Please can you include the following device-tree fixes for 5.4.y that
>> are triggering some warnings on a couple of our Jetson platforms. This
>> is currently causing one of our kernel warnings tests to fail. Both of
>> these have now been merged into the mainline for v5.5-rc1.
>>
>> commit d440538e5f219900a9fc9d96fd10727b4d2b3c48
>> Author: Jon Hunter <jonathanh@nvidia.com>
>> Date:   Wed Sep 25 15:12:28 2019 +0100
>>
>>     arm64: tegra: Fix 'active-low' warning for Jetson Xavier regulator
>>
>> commit 1e5e929c009559bd7e898ac8e17a5d01037cb057
>> Author: Jon Hunter <jonathanh@nvidia.com>
>> Date:   Wed Sep 25 15:12:29 2019 +0100
>>
>>     arm64: tegra: Fix 'active-low' warning for Jetson TX1 regulator
>>
>> Thanks
>> Jon
> 
> Now queued up, thanks.

Thanks. BTW were you also able to queue the following? This is another
one that is needed for 5.4.y.

commit c745da8d4320c49e54662c0a8f7cb6b8204f44c4
Author: Jon Hunter <jonathanh@nvidia.com>
Date:   Fri Oct 11 09:34:59 2019 +0100

    mailbox: tegra: Fix superfluous IRQ error message

Cheers
Jon

-- 
nvpublic
