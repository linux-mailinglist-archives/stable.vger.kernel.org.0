Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B26A0628B66
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 22:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236810AbiKNVh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 16:37:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236250AbiKNVh1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 16:37:27 -0500
Received: from outbound-ip19b.ess.barracuda.com (outbound-ip19b.ess.barracuda.com [209.222.82.216])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D8219032
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:37:26 -0800 (PST)
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199]) by mx-outbound42-203.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 14 Nov 2022 21:37:25 +0000
Received: by mail-oi1-f199.google.com with SMTP id be25-20020a056808219900b0035ad466a313so2289987oib.17
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:37:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dWDd/MBzZEtsCg8lCXMYeDNkXSIMpUqiJyLusf/wE8M=;
        b=Ek62IgRUOn87cEM3WfVw1pK1ghk2aB7owmZWSRIM7Uau+O0vfJ2Nu60LMH4uYxOTLF
         qQnEdN276IgPrfGuThCIpYAstIbJSOeXdhYL2ECHyv9WHOZdAFgLrQdR5QKYeX0BgIgu
         4RrWUmLSd5FOeiMen5fS5N8ptn/eH9zKkYEnrbt84+ND6s/YRuNjAlC12yR4V/gbE0Ll
         vRXThrHWj85cfKQZvY73n726NhuNZThoPy7LsHsXiZze+QdBX3a36wGZZgO6KVYjXuoZ
         2KtS7tGO5F0C2jZsLZtzxr1Zj69LNZJuKFimHrCb1ixfktOm+969aFkdR9ETGHqfDVk8
         4REQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dWDd/MBzZEtsCg8lCXMYeDNkXSIMpUqiJyLusf/wE8M=;
        b=Va/A6D7osUMI4rdm9yaWlTCwbcMHScvtSg/timYrfbwYltJ+YvzU1AK6J7KFUJmPCX
         GX/BQAJ1MWjfgJ+elA6zLsPnLdFMRuhCh0ld3GSMk7VSlMM0elx1IL9hA8VJ1dda+mqm
         FewAtAq/ygXK7FXxLSjWIpFS9+UUGSY+GBTOXiZGC3f8cbV7N6bDRCuvgwOpcoE8/ncD
         9hp+GSDOuNmNBoWU+GYOE2TfVRQXjeySukx4YxrXH5YokIIc2ncNycw1nQRRiPiC2XOl
         tv+TSOlhoiGNM7zhYP+ofXrVb5VJBU1YmrkOAqTEYzqQUJXatU38Tf2yABEnXm4LrzwS
         GLOQ==
X-Gm-Message-State: ACrzQf3QoNBeIL4UZsnlesNDm7uNktIBg+I8Jqem/e0gzpRSTk7oWZte
        YtzjIPTGIEbR1IzNz05nAnz1udm+YCN3mcMMqdulLL4j9t9Rsg6GahvRz//FVuoJF9j1voLL5VL
        DvESWQrFBkRGcVqSimfKUBl8yaicdZ9AVSjoMulayJuJY9obUK0x/LG2XlFXHPODS
X-Received: by 2002:a17:90a:8008:b0:211:906a:f8ef with SMTP id b8-20020a17090a800800b00211906af8efmr15292371pjn.71.1668459973240;
        Mon, 14 Nov 2022 13:06:13 -0800 (PST)
X-Google-Smtp-Source: AA0mqf54TK9/wMXk1YqcBX6lX0AbuQzvLTAAcG++rlznAG6MtbzAwLLlIeMlYRitwx0z9El5SS8Av+acp9alxzg+Ams=
X-Received: by 2002:a17:90a:8008:b0:211:906a:f8ef with SMTP id
 b8-20020a17090a800800b00211906af8efmr15292355pjn.71.1668459972936; Mon, 14
 Nov 2022 13:06:12 -0800 (PST)
MIME-Version: 1.0
References: <20221114124448.729235104@linuxfoundation.org>
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
From:   Slade Watkins <srw@sladewatkins.net>
Date:   Mon, 14 Nov 2022 16:06:00 -0500
Message-ID: <CA+pv=HMzyBA8UeC_NEbe85-EWfsLHL4G+fUiursk0Z7P14ukRQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/131] 5.15.79-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-SWM-External: yes
X-SWM-IntToExt-Scanning: swmout (swm-pri11-itoemail0-scan.leviathan.sladewatkins.net)
X-SWM-Sent-by: swmPRISMgateway (swm-prismgateway-pri02-mail8-scan.leviathan.sladewatkins.net)
X-SWM-Antivirus-Version: 1.1.0
X-SWM-ite-Primary-Server: swm-pri12-item.leviathan.sladewatkins.net
X-BESS-ID: 1668461844-110955-5613-7430-1
X-BESS-VER: 2019.1_20221114.2026
X-BESS-Apparent-Source-IP: 209.85.167.199
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.244150 [from 
        cloudscan10-163.us-east-2a.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
        0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS162129 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND, BSF_SC0_MISMATCH_TO
X-BESS-BRTS-Status: 1
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 14, 2022 at 7:54 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.79 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.

5.15.79-rc1 compiled and booted on my x86_64 test system. No errors or
regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

All the best,
-srw
