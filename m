Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8ECA19A1E6
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 00:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731470AbgCaW1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 18:27:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730556AbgCaW1l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 18:27:41 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2ADB20787;
        Tue, 31 Mar 2020 22:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585693661;
        bh=RaMiVDzxO2Dn3x9dsg+2vW4FZPGQYDdsEU6DIIaK4n0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ODDTEmeuwrefAjJOQ7QMSp+EECDFQz81Z6/ESxE2ci3+DHchlzxfGsmZs4vsmAqXv
         LSbKLiUzxDRd2XFn1b6L8S86fdLQYsyKAPxyBpTiBa8kIg9NYnGDpVGE6Bdodl4PQX
         OeVCzIpIy1T+zrrmcmwX2ejtxnwgu5HRB5xjVRaU=
Subject: Re: [PATCH 5.4 000/156] 5.4.29-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200331141448.508518662@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <6bd7a1b7-a498-a6ba-5a4b-a2b7e1a0c545@kernel.org>
Date:   Tue, 31 Mar 2020 16:27:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200331141448.508518662@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/31/20 9:32 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.29 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Apr 2020 14:12:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.29-rc2.gz
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
