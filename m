Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B154137E7
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 18:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhIUQ7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 12:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbhIUQ7y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 12:59:54 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E317CC061574;
        Tue, 21 Sep 2021 09:58:25 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id s11so21308567pgr.11;
        Tue, 21 Sep 2021 09:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CETVK6ds2+pVBiYyRDYkGHOQ2Xi8265HXP1w2IsOw/s=;
        b=fXw07H7h/S09+jhMew/WRu/2l5CgTYmLbhvhhhUDFApMwO4chkFXboY8pr/pk4vc+m
         G/9Qfye2GpmREPTP4cjHHtFo1FkY5P/O0nIfZN1czk2PeViG+gMjnUyLO0Iiu1+8d/FN
         B2kQ3deBVaOyS08uPowNavm3ZwxZkmD/34yUjs8hauBwemPbtYVjBSYEMSbruyMbDmE1
         eLC1+nyscLCj+5jYUf2I3cTKTCHT+2r/wMpUSvmXYa7uxs2mvGJwTNY5BHMxmbQ3AOVC
         pffiA5G01ZR65F0aU56ZvX6uCSMyu+zjJKVRFWI9QZCW6WVd3W9gMwK+RrqWjT5+OhrO
         cDww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CETVK6ds2+pVBiYyRDYkGHOQ2Xi8265HXP1w2IsOw/s=;
        b=kWyKrRCxRoSQIXAg40lMiz+Mn8xlt6Lx+DZeS5bJD/P7mv8vIYT/4VkUz7eTDIzxyM
         3HEcNkejQAPimTgJFw5ta0BCWN7fD7m38fgCOYV5oPOJMdEhh3M2M6vz+zk2cgYP4ACj
         wUy0W8LQMrKzJ9NQnGLSch4hJjjNA/Muj/wbOEgSRgm7E2RqR1y3znmovEW4rYItj5F/
         gYPXOCA9LbJ5Ed6GtDQSxv5gRCBGSgPdcmjaTmifss3xJqhl8iyz7rFSNdh/uTpuhr7X
         oMQkkg81kID/fSgAx1JYwx8jb0D74rzQEBiKAFTkqFMLUSstpBwKyP97ALLhDz0ly+VR
         8kMA==
X-Gm-Message-State: AOAM532YI3/rnqJ3ZNRJdgK+qITMxdVRkqmOwfSX5YRwq2ERkfqempQq
        6zbEmeV0fhHFFA083mjary+MUBEnw9o=
X-Google-Smtp-Source: ABdhPJze7D4radWbj3gJfRezAW0+9jYJ4S4t0zu2sEjS24I8fdxSUMmEJzGOSP6MfeGf+evY9zUCkA==
X-Received: by 2002:a63:3f85:: with SMTP id m127mr1129533pga.140.1632243504964;
        Tue, 21 Sep 2021 09:58:24 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id s2sm3480683pjs.56.2021.09.21.09.58.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 09:58:24 -0700 (PDT)
Subject: Re: [PATCH 5.14 000/168] 5.14.7-rc1 review
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210920163921.633181900@linuxfoundation.org>
 <ca3953f8-e3a9-e3a9-d318-0f84ba96db12@gmail.com>
Message-ID: <b420c3e8-9adb-ddbc-9eef-5961469c8865@gmail.com>
Date:   Tue, 21 Sep 2021 09:58:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <ca3953f8-e3a9-e3a9-d318-0f84ba96db12@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/20/21 11:54 AM, Florian Fainelli wrote:
> On 9/20/21 9:42 AM, Greg Kroah-Hartman wrote:
>>
>> Rafał Miłecki <rafal@milecki.pl>
>>     net: dsa: b53: Set correct number of ports in the DSA struct
> 
> (same comment as for 5.10)
> 
> This patch will cause an out of bounds access on two platforms that use
> the b53 driver, you would need to wait for this commit:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=02319bf15acf54004216e40ac9c171437f24be24
> 
> to land in Linus' tree and then you can also take Rafal's b53 change.
> This is applicable to both the 5.14 and 5.10 trees and any tree where
> this change would be back ported to in between.
> 
> Thank you!

With the updated tag pointing to:

commit c25893599ebc571ecb26074f1338ac0c642078e4 (HEAD,
linux-stable-rc/linux-5.14.y)
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Tue Sep 21 08:59:04 2021 +0200

    Linux 5.14.7-rc1


Tested-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks Greg!
-- 
Florian
