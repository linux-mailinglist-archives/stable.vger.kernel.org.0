Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF2F50803F
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 06:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349411AbiDTErZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 00:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349430AbiDTErY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 00:47:24 -0400
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081AE1BE8E;
        Tue, 19 Apr 2022 21:44:40 -0700 (PDT)
Received: by mail-ed1-f53.google.com with SMTP id z99so740827ede.5;
        Tue, 19 Apr 2022 21:44:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=p4hqPR2FQCDiioryNJZrJzUVBeqS3PlrFw0l8N9UTZA=;
        b=1KmXU/4cWtqxI3DslzR7vvXW/tCJLdW3QR4GHGtmuJjKWnr+L9BWSIw30gzVSK/1su
         r1uVi6+99Gv68VpALBaMf3BGv44dQNXit4GlVHxU3Z9zcvu4J4OfngLO2qY+KEX5YwjS
         XZ/vpx7BtrI8hj66vteIzU88utsS3DcDdoS7LAeSegKhHpx+RArBLwaP1KA8QPeHgswz
         kfpuPweFS/55LaNfYeYYNtly7vOmGZAW0RBmqAE/N0rLOTo91/CXpD+bzC2QehmrOnuf
         p9hytMtuN1XEa+9VusnXxuV4ELHnqJydjwrD2Cw/DP4C35xkHagLHgUc+wcm2PnYkAKg
         76YA==
X-Gm-Message-State: AOAM5326SShKx3mVUZqdNkPrC+IO/00KtqpFgw8dYoHn3JVcNxqjLCXD
        weka1evrqY9qeMxrz2ctIq8=
X-Google-Smtp-Source: ABdhPJw1ELVDLd/t3J7IhXSWaNyv52UcQV3URJJXqeQmVlRkcvpmh+HB+0rcJeOWzt9dgu1GaavQhw==
X-Received: by 2002:aa7:d394:0:b0:41d:799e:e5ed with SMTP id x20-20020aa7d394000000b0041d799ee5edmr21338873edq.347.1650429878478;
        Tue, 19 Apr 2022 21:44:38 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::49? ([2a0b:e7c0:0:107::49])
        by smtp.gmail.com with ESMTPSA id cb25-20020a170906a45900b006e87e5f9c4asm6386201ejb.140.2022.04.19.21.44.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Apr 2022 21:44:38 -0700 (PDT)
Message-ID: <2ed80464-d3cc-c233-eb80-94086345b997@kernel.org>
Date:   Wed, 20 Apr 2022 06:44:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.17 000/219] 5.17.4-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220418121203.462784814@linuxfoundation.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18. 04. 22, 14:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.4 release.
> There are 219 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.

openSUSE configs¹⁾ all green.

Tested-by: Jiri Slaby <jirislaby@kernel.org>

¹⁾ armv6hl armv7hl arm64 i386 ppc64 ppc64le riscv64 s390x x86_64

-- 
js
suse labs
