Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A69D16C21
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 22:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbfEGUWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 16:22:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:33330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725843AbfEGUWw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 16:22:52 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3476520578;
        Tue,  7 May 2019 20:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557260571;
        bh=rwYfNBSIQhfusY6AEXFsjYTvzpnvbwKIlhWrVqrjh4s=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=zJVRe2nFJpHGY45XygKBZ/VBtffhnBzjolKhNnqCwK04+URT6AV7GuKDgc9XaIHOx
         mSYnlCL4hM9E4g/JEin1OLmdYcxv/jVDvpgYwg6C7WCVK+Rl6CWqL/hpzON1H8mEOF
         PK64YaJTT5LAsCQeGdYdaSPgKOIZ5jgjBSLXqp5k=
Subject: Re: [PATCH 4.19 00/99] 4.19.41-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190506143053.899356316@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <161b0f3b-5569-3b8d-25ad-25be4cbc0b27@kernel.org>
Date:   Tue, 7 May 2019 14:22:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190506143053.899356316@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/6/19 8:31 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.41 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 08 May 2019 02:29:12 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.41-rc1.gz
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
