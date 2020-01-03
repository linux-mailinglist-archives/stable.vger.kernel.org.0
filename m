Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7F212F20B
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 01:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbgACAQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 19:16:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:53014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgACAQl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 19:16:41 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1D17217F4;
        Fri,  3 Jan 2020 00:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578010601;
        bh=IXRUwUNLalDIsRuTgfBq/d0vKgm9hCKSIPwYSoJF2L4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZXKoG+z6Xnwk4DhAwBAMILZyD36ZQhREuFSy7vmf7u2ZNYFCznsvZEEqiW/qrjqZv
         yqZ1wSFktVjbzqqvz/DnkfKh5x3p+3jlWVQjfYn7M3liqZeT06vGNTw8hXk1hAKUR8
         jwdCMoajbMnShJ++qYDvJmMFb1HSAOavpFJcB5LI=
Date:   Thu, 2 Jan 2020 19:16:39 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/91] 4.14.162-stable review
Message-ID: <20200103001639.GK16372@sasha-vm>
References: <20200102220356.856162165@linuxfoundation.org>
 <20200102230518.GA1087@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200102230518.GA1087@roeck-us.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 02, 2020 at 03:05:18PM -0800, Guenter Roeck wrote:
>On Thu, Jan 02, 2020 at 11:06:42PM +0100, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 4.14.162 release.
>> There are 91 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sat, 04 Jan 2020 22:01:54 +0000.
>> Anything received after that time might be too late.
>>
>
>drivers/pci/switch/switchtec.c: In function 'ioctl_event_summary':
>drivers/pci/switch/switchtec.c:901:18: error: implicit declaration of function 'readq'; did you mean 'readl'?
>
>The problem also affects v4.19.y. Seen with various 32-bit builds,
>including i386:allmodconfig and arm:allmodconfig.
>
>The backport replaces ioread64 with readq, which may not have been
>such a good idea.

Indeed. I'll drop it for now, thanks!

-- 
Thanks,
Sasha
