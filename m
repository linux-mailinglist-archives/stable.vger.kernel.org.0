Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B758B6BD769
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 18:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjCPRqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 13:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbjCPRqg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 13:46:36 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77EBF23D90;
        Thu, 16 Mar 2023 10:46:27 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id r16so2638548qtx.9;
        Thu, 16 Mar 2023 10:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678988786;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sPZg95eOf/E2ZkQuZc78nWY6/OH+N1ZiVxrFPyxfRKg=;
        b=IjrjqgOcNzR4oEMpZvWT9tg6p7CuK5YgxKV63oYBlMJT6PgKlICg6dZr1/8plko8BJ
         AkB212Sh2FUOL3x1EUSQJx9b8dVuJ9hWepUzQkMoL0t+xKCtDPIiRf2ZjM9tsdHxE+aj
         Q2RAo17qVF0Z4QkaI2p+JaoRv8bH8SeifK+zo9qTmcPpTCM80O35JS1QReVFra2JaUeo
         lklRcmb4UG+7Yytj1php4B6JxCeYfAy1Kp5YMR+hdjFZNCRekjYSRVwzC56yxhUJAnV1
         xQIKr+N1kUc5ykkwK/Z7gpEc73Qq7nSEq4xGanyqbzEls8KieRP3I40QBXr5/BiRhd8l
         o4Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678988786;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sPZg95eOf/E2ZkQuZc78nWY6/OH+N1ZiVxrFPyxfRKg=;
        b=u4OfqVtR9hMu4lk85xSBG5RZKaCFgmNkl8xzbVt8JSp2nmdfdpQfigqKbUfyBCpMTj
         x1j78ux0CrNRwxifMrXWEcr+k667uo6+2YrVhjUaobQ8+yJCiCbbPGvPx6Hp6/U0xkiy
         pXjifhVY6z3W3RACVO9kntuSvTdhnAySEe0FgluP15LiYUsx/gTcjC+vuA/X09h0uCj4
         nw0PqgR3TCUvjvs6DVTUMYaIt2pjfDydHfNFOaHxUOzEkMeQpJWI8GuEBuFYsYhSXFm6
         Jzco+ACQ2zcWr1rJBYi6YvLdnnuJd2eHFFSQrBU8BK0rHKGzYavoduvqqpQRpEoiJtYY
         bwOg==
X-Gm-Message-State: AO0yUKVROqEUkk2r2jlguZ4v7Ouusnd19nLBpEdZaLCUd07phUwP6+vl
        MAgxzSXi9x3+A5FQZdJn0ng=
X-Google-Smtp-Source: AK7set8PattTu8uWLuGWv1oNMtRTPKVUeUGtjmzlapFfYlNtp99OQflEaqMMcqTxTx4DgvgZNxjEYQ==
X-Received: by 2002:a05:622a:1393:b0:3bf:dbb4:3bcc with SMTP id o19-20020a05622a139300b003bfdbb43bccmr8320234qtk.4.1678988786527;
        Thu, 16 Mar 2023 10:46:26 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k16-20020ac84790000000b003ba19e53e43sm46072qtq.25.2023.03.16.10.46.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 10:46:25 -0700 (PDT)
Message-ID: <eec5798a-79fa-0262-340d-8c48c8064c02@gmail.com>
Date:   Thu, 16 Mar 2023 10:46:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.4 00/55] 5.4.237-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230316083403.224993044@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230316083403.224993044@linuxfoundation.org>
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

On 3/16/23 01:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.237 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.237-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

