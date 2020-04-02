Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB8819C775
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 18:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389390AbgDBQ6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 12:58:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387700AbgDBQ6Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 12:58:16 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 544C920737;
        Thu,  2 Apr 2020 16:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585846695;
        bh=94acs22/ufkGM3PkaWe2l1MIKc5PPd7XnOPcfdS+ocw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=V/fgbAPQEaRARQNC+OG36NoXyyeTrShsVQ7FoTvAMp9GQzfmXIRei8Vsncr4e36im
         xMnsTJMc7Ewdzv2gtYzBvPOFC5j5+CG6+KdsnfLE6O6N8uM/OScpvA2ch84YhBTgJ4
         k/RKN7Ic9vEtJffRfdxYDv0yyL7zXn3tzOQGrdQo=
Subject: Re: [PATCH 4.9 000/102] 4.9.218-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200401161530.451355388@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <84768482-4fa1-9b4a-6287-438298ed5ca7@kernel.org>
Date:   Thu, 2 Apr 2020 10:58:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200401161530.451355388@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/1/20 10:17 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.218 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Apr 2020 16:09:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.218-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
