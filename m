Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9A4552E86
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 11:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349107AbiFUJhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 05:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349111AbiFUJhF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 05:37:05 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1177C27173;
        Tue, 21 Jun 2022 02:37:02 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id e25so14199695wrc.13;
        Tue, 21 Jun 2022 02:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=P/HgWE5zx6ak8pGZYSWP8wvpjOQw9jeFYu+LvoDV+xs=;
        b=A0jeweQvtYrqb4j0jMeIU/WN0N2S/IFolNmvLtlV/t6KF95L6rCQCjezpjQUfYQyOY
         vTA9/gfs2D+EcKRl6aw0mFfiKlsZAPYJkPgEirvKmFbpgv1vWwTYIfsq2rUhD1fnTDWG
         IZZy2J0CrfBQk1mfK6Cp9phZ8QGhoEarQYgJ1k8V0L4qWzSkCP7xH9Kur+xthd6PAxnb
         d3tNjhlMqwIIBNcVXq6DUcwZDJ45AWurjTIy6epq9HGBzu/DeHQxJ2/FuQnborzROz1H
         /2TUtmhvMDVBnV5AlDvgAPf146y8DacC+8J74qXZN+kaCMNtYdDVpgDG85kxorR65l9+
         YCBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P/HgWE5zx6ak8pGZYSWP8wvpjOQw9jeFYu+LvoDV+xs=;
        b=aOlGpmQ9T6hDwk29u/wvNr+ayglv5VCZRLot+FRtMJdPQiRtE+mJbG/Q5PBSb384iY
         TecvvduhgPHWD9GHLq/rqY9WYzMKB3YzGCBb5KpjluDjGVaV7tdCl7w/XdRyfbx4GnZP
         Is9fcGUye7O9o6JbHS4aFr25QGszG5f94iva4TVFWELBMZrvw6RXSrmwX/7fEVmPIuuf
         lUl8ISEBoa77o+m6RPEwwXKyWDRwhm0lO7p7oVnWxBts9UVwfxNh36KZYGH3Bei/O1tX
         LlHoo0+8bJe0Z8W+6t7FawJHt8SUhP7MI5tmZpV7mbis+QJWlvj0bpNiO9/zZRhnPHGc
         ZVMw==
X-Gm-Message-State: AJIora/qSkPeFsevTrFaes7YewUtbKAh+jPIzrfUWS3AUGpUPqRs0IUa
        ozEX9+S8+ZGWqdEZmK9Hyh5Ft4WI3uc=
X-Google-Smtp-Source: AGRyM1u5tlS/ABAdrQ/7V3A5WvprA/ds4q8szC1BQSSYZSFsaxekTuslkLh880M9dpDlm/oU+PjSSQ==
X-Received: by 2002:adf:d229:0:b0:21a:3916:84ff with SMTP id k9-20020adfd229000000b0021a391684ffmr25134606wrh.349.1655804221272;
        Tue, 21 Jun 2022 02:37:01 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id bv27-20020a0560001f1b00b0021b84ac7a05sm6184698wrb.0.2022.06.21.02.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 02:37:00 -0700 (PDT)
Date:   Tue, 21 Jun 2022 10:36:58 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/84] 5.10.124-rc1 review
Message-ID: <YrGROt9cmGYR+Bx3@debian>
References: <20220620124720.882450983@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620124720.882450983@linuxfoundation.org>
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

On Mon, Jun 20, 2022 at 02:50:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.124 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220612):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/1361
[2]. https://openqa.qa.codethink.co.uk/tests/1364


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

