Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED2E82D6C2B
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 01:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388996AbgLJXrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 18:47:36 -0500
Received: from gproxy2-pub.mail.unifiedlayer.com ([69.89.18.3]:59788 "EHLO
        gproxy2-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389463AbgLJXrQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 18:47:16 -0500
Received: from cmgw15.unifiedlayer.com (unknown [10.9.0.15])
        by gproxy2.mail.unifiedlayer.com (Postfix) with ESMTP id 946CB1E60FB
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 16:46:25 -0700 (MST)
Received: from bh-25.webhostbox.net ([208.91.199.152])
        by cmsmtp with ESMTP
        id nVdhkXQoWh41lnVdhkZ0ct; Thu, 10 Dec 2020 16:46:25 -0700
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.3 cv=JNUVTfCb c=1 sm=1 tr=0
 a=QNED+QcLUkoL9qulTODnwA==:117 a=2cfIYNtKkjgZNaOwnGXpGw==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=kj9zAlcOel0A:10:nop_charset_1
 a=zTNgK-yGK50A:10:nop_rcvd_month_year
 a=evQFzbml-YQA:10:endurance_base64_authed_username_1 a=_jlGtV7tAAAA:8
 a=kvk3kt7nRNyH8w8It4sA:9 a=CjuIK1q_8ugA:10:nop_charset_2
 a=nlm17XC03S6CtCLSeiRr:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=i8kUSeuv715kse3PbFIteUNOMNrQbQU5yphbekTMRMQ=; b=JsKOSZ2jXQ6NrSJQVYMS7vg0O7
        r2ANH45dbIX4iCzT1MlpZQvYwVaCtl8lK+ee2fUoDi4mSHlQCYPI5B4ccl8Qfm9IpVQzeYaPF8fVC
        lcA6BHXvaMi/0i1vZ9rlZLV1vH5nMSgl3Il66uN2IJzuXucpaXsRdXOPSVa7baVj7rLzkgXxDXarH
        N7EZDLVkWAElP3I8N4zl7ee0ArrvsP+Yfr29ipyMo6cngOyvmljSIkOhO/9qFOY1HSVk3+bdVE2bl
        sdqF+WmVkghNtWDcG6wJyh/5bJkBsbz37FJN9TxQ10tDoN12RvDKdWenxosmzgkX2PIpmpcI/dvWj
        VXA0kKpA==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:34642 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <linux@roeck-us.net>)
        id 1knVdg-0045ZJ-Li; Thu, 10 Dec 2020 23:46:24 +0000
Date:   Thu, 10 Dec 2020 15:46:23 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.9 00/75] 5.9.14-rc1 review
Message-ID: <20201210234623.GE259082@roeck-us.net>
References: <20201210142606.074509102@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1knVdg-0045ZJ-Li
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:34642
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 38
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 10, 2020 at 03:26:25PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.9.14 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Dec 2020 14:25:47 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 426 pass: 426 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
