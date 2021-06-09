Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD9A3A1C92
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 20:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhFISQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 14:16:56 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:33604 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhFISQ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 14:16:56 -0400
Received: by mail-pl1-f176.google.com with SMTP id c13so13060176plz.0;
        Wed, 09 Jun 2021 11:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wwfufyKvmvEMNzYlwDLpaW9ByvmiH5n3ydfZUfKPQ0o=;
        b=UF+EyQxDzrgR2+h9n0XecWNi6AXcmwM+5Ntm0fefDtJYMPIcem5IlFCnKFacXPvTM+
         jFkcGXUuLgMlIOu/dM1tW+IHSAtmF9mf11MREWHhDrNAyCgb6Z3FNErO58qmEnUxFe1y
         WP2YjHseJJT3nWhtFrF+Ntl//OQTBg+yD9AyHYHY/gIc/L2hgEAmeicg/N8lVWeZFIPE
         2OmkSeln4Qg3xY6otJMfOgJoirTCvzyj2JAgpbAXhPDlTHX/4iZYTAbDDL7rrtkBQa4r
         z9LQye8gN//spW+Ghbgwp2PuBdtHS0CSZWg6IsuYM9OGn/Wghwk/bSex5t5YofH83+vC
         Ky8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wwfufyKvmvEMNzYlwDLpaW9ByvmiH5n3ydfZUfKPQ0o=;
        b=cFfmtmVq6rKJEc23nAff/v+fp6mYasvlOzxITJg3G7NugQPKyxpIfrgqMZcX8B5cFo
         Po/o32AYQYqkxfVRzDIOrFQRmf8yySMnAoM4OzU+U/xpGgXokpL71yTwQNW58N/aFhG4
         hkdO5pKAgbVpABadcCcj6qKK3dizjA0RKGJBen8OhtjwAGj9V6ONWz6U8QA6nUnqHro2
         Xfzc8vG/lX8DJGTFpIqjFMuDElLVmomRLCLv9jcxj28gJiSA5jA1AwD4jx43Xuxko5fY
         4zl8QulPfVvAhC9fVFpIguGc3eHphF15MUt4GSFa3ntDdJp/XsmvTFgH1bl/AS/sJexT
         yCGQ==
X-Gm-Message-State: AOAM530hxg4TqbYWw7A+C0j2m+s/xdXmGD5vTeA87i8g0YPU7PSTLiWG
        5i3tlmKm7hNzLwJ+WjZUkh4hGdU4GOU=
X-Google-Smtp-Source: ABdhPJxOuU3bBbjm5CmEh4pG6cx6MHMHT0WPG9bqTMucVge33E1J6Pcqg1w7J2s5n4qggz7KEgfNMg==
X-Received: by 2002:a17:90b:19cb:: with SMTP id nm11mr831313pjb.1.1623262425574;
        Wed, 09 Jun 2021 11:13:45 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 60sm317125pjz.42.2021.06.09.11.13.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 11:13:44 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/29] 4.9.272-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210608175927.821075974@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2b7b3fd7-a5ce-b15b-b6db-91c6a886c0ff@gmail.com>
Date:   Wed, 9 Jun 2021 11:13:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210608175927.821075974@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/8/2021 11:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.272 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jun 2021 17:59:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.272-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
