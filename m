Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52B42C1882
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 23:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732590AbgKWWf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 17:35:56 -0500
Received: from gproxy1-pub.mail.unifiedlayer.com ([69.89.25.95]:35066 "EHLO
        gproxy1-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732583AbgKWWfz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 17:35:55 -0500
Received: from CMGW (unknown [10.9.0.13])
        by gproxy1.mail.unifiedlayer.com (Postfix) with ESMTP id 07187BB17206D
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 15:35:55 -0700 (MST)
Received: from bh-25.webhostbox.net ([208.91.199.152])
        by cmsmtp with ESMTP
        id hKR8kbfqXi1lMhKR8karhO; Mon, 23 Nov 2020 15:35:55 -0700
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.2 cv=dPvWoKRb c=1 sm=1 tr=0
 a=QNED+QcLUkoL9qulTODnwA==:117 a=2cfIYNtKkjgZNaOwnGXpGw==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=kj9zAlcOel0A:10 a=nNwsprhYR40A:10
 a=evQFzbml-YQA:10 a=_jlGtV7tAAAA:8 a=P0IHjmhyoBqlU0BRrBYA:9 a=CjuIK1q_8ugA:10
 a=nlm17XC03S6CtCLSeiRr:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=DLOKKh23PRhX2QPUA1NUtu1P5dVf/Uv3+kgKGAgJ9Aw=; b=F28No0CeoQAuZKnvCuPZE6kSKY
        ZQnaTPBqOT+5gPgvl7bfYJSh//4RJSMI5Er9kAUwk/JJDFqaMzJGYLBnKqCXwb0c7Riw8xM5OSNy0
        qSxz5TjYzvcXlmk2NCrcTt/4UgtF5sGRRv9/ZruO/PQpDmA3EZVM4LLquL11GLU2EqenP4xyHzTSj
        8bLpd48PThm2szCWpQRAMbOzFWVsGqfzbRMkcwj14FDFQMU2h0Q9Xb+cZnaCIl8R3AwRiJDVzaRzN
        Obv9uodZyq3eQh1ToKm+T2DRXhBa01P1LGaWf/w5vnazBpRmPP7QiXO48cV8OYI2qBxlXqoQCQEon
        xxwbu2Iw==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:53334 helo=localhost)
        by bh-25.webhostbox.net with esmtpa (Exim 4.93)
        (envelope-from <linux@roeck-us.net>)
        id 1khKR7-000UUp-Ru; Mon, 23 Nov 2020 22:35:54 +0000
Date:   Mon, 23 Nov 2020 14:35:53 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/60] 4.14.209-rc1 review
Message-ID: <20201123223553.GC223204@roeck-us.net>
References: <20201123121805.028396732@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201123121805.028396732@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1khKR7-000UUp-Ru
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:53334
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 19
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 23, 2020 at 01:21:42PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.209 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Nov 2020 12:17:50 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 404 pass: 404 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
