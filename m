Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84B5C1220C7
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbfLQA5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:57:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:45200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726637AbfLQA5x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 19:57:53 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86B3520CC7;
        Tue, 17 Dec 2019 00:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576544273;
        bh=arlHUxcowrP++Ny6/K4IC3w5gYo1UaKSQWAVKfsDsag=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=MheGbXg5uB9U32daoBMI7hncWPix7icWEBDh3Xb0SUVfDDv/J0whZpmA4Z1ESB3+Q
         A2XRF3EvvH6uZQmGUAcqkjBIwM5MRyBwXyVe3udGOoZpb7MDhXRdRFVpX0B59oo3mP
         Gwwztn96kImxOdj1fDfHWZ5cAxi/EFhL/1xy9Glo=
Subject: Re: [PATCH 5.3 000/180] 5.3.17-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20191216174806.018988360@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <7f78940e-ebd0-dc8c-0439-bfe0a46d85e1@kernel.org>
Date:   Mon, 16 Dec 2019 17:57:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/16/19 10:47 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.17 release.
> There are 180 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Dec 2019 17:41:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. NO dmesg regressions.

thanks,
-- Shuah

