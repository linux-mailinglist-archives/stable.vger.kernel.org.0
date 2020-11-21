Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7E02BC1AA
	for <lists+stable@lfdr.de>; Sat, 21 Nov 2020 20:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbgKUTBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Nov 2020 14:01:02 -0500
Received: from gproxy3-pub.mail.unifiedlayer.com ([69.89.30.42]:35167 "EHLO
        gproxy3-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726305AbgKUTBC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Nov 2020 14:01:02 -0500
X-Greylist: delayed 1363 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Nov 2020 14:01:01 EST
Received: from CMGW (unknown [10.9.0.13])
        by gproxy3.mail.unifiedlayer.com (Postfix) with ESMTP id 922E7400B3
        for <stable@vger.kernel.org>; Sat, 21 Nov 2020 11:38:18 -0700 (MST)
Received: from bh-25.webhostbox.net ([208.91.199.152])
        by cmsmtp with ESMTP
        id gXm6kRQYEi1lMgXm6kQwk9; Sat, 21 Nov 2020 11:38:18 -0700
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.2 cv=D4A3ErZj c=1 sm=1 tr=0
 a=QNED+QcLUkoL9qulTODnwA==:117 a=2cfIYNtKkjgZNaOwnGXpGw==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=kj9zAlcOel0A:10 a=nNwsprhYR40A:10
 a=evQFzbml-YQA:10 a=_jlGtV7tAAAA:8 a=959YoNXsCQVYEN-jlBQA:9 a=CjuIK1q_8ugA:10
 a=nlm17XC03S6CtCLSeiRr:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gjTsQMpb8Fsw6hXBqlFhYKEFt77M9HPCU5xg2TbjIpU=; b=kvzYCSNgBMbTdpsi72lmk3PFtl
        iFQNpRTYLGjQiorLZtfeFGjFVQZAzTyzDJFbYtZoHIkjIr2WuOUnOJw8t8oDuyvEmH4WZQTtvVSSf
        gNxljeljLl4AsQ4pZYgXFOzrGmTlcRjUlXex98fl565tEOtNWPQKWvQqnfalmcwoAAEriXeeDmp75
        quB3o2Df1hjgmyDrLaMuyZGCtRAVhLpiDgoV1eY2YGjjGqyCCiC2xJ+97j6H86Kn2vQ0fVIcaeR8z
        ZL67VrrYLJCBHC4w5/vQdp9o44FBZ8p/WXk/kUz/KH4KM1KVy4bfOWX/Aymbh5wBexGekGcFgj95l
        s1IRYQ2w==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:40942 helo=localhost)
        by bh-25.webhostbox.net with esmtpa (Exim 4.93)
        (envelope-from <linux@roeck-us.net>)
        id 1kgXm5-0038XF-Fu; Sat, 21 Nov 2020 18:38:17 +0000
Date:   Sat, 21 Nov 2020 10:38:17 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.9 00/14] 5.9.10-rc1 review
Message-ID: <20201121183817.GG111877@roeck-us.net>
References: <20201120104541.168007611@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120104541.168007611@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1kgXm5-0038XF-Fu
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:40942
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 46
X-Org:  HG=direseller_whb_net_legacy;ORG=directi;
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 20, 2020 at 12:03:38PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.9.10 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 22 Nov 2020 10:45:32 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 426 pass: 426 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
