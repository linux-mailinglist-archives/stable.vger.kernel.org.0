Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85177583545
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 00:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233628AbiG0WSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 18:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233423AbiG0WSI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 18:18:08 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A1DAB46;
        Wed, 27 Jul 2022 15:18:07 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id w185so344397pfb.4;
        Wed, 27 Jul 2022 15:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=PhrzBC+u8XXMU708mTbVCiWs4Y408E8Gnlbker0YCmc=;
        b=hga+n2rcFwbRsybKKxT5Ocdn5MThteXg6iivx+yhJoT9XHHMAlxEhXdUCxkwb9R019
         /l4SzuPV9Kc0b2KxxOkffKXSY7pXp1dzfbf8MJ6J+Npgxm3kJqG2s6dEl2EkEHf7oTVg
         zVlpnWqBbnh356tHAUgjPmSgoHr55EKiFLTzFQeZx4qgtMY2HnQFnf8ZV1kqZIaboFnY
         PjlqldtL+FcRRE4WqcSYdEtmljnhsX3HoN14q8S7/3BQnHghsUqi9/M/jJABUIP5vcuu
         GiwZF71r4zzCN4FeFa9v3pfawI2UFrbd4sRhyADWvan5zsYJQsOAw/gg+NBAZWW9Mko1
         U14g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PhrzBC+u8XXMU708mTbVCiWs4Y408E8Gnlbker0YCmc=;
        b=jCNQStoRWczncZpseceKjUvqzSIpIV3cwt3lZNS1cj+BAM2h7eK5bwZO+XS0DT+mdb
         dwTVbA8fsQ+Xpeag/Gxe7EzHHZUsC4LehAHEiGbA7EEek7tiNF+8i/xaCweqk3mQaLrE
         THWZNYOAy3IbkNsXKfLEFssvrdiAL+gR4tksVplzDZ0to+F8V4hUcxy5wAphVcwyDtOf
         PoaI8ETFg5nSJ5fAquc3kGeygoQQUVUqUGdYc2oJdjUmhYJEQ6ZACkYlSl5QlwkOLnUR
         zBa8AU6+WVz9nQJwUgLvKqzodLANftPysUIP92OY0tUS3jMIb4R/feDJXbCK5TGckayE
         FPGQ==
X-Gm-Message-State: AJIora9li1944kiErAmSLmGF/m5/FW1XrPb0lfOtUU0Ahf2r2TF1owyr
        6S0a9FNRSFocVgV/0fzpj5PLId69loQ=
X-Google-Smtp-Source: AGRyM1tc3Juh7OUE+WZ9kPlpP6xSRR+DG9TKJ/I2+rAdT0+xTS3+Duc4Qm2Rcs74zqsvB9OJdoKP/w==
X-Received: by 2002:aa7:84c1:0:b0:52a:e11a:f5e9 with SMTP id x1-20020aa784c1000000b0052ae11af5e9mr23856756pfn.55.1658960286589;
        Wed, 27 Jul 2022 15:18:06 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id p19-20020a634f53000000b0040cfb5151fcsm12582193pgl.74.2022.07.27.15.18.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jul 2022 15:18:06 -0700 (PDT)
Message-ID: <c7f1ad2d-b412-e792-57bc-dfd6373cd6c6@gmail.com>
Date:   Wed, 27 Jul 2022 15:18:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 4.9 00/26] 4.9.325-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220727160959.122591422@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220727160959.122591422@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
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

On 7/27/22 09:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.325 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.325-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels and build tested on BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
