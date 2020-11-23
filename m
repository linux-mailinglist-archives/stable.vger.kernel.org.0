Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC012C187B
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 23:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730556AbgKWWe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 17:34:58 -0500
Received: from gproxy7-pub.mail.unifiedlayer.com ([70.40.196.235]:41562 "EHLO
        gproxy7-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728649AbgKWWe6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 17:34:58 -0500
Received: from cmgw11.unifiedlayer.com (unknown [10.9.0.11])
        by gproxy7.mail.unifiedlayer.com (Postfix) with ESMTP id 153CB215CD4
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 15:34:56 -0700 (MST)
Received: from bh-25.webhostbox.net ([208.91.199.152])
        by cmsmtp with ESMTP
        id hKQBkrEoxdCH5hKQBkwerg; Mon, 23 Nov 2020 15:34:56 -0700
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.3 cv=c96Fvy1l c=1 sm=1 tr=0
 a=QNED+QcLUkoL9qulTODnwA==:117 a=2cfIYNtKkjgZNaOwnGXpGw==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=kj9zAlcOel0A:10:nop_charset_1
 a=nNwsprhYR40A:10:nop_rcvd_month_year
 a=evQFzbml-YQA:10:endurance_base64_authed_username_1 a=zYuN4n1ukJWBC5y8lIQA:9
 a=CjuIK1q_8ugA:10:nop_charset_2
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QOx+eBti5728yBM1p5J1+PJQErWgKVyNr+KoihUmE9I=; b=gQZqSR0fMDe3rUcufSwzQiNyqK
        4ZgGm2gLP+bJB+Enm31MVU1cJZzNa5gs0xhl4MBOnAW7c3fQfw1nRlw5evUq3Q9IaALRFs4B/wUuk
        RVDIOQBaToZvsuxx2Y2i6m5356W2SSzZwiuT+A0xZ/jZ4Ovy3p/ObzlSxwcUayGSwL5lmZBbHvEuC
        hVLVfhfxkx9EfMX+4oPQEbdUJpou6v/n+57/PCc33ORMTCYLm33jNe00lyO62NIPcmgBA28gSQlOZ
        5ROBMfOsl1PkJUggTst6akCGruq3J5XksB6e+FJU21TigksxSTBx29ag5rtMLpUYbGSuA/Jm2YRm+
        6T0ILeGQ==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:53328 helo=localhost)
        by bh-25.webhostbox.net with esmtpa (Exim 4.93)
        (envelope-from <linux@roeck-us.net>)
        id 1khKQA-000UCy-UB; Mon, 23 Nov 2020 22:34:55 +0000
Date:   Mon, 23 Nov 2020 14:34:54 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/38] 4.4.246-rc1 review
Message-ID: <20201123223454.GA223204@roeck-us.net>
References: <20201123121804.306030358@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201123121804.306030358@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1khKQA-000UCy-UB
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:53328
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 1
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 23, 2020 at 01:21:46PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.246 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Nov 2020 12:17:50 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 165 pass: 165 fail: 0
Qemu test results:
	total: 328 pass: 328 fail: 0

Guenter
