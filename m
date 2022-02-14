Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91E4E4B5EF3
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 01:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbiBOATp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 19:19:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbiBOATo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 19:19:44 -0500
X-Greylist: delayed 1264 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 14 Feb 2022 16:19:35 PST
Received: from qproxy3-pub.mail.unifiedlayer.com (qproxy3-pub.mail.unifiedlayer.com [67.222.38.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF01012D0B2
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 16:19:35 -0800 (PST)
Received: from gproxy3-pub.mail.unifiedlayer.com (gproxy3-pub.mail.unifiedlayer.com [69.89.30.42])
        by qproxy3.mail.unifiedlayer.com (Postfix) with ESMTP id D3F38802A95B
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 23:58:30 +0000 (UTC)
Received: from cmgw11.mail.unifiedlayer.com (unknown [10.0.90.126])
        by progateway5.mail.pro1.eigbox.com (Postfix) with ESMTP id 2074410047BCC
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 23:58:30 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id JlEjnISntwm8iJlEjnJ9Zf; Mon, 14 Feb 2022 23:58:30 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=DpSTREz+ c=1 sm=1 tr=0 ts=620aeca6
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=oGFeUVbbRNcA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ScEyoHUccvNVCjYeOJrZASzf1PVV3fhbdAISfsk9YVQ=; b=mYnlATE2wAPc/qkXEbilWbK9zP
        IYHKd+RD2dGrswOQctONmhQtH0sUJdKhmDxEhFSUstgAz0Vj03dnJ2puJK6XDekShagccCiFZvEWf
        ru9vrBxIwoVDDvdmgoKHvOI6f;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:54484 helo=[10.0.1.23])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <re@w6rz.net>)
        id 1nJlEi-000FYY-UJ; Mon, 14 Feb 2022 16:58:28 -0700
Message-ID: <ca5640d6-d4b1-e51f-6d9f-58f5705cc1e3@w6rz.net>
Date:   Mon, 14 Feb 2022 15:58:27 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.15 000/172] 5.15.24-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220214092506.354292783@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.162.232.9
X-Source-L: No
X-Exim-ID: 1nJlEi-000FYY-UJ
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.23]) [73.162.232.9]:54484
X-Source-Auth: re@w6rz.net
X-Email-Count: 12
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/14/22 01:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.24 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.24-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

