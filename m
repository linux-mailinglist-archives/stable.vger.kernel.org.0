Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19EC4529F6
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 06:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbhKPFrs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 00:47:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236129AbhKPFrl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 00:47:41 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA0EC0432C1;
        Mon, 15 Nov 2021 19:32:08 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id r5so10440549pgi.6;
        Mon, 15 Nov 2021 19:32:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=sM9JlZyeOv/O7uoNQWF2VaX9Gxpvdbv8KSMiYaGIkAo=;
        b=gdeseGBpRtU2p0X04orYBfuEFcosPWbnIR3Bqn4+JWIWZR2u+PEnq/+Xpw0RLtxlX7
         M2lyMImt1LfM0zpI956EqKo7PjRTYVNpOtY19NWD7DStuDIsHttqmGlj7xpdZLCVuaFQ
         grjeNVEfOgKoOWzl1NmVc0PMf7IUPgne7cmkfVkKPPuJ9pPbnsElTOPL1TdwT40rJgKv
         l7H8oZHPsOJ0OhSP6n9GcV8DdAv27hz7thY3SDSjZ8SzpYnT9l7WwYG9z+8itGnOY5/J
         H3Yjca9A0xPUMz5Z0htAhsu93f4+WGedgDMU2HLLSwuX+dICCCLU/cfnJT6r4TI9nvRY
         2jWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sM9JlZyeOv/O7uoNQWF2VaX9Gxpvdbv8KSMiYaGIkAo=;
        b=IvZZntzUfcWvv2R/3k06Qjd+mNVmvICfPIE6LE1oO7x6kZD8BeTicFoF2wcN9TLlAJ
         MO2NkGFum3Vy/6X1vzd63wdGGDpQoCTlsc5OivY/rHlRr6FBeq/68hVINkM2yfNE0J6+
         PQDugigM6X3DlJd5lr8E+my08kjePal9hiCakd/YPVplyZUGpdLdzFpkpyeUK1b8tcwT
         aBP//dXblI5GPYoM6EQVkpkAobcMAWMCeoE69G3zwzzSNywy4n1SYWi4NeLPpCbxldmu
         EcATFtHI0ZHHzJDZzKCNXh0A0Kn9ipkUHHoWhno2f4LtrtGypEYVgIJCQK5riDZ248Km
         lKNQ==
X-Gm-Message-State: AOAM532Ahl18s/dJku2/XlfPsTdYOeaE1OsBMl56Sx3vTZGAt0YSQw5M
        p48OjaNp7WNSiJssp76tOIU=
X-Google-Smtp-Source: ABdhPJyfeEreRKbgOoLOD2svX74KDLr9HasQvC21aYmCAUasAnq11knwRfgItqOgY47wprhZMoQn9w==
X-Received: by 2002:a62:16c7:0:b0:49f:a6cc:c77d with SMTP id 190-20020a6216c7000000b0049fa6ccc77dmr36718514pfw.23.1637033527731;
        Mon, 15 Nov 2021 19:32:07 -0800 (PST)
Received: from [10.230.0.229] ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id c9sm4652645pfm.84.2021.11.15.19.32.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 19:32:06 -0800 (PST)
Message-ID: <c64fce18-9b31-c8ce-c6ff-7561ba6e90bc@gmail.com>
Date:   Mon, 15 Nov 2021 19:32:04 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 5.4 000/355] 5.4.160-rc1 review
Content-Language: en-US
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, stable@vger.kernel.org, pavel@denx.de,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux@roeck-us.net, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
References: <20211115165313.549179499@linuxfoundation.org>
 <CA+G9fYvxhzL9KUxZcRzMxnbGPK5GKTCtb5kWM3JB09D+-KhVug@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <CA+G9fYvxhzL9KUxZcRzMxnbGPK5GKTCtb5kWM3JB09D+-KhVug@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/15/2021 10:00 AM, Naresh Kamboju wrote:
> On Mon, 15 Nov 2021 at 22:39, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 5.4.160 release.
>> There are 355 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 17 Nov 2021 16:52:23 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>          https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.160-rc1.gz
>> or in the git tree and branch at:
>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> 
> Perf build broken due to following errors.
> 
>> Andrii Nakryiko <andrii@kernel.org>
>>      libbpf: Fix BTF data layout checks and allow empty BTF
> 
> 
> In file included from btf.c:17:
> btf.c: In function 'btf_parse_hdr':
> btf.c:104:62: error: 'struct btf' has no member named 'raw_size'; did
> you mean 'data_size'?
>    104 |                 pr_debug("Invalid BTF total size:%u\n", btf->raw_size);
>        |                                                              ^~~~~~~~
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Build log:
> https://builds.tuxbuild.com/20xsgAxLwf4E60xl2dTdXnNS8FZ/

Same here.
-- 
Florian
