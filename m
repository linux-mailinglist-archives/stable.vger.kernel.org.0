Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B74E1822A5
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 20:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731030AbgCKTj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 15:39:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730913AbgCKTj6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Mar 2020 15:39:58 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAEAF20737;
        Wed, 11 Mar 2020 19:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583955599;
        bh=VMxT2QHrTbpDF4vMVOmSH47H3kHkpy2JLspFU5J/RY0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=xO0n23G3AJarC0pu4GYyAz+NzOxr8qIxPFGzgu1L8H8NW6vD0RnIELhPaeTDOK5Js
         58muMRPTirG4BZlSIjGvDeuErhuu+kRQTFg2UP8BlCidApUrp1X+fh4AXCx6GWquPu
         Z72PmZ8QxvUBWai9JX51af5qgjidMkMRx7V47dpw=
Subject: Re: [PATCH 4.14 000/126] 4.14.173-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200310124203.704193207@linuxfoundation.org>
 <20200311131135.GA3856613@kroah.com>
From:   shuah <shuah@kernel.org>
Message-ID: <b9917046-393a-0314-0836-61003fd3d8e8@kernel.org>
Date:   Wed, 11 Mar 2020 13:39:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200311131135.GA3856613@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/11/20 7:11 AM, Greg Kroah-Hartman wrote:
> On Tue, Mar 10, 2020 at 01:40:21PM +0100, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 4.14.173 release.
>> There are 126 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 12 Mar 2020 12:41:42 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.173-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
>> and the diffstat can be found below.
> 
> I have pushed out a -rc2 release to resolve a reported KVM problem now.
>   	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.173-rc2.gz
> 
> thanks,
> 
> greg k-h
> 

All clear now on rc2. The kvm problem is gone.

thanks,
-- Shuah
