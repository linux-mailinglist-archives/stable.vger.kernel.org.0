Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9796932E37E
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 09:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbhCEIR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 03:17:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhCEIRL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 03:17:11 -0500
Received: from forwardcorp1j.mail.yandex.net (forwardcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1E0C061574;
        Fri,  5 Mar 2021 00:17:10 -0800 (PST)
Received: from vla1-fdfb804fb3f3.qloud-c.yandex.net (vla1-fdfb804fb3f3.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:3199:0:640:fdfb:804f])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 31CED2E15BA;
        Fri,  5 Mar 2021 11:17:06 +0300 (MSK)
Received: from vla5-d6d5ce7a4718.qloud-c.yandex.net (vla5-d6d5ce7a4718.qloud-c.yandex.net [2a02:6b8:c18:341e:0:640:d6d5:ce7a])
        by vla1-fdfb804fb3f3.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id nBUJYgG9mP-H504YqKo;
        Fri, 05 Mar 2021 11:17:06 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com; s=default;
        t=1614932226; bh=ikw0NZHqJgFqyaFCRWbjp7lWwmWwPcvXaMhsrOZJ7u0=;
        h=In-Reply-To:References:Date:Message-ID:From:To:Subject:Cc;
        b=g7V+jCO9XOBzYLR0mvS0cct1Ktx8BVoGBuc0crJqmqQtZ4FTPm7DaScDEfSMgT8zC
         9OBp5iIVfCwU3yC9+GCFlc8ENlzofOeeHIxJSCKzb8+eMLqsBYFZF78ULUu8xknjIN
         p41IsEpZgZKuUmcENCnWG0PXH8qBhm8SK/J6Ymw8=
Authentication-Results: vla1-fdfb804fb3f3.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.com
Received: from dynamic-vpn.dhcp.yndx.net (dynamic-vpn.dhcp.yndx.net [2a02:6b8:b080:8217::1:2])
        by vla5-d6d5ce7a4718.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id Q79TVul5mw-H5n0O6mP;
        Fri, 05 Mar 2021 11:17:05 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [PATCH] iommu/amd: Fix sleeping in atomic in
 increase_address_space()
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Will Deacon <will@kernel.org>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>,
        valesini@yandex-team.ru, stable@vger.kernel.org
References: <20210217143004.19165-1-arbn@yandex-team.com>
 <20210217181002.GC4304@willie-the-truck> <20210304121941.GB26414@8bytes.org>
From:   Andrey Ryabinin <arbn@yandex-team.com>
Message-ID: <298d9f1e-39b7-ee1c-86f6-9f9780356942@yandex-team.com>
Date:   Fri, 5 Mar 2021 11:18:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210304121941.GB26414@8bytes.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/4/21 3:19 PM, Joerg Roedel wrote:
> On Wed, Feb 17, 2021 at 06:10:02PM +0000, Will Deacon wrote:
>>>  drivers/iommu/amd/iommu.c | 10 ++++++----
>>>  1 file changed, 6 insertions(+), 4 deletions(-)
>>
>> Acked-by: Will Deacon <will@kernel.org>
> 
> Applied for v5.12, thanks.
> 
> There were some conflicts which I resolved, can you please check the
> result, Andrey? The updated patch is attached.
> 

Thanks, looks good to me.
