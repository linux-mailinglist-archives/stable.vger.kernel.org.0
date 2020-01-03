Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA0412FE70
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 22:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbgACVtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 16:49:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:58592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728657AbgACVtR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jan 2020 16:49:17 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46253215A4;
        Fri,  3 Jan 2020 21:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578088156;
        bh=TqnrG4c5lZ3onzNS86Pjwzr5o3IjCHOo2I0eb7S4t3M=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=UWOWfdTc9V/Yhndd4IJ0rfhUIgIA+BC1HI+3bk1lj71y0irPC7aVs8uRBmoYm3xhS
         Mw6FwSk0KFeosSDTa9flaqZcYdccsCHu3fqNlC0Ob6uUO6odLpITyHRGZhvuyHeXd7
         iCHYklx0JPVhxYWjfTSkujWrmbw+ALscCHA4kYaY=
Subject: Re: [PATCH 5.4 000/191] 5.4.8-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200102215829.911231638@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <59e0fada-0277-d5db-f550-f1ff9db01212@kernel.org>
Date:   Fri, 3 Jan 2020 14:48:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/2/20 3:04 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.8 release.
> There are 191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 04 Jan 2020 21:55:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.8-rc1.gz
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

