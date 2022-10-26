Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2109C60E5CA
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 18:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbiJZQv1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 12:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233884AbiJZQvZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 12:51:25 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6EAA2A9D;
        Wed, 26 Oct 2022 09:51:23 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id l6so11001247pjj.0;
        Wed, 26 Oct 2022 09:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=otIxxDfSMe9NIzeveqx6jnjued64xx34K/45O0pl07U=;
        b=jJKA3ulHxiWK+gd+Gn9nSqwVxiPE3ZCz1dWPoyI7yyKR86Tm8IRtkuRgGjO3Osub64
         wWkZrx+1QL7U5jq4BNzLSa3qabbc7taFjcjOt+Z5ZnF6OgCmx7COgYhcQNjiywHRtN0n
         cIAwDWyvK4O9u11HP7MeHmj+9VJnPpzgakF7HyOQnmJ9x6fP9WzIFrYYAi00pJz5shj2
         x1oX3xtoFN3XgqamPJiB/9DHgqgLGzmMc1wyMXDPORQ7YO/QCQ2SrQFilgnXiHq89t1Z
         /NK5r5oV/2BSbrwJUCft9B3yZrdYAdyureMMesp2c9QPk8Elxyn0Rl/o11akDbD3a60b
         I9uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=otIxxDfSMe9NIzeveqx6jnjued64xx34K/45O0pl07U=;
        b=K/TqdCwQ1HhU9AUL/iEkl5RilCNzeT3phh9uVEeZGzlFgZHbs7D21a8I+zK0NRw1yj
         Hg8Fi24v4myUZFq1krHB8xB8mnAIJeqDd0KxG19uR9ziYCRHsw4cz6LxO9jIQQuLCh/I
         JPTfv8ni0cHTZ/6NfE/iF+USPbYjkF8pGPSZ6bdIZ0t2y5sfSCrwi9K6CKO3bPxzNCtY
         Czr0/B2XQ17fQTpyrTvdWe6SoNrYEzDNraPafs8RBDuLjCI3HQgzmyoVyBUjljIy9C9q
         7U/+Ru6KV/U4uQCjzxapUpF0m3dZ4ZCQNlwsfQAT8G+jUL2j2zWN1TOcw7uMm7X7tU48
         Zezw==
X-Gm-Message-State: ACrzQf00vP01ZpfAA5j2P6FPmi7SmWmcNA2d7NgCgj2JEOSM2WuMjtiX
        /PTxM4CpKiZNcqKINYDZn+CFOPD8W3g=
X-Google-Smtp-Source: AMsMyM51RcQoRYQcB4q2ADLlloKLf5sfxlm5+/zLXCjtlGv62pW80DfsbwFcNmdWhppzrZbojSwWDA==
X-Received: by 2002:a17:902:6542:b0:172:95d8:a777 with SMTP id d2-20020a170902654200b0017295d8a777mr44965751pln.61.1666803083093;
        Wed, 26 Oct 2022 09:51:23 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:1c5e:eaed:5c17:c765? ([2600:8802:b00:4a48:1c5e:eaed:5c17:c765])
        by smtp.gmail.com with ESMTPSA id g12-20020a17090a4b0c00b0020dd9382124sm1297892pjh.57.2022.10.26.09.51.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Oct 2022 09:51:22 -0700 (PDT)
Message-ID: <4f0ae178-f075-1f24-43b7-7ba8e494db76@gmail.com>
Date:   Wed, 26 Oct 2022 09:51:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH stable 4.19] arm64: errata: Remove AES hwcap for COMPAT
 tasks
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ionela Voinescu <ionela.voinescu@arm.com>,
        Shreyas K K <quic_shrekk@quicinc.com>,
        Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
        Reiji Watanabe <reijiw@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        "moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20221020230110.1255660-1-f.fainelli@gmail.com>
 <20221020230110.1255660-3-f.fainelli@gmail.com> <Y1llLTazLS6LyOWB@kroah.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <Y1llLTazLS6LyOWB@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/26/2022 9:49 AM, Greg Kroah-Hartman wrote:
> On Thu, Oct 20, 2022 at 04:01:07PM -0700, Florian Fainelli wrote:
>> From: James Morse <james.morse@arm.com>
>>
>> commit 44b3834b2eed595af07021b1c64e6f9bc396398b upstream
>>
>> Cortex-A57 and Cortex-A72 have an erratum where an interrupt that
>> occurs between a pair of AES instructions in aarch32 mode may corrupt
>> the ELR. The task will subsequently produce the wrong AES result.
>>
>> The AES instructions are part of the cryptographic extensions, which are
>> optional. User-space software will detect the support for these
>> instructions from the hwcaps. If the platform doesn't support these
>> instructions a software implementation should be used.
>>
>> Remove the hwcap bits on affected parts to indicate user-space should
>> not use the AES instructions.
>>
>> Acked-by: Ard Biesheuvel <ardb@kernel.org>
>> Signed-off-by: James Morse <james.morse@arm.com>
>> Link: https://lore.kernel.org/r/20220714161523.279570-3-james.morse@arm.com
>> Signed-off-by: Will Deacon <will@kernel.org>
>> [florian: resolved conflicts in arch/arm64/tools/cpucaps and cpu_errata.c]
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> Change-Id: I651a0db2e9d2f304d210ae979ae586e7dcc9744d
> 
> No need for Change-Id: in upstream patches :)

Meh, the perils of working with Gerrit in the same tree.. do you need me 
to resubmit or can you strip those when you apply the patches?
-- 
Florian
