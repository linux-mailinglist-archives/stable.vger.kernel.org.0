Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 123556E79EB
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 14:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbjDSMq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 08:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232690AbjDSMq5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 08:46:57 -0400
Received: from qproxy1-pub.mail.unifiedlayer.com (qproxy1-pub.mail.unifiedlayer.com [173.254.64.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92BC7686
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 05:46:55 -0700 (PDT)
Received: from outbound-ss-761.bluehost.com (outbound-ss-761.bluehost.com [74.220.211.250])
        by qproxy1.mail.unifiedlayer.com (Postfix) with ESMTP id 7B0988028401
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 12:46:55 +0000 (UTC)
Received: from cmgw12.mail.unifiedlayer.com (unknown [10.0.90.127])
        by progateway8.mail.pro1.eigbox.com (Postfix) with ESMTP id 0DAB4100454C5
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 12:46:55 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id p7D5pnSkT4NB1p7D5pL1Af; Wed, 19 Apr 2023 12:46:55 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=Ab90o1bG c=1 sm=1 tr=0 ts=643fe2bf
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=dKHAf1wccvYA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=XYAwZIGsAAAA:8
 a=VwQbUJbxAAAA:8 a=KpfOZQ45AAAA:8 a=h0uksLzaAAAA:8 a=puOezyK_5uT_Nh3Qo0QA:9
 a=QEXdDO2ut3YA:10:nop_charset_2 a=E8ToXWR_bxluHZ7gmE-Z:22
 a=AjGcO6oz07-iQ99wixmX:22 a=KHlNn528OWJD8b-aQ5dU:22 a=MSi_79tMYmZZG2gvAgS0:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9uJmgAn6Mve8eWQ9U34OqXIpdjTnTjK8C6E0nTYFjnA=; b=KVpms3xFDJDMIq1nCk4AI1nLfX
        rXU4ejipU6A7Ft5c56YE32maQlsB9qUU1UQX++nbBU+0TKEigZSTvTNl+3nt0KNxkElzAq7dmFmJ5
        CJhJBFeJq+bvtFJ29/TuR3Rq5J/ni+KVEQ2WYHoz8VLAK+/TcNUYC1ZJc6yGMA8jtjVSHW1CEtv5n
        YkU0unTC1DQJhHAemQnI4q+G1kVY0hsToT49736bhLcNn0y6hi7HETF9FMwxjUgaLBTAqPwDbg8Dy
        WxH6dwnLw/aztWwCGC2Hv5+Ly0qTyO8qCVVhmtZZBmmQt8lUPDwGMz10BqNMFzHwyfMExAbxZ3Bjr
        n8PMQfjA==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:35400 helo=[10.0.1.47])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1pp7D3-0021EP-DU;
        Wed, 19 Apr 2023 06:46:53 -0600
Subject: Re: [PATCH 6.1 000/132] 6.1.25-rc2 review
To:     Conor.Dooley@microchip.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, hi@alyssa.is
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230419093701.194867488@linuxfoundation.org>
 <306005cd-b4a0-44d3-c9b4-f3c238e1cde7@microchip.com>
In-Reply-To: <306005cd-b4a0-44d3-c9b4-f3c238e1cde7@microchip.com>
From:   Ron Economos <re@w6rz.net>
Message-ID: <5e3d78ec-40fb-70fa-2d25-a465c823fb1c@w6rz.net>
Date:   Wed, 19 Apr 2023 05:46:50 -0700
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
X-Exim-ID: 1pp7D3-0021EP-DU
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:35400
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/19/23 4:58 AM, Conor.Dooley@microchip.com wrote:
> On 19/04/2023 10:40, Greg Kroah-Hartman wrote:
>
>> This is the start of the stable review cycle for the 6.1.25 release.
>> There are 132 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 21 Apr 2023 09:36:33 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>           https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.25-rc2.gz
>> or in the git tree and branch at:
>>           git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>>
>> Alyssa Ross <hi@alyssa.is>
>>       purgatory: fix disabling debug info
> Alyssa provided a custom backport of this that did not require
> picking up Heiko's patch below, but it did not seem to get
> picked up.
> Lore is ~dead for me, so all I can give you here is her message-id
> for the custom backport: <20230418155237.2ubcusqc52nufmow@x220>
>
> Heiko's patch is dead code as you've (rightly) not backported
> any of the users.
>    
>> Heiko Stuebner <heiko.stuebner@vrull.eu>
>>       RISC-V: add infrastructure to allow different str* implementations
>
>
>> Alexandre Ghiti <alexghiti@rivosinc.com>
>>       riscv: Do not set initial_boot_params to the linear address of the dtb
> This one should also be dropped, either the whole series or
> none of it please!
>
> Alex has said he'll send the lot in a way that avoids confusion.
>
> Otherwise, my testing passed.
>
> Thanks,
> Conor.

The "riscv: Do not set initial_boot_params to the linear address of the 
dtb" patch is fatal. Definitely needs to be dropped.

[    0.000000] Hardware name: SiFive HiFive Unmatched A00 (DT)
[    0.000000] epc : fdt_check_header+0xe/0x230
[    0.000000]  ra : __unflatten_device_tree+0x4e/0x320
[    0.000000] epc : ffffffff80ae48e6 ra : ffffffff808bba16 sp : 
ffffffff81803e0
[    0.000000]  gp : ffffffff81a3d390 tp : ffffffff81811200 t0 : 
ffffffc6fefff00
[    0.000000]  t1 : 000000047fff0000 t2 : 65736552203a616d s0 : 
ffffffff81803e0
[    0.000000]  s1 : 0000000040000000 a0 : 0000000040000000 a1 : 
000000000000000
[    0.000000]  a2 : ffffffff81a43188 a3 : ffffffff80c3fbd0 a4 : 
000000000000000
[    0.000000]  a5 : 0000000000000000 a6 : 0000000000000000 a7 : 
000000000000000
[    0.000000]  s2 : 00000000fff63036 s3 : ffffffff81a43188 s4 : 
000000000000000
[    0.000000]  s5 : ffffffff80c3fbd0 s6 : 0000000000000000 s7 : 
000000000000000
[    0.000000]  s8 : 00000000fff63036 s9 : 00000000fffcbf60 s10: 
000000000000000
[    0.000000]  s11: 00000000fffcbf60 t3 : ffffffff80e12288 t4 : 
ffffffff80e1228
[    0.000000]  t5 : ffffffff80e12288 t6 : ffffffff80e122a0
[    0.000000] status: 0000000200000100 badaddr: 0000000040000001 cause: 
000000d
[    0.000000] [<ffffffff80ae48e6>] fdt_check_header+0xe/0x230
[    0.000000] ---[ end trace 0000000000000000 ]---
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.000000] ---[ end Kernel panic - not syncing: Attempted to kill 
the idle -

