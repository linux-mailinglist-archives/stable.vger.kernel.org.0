Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B44421AD28D
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 00:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbgDPWFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 18:05:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728086AbgDPWFX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 18:05:23 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96B35218AC;
        Thu, 16 Apr 2020 22:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587074723;
        bh=9goen5q97IXE1QNsquPqQOAcD07uSEh64MmoAuyZQVU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=TVXfprzCU3S0/bb29TUEpGCQ6zLmeTHCdg0sVNPb0WNrplplrAKzxCwyQQRDWj6qt
         PU+3UJlqAppJEcrekP7G6XxpayRPbolAXoH9TzwvTNq5ppFYe5KhGqKmYaUh97HLBX
         Pjd9LDuIFhPL8vwge13tNBFXmxPDPLfRZryi79/4=
Subject: Re: [PATCH 5.4 000/232] 5.4.33-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200416131316.640996080@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <1fbc738b-30d4-59db-184f-5d4812892481@kernel.org>
Date:   Thu, 16 Apr 2020 16:05:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/16/20 7:21 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.33 release.
> There are 232 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Apr 2020 13:11:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.33-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.
reboot and poweroff hang forever. The same problem I am seeing
on Linux 5.7-rc1 and Linux 5.6.5-rc1 and now on 5.4.33-rc1.

I am starting bisect on 5.6.5.

thanks,
-- Shuah
