Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 382CD18DCD6
	for <lists+stable@lfdr.de>; Sat, 21 Mar 2020 01:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgCUAuy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 20:50:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:32886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbgCUAux (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Mar 2020 20:50:53 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1D0D2072D;
        Sat, 21 Mar 2020 00:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584751853;
        bh=M9bbJaVZb9089JUD2phojo7fZFMiZIUm9uRxe1zkSp8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ZyARP0tx6rNnkEUXpNRVOE83U60WinqFN3Y3Iy5vy5DhHUUM+sYokfTGQHv7A+PDn
         bZ40vWdp7FTC6YXLXh+J/0Y8EOvx3aTC4jdpVHWmlC/o3RzafbA9ax1gfMUIHljoxd
         jlD487b8svqAhLgp8jJPy6AmH9AjxJ3mKDQTM/mk=
Subject: Re: [PATCH 4.4 00/93] 4.4.217-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200319123924.795019515@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <bf7f6d54-40c0-f772-ef1f-ff8a3c505df3@kernel.org>
Date:   Fri, 20 Mar 2020 18:50:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200319123924.795019515@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/19/20 6:59 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.217 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 21 Mar 2020 12:37:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.217-rc1.gz
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
