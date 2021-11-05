Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30A0445E1B
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 03:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhKEC4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 22:56:19 -0400
Received: from smtpq3.tb.ukmail.iss.as9143.net ([212.54.57.98]:52118 "EHLO
        smtpq3.tb.ukmail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231510AbhKEC4S (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 22:56:18 -0400
Received: from [212.54.57.96] (helo=smtpq1.tb.ukmail.iss.as9143.net)
        by smtpq3.tb.ukmail.iss.as9143.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <zarniwhoop@ntlworld.com>)
        id 1mioxt-0006bs-PI
        for stable@vger.kernel.org; Fri, 05 Nov 2021 03:28:25 +0100
Received: from [212.54.57.110] (helo=csmtp6.tb.ukmail.iss.as9143.net)
        by smtpq1.tb.ukmail.iss.as9143.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <zarniwhoop@ntlworld.com>)
        id 1mioxs-00009T-9b
        for stable@vger.kernel.org; Fri, 05 Nov 2021 03:28:24 +0100
Received: from llamedos.mydomain ([81.97.236.130])
        by cmsmtp with ESMTPA
        id ioxrmTbMz24zoioxrmsZBc; Fri, 05 Nov 2021 03:28:24 +0100
X-Originating-IP: [81.97.236.130]
X-Authenticated-Sender: zarniwhoop@ntlworld.com
X-Spam: 0
X-Authority: v=2.4 cv=K8YxogaI c=1 sm=1 tr=0 ts=618496c8 cx=a_exe
 a=OGiDJHazYrvzwCbh7ZIPzQ==:117 a=OGiDJHazYrvzwCbh7ZIPzQ==:17
 a=IkcTkHD0fZMA:10 a=vIxV3rELxO4A:10 a=VwQbUJbxAAAA:8 a=NLZqzBF-AAAA:8
 a=B6Mp3mB2RnZxMwUMpXQA:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
 a=wW_WBVUImv98JQXhvVPZ:22
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ntlworld.com;
        s=meg.feb2017; t=1636079304;
        bh=e5328Vr1J8W38tjVI7dbOgdY/E2N0jqj3nCMfUD1LjM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=V6X/uPHgSGMR96xEure1TalixjGsv7ryJ0WX5k88wuAs2P2Dunj4BSypy5+o8JoUx
         NuGztQ7BQde0dOXU8kHqJaUSXPxyiPex+4F9B150or9gwRsRg+0VBVlqUJzJ+XB5k9
         7c/2gv8fkC7yRESOcu/EmEAyht68QoqP1xQjVU9le6sz5hC9C8gWipQXJS85HaPpMi
         wCx/VUeJApm2O8iD/eoWjOAU22orPdWf7ZR6gsfSyrRg/bfcuJ2KN9jmTItCEs7cqZ
         a4NWD2bwWyzimQAvRg9x7gtOehF6b3XKKE5HGpEQPzO6xs7TVhuWWlksz8c0X+oXWf
         J3W64FiYwPgsw==
Received: by llamedos.mydomain (Postfix, from userid 1000)
        id 5E6B460C47; Fri,  5 Nov 2021 02:28:22 +0000 (GMT)
Date:   Fri, 5 Nov 2021 02:28:22 +0000
From:   Ken Moffat <zarniwhoop@ntlworld.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 00/16] 5.14.17-rc1 review
Message-ID: <YYSWxsdGN8v5LHct@llamedos.localdomain>
References: <20211104141159.863820939@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Clacks-Overhead: GNU Terry Pratchett
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211104141159.863820939@linuxfoundation.org>
User-Agent: Mutt/2.1.3 (2021-09-10)
X-CMAE-Envelope: MS4xfLrll7x434LESxUqenpNcv4kofqIBBvMjTCL8L9sjKdfOU+rq5g1uLGsuSJBdF0z7IbUFVdslRlQ/tiAAt9aXJI3Euwvh9wWEfSdkXoJZ9hP4p39poN+
 naCMbaftzMr3MyBr8Hmi8DtPABbeU7+mycaVEF4jzm3D9DxTD8yK+53TTg8NFsZB6NMaV5isKbXULsQRMYTqwH1yVCTM3wuWXzg1DZWDzHdhPOq/FkXNLKr4
 Q05ydqs5NOjYCgrRls1AtTh/zirGiwmI3bsuNIG8WGLrJsgtEoxPoevp8YwTpFn319kYfGL+BBpltnREkyoecVS3A5q5PGdy8hPt4NHO0I+6zyu+pyVvBEIW
 FNld3E1AE5T+Ll/4yj20ZAhVVEG7gzdh3mDg2QIYV6Hpy/6WVctBVCXiw5rvneLTd7fBJWmTSXjbmJco+Rl3K6C80Tk+xs+BVdpevIEcwoHLzqRFWhXTSPwR
 EiKTMl2NV2r6H0D2Ha2WZ/XbbnFIlpNTP7CZWTKatCwRcpOL8BREvZtw5GFc+/6F54Oj53BH6IQLbstEKY0pjRGgXzRmAsLpUibnE7gpply633KZY5lOPGPo
 V/U=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 04, 2021 at 03:12:31PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.17 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Nov 2021 14:11:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
Tested on my AMD Picasso, I confirm this fixes the Xorg problem in
recent 5.14 kernels.

Tested-by: Ken Moffat <zarniwhoop@ntlworld.com>

ĸen
-- 
Vetinari smiled. "Can you keep a secret, Mister Lipwig?"
"Oh, yes, sir. I've kept lots."
"Capital. And the point is, so can I. You do not need to know.”
