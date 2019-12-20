Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 363B11274C3
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 05:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfLTEqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 23:46:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:52504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727128AbfLTEqM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 23:46:12 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09C6024680;
        Fri, 20 Dec 2019 04:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576817171;
        bh=RpmSljn9O8trFrIwF6/L0kx4crHeI8F3g7HdviWpXBw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=I9qiyNYvEwogSwBR/rJ/OSIrS+kdlM5Eth8ShnPtZ8Qn40KLLyhCecCDm8Q6XpoK3
         /84+3G2LOk6572QLbmJzxnlFpG6Hx6eMA9NHO4L9c/zuV/pcZ68WAkcNVg/D4Tluiv
         5Qx6UYj3JA/KWXDGsDUKltOKZG0PkRNZsmi8myoE=
Subject: Re: [PATCH 4.4 000/162] 4.4.207-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20191219183150.477687052@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <fb839d4e-92b3-e348-f2b5-0bcf5f508781@kernel.org>
Date:   Thu, 19 Dec 2019 21:46:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/19/19 11:31 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.207 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 21 Dec 2019 18:24:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.207-rc1.gz
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
