Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B873725A0A
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 23:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbfEUVjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 17:39:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:57652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727222AbfEUVjF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 May 2019 17:39:05 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5E62217F9;
        Tue, 21 May 2019 21:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558474744;
        bh=/E2M/zM6R7+VpJ4MhZxa0lwH2AQ/HgsCo6xHt+0dCGs=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=PwHD0pwIPkIfaju6hnIxU56GLE7PcZmdt4s02dI9PAvFKibbhdGoQ3f3jeHxVlRDJ
         +HmKW6z44JaF+gRY16MTniwsdHSsCOW25q0fwn3IY07meW0G0yw6iTBZFsXLFOoLix
         VCWif9SJwKG/URJ7DzXCeSEJP2uZAG2KAGmWxJ3Q=
Subject: Re: [PATCH 4.9 00/44] 4.9.178-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190520115230.720347034@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <d517b2e2-7234-47f1-4403-499de8fefdd4@kernel.org>
Date:   Tue, 21 May 2019 15:39:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190520115230.720347034@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/20/19 6:13 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.178 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 22 May 2019 11:50:58 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.178-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

