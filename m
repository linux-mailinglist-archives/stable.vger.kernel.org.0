Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C9D6CCBDB
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 23:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjC1VGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 17:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjC1VGY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 17:06:24 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2859995
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:06:20 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id y85so5943380iof.13
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1680037579; x=1682629579;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fh1p9EqtypVK/FU1PKqg+wt7kdvoTdm3/SCa+JJX8Ck=;
        b=b3ICo8AGkcBYTVMqEwoP27yNuHsqoxH3gzS1yJX1qPxvm6x88wiBkduSJcW77czSU4
         Ks8izqJOE7OcybjyJKDMX3QEEU05MWDKwOBaw0xSB7jwHYAq86f3ryIKfo/g2uvWCMzf
         4pQzsT1Qbn4JxggEkaiKkVVL3ywvSpnOafPzo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680037579; x=1682629579;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fh1p9EqtypVK/FU1PKqg+wt7kdvoTdm3/SCa+JJX8Ck=;
        b=PURtzoKHEsoPJRDfIQcVWbLCirVgTFmurfyx5deGhT4JMKeUpcX5Tl9iGM8vikMquL
         qwTstk5TRs7/oX6cqwHTbV1q8iSzuJrSCUazuypzimm6EBJ1SMKaAlaC9i4FITWA+ZYL
         jUx2DR3b9PZk5ei4BDdV2Cv22hDCHwNoDMKLPWR3UXMNG1+0mmlI9EJu0OwGX8LreUru
         bKUAaOv7w909nAqCRh1pFBop8exUNM7IxkC0vOLCT5+ArbqlpA1IE2ruc4QTON8WQoXY
         Tlngr3TwlcAkH3l8bAwahjwoB+h+R2GLvJHjmdEdYHfElIV733RTE/IUkxKKH+SsPn8W
         FGcw==
X-Gm-Message-State: AO0yUKWUc772cSGHHD90mo+n7Mc35vZJ+XX/PY0BFpxxPKbC5ldjTlqQ
        4Vg1JGtHc/m4I6+aXhAisxV/rA==
X-Google-Smtp-Source: AK7set98fryjX5VQtWqqGxbEj5ekYdOc/twUQ9Ozgv42EacGk99K4Q9qOmIYBq2cfoF0ItshG8Qgrg==
X-Received: by 2002:a5d:9d96:0:b0:757:f2a2:affa with SMTP id ay22-20020a5d9d96000000b00757f2a2affamr11128697iob.1.1680037579430;
        Tue, 28 Mar 2023 14:06:19 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id w7-20020a056638138700b004065d5d1447sm8416688jad.171.2023.03.28.14.06.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Mar 2023 14:06:19 -0700 (PDT)
Message-ID: <e45b5a19-a613-beae-4465-b4ad6e55e7a5@linuxfoundation.org>
Date:   Tue, 28 Mar 2023 15:06:18 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 6.1 000/224] 6.1.22-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/28/23 08:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.22 release.
> There are 224 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Mar 2023 14:25:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.22-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
