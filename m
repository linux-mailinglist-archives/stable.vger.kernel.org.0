Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 880E6AA695
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 16:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729719AbfIEO5s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 10:57:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726088AbfIEO5s (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Sep 2019 10:57:48 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9862E20820;
        Thu,  5 Sep 2019 14:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567695468;
        bh=zNIbJvEwXPMq+66/oYMUIqWIi0UEzFzWcGMOcefbigo=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=a9UU3d7/ldf/Ys11wI3V0fxQmz33xhCZaiQQB/37+mYjhGtWskMANJjFl22mOeX9d
         9/2v45mYe98Ntv29eEVmJZPJ/P621lKFqYZACS0hGGwgKBSriAnUrE/ql69t294SAO
         oOEdIxAiubhyUtTdusUnMQZCgTQAhoFZxywXRXnw=
Subject: Re: [PATCH 4.19 00/93] 4.19.70-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190904175302.845828956@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <cded890e-71c8-2741-6358-20ab9b4ee91e@kernel.org>
Date:   Thu, 5 Sep 2019 08:57:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/4/19 11:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.70 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 06 Sep 2019 05:50:23 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.70-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
