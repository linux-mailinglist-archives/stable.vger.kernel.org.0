Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27938163754
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 00:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgBRXhm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 18:37:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:41928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbgBRXhm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 18:37:42 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D7AB2173E;
        Tue, 18 Feb 2020 23:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582069061;
        bh=0aWiRZmAfoGXZzUWUGCycJjuXmddi7uYzgUaZE/M7uc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=OPk9m23ZTUqwf7aTnrGTPlZ+tgVlZDOk2pNut3NoQaY7x0cAB6aZQ/76La+7wl5Re
         AtN2fXSr9P71aU5MMq/b4tMMnTj5pvWCT3PYARCb1SbCnu5P64CuSBF2ifTOPlFbic
         K70nrIqDLiowtxG0S/vqOVlMdYAeAFcbRdPKcXJw=
Subject: Re: [PATCH 4.19 00/38] 4.19.105-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200218190418.536430858@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <5c3972ba-4343-a84d-7cfc-9b602e34e656@kernel.org>
Date:   Tue, 18 Feb 2020 16:37:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200218190418.536430858@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/18/20 12:54 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.105 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Feb 2020 19:03:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.105-rc1.gz
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
