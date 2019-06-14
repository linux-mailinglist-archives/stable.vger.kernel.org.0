Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB3B450D1
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 02:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbfFNAom (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 20:44:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725778AbfFNAom (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 20:44:42 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 122CF20850;
        Fri, 14 Jun 2019 00:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560473081;
        bh=EDQ95EW5SOC9CqwmmSlrOSqcZXu5epBSz2LwhJ51RsE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=c80Q5/lekP2rmRhnNkDvIip0YnTzMcr3kk6FxMzABjF3BhM4kwYlGBFLThGBImN+K
         zd/SZb9HkIyNBI/XyRt/+vZ3lKMBB+t8z/XQvTsNvh/jQ5tk0oYNXYUbtsTrHENZf0
         NZXVBm/fXugw3TOIXpT8txfi80FJLf4rF/E/HjPA=
Subject: Re: [PATCH 5.1 000/155] 5.1.10-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190613075652.691765927@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <91e6c918-5c9d-a036-c207-dea6091bf3fd@kernel.org>
Date:   Thu, 13 Jun 2019 18:44:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/13/19 2:31 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.10 release.
> There are 155 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 15 Jun 2019 07:54:40 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
