Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 527FE145D49
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 21:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgAVUve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 15:51:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:54092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725827AbgAVUve (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 15:51:34 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E9A82087E;
        Wed, 22 Jan 2020 20:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579726294;
        bh=RgP6Kr46V7F2i2bdLf829yu5frz9sTJ7d5laorPgTR8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=mtortDeCk1nyHpXOlDxvdFoJQGO1hQUtJbdMO1jfAQAO3RGy6VQCXvo0R1qzeqbes
         RZ4L4LE5zF2sz9jA85YHO6VjSaEBFhnyVAde1PNZ/bpA3wOEKuL9NGdq3u7HzUzbeD
         RJlDP6uCyTy5HuwVHapvlMvgNC9Z/jIzC9hF2hcw=
Subject: Re: [PATCH 5.4 000/222] 5.4.14-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200122092833.339495161@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <d1a53f66-136e-f1c8-34d4-9ead26cff0b7@kernel.org>
Date:   Wed, 22 Jan 2020 13:51:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/22/20 2:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.14 release.
> There are 222 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Jan 2020 09:25:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.14-rc1.gz
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

