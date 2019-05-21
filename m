Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6C8A259B3
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 23:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbfEUVLR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 17:11:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:43790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727136AbfEUVLQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 May 2019 17:11:16 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C411D2173E;
        Tue, 21 May 2019 21:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558473076;
        bh=8qi/YvlhmCAXgUmePEX/QgMDajatGm28B3apQAGlpUc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Vg3yGk+/jxD3V42ypO5ZZARpPR6s80nBJsdXp+++hwfJRgkeoCh8Sz4oMjwwGl9Qs
         ymm97PXU1s3zEtYSgAq7Tzz6qtJytdsS4HVZ91zWHT2W0xhO4CpTQj7KSxFw5DXYL7
         QVSiJTRNE2CYBFuX+/UKIeP09blR/kswVGWr/Aoo=
Subject: Re: [PATCH 5.1 000/128] 5.1.4-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190520115249.449077487@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <0c574740-e2be-b2ee-4b0e-f17e5b08d342@kernel.org>
Date:   Tue, 21 May 2019 15:11:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/20/19 6:13 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.4 release.
> There are 128 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 22 May 2019 11:50:41 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on the test system. No dmesg regressions.

thanks,
-- Shuah
