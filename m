Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA79F451F5
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 04:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725777AbfFNCin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 22:38:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbfFNCim (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 22:38:42 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B14C3204FD;
        Fri, 14 Jun 2019 02:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560479922;
        bh=Ac2dDgW7f9n/ygVJVX85PUlzzxW6J0HhTAoa6dQeHyg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=JIjh8yM9bxhBDMmvKncTYilyFR7WR6pO5LTb93JnHNYwKGM2VxeCWHYuQEtICFVTu
         4NMFRVE1I+sOhuzV9IgcySpqVOO02rZAWF/Xh66fVZgUyoUii171awtnYuXYcz7vC9
         flFMkhc5LajqMcxtIVleG/3aUO4P0But6N7YPo5o=
Subject: Re: [PATCH 4.14 00/81] 4.14.126-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190613075649.074682929@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <b40de109-0b20-3972-1570-54e01ac6df59@kernel.org>
Date:   Thu, 13 Jun 2019 20:38:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190613075649.074682929@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/13/19 2:32 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.126 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 15 Jun 2019 07:54:51 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.126-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

