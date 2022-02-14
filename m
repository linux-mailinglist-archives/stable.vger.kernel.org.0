Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6D754B5BF5
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 22:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbiBNVBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 16:01:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiBNVBl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 16:01:41 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 775148020D;
        Mon, 14 Feb 2022 13:01:20 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id e17so11824355pfv.5;
        Mon, 14 Feb 2022 13:01:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xpGjdBuWBo0/fCuqaW8D1rC/RmyP4zpkCXt7KDYZNcI=;
        b=S6T6B9c9HHpJeqSEGjxZrl5m6odevc5RDaveFKwfcS8QSNpDHuWH3tiQL81twy8PNp
         Vzx8WcPNo3ASreDrKFpNjbcOsxoR6+wPusG+cPMiTVpwKXD1QNn68t405yIZeNn+uill
         ynTOk5zTMFUp5mVXzrbfAJaf0dfKgvlJaweMQdPqYL5661VTOApUMYPP6sPrhjcddVfl
         DBTHf74Y2caZoAZtQ0xzEtskz8b1Kuv8q8eaJzR4CQdRtfwyM/GUwQoW3K8CNDNyQQdO
         rohBsXelKIDKuWTJdH1jqZDWjQZXEqk6wdfpgOsaCEdM/WJ8QCTkk8/kIYUh/KDUu3Mp
         vHPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xpGjdBuWBo0/fCuqaW8D1rC/RmyP4zpkCXt7KDYZNcI=;
        b=x6otNLslWrmCUCzrbNshl9LCdY4AUcRUNw3zKPLioEgEQt4vXmpZG10SQ7AxzheTRO
         CbXSHTRW3fU8iSUZ9+j1rVjesORYP1QS9Ep5Rwfey7D5L9auFJ5aAU8xiOPgwyEbSgmP
         L6xXGCxsO2QM3QV8yJ+v4216Xq7xK2LqK/ed1weeGnroontaZ1BxwgRhSk4Z8l9UUpPB
         n1Y9v24tfzXj45yfrKgq+EvT3Q+H7VpkHuyGHZ1Iq0n3QK2tCOw3r8+6VLOpqThGkw30
         Ldw6BY/9xbQtcbfoUlTeovLlJkD7M5d2P8Fpx1zgm3pKzII+bN97qkg4Q7zcA11wTPWi
         N36A==
X-Gm-Message-State: AOAM531mwKSg+CSyfbkuoN/Z+5t1e9gPeh1suLMuE/XyM9+3w2i4p+8F
        CiiWZx/aSAsOZN0NFDX2LyDVQwvfQxQ=
X-Google-Smtp-Source: ABdhPJxFknBPsF7sk0Olrl28gZDsrNjHc8MMToR9WCcpozGObjFSybxsKZoAFw5wYCShLb3cGEmc2A==
X-Received: by 2002:a17:902:9895:: with SMTP id s21mr464803plp.53.1644868220878;
        Mon, 14 Feb 2022 11:50:20 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id m13sm35090007pfh.197.2022.02.14.11.50.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 11:50:20 -0800 (PST)
Subject: Re: [PATCH 4.9 00/34] 4.9.302-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220214092445.946718557@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c58dc18f-aed2-1d60-406c-863da94d609a@gmail.com>
Date:   Mon, 14 Feb 2022 11:50:14 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220214092445.946718557@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
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

On 2/14/22 1:25 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.302 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.302-rc1.gz
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
