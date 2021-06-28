Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1733B6A1E
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 23:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237034AbhF1VWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 17:22:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233305AbhF1VWn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 17:22:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DBF861CF9;
        Mon, 28 Jun 2021 21:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624915217;
        bh=WC4t2AebEhqOelJW+niPP2YlMlBWflZN2MC6DVyRPaE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sNf+es0eLKMl8WyAP5+0u02ZQqimvwRC5RgYRYOhVVBaBWbXR6AwvU8JUNSRcIo+2
         yEicmmS0Rj7X7xvrFdA++OExLCGAStnUvHMG1zlAXqmsDHs+2dYO2KBwGXkwR9Mncs
         ifclkYpBTxbw13Zpmk0x4buMTKMi0nCZt5fCbo9pwi/kp7fAgQQtiExLA5ZIJcQOik
         N2aihn9BawJQJumPIHghn51fxA0IYvtz0Ua78R2j0paHBdd1lMRxBpOR+sywneX04o
         TNx5BR4VmXqM0A/eyQj35zLPIyrWy2PDF0Ba9Q7HSlXIN8vjaeBPhBpHGqDOfC7gFl
         D0z8aPEFSKi9w==
Date:   Mon, 28 Jun 2021 17:20:16 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 5.4 00/71] 5.4.129-rc1 review
Message-ID: <YNo9EL/9dLtiUuvU@sashalap>
References: <20210628143004.32596-1-sashal@kernel.org>
 <d3122f35-4659-8bed-65eb-77087eec82fe@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <d3122f35-4659-8bed-65eb-77087eec82fe@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 28, 2021 at 02:57:20PM -0600, Shuah Khan wrote:
>On 6/28/21 8:28 AM, Sasha Levin wrote:
>>
>>This is the start of the stable review cycle for the 5.4.129 release.
>>There are 71 patches in this series, all will be posted as a response
>>to this one.  If anyone has any issues with these being applied, please
>>let me know.
>>
>>Responses should be made by Wed 30 Jun 2021 02:29:43 PM UTC.
>>Anything received after that time might be too late.
>>
>>The whole patch series can be found in one patch at:
>>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.4.y&id2=v5.4.128
>
>My tools are failing on this link. Is it possible to keep the rc patch 
>convention consistent with Greg KH's naming scheme?
>
>The whole patch series can be found in one patch at:
>
>	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.128-rc1.gz

I don't mind changing that if Greg can set up the permissions around it.
Last time we discussed it, it seemed like a pain to do so.

-- 
Thanks,
Sasha
