Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45331AD270
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 00:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbgDPWAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 18:00:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727998AbgDPWAo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 18:00:44 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BC6D21973;
        Thu, 16 Apr 2020 22:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587074443;
        bh=hhZzPa5SgV+v9yYiCoJdl3XyVSJ7T8c2QGwaUu3C+tY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=nFg03IkaTrLcq0oRL015ekp2nsNQXvgDuXHDbJYkNFCqU0w6Kz9FzAjGZQz/v73/X
         1HhUmEcZy3o+aSLLwrZAQzsrNGk4qy5Qog7ZfFQgxTKFVRRJX0VkVTcg/zN506QLrh
         PyhiFgT6iFPLCqxc+ILTHiGA1d5VTy2ZaLsUYI9k=
Subject: Re: [PATCH 5.5 000/257] 5.5.18-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200416131325.891903893@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <d0509d69-7531-052f-6ec7-72dda555e321@kernel.org>
Date:   Thu, 16 Apr 2020 16:00:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/16/20 7:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.5.18 release.
> There are 257 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Apr 2020 13:11:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.
reboot and poweroff hang forever. The same problem I am seeing
on Linux 5.7-rc1 and Linux 5.6.5-rc1.

I am starting bisect on 5.6.5.

thanks,
-- Shuah
