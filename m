Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB4E208BA
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 15:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727748AbfEPN4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 09:56:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726911AbfEPN4f (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 09:56:35 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94BCA20657;
        Thu, 16 May 2019 13:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558014995;
        bh=uoe7jw0e+uNuNcDQkLTv0BILM0FRBInrHzZkZz5BOhw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=StJ+rmuvH7Txh48TZ6pYlOL6PEnDykPXXZb+dnTw4U4LU0Z8HtUVs+okwT87rdujC
         huIKxzutEGOsBarjB4/6NngTfqOWQwrR/KZT5MNGOKLwaOQKjAMG0cuDHPOgWqdRHD
         5DhvYTZJYNUnYl45YX1nJi48iQDs+6tg5S6KCQrg=
Subject: Re: [PATCH 5.0 000/137] 5.0.17-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190515090651.633556783@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <551c94ee-e879-286a-7bd7-4070417c4826@kernel.org>
Date:   Thu, 16 May 2019 07:56:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/15/19 4:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.0.17 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 17 May 2019 09:04:31 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.0.17-rc1.gz
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

