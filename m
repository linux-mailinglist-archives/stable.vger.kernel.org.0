Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEAB2BC1AB
	for <lists+stable@lfdr.de>; Sat, 21 Nov 2020 20:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgKUTBD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Nov 2020 14:01:03 -0500
Received: from gproxy8-pub.mail.unifiedlayer.com ([67.222.33.93]:43018 "EHLO
        gproxy8-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727155AbgKUTBC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Nov 2020 14:01:02 -0500
X-Greylist: delayed 1410 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Nov 2020 14:01:02 EST
Received: from cmgw11.unifiedlayer.com (unknown [10.9.0.11])
        by gproxy8.mail.unifiedlayer.com (Postfix) with ESMTP id AC76B1AB058
        for <stable@vger.kernel.org>; Sat, 21 Nov 2020 11:37:32 -0700 (MST)
Received: from bh-25.webhostbox.net ([208.91.199.152])
        by cmsmtp with ESMTP
        id gXlMke6kAdCH5gXlMkjqzh; Sat, 21 Nov 2020 11:37:32 -0700
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.3 cv=LM5Ivqe9 c=1 sm=1 tr=0
 a=QNED+QcLUkoL9qulTODnwA==:117 a=2cfIYNtKkjgZNaOwnGXpGw==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=kj9zAlcOel0A:10:nop_charset_1
 a=nNwsprhYR40A:10:nop_rcvd_month_year
 a=evQFzbml-YQA:10:endurance_base64_authed_username_1 a=_jlGtV7tAAAA:8
 a=fdlRntML_--j2W6K2eYA:9 a=CjuIK1q_8ugA:10:nop_charset_2
 a=nlm17XC03S6CtCLSeiRr:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=nklTW5UvU8GSzOOTaBD8Byt5hLAWZa/rU9ilYdShtHI=; b=w49XblgwPZcekX0VFF1tgLG+9a
        b5yzrYlJnxWhKqCyJfSE0xyZZRowuF8JlrcnjObjfw+1HNUIJMCB9+mHN9j3H93N9ro+kt7tU3Gyp
        JvSI7EgAs1GTgtO0ykDflFWuXpRpe5FsxDnMFMaOZxk9/lbPfPD15n3vxe4z39GLfixdy/dBO93UP
        P77MKzTdBhnswEm7UVhCZsZFvXFh1qc2KUsCfDBMmd9d0iauxglMqtapMkqfpzIkvzzdKY6SVoYez
        HVbwzKF6AjPEJdzr3j8LDf+/5ZByaqIMVEEU7nRli9yBUpBx2DM0ArytdoN64Ew3RwkIvny1vfpRv
        FZ5bHw9w==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:40936 helo=localhost)
        by bh-25.webhostbox.net with esmtpa (Exim 4.93)
        (envelope-from <linux@roeck-us.net>)
        id 1kgXlL-0038IJ-I7; Sat, 21 Nov 2020 18:37:31 +0000
Date:   Sat, 21 Nov 2020 10:37:31 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/14] 4.19.159-rc1 review
Message-ID: <20201121183731.GE111877@roeck-us.net>
References: <20201120104539.806156260@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120104539.806156260@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1kgXlL-0038IJ-I7
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:40936
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 28
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 20, 2020 at 12:03:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.159 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 22 Nov 2020 10:45:32 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 417 pass: 417 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
