Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F77E149068
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 22:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbgAXVrN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 16:47:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:57650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728205AbgAXVrN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 16:47:13 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 133072075D;
        Fri, 24 Jan 2020 21:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579902432;
        bh=HXn+mcfDPhsBbwCzu2k5nsCrOqEyJByYkXRSGBb9/jw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=qh+64+XHTQq0KEBhUUqWfJ8FuBY3006I7A2pXOwYSWEzSE23GFlhFwKta7URngdPs
         0GbGfAbTFPc83qLE5hBDKnZEGHkz5wUSLBvbPfq1e4VkslhzZ2chyVv/RVbelV1Jez
         WBGVSfe0PWGimmg2CRqKevCH4bIT30WMAfNaPjZ8=
Subject: Re: [PATCH 5.4 000/102] 5.4.15-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200124092806.004582306@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <ff4da7a6-5b13-89fd-1cec-9dc2b85a0ae7@kernel.org>
Date:   Fri, 24 Jan 2020 14:46:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/24/20 2:30 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.15 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Jan 2020 09:26:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
