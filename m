Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 739B1643FD0
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 10:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233811AbiLFJ0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 04:26:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233558AbiLFJZr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 04:25:47 -0500
Received: from progateway7-pub.mail.pro1.eigbox.com (gproxy5-pub.mail.unifiedlayer.com [67.222.38.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D25E13D33
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 01:25:47 -0800 (PST)
Received: from cmgw15.mail.unifiedlayer.com (unknown [10.0.90.130])
        by progateway7.mail.pro1.eigbox.com (Postfix) with ESMTP id 1D2EA10044A69
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 09:25:35 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id 2UCkpanlb5g7L2UCkpzd76; Tue, 06 Dec 2022 09:25:35 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=J5tvUCrS c=1 sm=1 tr=0 ts=638f0a8f
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=sHyYjHe8cH0A:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=1GQxe75yrw9fIeUcjpcA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:In-Reply-To:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FlNqVGrvtNSL6qyd33cZ4bkIqjrXwRGEEZ0ySVFGUcw=; b=nNwlS5umgwHwWCv54vgsmn7fSI
        D7Bv2A6AJKu42IEfA6eAa47qNbfh6C/y1J/ncDHoeKxJKS8/8dW+dAqjCQeq+8FKJo8VNOBh0Uuig
        IF9MpU0S4huhhaazXjMq34iahkGwNiIUyumdJOmfcE7gHfsH+2q3KTOTP8dd8y8vdW5y7aS8EnueK
        5/aFXuDqscGhx+j3XM8Ha6NPj6mFCc/qbpvIdu1IvFWiK31jb8hHRi2dO5JDE9PK2R0ehIBzkH/Rs
        Ix3srIzp384d6jsP96wA951NpOzRVrYx6bsD7a2lSoPrerDSvMF5Wab0Mwtqap8433PNSoEdnbX8n
        WFbMcBuw==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:60198 helo=[10.0.1.48])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1p2UCj-003cjK-CD;
        Tue, 06 Dec 2022 02:25:33 -0700
Subject: Re: [PATCH 5.15 000/120] 5.15.82-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20221205190806.528972574@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
Message-ID: <ad355e64-1a5a-a409-e404-13a70b481e9b@w6rz.net>
Date:   Tue, 6 Dec 2022 01:25:29 -0800
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
X-Exim-ID: 1p2UCj-003cjK-CD
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:60198
X-Source-Auth: re@w6rz.net
X-Email-Count: 2
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/5/22 11:09 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.82 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.82-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
Fails to build on RISC-V RV64 with the following:

arch/riscv/kernel/smp.c: In function ‘handle_IPI’:
arch/riscv/kernel/smp.c:195:44: error: ‘cpu’ undeclared (first use in 
this function)
   195 |                         ipi_cpu_crash_stop(cpu, get_irq_regs());
       |                                            ^~~
arch/riscv/kernel/smp.c:195:44: note: each undeclared identifier is 
reported only once for each function it appears in
arch/riscv/kernel/smp.c:217:22: error: ‘old_regs’ undeclared (first use 
in this function)
   217 |         set_irq_regs(old_regs);
       |                      ^~~~~~~~

It's caused by the patch "riscv: kexec: Fixup crash_smp_send_stop 
without multi cores".

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-5.15.y&id=87cc180470e099ae8f53e5e76cb6f4c1460d6d83

That patch relies on a much older patch that was never backported to 5.15.

The patch "riscv: kexec: Fixup irq controller broken in kexec crash 
path" should also be reverted since it's part of the same series.

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-5.15.y&id=3be3dce50bdf92817d16b3495d573186b967484c

Tested-by: Ron Economos <re@w6rz.net>

