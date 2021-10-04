Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE9254217DD
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 21:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233944AbhJDTrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 15:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233878AbhJDTrC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 15:47:02 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ABE3C061745
        for <stable@vger.kernel.org>; Mon,  4 Oct 2021 12:45:13 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id h9-20020a9d2f09000000b005453f95356cso23046209otb.11
        for <stable@vger.kernel.org>; Mon, 04 Oct 2021 12:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JKd9BiPYYFvJySR1Ez4/0JZz+DNQpc9/XCSXc+UC0MU=;
        b=KwIJzNoRNMYqwjX+9BO1ImaUaIgyBy+05c8cnJF7ws+euzNDPJav0cPwz2y4F2gsfY
         THH7xM/f7l6XakEnsuzOwjW8jC/LiYhPiP/hV8zEvH6bSp08TYGQ6qmJdTPGtoG4C/ye
         rLxRz0VTgpKw8kdBmdaBsVgoiqlRWb1LeJdsU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JKd9BiPYYFvJySR1Ez4/0JZz+DNQpc9/XCSXc+UC0MU=;
        b=KVBh7yqFmCxBnkiieO+UjEWwlOdsfq58G/eYJZ8zjoQE3MCAnMUvMbpKM3QitJZBTD
         kffiPk+o8tonF28SxxjzLHs9gqYIl9finw8ONk958dtcklWey/mjwzR7+L+5CS2nqgGv
         vN/i5udWaVAS0gc8z7HfvUDP2dJ2YMdPAW6rNF08+Y4AyoQxm2siu4mRExMQGh3LVU6J
         hUZnweU2bC7Y6inACwWFQS5fSs9IFriStRglYSAf72kPj+HHGgFzQEOjdpl/4KZtI8tn
         zJnvVrAEXb+c86i29HIkh17Alr2DCdmo5LXaXTbzgvErUnuz1jXO2h03A83lnKfPuzcC
         n9mg==
X-Gm-Message-State: AOAM533tTTFeHTtHwwabFyMyejCjzPCNoL7iNs5RMeGXmvLyDVHDFrCL
        j6ntWmHPmsG3E8bKuPxAN1k5lg==
X-Google-Smtp-Source: ABdhPJwY7YDbgvjq7CE3TiOcmcG4Ofrgy35eV+SLVP66X8DWGdx5t7Efwi9PxW+BzqlkKA1dN53rEQ==
X-Received: by 2002:a05:6830:89:: with SMTP id a9mr11431919oto.121.1633376712456;
        Mon, 04 Oct 2021 12:45:12 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id q20sm3015054ooc.29.2021.10.04.12.45.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 12:45:11 -0700 (PDT)
Subject: Re: [PATCH 5.14 000/172] 5.14.10-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <de79434e-af54-085f-78dc-95bc282f4743@linuxfoundation.org>
Date:   Mon, 4 Oct 2021 13:45:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/4/21 6:50 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.10 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Oct 2021 12:50:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah

