Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7B325EB2C5
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 23:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbiIZVDV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 17:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbiIZVDU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 17:03:20 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 064C6A1A43;
        Mon, 26 Sep 2022 14:03:20 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id z9so5085495qvn.9;
        Mon, 26 Sep 2022 14:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=73iF4Yx/+iECRXTsxGYh+zaObPrHhUa64cwOQzTNXxw=;
        b=D9f48OBwoBZc4IGfMPAqfGrsVUqhAyBID9xpJXpX637WKBQ63jN6ey/K8cJqVykw1p
         sR0cN/yUhEdjkUnf9TSpnK0clnSPIOVGqve9fVJLI0EXqsmiz6LmzNbLm92xT7ilkXbi
         DNe3qTXkbpzztnLFkeDNtIU9Q8TvUZ/1lzeDlJcQP4ADXyP+9Gnr/S4sgMzosGVR2qQ9
         C7sHxlzh/KcfblZHX8HE5repida5E+c2Qldb8D1ywSqYk3I/1GVg6D3VV5Z4uCH2CjUa
         E4w/zuUa5dPg+4i0lav6Y2iv81KGejXuUeMdAHXcOE8HSvpE11yXRLdl1ydibJiQNn7z
         u+4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=73iF4Yx/+iECRXTsxGYh+zaObPrHhUa64cwOQzTNXxw=;
        b=LGh6tJ/gRT3p3g5k0ZjbjtIpndZ5OvqAlcpvUdzYteu56hDO4Itnlfu4+7ea7g5qCO
         2TxUgujOigrR2UrbIsHrbbenDHlN7G3bs/IApASHkRzBM2OkVliW1SauQrgbIZi3IYxS
         yZbtl2q5gL1GVC9f94+GfWkpbgnjXUpTIYw7DMyR61N/NdBSDnRsJaN9ooViVQmmr5Q6
         hbr3nd88tQfvn9VHn6VULCVV2HD76fGv58ftWNrDEHJnWUa4X8XnMXpD++UzXOaw/f6M
         70X6L8WrSaUg3U+BM4NOQNiK1a83Y1xKZEr5WB9zzlPNhhermLrP5dxKhTEonzzeuDYY
         S5pQ==
X-Gm-Message-State: ACrzQf1t6bw5yQr+zMcueGHCKZ5pzloaNMnHcxU9ruUK2iFEwZptzm0R
        OLn91TtM8SpGBozuEs7kTk4=
X-Google-Smtp-Source: AMsMyM6AQfv1Sh26G8su3MQs3vvQ+qeD6cGFFB+hSE7dYbXaErA81uqcwAJ04KNKykLeKTx8GICtXg==
X-Received: by 2002:a0c:e0d3:0:b0:4aa:9d28:6603 with SMTP id x19-20020a0ce0d3000000b004aa9d286603mr19124885qvk.91.1664226199087;
        Mon, 26 Sep 2022 14:03:19 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x2-20020ac86b42000000b0034305a91aaesm11126227qts.83.2022.09.26.14.03.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 14:03:18 -0700 (PDT)
Message-ID: <d3fcd3c7-2b6e-fc49-4428-8854ab831ad7@gmail.com>
Date:   Mon, 26 Sep 2022 14:03:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.10 000/138] 5.10.146-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220926163550.904900693@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220926163550.904900693@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/26/22 09:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.146 release.
> There are 138 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Sep 2022 16:35:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.146-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
