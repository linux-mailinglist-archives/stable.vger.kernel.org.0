Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 114BF2D6C1C
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 01:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394428AbgLJXp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 18:45:28 -0500
Received: from gproxy6-pub.mail.unifiedlayer.com ([67.222.39.168]:54930 "EHLO
        gproxy6-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391754AbgLJXov (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 18:44:51 -0500
Received: from CMGW (unknown [10.9.0.13])
        by gproxy6.mail.unifiedlayer.com (Postfix) with ESMTP id 080641E06DF
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 16:44:08 -0700 (MST)
Received: from bh-25.webhostbox.net ([208.91.199.152])
        by cmsmtp with ESMTP
        id nVbTkFEz4i1lMnVbTkBvlU; Thu, 10 Dec 2020 16:44:08 -0700
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.2 cv=UIKtJGXy c=1 sm=1 tr=0
 a=QNED+QcLUkoL9qulTODnwA==:117 a=2cfIYNtKkjgZNaOwnGXpGw==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10
 a=evQFzbml-YQA:10 a=_jlGtV7tAAAA:8 a=7SmjOsVxDckMDeVQEeMA:9 a=CjuIK1q_8ugA:10
 a=nlm17XC03S6CtCLSeiRr:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LlG1E7buaiQIk6RlZwx6qKhUB5iIZVMBUKvzgPwO7s4=; b=U4Wt45JNDbP6jQPYdQttTxB/Dc
        1lImKvcAw5LtD3ulgFS7j6DQ6Brj/eow5HfslnQngWeV/zAumSPpcIlOAEDdAJtrwYiBhcf9Gkyzs
        RHJf6pDOWfsGDW5Eogi01tAQdkau3LaO+pLYFyWVZj6eSaJJVsO+svIBgTqj2/PQDUw9/kHGd6iZ/
        E/zRe7VbIXRcpNEiVYsM5TsgBH3fD7o5I74C0wxGolcSoBNzVrRFx5kMUDtf1edkqpgdfKHjvuHoN
        055DsI6XDKbnyFGUnGLCFw9HKOD/+uhqyAgsaxZZv8erjR7X3Hj43/1HvtePXM9N4zpydM8n4VQlU
        n5V+oMFQ==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:34626 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <linux@roeck-us.net>)
        id 1knVbT-0044Ui-38; Thu, 10 Dec 2020 23:44:07 +0000
Date:   Thu, 10 Dec 2020 15:44:06 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/31] 4.14.212-rc1 review
Message-ID: <20201210234406.GB259082@roeck-us.net>
References: <20201210142602.099683598@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210142602.099683598@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1knVbT-0044Ui-38
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:34626
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 11
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 10, 2020 at 03:26:37PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.212 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Dec 2020 14:25:47 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 404 pass: 404 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
