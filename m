Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6704F5EBA
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 15:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbiDFNDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 09:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbiDFNCV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 09:02:21 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3700D5BE775;
        Wed,  6 Apr 2022 02:27:09 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id q142so1708219pgq.9;
        Wed, 06 Apr 2022 02:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=ld9hXJBuPgc9K87ld4siRPnyEnw7v/554KsebgNr2z4=;
        b=MGbUsahalDB/WfCcd63SJ0yfgouaivWJfOPEuI7d3H5i06UZG81C5+KvpBV5uK17Mo
         oRUdRI1Ax0+8+oFZUwvc3wqibe9G6keLbb8FZ0WVtN/lFxoA1HQ66bZcePhVBeXMdJzy
         7wSEkoH0/IHM/ON6fuFD4qh5/tfeGBlUWkR72VplqKTlCyIqRhpHuCVueX2ScUud2eiG
         9vy2o5X2c5rwGYDJVTXJjiP/kxBiev1zyuMbWdycPT5ZXFDtdThi8wE8AgY34MR6Cgj2
         4ICJcaih9KnSo6ZJhBRa8l5HsctZH4d1YuEPKihFQot+hNJ5phS226CKsl19yDAmScjC
         XrDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=ld9hXJBuPgc9K87ld4siRPnyEnw7v/554KsebgNr2z4=;
        b=X8tlBf+617XVGuVcPBXSuL5fGhGCphVSF3UmwOel/YWpf5gGU5/6sDe6BpukoGz+9Z
         8l6sBOo/jtYX1OYHdVJGmFsiRvOOch+lOdGyqcMbWpcV4YdLmTBB43iRKiiI4tG0KA4G
         zhTy50/qOT5yN2rkA6P+5oQVYJA4BjQeCuyHDaeGPO3nnpaS742Z9guTnNMXuqhecI+7
         PjTJqXBpCsYxUUH4Cd/OGbfcY2AX7vqWkv3lyoFoMpay5fH/WARSGC9O80tuWplBBn/G
         eNAQ/diIB0uR6X7tPJHPCPZaYX0iT/eX1Khj6bag+VYGN1+oH7UTvcslyZNb9GlcXfyG
         UoWQ==
X-Gm-Message-State: AOAM530rkmN/pRhFtv7vv4GjoT152oqZ/J7CrN8nd6o3HRKSDtpqEyFD
        PX4cNRTaHpASmedCaIgJblYqyKpCPtNP46LJ9uE=
X-Google-Smtp-Source: ABdhPJwc0l/XWr2ummHiBwi8nf1XrS7yVBBJXqwVH1Gny9aonoXybVWDyKOWDfh+yadhX7T+l0Ev0A==
X-Received: by 2002:a63:51:0:b0:398:a2b7:be6 with SMTP id 78-20020a630051000000b00398a2b70be6mr4250857pga.214.1649237226613;
        Wed, 06 Apr 2022 02:27:06 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id n18-20020a056a0007d200b004fdac35672fsm17470406pfu.68.2022.04.06.02.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 02:27:06 -0700 (PDT)
Message-ID: <624d5cea.1c69fb81.d0e6b.e9c9@mx.google.com>
Date:   Wed, 06 Apr 2022 02:27:06 -0700 (PDT)
X-Google-Original-Date: Wed, 06 Apr 2022 09:26:59 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/599] 5.10.110-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue,  5 Apr 2022 09:24:54 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.110 release.
> There are 599 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.110-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.110-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

