Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5841B75295
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 17:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388457AbfGYP3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 11:29:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387422AbfGYP3O (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 11:29:14 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B33C9229F3;
        Thu, 25 Jul 2019 15:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564068553;
        bh=4b/v1t/uy+XmaW0ZZ73dYU2Gh8zC6RvGBbrrPU0NvKQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=iQ09zGeCmxuSE7Ik2RlYoh7Ve3o1g6mdZ6jxIjVzNSfVkVJbeJpI8hQRmO8+ORbF3
         YEUtiBMujJIfOdo5jtj2qqOXinqt8SM9JkPqO4l88C/ryWxQCLsNOzIrKJZU2gKOhe
         8oAC5CkT15FuWsda6b4tJRNOQm8m36AmAn4bxrIk=
Subject: Re: [PATCH 5.1 000/371] 5.1.20-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190724191724.382593077@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <6af97ebd-9c0e-ee56-c26f-2a4f06dca1cb@kernel.org>
Date:   Thu, 25 Jul 2019 09:29:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/24/19 1:15 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.20 release.
> There are 371 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 26 Jul 2019 07:13:35 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.20-rc1.gz
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
