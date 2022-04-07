Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C614F8660
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 19:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbiDGRoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 13:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbiDGRoW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 13:44:22 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA841228341;
        Thu,  7 Apr 2022 10:42:20 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id w17-20020a056830111100b005b22c584b93so4373229otq.11;
        Thu, 07 Apr 2022 10:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:content-language:to
         :cc:references:from:subject:in-reply-to:content-transfer-encoding;
        bh=3eSQtawQe69k3nOU7ZXczx1U5S7lGRhrFISgI9KDRYo=;
        b=hNwW1aBNsUjz8Xs46xMUBIoXSIUl856NVq4c2Int6JBGM3sNj6G40UoihPbXRsZEma
         VIDfGo9Elo7p93rWpWGvGR1byxU79PMKm2ZczfhnDFnv75XRLNvSzwexUFiVD6iW56Vb
         F3w2np1p01v1PxgGzxx7BUPbB+JKE5ePs5ifAAlQ5NNep6eax0US8FArC2rmmGrEru/y
         +kP3e+e0L4uRaIugpd3mGNJ3C+LWJmwuj490PQGy+A6R2w7Mg/7VD6P+kLD2R/r2tdNf
         /CXQbNGoCXQ13zjYtdz0tjfYT8bpP0AXDUTAX+Cdn40Xor8YHkvWC5apFc5NE4kNgfW1
         F4Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=3eSQtawQe69k3nOU7ZXczx1U5S7lGRhrFISgI9KDRYo=;
        b=M2Gi4fK1Uu9WbwO5i9TYH3WwjFdewqX4JgHkwkCQwvlU2Ep706MQ3WzhyKO5rhlpEX
         1SbgfCCx83EDWGs1jFyU+wo6LdZXESu8oZnCrtF5UOSQkxbbuBtjJv37cwarEEMLh7Vf
         vILd/w8hQQaZneqUJ3tIvmiii3QgMzSktC69FycAU5O4EKxcKfCUCSXXZlxrwGxETeKO
         lPqCtzJDvW9cMM8IXG1yrrx0+nAc64E86DpT7BftrLDG8QmWeOrqIMt0uX4WkIdCyKTp
         wJgBiPkbEXc8dZ3EpHihBHTNTuecgKrA6Sx1cU2J41uch5yM+akwYb9b4EJL0OqVkNMi
         uZtA==
X-Gm-Message-State: AOAM532/l3rN56Gu7flmwww51jmzaaEcZEVYCEkBmAHOjo2rIH0lY26K
        YLUQWoLoqS0JLFTR5o83RymnFZ7o+s4=
X-Google-Smtp-Source: ABdhPJxyTwhz8nB/KZrBj1c80lEh5Pt9k9L7Az5RU+UmWJOibfTe2L/6/lZbHaE91R+HbM+VqktJEQ==
X-Received: by 2002:a05:6830:16d9:b0:5b2:7173:4239 with SMTP id l25-20020a05683016d900b005b271734239mr5251321otr.99.1649353339916;
        Thu, 07 Apr 2022 10:42:19 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n124-20020aca4082000000b002ecd08d8497sm7721262oia.5.2022.04.07.10.42.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 10:42:18 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <7d1903b5-7139-94df-11ec-02de782b8008@roeck-us.net>
Date:   Thu, 7 Apr 2022 10:42:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220406133013.264188813@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.10 000/597] 5.10.110-rc2 review
In-Reply-To: <20220406133013.264188813@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/6/22 06:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.110 release.
> There are 597 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
> Anything received after that time might be too late.
> 

Trying again ...

Test results for v5.10.109-598-gf8a7d8111f45:

Build results:
	total: 161 pass: 150 fail: 11
Failed builds:
	alpha:defconfig
	alpha:allmodconfig
	csky:defconfig
	m68k:defconfig
	m68k:allmodconfig
	m68k:sun3_defconfig
	m68k_nommu:m5475evb_defconfig
	microblaze:mmu_defconfig
	nds32:defconfig
	nds32:allmodconfig
	um:defconfig
Qemu test results:
	total: 477 pass: 453 fail: 24
Failed tests:
	<all alpha>
	q800:m68040:mac_defconfig:initrd
	q800:m68040:mac_defconfig:rootfs
	<all microblaze>

Common error is:

fs/binfmt_elf.c: In function 'fill_note_info':
fs/binfmt_elf.c:2056:53: error: 'regs' undeclared

Looks like a bad backport of upstream commit 9ec7d3230717
("coredump/elf: Pass coredump_params into fill_note_info").
Only seen on architectures defining CORE_DUMP_USE_REGSET.

Guenter
