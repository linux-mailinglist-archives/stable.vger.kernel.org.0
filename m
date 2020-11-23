Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E482C1885
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 23:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgKWWg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 17:36:26 -0500
Received: from gproxy5-pub.mail.unifiedlayer.com ([67.222.38.55]:47834 "EHLO
        gproxy5-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728226AbgKWWg0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 17:36:26 -0500
Received: from cmgw10.unifiedlayer.com (unknown [10.9.0.10])
        by gproxy5.mail.unifiedlayer.com (Postfix) with ESMTP id A9395140499
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 15:36:24 -0700 (MST)
Received: from bh-25.webhostbox.net ([208.91.199.152])
        by cmsmtp with ESMTP
        id hKRckvLOZDlydhKRckkU6L; Mon, 23 Nov 2020 15:36:24 -0700
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.3 cv=B+CXLtlM c=1 sm=1 tr=0
 a=QNED+QcLUkoL9qulTODnwA==:117 a=2cfIYNtKkjgZNaOwnGXpGw==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=kj9zAlcOel0A:10:nop_charset_1
 a=nNwsprhYR40A:10:nop_rcvd_month_year
 a=evQFzbml-YQA:10:endurance_base64_authed_username_1 a=_jlGtV7tAAAA:8
 a=QY7kn9Tg4AiwF_6MvTQA:9 a=CjuIK1q_8ugA:10:nop_charset_2
 a=nlm17XC03S6CtCLSeiRr:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1fDQxTpWAmlUyRwTogQsFazEiq7GaUsBNV4eZII4LYA=; b=FJX+AfCIeH7iJT6kRq0nD58iQ8
        IR6erhVUzCKI2Z7sz8auH0pjLJ0lUYeq+LkTQXudWCVDFbYLeTEkx64oFQH4V7MJAyNvHZaobTpyU
        RfnpA/uRcWYEsfxgAit/hMZMIPx5S17rXiSz1ISQF5b9XHj1Odn8tYPciaxwCmyDv4c7CilKauteu
        mu+AyOxmfGQUEU6ldy1faMQXArTlAWEDRe5sWPmUQJHrJqHUlTkppOju49IAATgyR+3RRUj+9rANX
        3AUQ4bxvJNHHbunHm035y6SD+9N1/SC7sDVFSKGPLfGmg7uaWsd73etnYi84jDoPi5tKKA0Gnniea
        79/s5JBQ==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:53336 helo=localhost)
        by bh-25.webhostbox.net with esmtpa (Exim 4.93)
        (envelope-from <linux@roeck-us.net>)
        id 1khKRb-000UfA-IS; Mon, 23 Nov 2020 22:36:23 +0000
Date:   Mon, 23 Nov 2020 14:36:23 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/91] 4.19.160-rc1 review
Message-ID: <20201123223623.GD223204@roeck-us.net>
References: <20201123121809.285416732@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1khKRb-000UfA-IS
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:53336
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 28
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 23, 2020 at 01:21:20PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.160 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Nov 2020 12:17:50 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 417 pass: 417 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
