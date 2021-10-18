Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860DF432925
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 23:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbhJRVjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 17:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233128AbhJRVju (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 17:39:50 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65156C06161C;
        Mon, 18 Oct 2021 14:37:38 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id g184so17435149pgc.6;
        Mon, 18 Oct 2021 14:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cNHl2gTAxcYmC+4CDwOzqqvlyygv7UZJti6PDMgFJCs=;
        b=qLgh/2uOi3Bofcgc0fncwLuzcLsShHDS1PkYp77PdXZa6T0omrhOU1OgDklK4KOyez
         4PjWtqoIAwlxHY8hAwFDEkbz0F93SBhJ9wsNzqIvS9MnAGyongvJvVJ6OYs6s7NANnCm
         +dYR7gdkUw+fJqeufohpqsSNf1TqL0E4PaI0Vwgmfaiu4w+zYQtxEy9OjSeSkmVyxnF3
         0+x3g5vCoJPF88tcerwmlKFaHm9XHk62TD+/vJLdpYhufshYcXJAAMvJX8dYi3xu9F/w
         hm7Qb9U/W37/Ru3FlP3Hd+Vhz0OygBehbZU/TxRaHOnLzXG40RRcd2zWEaCY1jeSA5qR
         Bvuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cNHl2gTAxcYmC+4CDwOzqqvlyygv7UZJti6PDMgFJCs=;
        b=XZFmkGEPfS0q7n2kWh+oV/thFLBrBHAxFok1EyS3s9O8OrMGmy+q7IMnprzJWDJesb
         aKpixkiMROhyYDIQGux7RxymUT6d6PL6H/KXsxC+HLVLDqcllBulQD62GFzu8mqexylM
         wcipTDaxI7y7L0TwZN3cV4gxNK3x0aw1BrGrqtNzd14JlWr7R3HbcprNI3586jsE5eWF
         leZBBv7svosMrsMgHH2CNkeET/DXQHA0DAtj8pw7qFk2GLebwk8qsMYLYO5zj/nzZ5cC
         US/eiv1QIJhKPuwJZC8Gy0uoZYqjPhBRZkelLJI3EsDdl8k9DbIubTB3nQ6RGSuLBsa5
         DvOA==
X-Gm-Message-State: AOAM532R5hT6dmnU1OUGmCGeHfRewrXKmTFUeozfSK5hbaWhyLxlTfy+
        fug0iefQA61DBZtBvJUIHnlry6YOhCk=
X-Google-Smtp-Source: ABdhPJwt7bN1uQfW2KONKHWES0vmzgYizVsvI1RPYjGakHS1JKTwiPRbdfXxN6ozTm9YGNX7eGsUtw==
X-Received: by 2002:a62:188c:0:b0:44d:6660:212b with SMTP id 134-20020a62188c000000b0044d6660212bmr31658434pfy.8.1634593057464;
        Mon, 18 Oct 2021 14:37:37 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id v9sm360861pjc.55.2021.10.18.14.37.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 14:37:36 -0700 (PDT)
Subject: Re: [PATCH 5.14 000/151] 5.14.14-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211018132340.682786018@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <69f619e2-868a-6825-47cd-11071c4a8d56@gmail.com>
Date:   Mon, 18 Oct 2021 14:37:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/18/21 6:22 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.14 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Oct 2021 13:23:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
