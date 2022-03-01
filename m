Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B22604C883A
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 10:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbiCAJle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 04:41:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232727AbiCAJld (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 04:41:33 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D0D583AA;
        Tue,  1 Mar 2022 01:40:53 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id e6so12578391pgn.2;
        Tue, 01 Mar 2022 01:40:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vtImWDa9kuuW8w+jMwpHP6G21qHUIm0vC1VrYW1qZiQ=;
        b=OgIDOSQC5sZVMIKPL+rg1AHhiu7+uLP1PIBAK4kGc11oC19N1pgRq0RJGG/ZWehK/5
         POLJscXbx0Q9dCY2NZ1uCZY8Zi/Oe6zoJ4Gj3tXfSK1erE0mwFUiO7hCrE164GLI+QJJ
         tBcEvcYNCMJbJbPMRModylAqKp1Bu0qh8AfeP1Js673B2/9dl0I8RsC9GteqTqEsV7H4
         ZIyWgLZPdi6QKbSHfKAMmw6zb8cP2S2wF0kXaKj10m8MsUX/4czx93vdSFajdKISTD7I
         zuyUNF+/ccBKfWZKft6kLsK7ijc6WGg27K4aDm4iQiVXkv4QFzYB3LoSzIxXbRggbDP3
         0ciQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vtImWDa9kuuW8w+jMwpHP6G21qHUIm0vC1VrYW1qZiQ=;
        b=x+FoVKCeq9yCsb/mPs/wwYpwyfy5+Bs8Qcp09Egut01ONITLIFyXA9NYoY7PLd+gjy
         iQ5fbx/2U2hh1P0ObPmGw5zjDZ5FyQ+8gD5a1i0xAIRyGmcDpU5agReWhLF/bE8Jnl3j
         FlV+8HlQa3puanYyqrdeXmHp+EPw2vZmZCH22pabDb4DleDQh3OvasZHoHvX+SBpPCJ6
         NGP2k3aFVrdQTFiSbjwFH1g+Wg/BAl1/l1Ec7schbyAGaxfWq7d2qcMaYxg8RO9OYAfy
         bcRvjbnsWyiE56Txhke2AG+jP+D7g/iXWBanzKab+jvSL8t/IBPMOGiubG/n8gir+R/I
         EdvA==
X-Gm-Message-State: AOAM530j0YOxOY8sFxFlzbYjUlG5SRx/AvmyzkBhILr3BmloRE4kuN+i
        J7GMZkEYz370ANMHznOKPcY=
X-Google-Smtp-Source: ABdhPJyORJORiFXCxLPwpvHuBrxOMH7lc2Ujrsfv28e0L1lov0HREnsG+/Lngp3naTuTtTIeObLzQA==
X-Received: by 2002:a63:5004:0:b0:373:e921:c0ca with SMTP id e4-20020a635004000000b00373e921c0camr20836116pgb.154.1646127653136;
        Tue, 01 Mar 2022 01:40:53 -0800 (PST)
Received: from [192.168.43.80] (subs02-180-214-232-83.three.co.id. [180.214.232.83])
        by smtp.gmail.com with ESMTPSA id lr11-20020a17090b4b8b00b001bc4098fa78sm1746704pjb.24.2022.03.01.01.40.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 01:40:52 -0800 (PST)
Message-ID: <9792aadf-ce4e-3d39-8bf7-762a585814ba@gmail.com>
Date:   Tue, 1 Mar 2022 16:40:47 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 5.16 000/164] 5.16.12-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220228172359.567256961@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/03/22 00.22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.12 release.
> There are 164 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0)
and powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
