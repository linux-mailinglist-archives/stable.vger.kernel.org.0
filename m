Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 992014D44FC
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 11:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232670AbiCJKvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 05:51:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241398AbiCJKvw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 05:51:52 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C35E75C17;
        Thu, 10 Mar 2022 02:50:50 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id 132so4398214pga.5;
        Thu, 10 Mar 2022 02:50:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ABgsYrqLgZZQM9Pa+ScXgPWh/VX7r2Rdh+mooRPogfk=;
        b=QR7+okol3BZP0ZJIQM/p6sBE5FuJGYTmcog/DJGTl4jRJ2/9nJfrZq/ZUtUX6j3erj
         0sLvD3+uPZ5EXr628h1ZftSrrUlcRqW+jtlmK7aAPrvGaWzLYxdxIp5WAgPxgmp3d5Q/
         rfoxDvgRK2dpvpJjAQSHPVhTyySQm4H6beoyGI3jSr8AlnqDaTCqA7jzS5jDvWWXdWfx
         I+TxEdWPre++SIPfRrwgVhWVk0YmcHK8RqRHmHKWaW6iqFDtBKy0436lS2zaeeStF7UA
         0bwX01kWcTMwzVNo8tWt6c/hn21EhpLA2HmnXpc2CMUiVt99mTw89y9ga+UwN+ryensO
         CCQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ABgsYrqLgZZQM9Pa+ScXgPWh/VX7r2Rdh+mooRPogfk=;
        b=jKT3fNoHQy8MHjDlU2LcESJSv9UmpUUQdbYxBtfVLMdIUJb02IkpJetTXMlt4cZWzw
         qbprBSglUMen92W/6H+5d0wt40PlP5s64RDe6GizLmFJlHP7CrXU0mnn23RxwEp8OTp8
         t2JuPYYu4bhVmgbiKBYF1AxpqmG8VmnBG2H9vzg+p6QubpOaXRPZxB0Lp1f94YTH7F+i
         AdI1NG/Cco+oPSaxpGe/FIIaYStS9A0sIbBhAdkFqggOD92kP+burPM4xp3SjGSaoBxj
         1+nZfezIot1hl/RfdZmIBjTuxkzVzno2dZcrhJX0tQWWDc+xrVgsHAPDsQzPIN9rzJCt
         VLRg==
X-Gm-Message-State: AOAM531dwENsz+gr4LzDZPVibF0MDW7UiHyo6BMlgKcjKSCa/6YV8kde
        eFaKpBlxhITBf/8n1Pln3Dw=
X-Google-Smtp-Source: ABdhPJzAUXYW5zLSoQvG8VnPsKnjfceTjqcf+d5Eejww8SreHOasPOikTSpsZqGLu7WSX5g89f4hwg==
X-Received: by 2002:a63:6306:0:b0:380:f45b:5dfb with SMTP id x6-20020a636306000000b00380f45b5dfbmr695329pgb.109.1646909449885;
        Thu, 10 Mar 2022 02:50:49 -0800 (PST)
Received: from [192.168.43.80] (subs03-180-214-233-75.three.co.id. [180.214.233.75])
        by smtp.gmail.com with ESMTPSA id 9-20020a621909000000b004f6f40195f8sm6176932pfz.133.2022.03.10.02.50.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 02:50:49 -0800 (PST)
Message-ID: <d2ef59a4-06e2-ddf8-aac2-d43343bbf42b@gmail.com>
Date:   Thu, 10 Mar 2022 17:50:40 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH 5.16 00/37] 5.16.14-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220309155859.086952723@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220309155859.086952723@linuxfoundation.org>
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

On 09/03/22 23.00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.14 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0)
and powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
