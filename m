Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB19208C3
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 15:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbfEPN6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 09:58:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726692AbfEPN6N (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 09:58:13 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9554C20675;
        Thu, 16 May 2019 13:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558015093;
        bh=LifAjhEIOzmi9WqrtRfNYP3uxrb4PktdlUtR4Sdp1QI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=BGG7LIcmmdjkM1YFPgW8MuZRkRo74w7CjMBQmvO73/yjkqgVse5mXPCCWfyRux6lX
         Py1Y8G7bZJkkKtbJl4w4DdTgHmqBK++tYADb6zT+CaTlrXHLC0x0Mcw17q4unZTwUj
         2r6kKLvx72N+rFxOxQUdiFWVIRfyaMdWM48eldtI=
Subject: Re: [PATCH 4.19 000/113] 4.19.44-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190515090652.640988966@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <98a7251a-f7d9-084d-10e1-a19fe56ae0af@kernel.org>
Date:   Thu, 16 May 2019 07:58:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/15/19 4:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.44 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 17 May 2019 09:04:35 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.44-rc1.gz
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
