Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF5B912CBEC
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 03:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfL3C0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 21:26:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:49426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726726AbfL3C0Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 21:26:25 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B016020718;
        Mon, 30 Dec 2019 02:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577672785;
        bh=iiKV+RKqxqnXDNnnnoWIICdP8SMC0mH+QCvS24BGJeY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=J4zfldU5gd81fN8eAivxbQ3P7kK8XeCcVmVX2TWL9QjG2X+B3FtVLJEuPDJjBtTj8
         b0zAvuBPqtN16VGzDkGnXx8t6gf8TsArW+bHdqk9FqlRDppaL6lXnuXcQRQJY/cbST
         YvkMTb1lTUt7jTAyxpabgiALEJJ1O9Pg1eqCfNsI=
Subject: Re: [PATCH 4.14 000/161] 4.14.161-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20191229162355.500086350@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <4a29a98b-d271-2489-1b27-e9654d369aba@kernel.org>
Date:   Sun, 29 Dec 2019 19:26:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/29/19 10:17 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.161 release.
> There are 161 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 31 Dec 2019 16:17:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.161-rc1.gz
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
