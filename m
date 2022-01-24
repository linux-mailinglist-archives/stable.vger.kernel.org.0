Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C112249AB44
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390049AbiAYErW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 23:47:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S246287AbiAYDq3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 22:46:29 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5337FC038AC4
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 15:40:00 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id o9-20020a9d7189000000b0059ee49b4f0fso7365784otj.2
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 15:40:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cvIF+YtmQ4XCjCv6/aKe23ut2l/NP75C4vTgLOVaQsw=;
        b=YZCsI9ZxCRIiRaGzz9ZSSkjzz3ejco00j50WjvEl1RTbr36SburOI3KxmWTu7Z9Qau
         obm75HL1eGKmC8hczjokrVG99yfYRDcpWCeklnb1918Irl+ZeFOVMNM0bfhEboDmotlp
         cFJyqRIS4DqlScI9/GoRkiDybzRbyC8shBsPM16o/kTFsOmzE1KXe44/mUN33Ka997Ob
         SM7/s6fvzSdr7SM6wtwnaVIWjARmK0o5mx0Gq233K0jVD6J8nFJrH4Yh1pvLoWbwq8eh
         JA3m5QNSZMu9Y+fEUOYO594/0zPeKPODZ119/g8CvTO2vnzY5sun9XO1zsHVbbEamhgU
         kCRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cvIF+YtmQ4XCjCv6/aKe23ut2l/NP75C4vTgLOVaQsw=;
        b=KZFU9npOTPbftQqRYKRSDuzVeQbopIjAf2+lNEosOphhwNxcwHUmjuWnjkTekWQPlb
         A9yEIXU/hB+toeN5LjtaW97WOyhO+eT+54+qu3XAoRmWrpkrfAzR9YMdHM+/ZUN2rHyp
         fA09uUpqfzBHj77LKJ5hWf0Gz0EoOmy6i/WuNc8GbwkvHK3gCt8Ja6tfpeLm+gvOX8QO
         jQmnrlW7KiiLtvxQUqhbAvhnG02geJ4M+P3sAC6jyrYfwi3KMLZDaLB7enBU9yDqCyTs
         NiiEUjsHpASiTYfMY0gvXgNHiDmrxhEo3U9r8D0G2mA9Q8Pe51DQcJXQrmyuGhvZtF82
         yg5A==
X-Gm-Message-State: AOAM530NHppy5pbkHHGvm24bCdoo2qQerGbNp5BHW+XMFN/kLih+Zqbo
        zbtpCPpDMGXLpRrJokFPhzxqDuTJaMvGzw==
X-Google-Smtp-Source: ABdhPJwHPmapIvQNXbQck+aZepoN1PElzPzSl9iWUFV0WLtONtf3QFDq0WJNdPmMsY3CC0KDAI6s+Q==
X-Received: by 2002:a9d:7354:: with SMTP id l20mr13788444otk.257.1643067599674;
        Mon, 24 Jan 2022 15:39:59 -0800 (PST)
Received: from [192.168.17.16] ([189.219.72.83])
        by smtp.gmail.com with ESMTPSA id l16sm4882014oop.45.2022.01.24.15.39.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 15:39:59 -0800 (PST)
Message-ID: <e2c9b01d-0500-645f-b4cc-f8dcb769996e@linaro.org>
Date:   Mon, 24 Jan 2022 17:39:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.4 000/320] 5.4.174-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        stable@vger.kernel.org
References: <20220124183953.750177707@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 1/24/22 12:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.174 release.
> There are 320 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.174-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Regressions detected on arm, arm64, i386, x86, parisc.

This is on Perf on arm, arm64, i386, x86:

   libbpf.c: In function 'bpf_object__elf_collect':
   libbpf.c:1581:31: error: invalid type argument of '->' (have 'GElf_Shdr' {aka 'Elf64_Shdr'})
    1581 |                         if (sh->sh_type != SHT_PROGBITS)
         |                               ^~
   libbpf.c:1585:31: error: invalid type argument of '->' (have 'GElf_Shdr' {aka 'Elf64_Shdr'})
    1585 |                         if (sh->sh_type != SHT_PROGBITS)
         |                               ^~
   make[4]: *** [/builds/linux/tools/build/Makefile.build:97: /home/tuxbuild/.cache/tuxmake/builds/current/staticobjs/libbpf.o] Error 1


This is from PA-RISC with gcc-8, gcc-9, gcc-10, gcc-11:

   /builds/linux/drivers/parisc/sba_iommu.c: In function 'sba_io_pdir_entry':
   /builds/linux/arch/parisc/include/asm/special_insns.h:11:3: error: expected ':' or ')' before 'ASM_EXCEPTIONTABLE_ENTRY'
      ASM_EXCEPTIONTABLE_ENTRY(8b, 9b) \
      ^~~~~~~~~~~~~~~~~~~~~~~~


Bisection of the latter points to "parisc: Fix lpa and lpa_user defines".

Greetings!

Daniel Díaz
daniel.diaz@linaro.org
