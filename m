Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44AE93DFBA3
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 08:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235260AbhHDG6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 02:58:50 -0400
Received: from goliath.siemens.de ([192.35.17.28]:50999 "EHLO
        goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235227AbhHDG6u (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Aug 2021 02:58:50 -0400
Received: from mail2.sbs.de (mail2.sbs.de [192.129.41.66])
        by goliath.siemens.de (8.15.2/8.15.2) with ESMTPS id 1746wHWd023426
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Aug 2021 08:58:17 +0200
Received: from [139.22.36.137] ([139.22.36.137])
        by mail2.sbs.de (8.15.2/8.15.2) with ESMTP id 1746wGge023617;
        Wed, 4 Aug 2021 08:58:17 +0200
Subject: Re: Faulty commit "watchdog: iTCO_wdt: Account for rebooting on
 second timeout"
To:     Michael Marley <michael@michaelmarley.com>,
        Jean Delvare <jdelvare@suse.de>,
        linux-watchdog@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>
References: <20210803165108.4154cd52@endymion>
 <e13f45c4-70e2-e2c2-9513-ce38c8235b4f@siemens.com>
 <934e0af4-3c4c-3ac5-30e2-958f0725a21d@michaelmarley.com>
From:   Jan Kiszka <jan.kiszka@siemens.com>
Message-ID: <788533fa-0b77-4c44-2906-d8c9b2b8997d@siemens.com>
Date:   Wed, 4 Aug 2021 08:58:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <934e0af4-3c4c-3ac5-30e2-958f0725a21d@michaelmarley.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04.08.21 02:04, Michael Marley wrote:
> On 8/3/21 10:59 AM, Jan Kiszka wrote:
> 
>> https://lkml.org/lkml/2021/7/26/349
>>
> 
> It fixes the problem for me (the person who opened the Bugzilla report)
> too, thanks!
> 
> Tested-by: Michael Marley <michael@michaelmarley.com>
> 

Thanks for the confirmation!

Yeah, sorry, that original mistake is truly mine. In fact, I wrote this
code twice [1] but only messed it up here. Unfortunate that it spread so
quickly. I'll try discuss this with stable people eventually, if it was
a one off or if there are more such cases.

Jan

[1]
https://github.com/siemens/efibootguard/commit/aa89fe3cbd883198c23eaec43c4448fe9e8ae148

-- 
Siemens AG, T RDA IOT
Corporate Competence Center Embedded Linux
