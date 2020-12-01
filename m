Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F5D2CAED9
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 22:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389578AbgLAVjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 16:39:21 -0500
Received: from gproxy5-pub.mail.unifiedlayer.com ([67.222.38.55]:44673 "EHLO
        gproxy5-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389635AbgLAVjU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 16:39:20 -0500
Received: from cmgw15.unifiedlayer.com (unknown [10.9.0.15])
        by gproxy5.mail.unifiedlayer.com (Postfix) with ESMTP id 927D114082F
        for <stable@vger.kernel.org>; Tue,  1 Dec 2020 14:38:38 -0700 (MST)
Received: from bh-25.webhostbox.net ([208.91.199.152])
        by cmsmtp with ESMTP
        id kDM6kMMIWh41lkDM6kPHKS; Tue, 01 Dec 2020 14:38:38 -0700
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.3 cv=B4iXLtlM c=1 sm=1 tr=0
 a=QNED+QcLUkoL9qulTODnwA==:117 a=2cfIYNtKkjgZNaOwnGXpGw==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=kj9zAlcOel0A:10:nop_charset_1
 a=zTNgK-yGK50A:10:nop_rcvd_month_year
 a=evQFzbml-YQA:10:endurance_base64_authed_username_1 a=_jlGtV7tAAAA:8
 a=4Umlx7kv9JDgo9_PKIgA:9 a=CjuIK1q_8ugA:10:nop_charset_2
 a=nlm17XC03S6CtCLSeiRr:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3xjs9wIEpHhUteSiUIPhwq0xSOsFP9uRPnKvGnDewM8=; b=scLmkjHJ1efNSTGxLMq2JbUEvc
        hw/AH92u9CHOVJlYmJQAqOlW9PSSYclvN3ColW+/n5R9bRzVLVl7oj+8WbWqUgMp1rYOrQJNvIB/o
        js264Ao3FzOCR55L5qovV7pFEkmfBkFpopGhwtPJKXcnDrFLC5pRNbyZ4hYKPOqCB0gZnuPLcxRzm
        s3pFvo9tLFff3ffFJqXh9ufUxyo860GNKTCNkoQ89ONjI5ihDdCl5I9HVzfpXd8Ky0i7/NApiE7tt
        NvNIixTO3/TWM6qNZSXV+Ukf3QK93wFQ9GXu2eo89bL19Fv7MWQ01UMlvI/ues5pRvJNynxT0hldp
        RQrsDSXw==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:33634 helo=localhost)
        by bh-25.webhostbox.net with esmtpa (Exim 4.93)
        (envelope-from <linux@roeck-us.net>)
        id 1kkDM5-003LIL-GE; Tue, 01 Dec 2020 21:38:37 +0000
Date:   Tue, 1 Dec 2020 13:38:36 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/24] 4.4.247-rc1 review
Message-ID: <20201201213836.GA12919@roeck-us.net>
References: <20201201084637.754785180@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201084637.754785180@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1kkDM5-003LIL-GE
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:33634
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 1
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 01, 2020 at 09:53:06AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.247 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 03 Dec 2020 08:46:29 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 165 pass: 165 fail: 0
Qemu test results:
	total: 328 pass: 328 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
