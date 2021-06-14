Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE7083A7033
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 22:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235437AbhFNUYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 16:24:17 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:42896 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235200AbhFNUYN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 16:24:13 -0400
Received: by mail-pj1-f51.google.com with SMTP id 13-20020a17090a08cdb029016eed209ca4so52159pjn.1;
        Mon, 14 Jun 2021 13:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xat/qbGpfR/D0GzQjKqjwphadsiT4yXBSQlPfqst2Pk=;
        b=WFmXtiEPmDEZDcdA78V7VP0al5TpxiniASocr2eCzeTg5AvZbbFmhC5H/aV20c/QQJ
         wOt6QBnf0i0oxcdFtZACgWQjhYwDcnfAr1RmeKxRjIP5RnAWZ/y+NG8c86DzzP9W122h
         822k+2bAV1QfO62Ab3WCty4o3pYhaq+clwx2xLPUUVOGw5UcX1FTTYi9RPvx59E4GwZb
         kxpdpDujj2XWwMFOp7+MzNrZyWoEg2wuu319uVOF6eqehrKzzm+hO38SmmmhBGqd/8UT
         hmfXKJP1XXR05Urn2otQJ1jvf9xdK+Ni1fNbzVL0EZy0xvDv5bMDoGuJ8H/ZPrlaU00t
         CPww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xat/qbGpfR/D0GzQjKqjwphadsiT4yXBSQlPfqst2Pk=;
        b=hU7eJd4JYaAc6MRuu2m9X3mx9nxk5nJr4a1gawDenfZU4OJ+SxPcLeZKpGR+yKowJ6
         hTShJMXxiBLFLyXzFi6DGMsUuMejFnocfZdZ1S/JqIrOIWbxwtIphTCE1kocrNcJNOhV
         UdMJIEGja9ImrgzhSErydwKHCcL1XYwcXjXLup7Ebb019BqVDChQ/c39ETQ6Kbsrur8s
         1IW5KoMUjf9VBSIlkH43G019WVw+Y2M3XCSAWF0XPt0p4wAYcDXnlboHqqt9VasgeENA
         ta2n/q5jj9EWyW+1Rd7PdhyzuflldG9CT7+t7stQfE2HMm480FINkd1z07TObjBPZpii
         X3Dw==
X-Gm-Message-State: AOAM531AyuhhjRMWrJALQpkWyQABzofoMqwMizqBtI8FGEeMKda6vQlc
        ej6uI3mKu7GpoZAfHyJPRY3ks3OvB3Y=
X-Google-Smtp-Source: ABdhPJzuS2+gft6vKWXNCd6H7MAnUgGuRk3JlMCbaDEsdjtNdpMXv6Qfx04Pi+tcAqhPSlOfuyITtA==
X-Received: by 2002:a17:90b:1203:: with SMTP id gl3mr21173036pjb.145.1623702057326;
        Mon, 14 Jun 2021 13:20:57 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id w79sm13976013pff.21.2021.06.14.13.20.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 13:20:56 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/130] 5.10.44-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210614161424.091266895@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3505d28a-ebb5-f457-e2e3-b8f22bec78ef@gmail.com>
Date:   Mon, 14 Jun 2021 13:20:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210614161424.091266895@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/14/2021 9:15 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.44 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Jun 2021 16:13:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.44-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>On ARCH_BRCMSTB using
32-bit and 64-bit kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
