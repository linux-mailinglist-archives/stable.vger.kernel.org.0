Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE83338BD35
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 06:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238981AbhEUEWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 00:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233608AbhEUEWO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 00:22:14 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36266C061574;
        Thu, 20 May 2021 21:20:52 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id x18so9700202pfi.9;
        Thu, 20 May 2021 21:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=icILYuh9P3O1U5SJe4etPNI0jvZeHZ+tNI5ylFS/ni0=;
        b=R9pOpPhYUoIDdNBhMuDbu0qc2n1oZSgMAgwe7yoHROi0CMMX1k3iRskhSCx1psUaOq
         s9reM01h2hAWyxJa4Y1DnrGKuiLmjjq6W7kgBhtvSF5AOrlMNc8jWgPWUgsYMEkWEd9w
         u8iX7EORR+ipvbtVfoDxL0h52KBXLw43LYM9N/CMPzgoES9bzEoe4RAazejECDlCIvuP
         hdD/zW9iYnccTN4r8dmWD22N2n9ZD9djiX/V+YJUKI78SVrH7zbFJ20uw8MYfK3MP1UP
         Rc33nXgV0o7xy2GrPOyStgoKKv2zoKJKU096xZCveZ0KrTKfeoLBh5Cre/+9ZN/cPWz+
         5ANg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=icILYuh9P3O1U5SJe4etPNI0jvZeHZ+tNI5ylFS/ni0=;
        b=jdu8t6YDX2qKKyRbCP1R41g17XjqDyAL9Rq4h60gEYj5P7V7aH1UdKBGLujAY+jBkk
         0GjuBPLyuelX6GbAf5YOarxJTVaaLGe/kR+53hkCcsZ4+wYHxSAy4NJ588Hah1TpWvA9
         Khw/oDKrL6bODeBl+Sj99SiIOXyYQ1UK1b8DtZlycIKgEB5Zum+DB5+1fvOHFAcv/k52
         6glWtwz6fRC0i2fWmvt96MJMmGohffGNhzABtWqUeltIEbeCJCnzJsiD1xb2spI5uqMH
         eo+b5ocI91oBij8ZZfzEvZlDbRtD6kgH+LdcprDHHiuFGPyG/yaKOjyQ/1xadT/xbLlW
         g/ew==
X-Gm-Message-State: AOAM532w2WlmzWLv1J2hOO9FG2yjSYG6k3fy0L/GVXSzf5OQ1OdGJHJk
        tlbmGAkO6avGV3Z6XoAxWyLEaL8f6RU=
X-Google-Smtp-Source: ABdhPJwO9cW9relzXKSaJ1sTmV+ghRCR3mGzAaKejplwAmI4f2pp8THuqWz2WNQ5acycb7t2MpcDaw==
X-Received: by 2002:aa7:828c:0:b029:2d2:3231:7ef8 with SMTP id s12-20020aa7828c0000b02902d232317ef8mr8005545pfm.80.1621570851296;
        Thu, 20 May 2021 21:20:51 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a15sm2970598pfc.29.2021.05.20.21.20.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 May 2021 21:20:50 -0700 (PDT)
Subject: Re: [PATCH 5.12 00/43] 5.12.6-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210520152254.218537944@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <aad5f960-56cb-52b7-a858-81a1d94a47b5@gmail.com>
Date:   Thu, 20 May 2021 21:20:41 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210520152254.218537944@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/20/2021 8:23 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.6 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 May 2021 15:22:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.6-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
