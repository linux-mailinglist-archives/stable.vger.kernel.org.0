Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6354CC6D8
	for <lists+stable@lfdr.de>; Sat,  5 Oct 2019 02:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbfJEAKd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 20:10:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbfJEAKd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 20:10:33 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB44320830;
        Sat,  5 Oct 2019 00:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570234232;
        bh=lFa6sPDHITQrEVARSeh9KoE0BVymjT1WzNK/A9pWsEs=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=dg+rrekMTNui0+LdxWFrnPCR6wRQFY9WMWbwMEjssisZRM0ro77l7maaFvmcy+rfS
         ng2b6ZLby7Rtm69FInRZgs3rHVHnMk0o7wQcmaOiU8uX0M5Qy0hkRHhKwCEYG40uGM
         lcpMXhsvHFzEZjO9yEw5TFP+QHWWIEAxc8ahl7hU=
Subject: Re: [PATCH 4.14 000/185] 4.14.147-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, ben.hutchings@codethink.co.uk,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net,
        Hans Verkuil <hverkuil@xs4all.nl>
References: <20191003154437.541662648@linuxfoundation.org>
 <20191004175111.434wgtyscv647mql@xps.therub.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        shuah <shuah@kernel.org>
From:   shuah <shuah@kernel.org>
Message-ID: <b785e760-d624-d08e-f7e2-eb1fe58d91df@kernel.org>
Date:   Fri, 4 Oct 2019 18:10:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191004175111.434wgtyscv647mql@xps.therub.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/4/19 11:51 AM, Dan Rue wrote:
> On Thu, Oct 03, 2019 at 05:51:18PM +0200, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 4.14.147 release.
>> There are 185 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sat 05 Oct 2019 03:37:47 PM UTC.
>> Anything received after that time might be too late.
> 
> There's a regression listed below that happened while running 'modprobe
> vivid' on db410c. We've investigated it and are unable to reliably
> reproduce it. It happens less than 1% of the time, so it is very
> unlikely to be a regression. The detailed log can be found at
> https://lkft.validation.linaro.org/scheduler/job/950199#L1545 and we
> will continue to investigate and try to narrow down the problem so that
> we can report it coherently.
> 
> 

Adding Hans and linux-media to the thread.

Hans! I thought you might be interested in looking at this vivid panic.

thanks,
-- Shuah
