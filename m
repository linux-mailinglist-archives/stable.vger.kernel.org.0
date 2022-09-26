Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955B35EA9C8
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 17:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233535AbiIZPK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 11:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235814AbiIZPKc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 11:10:32 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA39D4A820;
        Mon, 26 Sep 2022 06:44:52 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id s90-20020a17090a2f6300b00203a685a1aaso6865746pjd.1;
        Mon, 26 Sep 2022 06:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date;
        bh=P5kXzw1aEe0pj2GkQUUttZ8RstPKUh7D6zNihCn388Y=;
        b=b0to35FKLgWn6reHPe/nUr00eeC8BqEK8f+Fin13fqmsHFiGBUCVrptfqhh7zHRz67
         yas0APFCOXaOVSotGKvtdNtWbux824BM7e/Evrve992G2xBSrbFF8tcBcSIzkThVnDB/
         fCwiqtxSC+3/s12KeFE8EL3fVFirB7UsWlFkeF4Aa+thHlapKPtbvG7i8Pk2VLyJQqfH
         L2pe+fO4ugpyYNzbXao9TU1DGjLpwi/e6UJxZVMV6L0027bbQcJHkO2vsSzcDn6VD351
         z1eBBIWKCavoB10Ub5b7x21autJYKGtZ78l8N4O3Dakurb9lMJZBTJ1aTcR6NjRE28Dt
         63Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date;
        bh=P5kXzw1aEe0pj2GkQUUttZ8RstPKUh7D6zNihCn388Y=;
        b=dNGXPCEyB85u/rG0vqsuea2RoA4+JNalb/JqRE+zSCYMKo9f7pXtP6VLWP9UF2SmgJ
         zVvpxX0jBGr2WvyV0arIaAYByUmvFBRikuaKg7cUuPYfQKnHqu7bIkr25iMajSxkSs30
         cuXqs+Iv0dL7FEydSgFpt6AK551Wvl9Fgc4eUXBQa5JyYCDGWy6RTpDDlGppl+xQONb+
         vmVNqoM0WB9g4O+URp240s/v0kSyHt22WfA8GGXJnODzNz4J5lD6EhUVA3p+O1Tl6Bcy
         ft6l/UV/ww5E8uSiidD1KtSB0qUdVZFo7nmPDh7UZh46YDU+fuEt1e5ZxQbNMhv6PPP0
         A6Aw==
X-Gm-Message-State: ACrzQf3KHHx1ZGyvNkFbewicFVBKfox6ViUtMCE+rCva3XYtksyhoWGL
        H1XzkOS4U59006saGQzsAqngRA4XBRGViw==
X-Google-Smtp-Source: AMsMyM5BSxnCE/P9Ko8UEsT9OVzF6VMR+qCIujIqdsBdDgVL4sDNI1nIOT1O8hDUHQdhWXzh+0OA5A==
X-Received: by 2002:a17:903:11c7:b0:178:af17:e93e with SMTP id q7-20020a17090311c700b00178af17e93emr22099953plh.78.1664199892333;
        Mon, 26 Sep 2022 06:44:52 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s8-20020a170902ea0800b00179b6d0f90esm8713690plg.159.2022.09.26.06.44.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 06:44:51 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <23dbb0fb-5bed-a340-55c2-1c0d3d537ea2@roeck-us.net>
Date:   Mon, 26 Sep 2022 06:44:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.15 000/148] 5.15.71-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220926100756.074519146@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/26/22 03:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.71 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Sep 2022 10:07:26 +0000.
> Anything received after that time might be too late.
> 

Another build failure:

Building powerpc:defconfig ... failed
--------------
Error log:
powerpc64-linux-ld: arch/powerpc/kernel/rtas_entry.o: in function `enter_rtas':
(.text+0x92): undefined reference to `IRQS_ENABLED'
make[1]: *** [Makefile:1214: vmlinux] Error 1
make: *** [Makefile:219: __sub-make] Error 2
