Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACA95D37B0
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 05:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfJKDDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 23:03:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbfJKDDB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 23:03:01 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B70F20650;
        Fri, 11 Oct 2019 03:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570762981;
        bh=J6ZUNuZ6TefhuDV16b2lA4r115dHZmrJ3xYTwBzePOw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=YUefcRZii96WYxECsUp7oylTEqO9dwjyPFfyzAqEO+Hca+lajDw1eLh4fPl6Te1Oo
         kXsQoTzv/PSPiKkfdEqIdpIcX9YmWidZH6iUAMto9xBVqvgHXlMdfYV6Ra2SVpHxDH
         eLK7zDefkz9ZwE5TAztxoVekAOSyhODvE7qHviBs=
Subject: Re: [PATCH 5.3 000/148] 5.3.6-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20191010083609.660878383@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <ac86815e-774a-7655-0619-9d3cae5e9ba0@kernel.org>
Date:   Thu, 10 Oct 2019 21:02:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/10/19 2:34 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.6 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 12 Oct 2019 08:29:51 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

