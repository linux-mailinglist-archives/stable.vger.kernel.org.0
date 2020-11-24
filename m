Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52DCD2C1B55
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 03:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbgKXCOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 21:14:24 -0500
Received: from gproxy7-pub.mail.unifiedlayer.com ([70.40.196.235]:50325 "EHLO
        gproxy7-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725815AbgKXCOX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 21:14:23 -0500
Received: from cmgw14.unifiedlayer.com (unknown [10.9.0.14])
        by gproxy7.mail.unifiedlayer.com (Postfix) with ESMTP id DFB91215D59
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 19:14:22 -0700 (MST)
Received: from bh-25.webhostbox.net ([208.91.199.152])
        by cmsmtp with ESMTP
        id hNqYkfDPbwNNlhNqYksPqT; Mon, 23 Nov 2020 19:14:22 -0700
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.3 cv=BoezP7f5 c=1 sm=1 tr=0
 a=QNED+QcLUkoL9qulTODnwA==:117 a=2cfIYNtKkjgZNaOwnGXpGw==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=kj9zAlcOel0A:10:nop_charset_1
 a=nNwsprhYR40A:10:nop_rcvd_month_year
 a=evQFzbml-YQA:10:endurance_base64_authed_username_1 a=_jlGtV7tAAAA:8
 a=YevrULbxMgbQK5KSpNMA:9 a=CjuIK1q_8ugA:10:nop_charset_2
 a=nlm17XC03S6CtCLSeiRr:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=TiwS3FNytJtkbUAhClok+Gwi0wLN7M+aJliiPHXvBgA=; b=t+KXkxXuvBIbcbKHbacfEUp/rl
        bk5wyYDl8iQK4zQl4eNpFfLvsy+luPAv6vkClAcP5pAzRXAiFopOape8Gy1MhOwgCkxcuhZ9nPmGs
        x4+t19Zpry19oAd9c5kdOlnr0b/fthrRGWELae3E3ZMSeeQkHwQ/YemRWsYboJazJ+ig0YhP9GVVk
        6No1dNOnI5fo+DcWtU+Wk8hjool0AHk9zl+ObpP5SmwZ562zusgtBnuTrCOYYnVQSKZYcTSJ/HJR6
        2RRD0QP8OyPU+1ijWY1XXVsCE12Wntu8qHyTo7koeUZReDCd9mf2vMMgskIbIDQKQ5fw8Uqw+wL1l
        LonhF/CQ==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:54024 helo=localhost)
        by bh-25.webhostbox.net with esmtpa (Exim 4.93)
        (envelope-from <linux@roeck-us.net>)
        id 1khNqX-001t9M-Qm; Tue, 24 Nov 2020 02:14:21 +0000
Date:   Mon, 23 Nov 2020 18:14:21 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/158] 5.4.80-rc1 review
Message-ID: <20201124021421.GA229092@roeck-us.net>
References: <20201123121819.943135899@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1khNqX-001t9M-Qm
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:54024
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 1
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 23, 2020 at 01:20:28PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.80 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Nov 2020 12:17:50 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 426 pass: 426 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
