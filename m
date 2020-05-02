Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98CCE1C28D1
	for <lists+stable@lfdr.de>; Sun,  3 May 2020 01:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgEBXPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 May 2020 19:15:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726346AbgEBXPh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 2 May 2020 19:15:37 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51A2620787;
        Sat,  2 May 2020 23:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588461336;
        bh=XRh9rypZauE7pU+abGOfnbd2nq6Ya98gSMrVrdbVpdw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=PaBywIl2jb9SpsfRvWPW6XvsyA58ZqCH/MDYYY+1xnYTFIaazW/kFGrDK56DW0hek
         I0bc3C1xrpsNH616FRKKkS4Jqeu/sZ3QinXKL8jM51aXUGvKx/Lyl/3NWBfATe7/pF
         DqahKySInfBNCWg5pHcRV1G+uePabt/HMQGxlkbc=
Subject: Re: [PATCH 5.4 00/83] 5.4.37-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200501131524.004332640@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <29593a85-3cfe-9ca3-78e2-535c3225cd02@kernel.org>
Date:   Sat, 2 May 2020 17:15:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501131524.004332640@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/1/20 7:22 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.37 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 03 May 2020 13:12:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.37-rc1.gz
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
