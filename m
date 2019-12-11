Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C84D11C077
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 00:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfLKXRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 18:17:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:35870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727036AbfLKXRH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 18:17:07 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48544206A5;
        Wed, 11 Dec 2019 23:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576106226;
        bh=6ZLR+kQ3GWo+CGBwBkyuFBPE1zONRel3mTbA1ivuFkU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=N919WcTjjcfgK5CGQ82kMvb2S/T3/Qf5OQyan57v3JHIY3IlVxyqicTpVd7m72sRt
         QSiyMHvTAkMCPIy6D8r0ysewQaWCSb6TheQc+34g68Yw38sIjN6RMKNbzUQy3akgrx
         yyfTJCaX4JQk1y8eu5geMTQ8sKRBKS1xTvNrSN+0=
Subject: Re: [PATCH 4.9 000/125] 4.9.206-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20191204175308.377746305@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <0c8ec2a9-556d-bbde-98b0-835c66613f06@kernel.org>
Date:   Wed, 11 Dec 2019 16:17:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191204175308.377746305@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/4/19 10:55 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.206 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Dec 2019 17:50:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.206-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

I know this is way late. I managed to boot 4.9.206 finally on my test
system running Ubuntu 19.10.

It turns out, Ubuntu 19.10 defaults to LZ4 compression.

/etc/initramfs-tools/initramfs.conf
COMPRESS=lz4

Enabling the following worked for me.

CONFIG_RD_LZ4=y
CONFIG_SQUASHFS_LZ4=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_DECOMPRESS_LZ4=y

Stable release older than 4.19 will require the above change.

thanks,
-- Shuah
