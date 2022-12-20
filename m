Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D65652355
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 16:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234205AbiLTPBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 10:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234247AbiLTPBJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 10:01:09 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF671ADA1;
        Tue, 20 Dec 2022 07:00:51 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id k189so10775478oif.7;
        Tue, 20 Dec 2022 07:00:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ag0pUV7b8eAkjTjOY+RjV6R4uNkcaDWd0iSI1OL238M=;
        b=cnmIQHeXOMtKyGY0j4hjCr5t8hSRsokfA8sMcZvoSpR6Nzw+D5XS+QHSvxPLVzXITU
         415iHHZX3BaB7YbLaNI4Y11NICqiX9co8rkHK1olYrjMPhLMd0iENGBWt23GJ+gz2KHf
         MxyTBhjl8q4EhQH41pbcDuKCRSQIdjDUAGQTm/Fb/ZXHMPTe4Waf6MhT35g7xIwRFnDA
         cqu4fRotDiUHoUNcOoFkKhZ88m5TjKcL0hGni3VyxdMD0hVktTr4AP+Hzma98ZxMA6Z5
         oeGxGo0v3If8IeN3123tHt3KbIyN138nYJ7I40tnq859joIF5zAmiAHf7LSs+j207Phz
         Z1zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ag0pUV7b8eAkjTjOY+RjV6R4uNkcaDWd0iSI1OL238M=;
        b=yBjwqaQB8wV+kvEuq09iRzLyGBOJ1gjZjeHmB0VNNha29u0BKTcN8D+2uoIa+xIwkP
         XLv0Sz7Ts88kiWlJv4A048AeZcAhoMub5tSGREHo7PT8MAe5BB0S1UVRecoMMTFIffHf
         bO2TufbGaRV0+Mn5eQQu2vvW0K54yFEajf2S4jbI8q0azrCUJCqcPMDEVsffFmoxMvcP
         6njEsiNF7rWmYkGdae5iPJ0JjwqC9RHfTTFLSSCid0mjrOoPfEhKoOw0ag9FsxLK50ma
         gzL+kwUb1ivsBSAK96Qiz9H6aj8fGRkbQX9kh4ppuOo8EozSheWMR6dGg2EdvYo0iNYI
         lprA==
X-Gm-Message-State: ANoB5pmbLRcMk2+BBRpuuK31JaSSV/bmTj+/nruBwu3ZbfOUtBcoFGLK
        JyHarRmqFwqtnFojt6RskfiaM55s5Ig=
X-Google-Smtp-Source: AA0mqf5xQF18meKRoEIf95umK8/98MauHZqK7XUa3ei/FAYezXlQxx52rdq7ZceAD/ZBRfhmXKAuYA==
X-Received: by 2002:a05:6808:1804:b0:35e:22a4:883b with SMTP id bh4-20020a056808180400b0035e22a4883bmr27248741oib.38.1671548450978;
        Tue, 20 Dec 2022 07:00:50 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a23-20020a9d6e97000000b0066ca9001e68sm5724244otr.5.2022.12.20.07.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 07:00:50 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 20 Dec 2022 07:00:49 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/25] 6.1.1-rc1 review
Message-ID: <20221220150049.GE3748047@roeck-us.net>
References: <20221219182943.395169070@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219182943.395169070@linuxfoundation.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 19, 2022 at 08:22:39PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.1 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 498 fail: 2
Failed tests:
	arm:xilinx-zynq-a9:multi_v7_defconfig:usb0:mem128:net,default:zynq-zc702:rootfs
	arm:xilinx-zynq-a9:multi_v7_defconfig:usb0:mem128:zynq-zed:rootfs

The failure bisects to commit e013ba1e4e12 ("usb: ulpi: defer ulpi_register on
ulpi_read_id timeout") and is inherited from mainline. Reverting the offending
patch fixes the problem.

Guenter

---
# bad: [4478ff938eb5814bd2ae93b7e2d68c4fe54e9380] Linux 6.1.1-rc1
# good: [830b3c68c1fb1e9176028d02ef86f3cf76aa2476] Linux 6.1
git bisect start 'HEAD' 'v6.1'
# good: [38b8e682acfa37b80cb947cecc743431c72a6c1d] USB: serial: option: add Quectel EM05-G modem
git bisect good 38b8e682acfa37b80cb947cecc743431c72a6c1d
# good: [8baa56d13f1bef9c621bc967c66b789022e9614e] staging: r8188eu: fix led register settings
git bisect good 8baa56d13f1bef9c621bc967c66b789022e9614e
# good: [aaac7e5db89b4f46c871b9a5c188bfbe6ae21b83] usb: dwc3: pci: Update PCIe device ID for USB3 controller on CPU sub-system for Raptor Lake
git bisect good aaac7e5db89b4f46c871b9a5c188bfbe6ae21b83
# good: [acbd8d17388466ea19eb52c2239c2e9d34906381] KEYS: encrypted: fix key instantiation with user-provided data
git bisect good acbd8d17388466ea19eb52c2239c2e9d34906381
# bad: [e013ba1e4e12b523bff42f600d598ff65a69c27b] usb: ulpi: defer ulpi_register on ulpi_read_id timeout
git bisect bad e013ba1e4e12b523bff42f600d598ff65a69c27b
# first bad commit: [e013ba1e4e12b523bff42f600d598ff65a69c27b] usb: ulpi: defer ulpi_register on ulpi_read_id timeout
