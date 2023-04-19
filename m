Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 302316E74B2
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 10:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbjDSILj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 04:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbjDSILi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 04:11:38 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE48A10C6;
        Wed, 19 Apr 2023 01:11:36 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1a814fe0ddeso7569615ad.2;
        Wed, 19 Apr 2023 01:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681891896; x=1684483896;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Yl4uAwWa39pOxQAlHQJyprHiogKr6ebOfSFDzFtU5is=;
        b=Nc1IJpv2Pmd+JcVQ3KKskMqBJfGqbmWCfPR7P/D8B3BQYRgvsyIh/sgHyp1EDQA9/7
         ylYnxLTZPZT3fVTBDLchT5+m/KlLlobZo70mlzCAKRQJ56u39cqXA0H7u0UTzJLVX0IX
         Ivak4YtM0OouFbdrihMEMlP4kC3q4brpE6H9QN/SapFH4Ulp1dpKIz5SasB0RbGMZsCE
         Vtbu83V4703GSe0Wjx0fvOFyT2qcPvnnLYgaiNf7bBO1lAIMV2kow3jr1yYtP6swrAy8
         ce16ZH348k2NNuqoa4FNv/Qyk2VvJNk2cTYdbLFRgRN6UfVmOoonodO6hzDzOchEvx/e
         6BIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681891896; x=1684483896;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yl4uAwWa39pOxQAlHQJyprHiogKr6ebOfSFDzFtU5is=;
        b=Qz0KANVPpMrQ4+hOAPO3geOj+BC9a9yTBQ0R0UEvApS9F9lq7VTKbtvAlsxVCCzbVY
         mocNUJm50iSCFJAQwwmbZN9plv9QYNgg4+PQlu6JT7IiEWXKMNCywZoIXyBtEnxxDMiY
         dTTlBB3UspUC716xZ/9FKAyPbR4FeJCguo9233XAef8mzighQ1pi+RAZ8+q/SMcSFuEz
         R+ceLDfFruWOb98ubw9oeUWcE9fHYqzO4iMCDuk/ah/a0W6yoBaEL5qNIihyOluqnFVe
         xir6jv2/V+hxjnfmUBAattLRWA8goPRswth9eTZJIR4AJyC/fhc/OaSv5WNwB/ZSI7e6
         lJ9A==
X-Gm-Message-State: AAQBX9eUWdMxIKk/IceCKmX3/xRtYYhU4f4quVtcVekjXB73YgbsJ0np
        CobZp4iwGU7zFjD6K3FOCkbwhskq1Gw=
X-Google-Smtp-Source: AKy350agtmcoveHHtLRKiYiSljQJi3z/72Dzx+y9vn6FF+kB8WGHgzus0bFr50zIbxe2ajqcee0M0Q==
X-Received: by 2002:a17:902:f54a:b0:1a6:523c:8589 with SMTP id h10-20020a170902f54a00b001a6523c8589mr5171217plf.5.1681891895989;
        Wed, 19 Apr 2023 01:11:35 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a7-20020a170902ecc700b0019719f752c5sm10819070plh.59.2023.04.19.01.11.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 01:11:35 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <f10dd20e-6dce-490a-f3fb-fdf79e83bc1d@roeck-us.net>
Date:   Wed, 19 Apr 2023 01:11:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230419072156.965447596@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.15 00/88] 5.15.108-rc2 review
In-Reply-To: <20230419072156.965447596@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/19/23 00:23, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.108 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Apr 2023 07:21:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.108-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:
> 
...
> Alexandre Ghiti <alexghiti@rivosinc.com>
>      riscv: Do not set initial_boot_params to the linear address of the dtb
> 

As expected, a quick test shows that this patch still results in immediate
riscv32/64 crashes.

[    0.000000] random: crng init done
[    0.000000] OF: fdt: Ignoring memory range 0x80000000 - 0x80200000
[    0.000000] Machine model: riscv-virtio,qemu
[    0.000000] earlycon: uart8250 at MMIO 0x0000000010000000 (options '115200')
[    0.000000] printk: bootconsole [uart8250] enabled
[    0.000000] efi: UEFI not found.
[    0.000000] Unable to handle kernel paging request at virtual address 0000000040000001
[    0.000000] Oops [#1]
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 5.15.108-rc2-00089-g6405847d6038 #1
[    0.000000] Hardware name: riscv-virtio,qemu (DT)
[    0.000000] epc : fdt_check_header+0x6/0x1fc
[    0.000000]  ra : __unflatten_device_tree+0x32/0x10a
[    0.000000] epc : ffffffff804a76e2 ra : ffffffff80723c22 sp : ffffffff81403eb0
[    0.000000]  gp : ffffffff815c6408 tp : ffffffff81411280 t0 : ffffffcefefff000
[    0.000000]  t1 : 000000009ffff000 t2 : 0000000000000004 s0 : ffffffff81403ec0
[    0.000000]  s1 : 0000000040000088 a0 : 0000000040000000 a1 : 0000000000000000
[    0.000000]  a2 : ffffffff815cadd0 a3 : ffffffff80a26fbe a4 : 0000000000000000
[    0.000000]  a5 : 0000000000000000 a6 : 0000000000001000 a7 : 0000000000000048
[    0.000000]  s2 : 0000000040000000 s3 : ffffffff815cadd0 s4 : 0000000000000000
[    0.000000]  s5 : ffffffff80a26fbe s6 : 0000000000000000 s7 : 000000000000007f
[    0.000000]  s8 : 0000000080019038 s9 : 000000008003d6a8 s10: 0000000000000000
[    0.000000]  s11: 0000000000000000 t3 : ffffffff80c191e8 t4 : ffffffff80c191e8
[    0.000000]  t5 : ffffffff80c191e8 t6 : ffffffff80c19200
[    0.000000] status: 0000000200000100 badaddr: 0000000040000001 cause: 000000000000000d
[    0.000000] [<ffffffff804a76e2>] fdt_check_header+0x6/0x1fc
[    0.000000] ---[ end trace 2baf78845f288dac ]---

Guenter

