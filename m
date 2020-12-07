Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC292D153D
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 16:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgLGPzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 10:55:16 -0500
Received: from gproxy3-pub.mail.unifiedlayer.com ([69.89.30.42]:43670 "EHLO
        gproxy3-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727060AbgLGPzN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 10:55:13 -0500
Received: from cmgw14.unifiedlayer.com (unknown [10.9.0.14])
        by gproxy3.mail.unifiedlayer.com (Postfix) with ESMTP id DBF8E40065
        for <stable@vger.kernel.org>; Mon,  7 Dec 2020 08:54:32 -0700 (MST)
Received: from bh-25.webhostbox.net ([208.91.199.152])
        by cmsmtp with ESMTP
        id mIqOkJDViwNNlmIqOkUQlh; Mon, 07 Dec 2020 08:54:32 -0700
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.3 cv=MKJOZvRl c=1 sm=1 tr=0
 a=QNED+QcLUkoL9qulTODnwA==:117 a=2cfIYNtKkjgZNaOwnGXpGw==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=kj9zAlcOel0A:10:nop_charset_1
 a=zTNgK-yGK50A:10:nop_rcvd_month_year
 a=evQFzbml-YQA:10:endurance_base64_authed_username_1 a=_jlGtV7tAAAA:8
 a=PnUBI_lfvFj6i1KUNy4A:9 a=CjuIK1q_8ugA:10:nop_charset_2
 a=nlm17XC03S6CtCLSeiRr:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=KWK+9KYlUAF+uw27TVEWyd13e+gbnINI98S9ZNj/KZg=; b=qEWz2FH1+A6ScSeE9Wb5dv6GH2
        LC0ZcT4Q6ySaHA43RjXaUr1I9EnGFMbcYrRbvyYx/VCOJ15u6UyQY8jSzJ2I1sSE6viD5Puoyjs0a
        e3y4D7wkBIoUsJybK2tKDE4f9YdRxxr8sU5nkNKzg/rQlAmpTeUwe+pSufX1O+uU/rgUL/NQznepp
        /ejcOjnRDYSwy+p4iDQqbEp0LPUhYZk+90/qhqTTDn2zo3ZEd5CMBMSEdhnF/ccB6x/4hA0Z5RYnc
        qMC+MrZBKd511TppX1G/0NWDwcwiJh6xBxDbOWNq+dD0lfw6OK7UHdnekoRGdO8islTXYHfn97YRO
        Wy8lXTyg==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:59894 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <linux@roeck-us.net>)
        id 1kmIqN-002tBJ-Qs; Mon, 07 Dec 2020 15:54:31 +0000
Date:   Mon, 7 Dec 2020 07:54:31 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/32] 4.19.162-rc1 review
Message-ID: <20201207155431.GB43600@roeck-us.net>
References: <20201206111555.787862631@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201206111555.787862631@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1kmIqN-002tBJ-Qs
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:59894
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 23
X-Org:  HG=direseller_whb_net_legacy;ORG=directi;
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 06, 2020 at 12:17:00PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.162 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 08 Dec 2020 11:15:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 417 pass: 417 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
