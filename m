Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA4541F28E
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 18:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbhJAQ5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 12:57:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhJAQ5i (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 Oct 2021 12:57:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 704E16124D;
        Fri,  1 Oct 2021 16:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633107354;
        bh=coj9Rf1WQ1xufZ8ZuCbTK3PBDKsVZwP1ge2lPW1FfQw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I+7XROpQM1kG9G/AOKCIemSU2hYSX3Nd2iOCnA+oeihrBaNR5sVH64FdC3N63vc+v
         fcZYmIXGpZ3wb92hAzMWEoBye/9Zqnf3jQyCAZuC5BxqvEmqhoP5vDbeiBDJotWFjY
         vq4ewjtBDmxSLSczSV01nsFtp2vaszQ594L3+a2+isBWoLz+JIEDs/pqVCYqWG7oTK
         vUtTl5yQEQYyRae1cHDLWa97UfzYVFwnnYQlbblUh1k8rlKydcWgsri1h3m64/wDwe
         u29wSB5QzKnKb4vNekiBmW+Nz808U94xWe0Y7ygoETjnGq5YcC6EnLJBO/FaSvJua1
         EUVKogYVu3tLA==
Date:   Fri, 1 Oct 2021 12:55:54 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     Salvatore Bonaccorso <carnil@debian.org>, stable@vger.kernel.org,
        greg@kroah.com
Subject: Re: [PATCH 5.4 0/3] usb: hso: backport CVE-2021-37159 fix
Message-ID: <YVc9mtE329rqf5ab@sashalap>
References: <20210928131523.2314252-1-ovidiu.panait@windriver.com>
 <YVNs/mLb9YXNz7G+@eldamar.lan>
 <2c3095ae-9f67-2a38-e258-1f8d707c4fa2@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2c3095ae-9f67-2a38-e258-1f8d707c4fa2@windriver.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 29, 2021 at 11:03:19AM +0300, Ovidiu Panait wrote:
>Hi Salvatore,
>
>On 9/28/21 10:29 PM, Salvatore Bonaccorso wrote:
>>[Please note: This e-mail is from an EXTERNAL e-mail address]
>>
>>Hi Ovidiu
>>
>>On Tue, Sep 28, 2021 at 04:15:20PM +0300, Ovidiu Panait wrote:
>>>All 3 upstream commits apply cleanly:
>>>    * 5fcfb6d0bfcd ("hso: fix bailout in error case of probe") is a support
>>>      patch needed for context
>>>    * a6ecfb39ba9d ("usb: hso: fix error handling code of hso_create_net_device")
>>>      is the actual fix
>>>    * dcb713d53e2e ("usb: hso: remove the bailout parameter") is a follow up
>>>      cleanup commit
>>>
>>>Dongliang Mu (2):
>>>   usb: hso: fix error handling code of hso_create_net_device
>>>   usb: hso: remove the bailout parameter
>>>
>>>Oliver Neukum (1):
>>>   hso: fix bailout in error case of probe
>>>
>>>  drivers/net/usb/hso.c | 33 +++++++++++++++++++++++----------
>>>  1 file changed, 23 insertions(+), 10 deletions(-)
>>Noticing you sent this patch series for 4.14, 4.19 and 5.4 but am I
>>right that the last commit dcb713d53e2e ("usb: hso: remove the bailout
>>parameter") as cleanup commit should ideally as well be applied to
>>5.10.y and 5.14.y?
>>
>>Whilst it's probably not strictly needed it would otherwise leave the
>>upper 5.10.y and 5.14.y inconsistent with those where these series are
>>applied.
>
>You're right, I have sent the cleanup patch for 5.10/5.14 integration 
>as well:
>
>https://lore.kernel.org/stable/20210929075940.1961832-1-ovidiu.panait@windriver.com/T/#t

Why do we need that cleanup commit in <=5.4 to begin with? Does it
actually fix anything?

-- 
Thanks,
Sasha
