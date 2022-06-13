Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8CEB549DAC
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 21:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235230AbiFMT3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 15:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351281AbiFMT3H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 15:29:07 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921F45D5E6;
        Mon, 13 Jun 2022 10:52:49 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id c83so4610076qke.3;
        Mon, 13 Jun 2022 10:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Xla91C2UcQ97H+k46Q2ZwzUHnW80EyE/ynT41i2I05w=;
        b=px+3WPCQZb6nMzINI2nyLOq02p5ky06WhhMrt/FxrDEnCNWJSjl2udhTzvQHkLu8ff
         MGz1lLT4g6ILJEKT29XpU4Pitbb1MkwxeHIYiSFqVSo6ci0FFvSzHaQbjKKbAlr/pnwA
         TZ49MHmyCk66O0BxWNR1Su5nSbICxoiQ+OGELKncZJOU1jaQr1zkob2zL/2FYnMiaQ/J
         auqi5jn058zgKuZ3Qy7LbTrG11cwhCKyo6sEhiZwIQs2v3Ko6QAu3kXkFLIaY2kmASzN
         SciTe3UWWwtr62119MiwKjRAMyi5XDj0gXFjcYtzBqlSF4sNePMIN8l1PDDetK4aD64E
         QQZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Xla91C2UcQ97H+k46Q2ZwzUHnW80EyE/ynT41i2I05w=;
        b=FJIdY7TkDalKKSRZbJRLh3naUCTEpGN94+fGl0WCgmwx1TmZ5SpwRJPZQC0uVQAwIq
         Ppe+nK1o/kp6evo6B1C7y6ZNKMZZcB5pW9vmRAk22HAh2JASJ71PFeIROlSkbOy/7S/j
         wkVCrVlJM6sHn+PH9/OKH8a5I5FQ7H2P7TaF3s7mhv/SL8L2jTFmwifo+LwLitAEab/t
         xfra7himIc91wpxzXXpPWOaPggc35cbD1InMLeXEiTU6EcbLaxuANI9bcCfy+amxgXOj
         IQ8kg8dJd7izYNssMqGZ4Lm2gd9mu0O2jN1LRoqKz23CbRapX5tkrbVD0X3jB/2S5Vwf
         Sf9A==
X-Gm-Message-State: AOAM531WpQgNHFKCzkLIDvWQ9RfwT5z46ObvXQl3WrRiLgEpFqmmljf9
        s1NTN0ACx0a3FJUp2VEoNic=
X-Google-Smtp-Source: ABdhPJxEbdd+iGY7vGbsWWhKPmtHdc0fRd+fVtzKu4+yL93Z4wC9PZkSqqBu+sB2kuq1L06CBvI5PA==
X-Received: by 2002:a05:620a:370e:b0:6a7:2471:b3eb with SMTP id de14-20020a05620a370e00b006a72471b3ebmr888325qkb.631.1655142768605;
        Mon, 13 Jun 2022 10:52:48 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k15-20020a05620a138f00b006a73654c19bsm6912665qki.23.2022.06.13.10.52.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jun 2022 10:52:48 -0700 (PDT)
Message-ID: <5824bdf6-accc-8938-16b0-743d6fe27282@gmail.com>
Date:   Mon, 13 Jun 2022 10:52:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 4.9 000/167] 4.9.318-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220613094840.720778945@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220613094840.720778945@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/13/22 03:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.318 release.
> There are 167 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 09:47:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.318-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
