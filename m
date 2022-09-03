Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3E35ABE98
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 12:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbiICKt6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Sep 2022 06:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiICKt5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Sep 2022 06:49:57 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE9D286E8;
        Sat,  3 Sep 2022 03:49:55 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id c11so962179wrp.11;
        Sat, 03 Sep 2022 03:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=XrMdVv2xUhxR5Q9kOZUXM47qxjFM4pdwsuKh8dulBXY=;
        b=X1THUn+uLxxNb25VDUXlkAxwbhSEA7vESxCPVQFbn/j3T9JBQ0o8jiOoOAfD0TodR7
         kyyzzq5XALDLjnhj1XbWHm4MME8mhngQoct6DDU6Z6T8xEfFhMAuJuwT3kexD9btG0re
         Ixb7t+giDUIvY6ice111MF/3acqruDyymnnExBlSGzg2WLmKuGyyV5s71jmEmbSIitOD
         VW9wgYeuiFmxqjEsvvDCzpMQysrmWKNBQ514yJVCd+tO5WhjL8Q6rRWCWOEScCLrG2Wq
         kQJGsyMQr9etrhUtlq2ljq6weeQGhTEDyMiMoT7tpQfuZSPykwjgTzdlwlD0Q/XQeS9i
         o1uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=XrMdVv2xUhxR5Q9kOZUXM47qxjFM4pdwsuKh8dulBXY=;
        b=CawTfQXGqhTqyWFMQCCV9uAzSOoSTphJm95GPeJ9u/hrPFKbDJcgH/wXoCIgXlWEYo
         0gXaRg2sRYcT3vx5yubuA0qZ/54HoWZX1qYgqhVpo8w7HE0v4vNSXDE+l8HFOJm6z/+3
         lxUJMoSpSTT+mJ7OTNbuibxcxi18lqA4faEOHEzIZiXYpS1mwAKOq57w8yyLWPlNC0ku
         oM2VDGKdyPQi7Llo4aZhHBLzydz4FOiqDuyUEM7uocKTM3S0OG5WHzr0FuobvgRcpqUQ
         iTrN72Z1LuYxBItkV8Fi6JMYXC01rSsffMmRUbwbEkHc4yaw06nYIb9YT/DbfUsT2IL/
         BcBg==
X-Gm-Message-State: ACgBeo00eAnIve8OkvPOsRp/mDChc5lYXWkBAqBV1MC7E2DzU55eUWho
        LZ7/LxKpzf4fyuAh6n/aR8Q=
X-Google-Smtp-Source: AA6agR49Vb//Nrma131t5FYZi2Q3c28psceHp6QgCMnwtih0gYx9oR2scSZcR5oMcwGpsyjYeVOEzQ==
X-Received: by 2002:a5d:5885:0:b0:228:28df:91af with SMTP id n5-20020a5d5885000000b0022828df91afmr3948437wrf.511.1662202194469;
        Sat, 03 Sep 2022 03:49:54 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id t6-20020a05600c41c600b003a5ffec0b91sm4619362wmh.30.2022.09.03.03.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Sep 2022 03:49:53 -0700 (PDT)
Date:   Sat, 3 Sep 2022 11:49:52 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.19 00/72] 5.19.7-rc1 review
Message-ID: <YxMxUOSMDpdU1j7w@debian>
References: <20220902121404.772492078@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Sep 02, 2022 at 02:18:36PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.7 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20220819):
mips: 59 configs -> no failure
arm: 99 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/1758
[2]. https://openqa.qa.codethink.co.uk/tests/1761
[3]. https://openqa.qa.codethink.co.uk/tests/1763

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
