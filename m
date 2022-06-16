Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF0754DE5D
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 11:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbiFPJqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 05:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbiFPJqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 05:46:44 -0400
Received: from outbound-ss-820.bluehost.com (outbound-ss-820.bluehost.com [69.89.24.241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFCB05A0AE
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 02:46:43 -0700 (PDT)
Received: from cmgw13.mail.unifiedlayer.com (unknown [10.0.90.128])
        by progateway2.mail.pro1.eigbox.com (Postfix) with ESMTP id 673CA10049CC3
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 09:46:43 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id 1m5Kos9rUxkuL1m5LoYzLC; Thu, 16 Jun 2022 09:46:43 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=GuaHRm5C c=1 sm=1 tr=0 ts=62aafc03
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=JPEYwPQDsx4A:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=mVZf0fXdk7trcMvNlOsA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:In-Reply-To:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WLgbi3u8pNg7vhNOmwuDvv3Xld8l+MmAnMfEqYEXpUQ=; b=JvgRnxXXzW1sMEwuw/D4LGYsAk
        QNT22VMxFkSQzmSiVse3sfLcdxoV55A8G6Ge2gPq6wDDY6YzAy6TANdL8wFxjc80sUU3Ns3nCfbb6
        kEHO2Pnx+o+epC8F+5ShHqiYzovXX7phKn1LmSC/Y1ynkpHe95j60i2XKd9p4nyFisqqGM+SsyLMF
        P4n9Mlc+D2H1eHFCDCn8dduGeg4Tik33B6/j9GVn82rQyy+lZU6A19FNvrwv3Ff0sBEmcKfJgGZGO
        s1sbOwFKHCgpgoYPjHzHNBjbZ4V0gmmVxeXsNYFIb53YGFzhAEWYldkHJ7ra8HV2kNHOqfXnJZxSX
        /D6pPvkA==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:44504 helo=[10.0.1.48])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1o1m5J-0000VG-Pi;
        Thu, 16 Jun 2022 03:46:41 -0600
Subject: Re: [PATCH 5.10 00/11] 5.10.123-rc1 review
To:     Jon Hunter <jonathanh@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220614183719.878453780@linuxfoundation.org>
 <9e43b35e-31da-7e51-006c-1aa69acb10d4@nvidia.com>
From:   Ron Economos <re@w6rz.net>
In-Reply-To: <9e43b35e-31da-7e51-006c-1aa69acb10d4@nvidia.com>
Message-ID: <a05678bb-29f8-23ea-9260-cc1cece3f480@w6rz.net>
Date:   Thu, 16 Jun 2022 02:46:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux armv7l; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.162.232.9
X-Source-L: No
X-Exim-ID: 1o1m5J-0000VG-Pi
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:44504
X-Source-Auth: re@w6rz.net
X-Email-Count: 4
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SCC_BODY_URI_ONLY,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/16/22 1:48 AM, Jon Hunter wrote:
>
> On 14/06/2022 19:40, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.10.123 release.
>> There are 11 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.123-rc1.gz 
>>
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git 
>> linux-5.10.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>
> No new regressions for Tegra. I am seeing the following kernel warning 
> that is causing a boot test to fail, but this has been happening for a 
> few releases now (I would have reported it earlier but we have been 
> having some infrastructure issues) ...
>
>  WARNING KERN urandom_read_iter: 82 callbacks suppressed
>
> This appears to be introduced by commit "random: convert to using 
> fops->read_iter()" [0]. Interestingly, I am not seeing this in the 
> mainline as far as I can tell and so I am not sure if there is 
> something else that is missing?
>
I'm also seeing this on RISC-V. 5.15 and 5.17, but not 5.18.

