Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD91382917
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 03:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730733AbfHFBOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 21:14:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:36112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728851AbfHFBOD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 21:14:03 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FBBD20B1F;
        Tue,  6 Aug 2019 01:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565054042;
        bh=NjNQjzsF+w3NkUgDSG1k8bEfRSGcJK92LYZmXcSdcZs=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=WIIVeIINSmvFFRAhWP46K/cgFgiHe7kXl9mAvih3Yg9j/CHj60+vFasToqlHcb0+T
         F/EDyR9JTbKTr1zbhGHKo1wJWKT3zq+XOx7AU8A9BGQvLbQzoGrszhUp8DghLKyE9w
         eMN7tqUtICeEDO3UYkaB1jDjz/x0QC1R1cvfHZw0=
Subject: Re: [PATCH 4.4 00/22] 4.4.188-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190805124918.070468681@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <feafe6cf-4dfc-3d78-4010-a9af38aeb590@kernel.org>
Date:   Mon, 5 Aug 2019 19:14:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190805124918.070468681@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/5/19 7:02 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.188 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 07 Aug 2019 12:47:58 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.188-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

