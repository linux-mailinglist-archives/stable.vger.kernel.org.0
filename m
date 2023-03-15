Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE7496BB5E8
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 15:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbjCOO0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 10:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231983AbjCOO0M (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 10:26:12 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52892366E;
        Wed, 15 Mar 2023 07:26:08 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id l9so7330865iln.1;
        Wed, 15 Mar 2023 07:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678890368;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=Bb6BqyZSkkDx4xoda/AlCz3K7+pWLz5fsJlOVsRCSK4=;
        b=iaxVKbT2pXx7PjPzTxBTkY8MW92024Hz4QkYyrHPY2Bxiw8SsxjdF/B9I6fXBEtJ+V
         NfrhW16kDczpBhZneos4/kyiGVNHEcvUrM9wIabSG/eW9onX7o0bKzJZw8j+HodqRHzm
         yXjCzpiG5GqaBgjrzdu1QTDfS5e3UXrRXfeVfwSSUpyREeeL9QYQv6uREdzCqCIGopov
         WqftZ4LUBpRRiju8MmLBOFZuMcM+IlMeiWn45lDZJOKfrWs8pZSxVvtpCtmVy0rDRXp6
         Tv0pa/wZM7xGXU+vJNU6SMf+cKJy7xbovVVrrglcvoX3ICF76BdgBO3T6vJ/OBFnegMo
         c5ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678890368;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bb6BqyZSkkDx4xoda/AlCz3K7+pWLz5fsJlOVsRCSK4=;
        b=2R5WQCpznCTbFIMux/FOzX7dEurDq8FAOBfkNMU9g4e31Gn7cRtoFvobrsmDi46F+p
         YCDIf6PBkuqZq6ua8VBsKIQEG5OWtN7kBqjhUwmPf/yLSVorL38EwVIhe3AVW3CLZ9VG
         vKjzkYUiGd50BdxEt8Td2bcFcBGUTn4w0JJfZmBTJeTUNE9E9i0I8uOVuZfT83T/t2L8
         PE/XCwyTdYdHNSrSdZR6/56KEum9peycMbC6LsmCOHZBXbnI3VbbqfFXITJPbm/KnizE
         My9CHlk+1LTuL9cSFhV4VwGgjkY2T4KanLVf+NkbPxnbrP/cAOZpak1VffXwp6SeFB/D
         rbLg==
X-Gm-Message-State: AO0yUKU/KZ8JzuZYu0xUldsOMh0GGUmyspsfdEZXkYmmGB2IBuKdyJxz
        59SMBnaU/1OkjbNXbMp9z6g=
X-Google-Smtp-Source: AK7set8C1jd4zWOBmgHem4sZfx6LWTQakUR6pnDF2vFmpvHZu+QCkV+nayXhi1TTSmLykuKYfxTbgg==
X-Received: by 2002:a05:6e02:c63:b0:315:69ef:345d with SMTP id f3-20020a056e020c6300b0031569ef345dmr3310631ilj.16.1678890368132;
        Wed, 15 Mar 2023 07:26:08 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m17-20020a056638225100b00404d129c1ecsm747391jas.138.2023.03.15.07.26.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 07:26:07 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <4584471d-d216-3edd-058c-e362e048462f@roeck-us.net>
Date:   Wed, 15 Mar 2023 07:26:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.10 000/104] 5.10.175-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230315115731.942692602@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/15/23 05:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.175 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.
> 

Another build failure, almost drowning in the noise.

Building riscv32:allmodconfig ... failed
--------------
Error log:
drivers/pci/pci-driver.c: In function 'pci_pm_runtime_resume':
drivers/pci/pci-driver.c:1297:9: error: implicit declaration of function 'pci_restore_standard_config' [-Werror=implicit-function-declaration]
  1297 |         pci_restore_standard_config(pci_dev);
       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
At top level:
drivers/pci/pci-driver.c:536:13: warning: 'pci_pm_default_resume_early' defined but not used [-Wunused-function]
   536 | static void pci_pm_default_resume_early(struct pci_dev *pci_dev)
       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~

Guenter

