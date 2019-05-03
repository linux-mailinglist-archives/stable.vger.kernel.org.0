Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E63F1134CA
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 23:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbfECVTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 17:19:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:44816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726041AbfECVTF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 May 2019 17:19:05 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A58F92070B;
        Fri,  3 May 2019 21:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556918345;
        bh=WslAkfR3VIJSQdw8DoQ3BaZ9KrdGSwOyRwtwZkB5RXQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=nq0Ciel2mHGONqMxjlnUp0snqdnwWCgfnBE6scZ3RgROiSuC2f9TvA+FG+dDRAr+x
         Je6nsHPbQmTsZFZyToQSKgsZirWeBs/esViEK8MknmwDY0z0OgKjZSU7zYjds6r+50
         EDLEleSyxYjvDfIOyAoof6stY3gbAnvObyK5Ri2g=
Subject: Re: [PATCH 5.0 000/101] 5.0.12-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190502143339.434882399@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <62fcde1c-2f21-7a51-a2fc-c2657dea0d7f@kernel.org>
Date:   Fri, 3 May 2019 15:19:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/2/19 9:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.0.12 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 04 May 2019 02:32:10 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.0.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

