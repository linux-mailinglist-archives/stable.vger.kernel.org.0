Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4979F4BF2AD
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 08:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbiBVHbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 02:31:42 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:60070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbiBVHbk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 02:31:40 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E034939C1;
        Mon, 21 Feb 2022 23:31:15 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 132so16341050pga.5;
        Mon, 21 Feb 2022 23:31:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=88T01Xv11IQ7vnlMjdCLjMUwiY0xai49HxAj9U+k4mA=;
        b=dvWsN85ePVKH9mqPejUMfjPsgCQRH5oyF4hQRpb1yCcdVYxu571HqfkIQ39CJTMTXb
         th8pKfFZzY4j/qBjDPRg3QK2neRzbk5O9Ghf/yAlBDlLHmjA+p7rqrhaS9O9UMtnJVa8
         UsaxRJGsmNPuFbj7BXxN3oVwSirX07MBVPrI8pfOwTz0XmNod1k8b8uGjzwtC+abReYr
         MSvupE8JKJld/vwMdzgDxgrj6k6ZHYqRL4sT5SPqygTJ8gYwHnBexs2xg2qP3zxDg7YS
         rEjyFzNX5piMoIiBdhcZaQVPtKquX6qRhlUaeSU9cX5SuiRC6IebZBPmHEi2f77DOwsi
         mOoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=88T01Xv11IQ7vnlMjdCLjMUwiY0xai49HxAj9U+k4mA=;
        b=h/yGiOlziBj4W8WgXtYe0zunpspIa6UKLXWgn53dxJ9bocYhx2mHXuO12fmmz46xwK
         9cQ/rX5WNsEKCAvZ7XlzBGjLsMQ3gMTlAk+7krN+816OeZnYaWNwjIklNM2MfOu5iGip
         3vV1+DRiDxlBN6uh3Zty14SMJei9HeXuYLg+G2IaeSeD2tWLrR1DIQLS1wh/LQO3AVY4
         jc6dIFc6Td0dI1swqq8AjMmolzyL0Vivy0py0HI66oBOeVWTwF/NyJQjpNYCkmU8XD6i
         t0JnPRz9l7QxEHI6lFnhH5tF9NSAeJog8p8EEy31rcVs9hCJD5LJrkKcMRDLNInOBTL9
         IzlA==
X-Gm-Message-State: AOAM532ulde89uc6bpFjvqgmb1zmzd1k/jEEt4t3gCmRB1cA4CtfKoal
        /HsjOtxAwG3sCj3Xl0lAPUY=
X-Google-Smtp-Source: ABdhPJwLlu5MyrG0vgrOWrQu8O3OeAyFPlCYVszWZqZOLHTFr4YDRZ/cbYKyZpEaDQpcMCxLYKmQng==
X-Received: by 2002:a63:e5f:0:b0:374:62d8:c551 with SMTP id 31-20020a630e5f000000b0037462d8c551mr3711899pgo.129.1645515074852;
        Mon, 21 Feb 2022 23:31:14 -0800 (PST)
Received: from [192.168.43.80] (subs03-180-214-233-30.three.co.id. [180.214.233.30])
        by smtp.gmail.com with ESMTPSA id oj5sm1429700pjb.29.2022.02.21.23.31.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 23:31:14 -0800 (PST)
Message-ID: <48821503-5b9b-6459-bcdd-c0950d23ad94@gmail.com>
Date:   Tue, 22 Feb 2022 14:31:09 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
From:   Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: [PATCH 5.16 000/227] 5.16.11-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220221084934.836145070@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21/02/22 15.46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.11 release.
> There are 227 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0) and
powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
