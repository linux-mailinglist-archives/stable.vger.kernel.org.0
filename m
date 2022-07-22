Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF89957D78F
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 02:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbiGVADJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 20:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbiGVADI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 20:03:08 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37FA118374;
        Thu, 21 Jul 2022 17:03:06 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id y141so3118774pfb.7;
        Thu, 21 Jul 2022 17:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=p8z6RDRXBRo9M6V6DMA4kElO+jhaV+6kExG3kqeP3Bs=;
        b=m4Iq7KOkI3mytZVy2km6PnWop6b7rkVW3J5c/GIal9LU2KHd0ZixAjbM1h97Huaq8W
         ZcWXOsankpukwkTFs49R/40BDbhIzvuYb028G5H67whvy7byBgUe72d2kIf+Dk3/5oyH
         C3vNm+Oawv39X6bzkDJ3/nfuiLr2en/HN+itgRP3S5tfVpCHDBOJBYSIGODXtmgAjW57
         Sd4xnLS2/UaFMTWeJYDHnWxyhblos/Nq0+nR0GDRV88DNoeQgUf8F6WUmBWx9nmBfGIb
         qM3AEQDpdLexpwE1kmIxNP0q99mjNTBrGaNykq/tQiNBMQxh/GR3RFUhiDvCCt9Ai582
         t6xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=p8z6RDRXBRo9M6V6DMA4kElO+jhaV+6kExG3kqeP3Bs=;
        b=ba9a1sr6jcYhWeO/8i0EMqAQp8SyS1su/MVPLv2uOJsd4ZubatdVi0D1Mhc3GRhqv9
         iETIf7MuqF5hlf1GiuLY9gzQ9TlGjEtiMDGT/PmoGOVSR9tgUdnYnN8mAkA/GZhInoo2
         3klOC6QSukgVHCmAvNXMaPEuJAfJE8oRox6iUbRLAOAcQTs9iDTF8p+wbPkHzl27MNUx
         7xdISEi1r6fJiL6aVC7Wy7cviViDlSXhE0x6pJ6IcFOrChGhhDEmDzehfSV02kaCQ4rd
         4pnlxCP3lOTlzINmpTxYz39pEyQKC3PSgBtNXSqg3VzIrFwqopLnfL6bDjqfNQLNnGVw
         sVog==
X-Gm-Message-State: AJIora+JvB67TmoxLAAFs6kBmdZvIYJqRyjSb8V5WOr8cXHvdMwZ8ZN1
        PosUDvKsSv2e6v+lwwS/1ko=
X-Google-Smtp-Source: AGRyM1tMQWP/lwE0rgBZ0kXzHY7MT+OXkAEYa+E+jQit/hT4eTpymIYi0OAgrdCgb6Jp2J8GgNIOOQ==
X-Received: by 2002:a05:6a00:134e:b0:52a:d5b4:19bb with SMTP id k14-20020a056a00134e00b0052ad5b419bbmr687433pfu.45.1658448185456;
        Thu, 21 Jul 2022 17:03:05 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id ik1-20020a170902ab0100b0016c48c52ce4sm2286149plb.204.2022.07.21.17.03.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jul 2022 17:03:04 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <5bd3b06c-c86a-6fc6-5a72-717c0d16b6ab@roeck-us.net>
Date:   Thu, 21 Jul 2022 17:03:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.18 000/227] 5.18.13-rc3 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220721182818.743726259@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220721182818.743726259@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/21/22 11:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.13 release.
> There are 227 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 23 Jul 2022 18:26:47 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
