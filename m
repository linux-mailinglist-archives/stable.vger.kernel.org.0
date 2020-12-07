Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB7412D1544
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 16:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbgLGP4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 10:56:15 -0500
Received: from gproxy10-pub.mail.unifiedlayer.com ([69.89.20.226]:54165 "EHLO
        gproxy10-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726250AbgLGP4P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 10:56:15 -0500
Received: from cmgw14.unifiedlayer.com (unknown [10.9.0.14])
        by gproxy10.mail.unifiedlayer.com (Postfix) with ESMTP id C88D514078E
        for <stable@vger.kernel.org>; Mon,  7 Dec 2020 08:55:34 -0700 (MST)
Received: from bh-25.webhostbox.net ([208.91.199.152])
        by cmsmtp with ESMTP
        id mIrOkJDoHwNNlmIrOkUR3s; Mon, 07 Dec 2020 08:55:34 -0700
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.3 cv=MKJOZvRl c=1 sm=1 tr=0
 a=QNED+QcLUkoL9qulTODnwA==:117 a=2cfIYNtKkjgZNaOwnGXpGw==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=kj9zAlcOel0A:10:nop_charset_1
 a=zTNgK-yGK50A:10:nop_rcvd_month_year
 a=evQFzbml-YQA:10:endurance_base64_authed_username_1 a=_jlGtV7tAAAA:8
 a=yFu0pY9xeM8WSDe_qikA:9 a=CjuIK1q_8ugA:10:nop_charset_2
 a=nlm17XC03S6CtCLSeiRr:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=sQ4FF6nFnm75YCOegGoECPYfa5x+9VwjLFrBth+z2ew=; b=k3572D5zjouoDZft84PzPEeuP3
        EEJjy/ceDgfiep8JpRfOjCLp+N7SglPNV2/B1WzZ0pfVZzRdaDsXYtg65ZqKD75MSXhdlUvBChkse
        PyRWJwQDLjaXqtb0vJ4Rk64De+dmfYFakwLF5J9SLID56RjZ7YT7z92CGOJxZLig09AWjpxSPI072
        X7tnPLG5ZdeNnwDQMXRy8FH5gB9LwXKAC1CPBq0L3sccMS2yQB65rYrTm6gzLkJkV63pJScgFVGI3
        mQySg3Ktbgg7RrC6GOBMnT/zBqqt1SduaL1w0hlN07jgeKC4sian78VDA1p5td+y/GKVKKgTCbnF1
        CC3SkS/w==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:59898 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <linux@roeck-us.net>)
        id 1kmIrN-002tZy-OI; Mon, 07 Dec 2020 15:55:33 +0000
Date:   Mon, 7 Dec 2020 07:55:32 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.9 00/46] 5.9.13-rc1 review
Message-ID: <20201207155532.GD43600@roeck-us.net>
References: <20201206111556.455533723@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201206111556.455533723@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1kmIrN-002tZy-OI
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:59898
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 41
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 06, 2020 at 12:17:08PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.9.13 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 08 Dec 2020 11:15:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 426 pass: 426 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
