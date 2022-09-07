Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5266B5B00A8
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 11:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiIGJiY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 05:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiIGJiW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 05:38:22 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C41B286B;
        Wed,  7 Sep 2022 02:38:21 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id bp20so18945789wrb.9;
        Wed, 07 Sep 2022 02:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=c/YzYhTM+LSkQhcYRxo3mbOA9N7njEiWKjfS3hl37ck=;
        b=GEeBD2z1uCDlWDO7KW8ZxN8Rl53WHspGMRZdNo4fQ9EVSzp8Gn6iz7VF19Y9x1gmRN
         UP/E9G7vp4BMFvS6Fb1jLzRAvpb1ec3cdfamQNLmO99p8UmR1hhFlWFR40Lmu18jgW1/
         G4gAB/+yK8zMiZYxHOBwDTgpTZHgq4reCu0E5HQp6agwPYKF7A64SFaDBAst0cmvakuN
         MWpM2mMm8XEfGHriGbhqnWwQKeyU9M7p14KMPqyuzWV/1KG8vDRMbrFUS/ajzh6vAOv6
         j2q4fLyN+eX/g9Sc7IRY/MLd4BmbCJx2bT1JjV4O+dYDKXUS4fDyU5vxRMFwKwJ9YhSU
         obAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=c/YzYhTM+LSkQhcYRxo3mbOA9N7njEiWKjfS3hl37ck=;
        b=k1ZB0JxS3E3Lw0QFjDeehDKQJzRYmqHEsO1RyEEY9iEN2GmLCfmXHRuf5TXT6iU+1b
         c51ZN7kz8ZzSAa3LiSdk4jpy1VSfjlmjyTAAxP/yC93ivWO+WCR4nfS0YpfBH9mppsWr
         tzDx+ASHiK+gpvPpEq5xoTtPg9T3ZyZPRI4DosEKAueiIGhLkcCMWzOCje9Zv5v+Onmq
         /UqsOMI2x7Bq+yZ8UWiuWNJrQ2aOeuHuFVAvvkv4vOmdA3QwN+PaglRxlJPWiz7H0lja
         2U/gYk7KX8sazIRKwybhijqzgYpVglT+knBdZazAFvXKU8Ljstg1sS1/wTww1QUX4tPY
         Ijwg==
X-Gm-Message-State: ACgBeo1GmddCBITHQyZNzY61e8EmlXB3IdT1PVcSKRsz6l2lJq8UvMMV
        jTRUdP3cLZPq21CQ7PZrQNM=
X-Google-Smtp-Source: AA6agR7PcA6HX4IRks2uk58dX3Gg67IBQE9CN+tcfmTBY41C7YqsF3fgVZSQ4T0QLuXFkYJ5vjtd1w==
X-Received: by 2002:a05:6000:78d:b0:226:d5c1:5ebd with SMTP id bu13-20020a056000078d00b00226d5c15ebdmr1489245wrb.565.1662543499402;
        Wed, 07 Sep 2022 02:38:19 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id bz9-20020a056000090900b0022584c82c80sm16986383wrb.19.2022.09.07.02.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 02:38:18 -0700 (PDT)
Date:   Wed, 7 Sep 2022 10:38:17 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/80] 5.10.142-rc1 review
Message-ID: <YxhmifV0TNEVMqZX@debian>
References: <20220906132816.936069583@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
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

On Tue, Sep 06, 2022 at 03:29:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.142 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Sep 2022 13:27:58 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220819):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1783
[2]. https://openqa.qa.codethink.co.uk/tests/1784


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
