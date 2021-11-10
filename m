Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D108B44CDA5
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 00:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbhKJXMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 18:12:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbhKJXMM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 18:12:12 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E9DC061766;
        Wed, 10 Nov 2021 15:09:24 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id r132so1390676pgr.9;
        Wed, 10 Nov 2021 15:09:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZYed9L8tjDqmmdBqxssK0wwI7VDJqETx7qq/WFdWQUc=;
        b=iNEqvP820+RbB95cErAT/weZ5I/BWtMAV8dNJMPcXLSG4UK7YHmCrkaCJociQEr/rE
         qo5d8dCk91E5sdJVfdwKPAd4PnlQP+Frjv95rUMeYyF34hq/jV3A7jqQ0W6+8e9SIpci
         R2wiwTp8OaX8n5ODn12+bJfbp5Mc0+CfdytTljuILNBM5UbjSjraDRverqH+uFEvC52V
         rb0KBMILQP8y0D9XbWLsuDv4cNik2APLx6BIIuQ49ZewHyE7/qBV4V0rji5W2BwO41B4
         GTiwyePaYBEijEOBSiD4j9h7EsHGfHhIdMfmgXaxr/ySx00UjeI3ZiQHgG2D8eNI21TV
         zFMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZYed9L8tjDqmmdBqxssK0wwI7VDJqETx7qq/WFdWQUc=;
        b=VglFOrW1DvSE7QomVdN9KON3aiYQOvDXVn6I0gPA6X5dGKNLyBGvfjB7Z58kyXuhUR
         2ks5XWD3YPYfyDdwjOe1m5AzZS6VvkWOg8Igz571a1SY6H1CF0zb4Lqz5cZRb6DdObbF
         gjvUXMUA4M+6Tic4tCXK9zo7E9GR4O6nbXOtka2YnMl6cnYB6cvhUuuCPuoWkYg2YoOU
         ODa4Qx/nc16BN/d112zDup3tKow+V2tWCUIrQ2LiN4Jfx0LkO0WjCgpOHLy/Z0HaADH0
         NmCT66pMEH5up3cFzYHv9Fnfw3gF57PkWMvYEyomExEdIZ+3InIL1sg4N4q6gU51rfJj
         0xdA==
X-Gm-Message-State: AOAM530D7jG8GTpmNX7vMYZvbHke+PvJT850Y9njmL7ciPznFkF6n/LF
        2G9GoKM0K1LGe+tAFwIVMAx73VoPJpk=
X-Google-Smtp-Source: ABdhPJzDOF3wEaiKVUpFXm1/tmaJFShw6YlA+fHVDFY/wue8hUqADpNdqtOChuzhQNMH494VQNVd3Q==
X-Received: by 2002:a63:2d47:: with SMTP id t68mr1712163pgt.52.1636585763650;
        Wed, 10 Nov 2021 15:09:23 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i185sm662603pfg.80.2021.11.10.15.09.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 15:09:22 -0800 (PST)
Subject: Re: [PATCH 5.14 00/24] 5.14.18-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211110182003.342919058@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <fb06974d-d62e-5c62-1d98-05064199d606@gmail.com>
Date:   Wed, 10 Nov 2021 15:09:21 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211110182003.342919058@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/10/21 10:43 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.18 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
