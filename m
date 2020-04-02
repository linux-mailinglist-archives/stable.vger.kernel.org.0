Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 012D319C750
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 18:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389255AbgDBQqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 12:46:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389084AbgDBQqF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 12:46:05 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E989620737;
        Thu,  2 Apr 2020 16:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585845965;
        bh=LtuSR5wcaLCc+FK1v1B851tpyhcyaF9SZJVXXxSesYc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=HJb2/E0ILhZBcRIPQaJ2mBfhB8AlXIu46sy2ggicfh+D3x8eP4acyAPO7Yolxw7lp
         DHwDVWOasHYGWc5prrWmAyKrVmMOL+oEjBuTAowe8ARkVm9/Ao76FPm+xW0mXI/LiK
         cK+PsdVUITg6j6k3MtCFmueiPZMD6iuzD+MNEPac=
Subject: Re: [PATCH 5.5 00/30] 5.5.15-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200401161414.345528747@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <72d786ac-e838-2c3a-8938-1bcb01923843@kernel.org>
Date:   Thu, 2 Apr 2020 10:45:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200401161414.345528747@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/1/20 10:17 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.5.15 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Apr 2020 16:09:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

