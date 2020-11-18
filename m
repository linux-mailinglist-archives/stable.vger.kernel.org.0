Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C872B8102
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 16:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbgKRPn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 10:43:29 -0500
Received: from gproxy2-pub.mail.unifiedlayer.com ([69.89.18.3]:33638 "EHLO
        gproxy2-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726089AbgKRPn3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 10:43:29 -0500
Received: from cmgw14.unifiedlayer.com (unknown [10.9.0.14])
        by gproxy2.mail.unifiedlayer.com (Postfix) with ESMTP id C2AD21E0D55
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 08:22:02 -0700 (MST)
Received: from bh-25.webhostbox.net ([208.91.199.152])
        by cmsmtp with ESMTP
        id fPHWk3O4ywNNlfPHWkHOWX; Wed, 18 Nov 2020 08:22:02 -0700
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.3 cv=ar6c9xRV c=1 sm=1 tr=0
 a=QNED+QcLUkoL9qulTODnwA==:117 a=2cfIYNtKkjgZNaOwnGXpGw==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=kj9zAlcOel0A:10:nop_charset_1
 a=nNwsprhYR40A:10:nop_rcvd_month_year
 a=evQFzbml-YQA:10:endurance_base64_authed_username_1 a=_jlGtV7tAAAA:8
 a=-PsjpLTujS7qZS_A3F4A:9 a=CjuIK1q_8ugA:10:nop_charset_2
 a=nlm17XC03S6CtCLSeiRr:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9fQAFSpe4ejooO3kL/zNhicitu0ci7Ua9hi/+HJRbbo=; b=MSgKnF70nHHqBMaFQE/+r+oh+4
        +BHsFrcGBshC5vuMT+L3ihKKGphT+Foqy+xRU0Ja5uorM0lFAEgWLEiH8HMSC5gVKbXnuGHM632NX
        4apDqg40M56/oPAhN5m5KKwDN53qqwcaAlmcyc1LmpF4aQJY4I4avPyr8u/OIXlENlYruOK48fXLn
        KmSDEVqWvcVeTVl8aQvEqBzEP4eJ6f/26CotISCvglhP3M/8M/2GLVVGBZ0yjRrmmVBVsPnqsu5aC
        2cnhXNmRWTcswWKEOVc0juwnAxtQ7o5wGqSW/1GYzlHRZGhYwnwGw0oFj9/RA1z00/xbkdlgwNhxm
        b32f9Bpg==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:54752 helo=localhost)
        by bh-25.webhostbox.net with esmtpa (Exim 4.93)
        (envelope-from <linux@roeck-us.net>)
        id 1kfPHV-000zMb-QV; Wed, 18 Nov 2020 15:22:01 +0000
Date:   Wed, 18 Nov 2020 07:22:01 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/64] 4.4.244-rc1 review
Message-ID: <20201118152201.GC174391@roeck-us.net>
References: <20201117122106.144800239@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117122106.144800239@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1kfPHV-000zMb-QV
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:54752
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 17
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 17, 2020 at 02:04:23PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.244 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Nov 2020 12:20:51 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 165 pass: 165 fail: 0
Qemu test results:
	total: 328 pass: 328 fail: 0

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Guenter
