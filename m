Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9D738F4F1
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 23:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbhEXVdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 17:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhEXVdo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 17:33:44 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E93C061574;
        Mon, 24 May 2021 14:32:15 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id 22so21520432pfv.11;
        Mon, 24 May 2021 14:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Su0Fl4wQCNXBOF4oM6+KVolqDcfXCaN+Ud//FfTMd5U=;
        b=IWeDv9aMFYjtEWtGg3dwxjBXe9FzdOYAjeLH1l+gW6/Q6KLINlYCQPL/DV9Oi9BxX6
         5Y8lQ9RpaFBm5OXf9GL8QhTNpMl6qC/10f6EtTweSfWexCgXPgPp9hRL6Sn6jvjr3YbQ
         YawAHEVjVBySxsR3B6iud1nN3Er34+WUFG+Y+SXUxcGol1WSNXm4eW9OPqnJ7SXyblR0
         YUL329/PRoTPi31fXznhKMMhPopgfjmtKii2lwAb99WEDDyFdxvCh6MCCoUYWcum2O4c
         Q0Y0gU2HZRUWV1yc/3FdIShN/dut/pi9IEMZFhzwVfshSay2aQ3yx83iSdwOvcrpmFYM
         QZpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Su0Fl4wQCNXBOF4oM6+KVolqDcfXCaN+Ud//FfTMd5U=;
        b=iaGzL6Dd3xGxphjX/YcjWnDHNKhK89QmaI7bWHZn7Ug/V3P+KIMSL8n9LLKVJtltO9
         xu0EzvLzymSWVAtFY6uNRq1FoyEL/yis2uQcFTMp2m9ER7N6+UmtuaxbJSLT97Q/VayK
         wNAU47XpvrOWN+HsyNYS2Qy5Bub/4FJb9DvSFUxgaOr+JDDWhe/9tGU5icFhma+O5DwT
         qsNChDWj1XW0e5V0FQ0eLDQS7NGTNmdlhvfnUYXM5YBxCD7GcRpTEm/OHAJiNxbGO5XX
         rc9saNNgvX2cDBkG1T3fvbzO38holq5TNQkXyYxpeydiipBg2GZDP8im3qmnx+3bsUjL
         Vu2w==
X-Gm-Message-State: AOAM533CQ5WqJlpd1KjJjIuszkdR/Jo6BDzBQMJYlCGfXbDQtrvkaNVG
        opKIrIqzvyHQLawOqUaQJBZ3jSPh/cs=
X-Google-Smtp-Source: ABdhPJwDS+QX7YIXVrmpcZAOug1r1tPJigF4nRqhYAjq/uKtZFcjP6xd/wa7wieTnAND5FRcfu2quQ==
X-Received: by 2002:a63:ba1b:: with SMTP id k27mr15611722pgf.381.1621891934334;
        Mon, 24 May 2021 14:32:14 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id gj21sm312426pjb.49.2021.05.24.14.32.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 14:32:13 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/71] 5.4.122-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210524152326.447759938@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2438c6df-dc68-a167-354b-8b53689cd4a0@gmail.com>
Date:   Mon, 24 May 2021 14:32:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210524152326.447759938@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/24/21 8:25 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.122 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.122-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
