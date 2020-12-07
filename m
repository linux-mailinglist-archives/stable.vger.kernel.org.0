Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5952C2D153A
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 16:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgLGPyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 10:54:47 -0500
Received: from gproxy4-pub.mail.unifiedlayer.com ([69.89.23.142]:60875 "EHLO
        gproxy4-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726000AbgLGPyr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 10:54:47 -0500
Received: from CMGW (unknown [10.9.0.13])
        by gproxy4.mail.unifiedlayer.com (Postfix) with ESMTP id 15592176C86
        for <stable@vger.kernel.org>; Mon,  7 Dec 2020 08:54:06 -0700 (MST)
Received: from bh-25.webhostbox.net ([208.91.199.152])
        by cmsmtp with ESMTP
        id mIpxksXjgi1lMmIpxkpipq; Mon, 07 Dec 2020 08:54:06 -0700
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.2 cv=KcKiiUQD c=1 sm=1 tr=0
 a=QNED+QcLUkoL9qulTODnwA==:117 a=2cfIYNtKkjgZNaOwnGXpGw==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10
 a=evQFzbml-YQA:10 a=_jlGtV7tAAAA:8 a=scmqx5nEzC6ecY5XZmMA:9 a=CjuIK1q_8ugA:10
 a=nlm17XC03S6CtCLSeiRr:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FLlAQkAtxtOE5fy8bROlSTjBWj22QU4jjmu1tRBQiBc=; b=KSEV3Be9vKNVEjljuGdfFqHj5E
        3w5J16fXGKhYhDxRYzKFwl5IDCXCqR5YXuPT/T4+jJEHhSZEVOGMbKE6q1qsv+fnl+qi7qiqYNk/t
        m9AEm1Aymz8GRC5xOIP+AQIbKrb1Ef/snbWWe8OADfE1sTfVN8yC3Fnq1XLhmfz7bb2wEEAx9Z1cn
        dX4mpisdnYfXKWMxp8TPAmZUO3SFGZ6K9pZUR+xXRI6FLMYBW3Nk9aKpkOxyZGNURNKyRhh5yvnsZ
        MWhs4M5NOF9/oh442y4YRenDuAGrAKtUj++sWll7r5rZtsRoIN8PyH8qNxFql2ivrmuyO6lcQmesv
        G26hyEaQ==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:59890 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <linux@roeck-us.net>)
        id 1kmIpw-002szA-Vq; Mon, 07 Dec 2020 15:54:05 +0000
Date:   Mon, 7 Dec 2020 07:54:04 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/20] 4.14.211-rc1 review
Message-ID: <20201207155404.GA43600@roeck-us.net>
References: <20201206111555.569713359@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201206111555.569713359@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1kmIpw-002szA-Vq
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:59890
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 14
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 06, 2020 at 12:17:03PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.211 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 08 Dec 2020 11:15:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 404 pass: 404 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Genter
