Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21E7429E8E
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 20:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391736AbfEXS4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 14:56:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391181AbfEXS4X (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 May 2019 14:56:23 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0B0B21848;
        Fri, 24 May 2019 18:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558724182;
        bh=6Epa1m9LNZsgEwNRSEGbamh91rJfdsZ6dvkBcZsooN0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=19BseHudoDiVcs2Sh836Bi/rmib5/BqtgYUscahe7w34x91wNnCjTbXxPjNWAqSm6
         fsx7FDuyJzNNNGiXJa/DBaKUTUUAeNq6i60EAqOrnu0RtS5oyJMnKbykeW5YnESWtU
         uP8QPBd+9CGdSbVdz1wR/ldeIgE3IMhjUtwGZ8W0=
Subject: Re: [PATCH 4.9 00/53] 4.9.179-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190523181710.981455400@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <d86f648a-4dd5-4eee-dcd9-13abbd019855@kernel.org>
Date:   Fri, 24 May 2019 12:56:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190523181710.981455400@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/23/19 1:05 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.179 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 25 May 2019 06:15:18 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.179-rc1.gz
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
