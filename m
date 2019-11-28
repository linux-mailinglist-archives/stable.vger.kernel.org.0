Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0F7610D000
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 00:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfK1X4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 18:56:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:49828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726609AbfK1X4X (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Nov 2019 18:56:23 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2E6C2081B;
        Thu, 28 Nov 2019 23:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574985383;
        bh=rgcfQAdzjwHBiGBaRdEMv/OMDzZ94O1llbONkRnEmj8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=LPqbTU0/MuTwhCuGuJ34SuAkiz0r75l7ZRUequD7f+616v+/RAwNpoFsRKxIEqOxO
         rBfZuPoFfC4YEgsR6mo2iW8NUOOSSMI5qzMRbhZfZVszoeOQtEM3EgR97LOKnEkQoZ
         rQ+Y6Pgu1lu26TfNmMbBJldMa+rHjtXhNadzHY/c=
Subject: Re: [PATCH 5.3 00/95] 5.3.14-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        shuah <shuah@kernel.org>
References: <20191127202845.651587549@linuxfoundation.org>
 <573a667c-2f94-568e-b032-5c7860adaed4@kernel.org>
 <20191128155948.GA3418086@kroah.com>
From:   shuah <shuah@kernel.org>
Message-ID: <068ca9d4-cd6c-318f-0215-c2308e89d0d2@kernel.org>
Date:   Thu, 28 Nov 2019 16:56:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191128155948.GA3418086@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/28/19 8:59 AM, Greg Kroah-Hartman wrote:
> On Thu, Nov 28, 2019 at 08:47:51AM -0700, shuah wrote:
>> On 11/27/19 1:31 PM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.3.14 release.
>>> There are 95 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.14-rc1.gz
>>> or in the git tree and branch at:
>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>
>> It didn't boot. Panics in netns_cleanup_net()?
>>
>> I am attaching a screenshot for the panic. I will try rc2 and see
>> if it improves things.
> 
> -rc2 should fix this, if not, please let me know.
> 
> I also did -rc2 for 4.19 and 4.14 with this fix.
> 

rc2 worked for me.

thanks,
-- Shuah

