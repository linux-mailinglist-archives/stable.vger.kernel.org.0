Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D35F107994
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 21:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfKVUpH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 15:45:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:46744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbfKVUpG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 15:45:06 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D21CC20704;
        Fri, 22 Nov 2019 20:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574455506;
        bh=0xs/+QvGrlu/SO1x23n6mxq5TK2F7dvKyVFmZDbTrUY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ygwblalajMOSeZc+XzZxGLQ64wXdyxnHVF+s7oFIGlCiovyBdLza/SgSvEgjjaMr5
         EPGyhuqKLC8oQV41eOdu2B6pEECW0MgwpJAHtesaCzg0P5CtsfUZd1198u8TyU8z1s
         uHc5Q5OTfdY/gwFFPV4JnKkAHlaoRdzN3lI8/Q+g=
Subject: Re: [PATCH 5.3 0/6] 5.3.13-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20191122100320.878809004@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <30001ff5-2c8b-49e4-bc41-a43e0284df2c@kernel.org>
Date:   Fri, 22 Nov 2019 13:45:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191122100320.878809004@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/22/19 3:30 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.13 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Nov 2019 09:59:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
