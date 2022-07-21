Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D707357C41E
	for <lists+stable@lfdr.de>; Thu, 21 Jul 2022 08:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiGUGGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 02:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbiGUGF6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 02:05:58 -0400
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6DC12D32;
        Wed, 20 Jul 2022 23:05:56 -0700 (PDT)
Received: by mail-ed1-f45.google.com with SMTP id m16so850710edb.11;
        Wed, 20 Jul 2022 23:05:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=4aFAperWkgMWZD1HrgPGLDvbqBbKMtmvuEATzypfwXo=;
        b=szvJjE3tPGN7KMnJ6oYZsxq8llHWQtmfewZKjVu5Sbu6HoEqVJ+L8Wfa2DA8UpyrPF
         h6aUy9PrASB4xMe5F1ZZP2fo7wi4PzQDt8K197yp7IhFf3epJ3kExo7aRnDbqxLafB+d
         5ii2YaixgyuKQxiopidV/Z9iPIkci2+iZWq9lj276Eyzn+mXSr3mTUUzbZwmLICxAM3g
         q0GOcKQqEp0U7SX9AWX0H6TGeP0tiPyarlwAKqOk8bhSovlmsPRWfUiiVA/VeJxkOynY
         hn8AZGiKDx8YGkAAq7fg2xKWErySQt8eVY+nZkq2H6EXgcJqEJrvONBelmDCV4FfzZyZ
         De/g==
X-Gm-Message-State: AJIora987cpVuU9B7i8SxjPD4RAc+5ERRl2OIcJJiLt+MoVKatc/Mdwh
        OGrkRiPTeyO3DLsbPwfaqSI=
X-Google-Smtp-Source: AGRyM1sz335CBIJ+dljd+h02oNbxHh9qgX9sOcTFL/NKb1++LzkRAts4RXmmKiOedM1E/5riSRa4eg==
X-Received: by 2002:a05:6402:2997:b0:43b:247b:89cb with SMTP id eq23-20020a056402299700b0043b247b89cbmr46145271edb.91.1658383555428;
        Wed, 20 Jul 2022 23:05:55 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id ku21-20020a170907789500b0072b3464c043sm443830ejc.116.2022.07.20.23.05.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jul 2022 23:05:54 -0700 (PDT)
Message-ID: <bb2516b5-8dd3-3223-0bdc-809e51311347@kernel.org>
Date:   Thu, 21 Jul 2022 08:05:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.18 000/231] 5.18.13-rc1 review
Content-Language: en-US
From:   Jiri Slaby <jirislaby@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Justin Forbes <jforbes@fedoraproject.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Slade Watkins <slade@sladewatkins.com>,
        John Harrison <John.C.Harrison@intel.com>,
        Tejas Upadhyay <tejas.upadhyay@intel.com>,
        Anusha Srivatsa <anusha.srivatsa@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
References: <20220719114714.247441733@linuxfoundation.org>
 <CA+G9fYsCL48P5zFMKUxoJ-1vwUJSWhcn17rUx=1rxOdzdw_Mmg@mail.gmail.com>
 <CAHk-=wjo-u8=yJQJQnaP41FkQw7we9A-zJH3UELx5x_1ynPDfw@mail.gmail.com>
 <YtgvLUMuz+1zpQHR@fedora64.linuxtx.org>
 <CAHk-=wiu=yk=3xzXk18o5yU6v1wn27rcrOD=vmKm_aLNz=zJ+w@mail.gmail.com>
 <6cb8a9c9-d256-5db2-e352-e8de1165950c@kernel.org>
In-Reply-To: <6cb8a9c9-d256-5db2-e352-e8de1165950c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21. 07. 22, 7:42, Jiri Slaby wrote:
> Config:
> https://github.com/openSUSE/kernel-source/blob/stable/config/i386/pae
> 
> It says:
> CONFIG_CC_HAS_SLS=y
> CONFIG_CC_HAS_RETURN_THUNK=y
> CONFIG_SPECULATION_MITIGATIONS=y
> CONFIG_PAGE_TABLE_ISOLATION=y
> CONFIG_RETPOLINE=y
> CONFIG_RETHUNK=y
> CONFIG_CPU_UNRET_ENTRY=y
> CONFIG_CPU_IBPB_ENTRY=y
> CONFIG_CPU_IBRS_ENTRY=y
> CONFIG_ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE=y
> 
> Patches:
> https://github.com/openSUSE/kernel-source/tree/stable/patches.suse
> 
> Apart from others, it contains:
> 3131ef39fb03 x86/asm/32: Fix ANNOTATE_UNRET_SAFE use on 32-bit
...
> b75b7f8ef114 x86/xen: Rename SYS* entry points

Thinking about it, that's likely the reason I'm not seeing any failures 
-- I still carry all the retbleed patches on the top of stable. So while 
5.18.12-rc1 (the retbleed one) had them and added the above configs, 
later 5.18.12-rc/-final (only rawnand fixup), or 5.18.13-rc1 do not -- 
the configs are gone.

regards,
-- 
js
