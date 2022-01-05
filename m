Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0034859FB
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 21:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244019AbiAEU0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 15:26:38 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:55336
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244010AbiAEUYh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 15:24:37 -0500
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id A74BA402A5
        for <stable@vger.kernel.org>; Wed,  5 Jan 2022 20:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1641414271;
        bh=Z7Q01MgSEbyZYHT3rk+3A+kephcacvWRoAm/f2TTeCA=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=SWm/cpgdCjILvKh8JAgGqT7sJEMBAR33hciT3Noy43VIQvaXqyaGC9b8yBGnR7HCm
         xZYg2Tvkntz00TJUwOeay3q1uS/oeQBPfGTzh5eetnnfpJ/wFqZrd4U/D4JPW2DaFO
         amvStszybeETbtgK9yrMale8cBIO8CFVrbNBmxVhPB17/awLZoeFOD5DoQCDZJvlGR
         PI53i18bdgm8JIK6DT1SMc4ZsT13bfi5e2gUE5dvYu2uYOviyV7loolSXacrIgOZxb
         ztjuj8FrUrrI97mP6SuLukpqyrZXTG/RZ7RLcrB94Uc7eo+4ohtPvYsVLSiNFGLu7j
         1QWamCkGRTeqg==
Received: by mail-wr1-f71.google.com with SMTP id s23-20020adf9797000000b001a485bd8e8dso123081wrb.11
        for <stable@vger.kernel.org>; Wed, 05 Jan 2022 12:24:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Z7Q01MgSEbyZYHT3rk+3A+kephcacvWRoAm/f2TTeCA=;
        b=Gmi0i13Lq1YrTZf625WKnePrBLO8CDEpM7Md9Qc29rkjjLfpA/3kt6D9fJPM3PB+zt
         Maent1QVZ4rnrxX18TLD06kqtbLkHwxphxj5SGdM1SKfKwESAjYG/q4mblwrbqlBEtEX
         qZHBhT0yenHjlHDM5kh4U+7XhXWmzsTB7Ewo6Mzt9M3yJa2uIB9H2d3N4yJi6udnrgiF
         sG4jJhGtxpzMtVKvnoyr8+tpAlUwTJqDxL6E0a4V0vTNKtmjSNDkqu09pFavY6v6RF6Q
         IoA0y77MB949HGOnhHDHSfRqVJZxSXtMAKpPHA/F79d/szhQp/OZLoPOXf8PsiauNwAD
         IXFg==
X-Gm-Message-State: AOAM5320yTML/be5VCDZ7L/EYPKdGVdCgJlRQgOvWURslnExu4haGHLc
        W3vM0pIQZJNBNDVnQKKxcs9SmNj4J4Sg8THi8Vc5aWMquP3DHcm8yHq+R4aIIfGXaakTn242dSV
        9VzEhF79BPYldlrs/pb/g5HMsSqquAWpfBg==
X-Received: by 2002:a1c:9856:: with SMTP id a83mr4298314wme.157.1641414271346;
        Wed, 05 Jan 2022 12:24:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyDOoioCbtDcfutGP5nnn1CRcSrlm9FAZ0/AwZzVCuwcbxtjswiY565cQifCl/khgMGZCxOOw==
X-Received: by 2002:a1c:9856:: with SMTP id a83mr4298293wme.157.1641414271152;
        Wed, 05 Jan 2022 12:24:31 -0800 (PST)
Received: from [192.168.1.124] (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id l26sm41211495wrz.44.2022.01.05.12.24.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 12:24:30 -0800 (PST)
Message-ID: <e54c289c-6aeb-fcf4-67fe-fc8e375149f9@canonical.com>
Date:   Wed, 5 Jan 2022 21:24:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH 01/24] pinctrl: samsung: drop pin banks references on
 error paths
Content-Language: en-US
To:     Sam Protsenko <semen.protsenko@linaro.org>
Cc:     Tomasz Figa <tomasz.figa@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Chanho Park <chanho61.park@samsung.com>, stable@vger.kernel.org
References: <20211231161930.256733-1-krzysztof.kozlowski@canonical.com>
 <20211231161930.256733-2-krzysztof.kozlowski@canonical.com>
 <CAPLW+4mosbk2_NPFFP=sUmKjBoZOG3vNcmT+7sMtTunhbVqcxA@mail.gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <CAPLW+4mosbk2_NPFFP=sUmKjBoZOG3vNcmT+7sMtTunhbVqcxA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03/01/2022 15:49, Sam Protsenko wrote:
> On Fri, 31 Dec 2021 at 18:20, Krzysztof Kozlowski
> <krzysztof.kozlowski@canonical.com> wrote:
>>
>> The driver iterates over its devicetree children with
>> for_each_child_of_node() and stores for later found node pointer.  This
>> has to be put in error paths to avoid leak during re-probing.
>>
>> Fixes: ab663789d697 ("pinctrl: samsung: Match pin banks with their device nodes")
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>> ---
>>  drivers/pinctrl/samsung/pinctrl-samsung.c | 29 +++++++++++++++++------
>>  1 file changed, 22 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.c b/drivers/pinctrl/samsung/pinctrl-samsung.c
>> index 8941f658e7f1..f2864a7869b3 100644
>> --- a/drivers/pinctrl/samsung/pinctrl-samsung.c
>> +++ b/drivers/pinctrl/samsung/pinctrl-samsung.c
>> @@ -1002,6 +1002,15 @@ samsung_pinctrl_get_soc_data_for_of_alias(struct platform_device *pdev)
>>         return &(of_data->ctrl[id]);
>>  }
>>
>> +static void samsung_banks_of_node_put(struct samsung_pinctrl_drv_data *d)
>> +{
>> +       struct samsung_pin_bank *bank;
>> +       unsigned int i;
>> +
>> +       for (i = 0; i < d->nr_banks; ++i, ++bank)
>> +               of_node_put(bank->of_node);
> 
> But "bank" variable wasn't actually assigned before, only declared?

Good point, bank has to be assigned just like in patch 2/24.

> 
>> +}
>> +

Best regards,
Krzysztof
