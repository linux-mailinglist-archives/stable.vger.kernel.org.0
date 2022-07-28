Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C6C584168
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 16:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbiG1Oey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 10:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbiG1Oej (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 10:34:39 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD756A9F8;
        Thu, 28 Jul 2022 07:32:00 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id w205so2077475pfc.8;
        Thu, 28 Jul 2022 07:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=6oZ44hEUQblGcAR6ofAUSZycDGVSclA71sZxflubxwQ=;
        b=NzPq7/fsX2x4s3d2ieI7jO2Lw6v2IVjFMJA9ZC81ngORkHusPSjFeMo3WVvn8ktKKD
         c+IrbMcN3T6BwwGpKcqFy7wYWaixRbbyiFu+hLuVVjycacqwLg2j882pgS/I3CbOryIf
         6IIP3Ce2GN2yKTVweBdJoBnGl7mBHYIrT10FjcP+mgs6hpHHZa0XbYuxofCxJKVOZ4P8
         HFLjp0Hue06tmjc7O0jZTwtDEFAbSIqLrBsJi/v16LArbTTpMZcZz7bD5POG0KQKVISx
         B1hQ0k3rcoyyQ7EKr/1VXNctfUBhFLkYVIwBNl3mnnYfGm4DJI4+cH5L2U293maYotiZ
         TWJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=6oZ44hEUQblGcAR6ofAUSZycDGVSclA71sZxflubxwQ=;
        b=r6CrVLBVjuv7XdGA61Gu3HEqtGfXDqbOnje/Fs6pPnFZx4wjlR0HuoQVOqtZHyJkhU
         syJT9NpwuzYdo/h+liL+BQzBce2cJOpRgvKGZAslVdFZbRrakljB7PzIHKA0PQDL6O0K
         HbNzHR8b/I27QJBpHSf0X5Ggi+l4QvL8lUSirPZNJE7q1jLpoNt+mcK6P27KvAlRPRut
         eMUdlraiClldvj29e/LuoT0MwGjgGfyf/XpIp1+1BgJ6BmAqwhm9jRcgTFLvZogmUWpQ
         5ePh64ECrjhiZ+U1x2fnXT7PuO0ShuwX/O4RS9jmvhZL/kEe6drLKHRfKEtOYpkWVrn+
         ngSQ==
X-Gm-Message-State: AJIora9LXZh0rL2mcviEHj3IySbs2Sf4xs/OoUMYMds8GapYghZ1NZRz
        gPxFaVu4xZNxl+qYAjNcrng=
X-Google-Smtp-Source: AGRyM1tYMDQ1g5FXssNlVJgSsYWnrrpDhMGbKYf5Ln0V0LC9slDq0yuzPIaB+VnWlrkumYSRWNVpyw==
X-Received: by 2002:a05:6a00:26f1:b0:52b:d0aa:4178 with SMTP id p49-20020a056a0026f100b0052bd0aa4178mr27348044pfw.86.1659018719861;
        Thu, 28 Jul 2022 07:31:59 -0700 (PDT)
Received: from debian ([2402:3a80:196b:933a:553c:d695:8a60:6d86])
        by smtp.gmail.com with ESMTPSA id x24-20020aa79418000000b00528c6c7bf37sm825573pfo.129.2022.07.28.07.31.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 07:31:59 -0700 (PDT)
Date:   Thu, 28 Jul 2022 15:31:52 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/62] 4.19.254-rc1 review
Message-ID: <YuKd2KJXia5GBp5n@debian>
References: <20220727161004.175638564@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727161004.175638564@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, Jul 27, 2022 at 06:10:09PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.254 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220724):
mips: 63 configs -> no  failure
arm: 115 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/1570


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
