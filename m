Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B19C828D8
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 02:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730717AbfHFAvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 20:51:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:59074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729383AbfHFAvx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 20:51:53 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26B3D2147A;
        Tue,  6 Aug 2019 00:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565052712;
        bh=Z+9tk3MU66K/tksiFxT3MI1Hc0PsUoTRcxWNrN/xtyc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=XQDLZWdKWsVDMr+DL3NrjCaZVKK5JNizg+H/cHDpZWeS56OtRgFVN34WpIGj5EUyK
         XOiJnjMSOYp2Cw+KdRTaN1A4XAsHu6ndOSR7QU4OCjZJTtJyrWDVXDYApFfH4B5BhG
         2VND5m/8JjvhYGfki9lAtS6UrmwAuPlPrFwSbUww=
Subject: Re: [PATCH 5.2 000/131] 5.2.7-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190805124951.453337465@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <f2ee51eb-d1e2-1a19-d1a2-dfa181530e03@kernel.org>
Date:   Mon, 5 Aug 2019 18:51:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/5/19 7:01 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.7 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 07 Aug 2019 12:47:58 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

