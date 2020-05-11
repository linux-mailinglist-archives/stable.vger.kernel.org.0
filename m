Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F581CE0F2
	for <lists+stable@lfdr.de>; Mon, 11 May 2020 18:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729731AbgEKQt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 12:49:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729619AbgEKQtZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 May 2020 12:49:25 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C77F8206D7;
        Mon, 11 May 2020 16:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589215765;
        bh=g44eaDpexa8q0IvKbWKMJAVtbiDTd6wY0dEFuy1+nww=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=0zDVv0F+5by/BhDpvOPpfbP34SkNX4Q5r7QuJJ2QxgvodHZEO2p72KbBXjhcWyxxl
         soNQJiteXRw1hhWx/MGt1uM2rxjRl+oqX00vP9Qt2PoDI6t2X5n5r7A3nwHSpk0glt
         YFtYF0LLpkY9fX7DBDXV6LljMwYh5zkKDU5u4rv8=
Subject: Re: [PATCH 4.19 00/32] 4.19.122-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200508123034.886699170@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <0a2447b9-7fab-dd3a-a8ae-c61245e861d2@kernel.org>
Date:   Mon, 11 May 2020 10:49:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200508123034.886699170@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/8/20 6:35 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.122 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 10 May 2020 12:29:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.122-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. I am seeing the same emergency
message in this release as well.

Initramfs unpacking failed: Decoding failed

thanks,
-- Shuah

