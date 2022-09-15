Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDBE5B929C
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 04:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiIOCYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 22:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiIOCYn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 22:24:43 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7399AB4AD;
        Wed, 14 Sep 2022 19:24:42 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id o13so13184642qvw.12;
        Wed, 14 Sep 2022 19:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=NZ9mExXnV9LnkE8n7KnEtq/Efc9W9Rk3emR8UWGx0B4=;
        b=copjgvcoiln67lPuAF+z0GBoMjfTQsv23p2sAvzZwC0EXxNUDlm1x1N8yVi+++yLxy
         HZYpNCGqx1CFoYVGcv+wPeY5STCO4ASzpqpeYPcEYmRcdpJ1YEVZyj1b8NLhFQEjK61g
         0cRDCkeUzasqxPOPqOpOwXcn0KSeqoeKNLwfFdWRKbYqR97vL+BoTG3LqRrtGDAG+LKY
         x9yCL8aMJMNCiEX/NWpv2pf7CDwJeI0lzVG9RclGGrH5olZZU/TyzfTsgBKw93HOOQQL
         1hYb2YW9cRM89ApdZI50slQPDueg5++49Wwp+DUGYfCemnBsEXyXfNGZj7Lq9zoYY2ay
         QYww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=NZ9mExXnV9LnkE8n7KnEtq/Efc9W9Rk3emR8UWGx0B4=;
        b=kb30IDcoZDzdxD1xYPjH1zpyA5Ld4S7RLtkuoyHr7E56mY7/8PrHvSXr+Yjnrf6O4a
         QEzfRz3//0l/JNz8FHS2RudZoRGHwMO6RBzvD6+zNxO0r+UrbkBOJpprxyOm+UTS8CF7
         uKqz2bmBb7LN/WhJ+sb+4OS8urp9r8tIT/t/0k4eE3t7GcNQLz/TP5G52RuwJaNz7Ae5
         9nAD9z3qxIb9wEj8PbKcHB5j8FqZ06+4yusR+Ob/Ghmol2tnZQSCcL3L4aoYuculKpD0
         2wnnRkbZvWShJyXw6aYaNuDL7XHqVG+OG7KcFnbiOMhji9K69228Y4TWUEy/IhIdzHCS
         agtA==
X-Gm-Message-State: ACgBeo0+fBvRsni1oAe8XAyBrNv0T4kwetBttQOWqUp1v0H0Pk+ZpEaK
        Ff/E2RZwabpKejAX0s4fWHo=
X-Google-Smtp-Source: AA6agR6jTSqWnxbVcseE4MW7JpE0bbl/z1Z/aDSQQn66c2v6/QZ3/wdDh0/QGJcu8vVtfuCf6uSxlA==
X-Received: by 2002:a05:6214:3008:b0:4ac:9f16:e454 with SMTP id ke8-20020a056214300800b004ac9f16e454mr19540146qvb.41.1663208681476;
        Wed, 14 Sep 2022 19:24:41 -0700 (PDT)
Received: from [192.168.1.102] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id de42-20020a05620a372a00b006b945519488sm3341537qkb.88.2022.09.14.19.24.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Sep 2022 19:24:40 -0700 (PDT)
Message-ID: <81314196-ccd5-069b-a6ea-db07b1d2a857@gmail.com>
Date:   Wed, 14 Sep 2022 19:24:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.19 000/192] 5.19.9-rc1 review
Content-Language: en-US
To:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220913140410.043243217@linuxfoundation.org>
 <20220915000912.GA603793@roeck-us.net>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220915000912.GA603793@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/14/2022 5:09 PM, Guenter Roeck wrote:
> On Tue, Sep 13, 2022 at 04:01:46PM +0200, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.19.9 release.
>> There are 192 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
>> Anything received after that time might be too late.
>>
> 
> Build results:
> 	total: 150 pass: 150 fail: 0
> Qemu test results:
> 	total: 490 pass: 490 fail: 0
> 
> New runtime warning
> 
> BUG: sleeping function called from invalid context at drivers/clk/imx/clk-pllv3.c:68
> 
> thanks to:
> 
>> Csókás Bence <csokas.bence@prolan.hu>
>>      net: fec: Use a spinlock to guard `fep->ptp_clk_on`
> 
> In the assumption that this patch will be dropped
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

It is being reverted upstream:

https://lore.kernel.org/netdev/20220912070143.98153-1-francesco.dolcini@toradex.com/

So probably best to just drop that patch.
-- 
Florian
