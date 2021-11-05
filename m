Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5D0445E09
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 03:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhKECvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 22:51:15 -0400
Received: from smtpq4.tb.ukmail.iss.as9143.net ([212.54.57.99]:55050 "EHLO
        smtpq4.tb.ukmail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229582AbhKECvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 22:51:14 -0400
X-Greylist: delayed 1325 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Nov 2021 22:51:14 EDT
Received: from [212.54.57.97] (helo=smtpq2.tb.ukmail.iss.as9143.net)
        by smtpq4.tb.ukmail.iss.as9143.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <zarniwhoop@ntlworld.com>)
        id 1miow2-0002sI-Q6
        for stable@vger.kernel.org; Fri, 05 Nov 2021 03:26:30 +0100
Received: from [212.54.57.111] (helo=csmtp7.tb.ukmail.iss.as9143.net)
        by smtpq2.tb.ukmail.iss.as9143.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <zarniwhoop@ntlworld.com>)
        id 1miow1-0004x2-HH
        for stable@vger.kernel.org; Fri, 05 Nov 2021 03:26:29 +0100
Received: from llamedos.mydomain ([81.97.236.130])
        by cmsmtp with ESMTPA
        id iow0mIhItufb4iow0mfAGd; Fri, 05 Nov 2021 03:26:29 +0100
X-Originating-IP: [81.97.236.130]
X-Authenticated-Sender: zarniwhoop@ntlworld.com
X-Spam: 0
X-Authority: v=2.4 cv=FOAIesks c=1 sm=1 tr=0 ts=61849655 cx=a_exe
 a=OGiDJHazYrvzwCbh7ZIPzQ==:117 a=OGiDJHazYrvzwCbh7ZIPzQ==:17
 a=IkcTkHD0fZMA:10 a=vIxV3rELxO4A:10 a=VwQbUJbxAAAA:8 a=NLZqzBF-AAAA:8
 a=4DOhSakD1qRXDmDi5pwA:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
 a=wW_WBVUImv98JQXhvVPZ:22
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ntlworld.com;
        s=meg.feb2017; t=1636079189;
        bh=VvfiRyeSH3AEwBpH2Q4Pe2E6hehLZWyq8iWj06fTFMk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=Q/Pc7nE36mcwRUcc7Ju6UZQJhfy1HjCOSP4kTvdJYZHsbJaT8Yk73jb5+hU44q+Fw
         xdXvUrBZBEteocz2Ccf6+qOEMyH4k4xjPiXfqyFnoBysk6c1C//no4seaO8bv7tBii
         HoOB3uJw7TKqpi5O/rxc6WOeDlZK11V71k0QR7piBRix93HJrtRfv/wgoufN4NF1SV
         RWCCfD9rpBmibbXW3IbRGAEO5EDa33SESVobXa80RQpUbCZrWpK3z54jYOkesSbQs8
         1Nvnf1cqM6TGs/YdjZ0fD7DkkVvJQmIXIH6sROTALa5O8jZ66wEOqIQr+m1BiXYtI0
         nNrfwciqYoQYg==
Received: by llamedos.mydomain (Postfix, from userid 1000)
        id 2783660C47; Fri,  5 Nov 2021 02:26:28 +0000 (GMT)
Date:   Fri, 5 Nov 2021 02:26:28 +0000
From:   Ken Moffat <zarniwhoop@ntlworld.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 00/12] 5.15.1-rc1 review
Message-ID: <YYSWVA1wnlK9V17J@llamedos.localdomain>
References: <20211104141159.551636584@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Clacks-Overhead: GNU Terry Pratchett
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211104141159.551636584@linuxfoundation.org>
User-Agent: Mutt/2.1.3 (2021-09-10)
X-CMAE-Envelope: MS4xfP1a8fm2vmqgAq6qIf/1pNCWBzqL/CASFF5z22rhkhLMZjKjAT7dcMqFrPfBRSvGDa9cSS2jYuU5mb3nuTUaekAYhOEZZlx4VQeN/S8X6Q9gNJo+tAWL
 7omaLWEh+QE/Z2SAfV1vCu+kqLdbekLA1bREylaqay9Fp2TcRmOrOhyZP0QQXVR0enUyshym3jDXzu3pfpazl0a2IXzUhsDxOQN96N9A8/RTJAb9I26tgUvN
 6aQDjf+U3ytWJIzru2Dr/3Yfsi3lI7P+VFJKTLV2ZDTvZN47Vawd/yM7p7mDJWtoxpfSh6rDWnuiVv2FMop8OWVe/EeHeq0MZzxC/pycg70tO96CbtwLb9i6
 Tana9m77vvZ2joS4Yn7FrznI9+asWeCH8+cX7S3dibPgTEQgbSCoWeDOLDaHrD2PqEs7okFrXEv9D8qPlbkpGBEXd/SWOMjFSWoGTXrUrbsqqIWNvWmA2WG5
 uOtu10/aw/uW8IwP0JxsWrbtY0zAuV2iGVXsbgOYQtxAzK/4SL7bnUcRRZL/MXunSJQAPhfZN2KmgqTqBuWLio2WeUayvqCwCVdIaX8+lApttlX2DZmQjDAE
 mbI=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 04, 2021 at 03:12:26PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.1
> release.  There are 12 patches in this series, all will be posted
> as a response to this one.  If anyone has any issues with these
> being applied, please let me know.
> 
> Responses should be made by Sat, 06 Nov 2021 14:11:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.1-rc1.gz
> or in the git tree and branch at:
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> linux-5.15.y and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
Tested on my AMD Picasso, I confirm that the xorg problems I saw in
5.15.0 are solved by this.

Tested-by: Ken Moffat <zarniwhoop@ntlworld.com>

-- 
Vetinari smiled. "Can you keep a secret, Mister Lipwig?"
"Oh, yes, sir. I've kept lots."
"Capital. And the point is, so can I. You do not need to know.”
