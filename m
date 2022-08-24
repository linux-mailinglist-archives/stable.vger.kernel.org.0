Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2DA55A031D
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 23:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbiHXVEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 17:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbiHXVEV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 17:04:21 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC76726A0;
        Wed, 24 Aug 2022 14:04:19 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id k6-20020a05600c1c8600b003a54ecc62f6so1482752wms.5;
        Wed, 24 Aug 2022 14:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=xZjUby4B8cD9EpdCkA6j7K02bwTB0VbtcN7t11qFtkE=;
        b=TpA7KC5A3RdIh2BpA5aBt7amycmffYQntHtBUzdMAEaePPErhDcNBy3a6M9Md3aRvo
         0Zcvk2V4+nY7c1oUKMfSPXd4snZgRSKVeYl1wlSpB8P0wGmPqvY/4OD8G+zKnzbgVm6J
         iskLvagYlo6Z3qLR19oJbJah5k39/PIbl10tPs/h67l1s9driOwWXaTQQNcqmFeTKA8M
         fO2sQoIS0g+GXT6S5C1F0nGbbx8PzsrnzHHU5lV6oQcernnntWyD/KMoqGvBlULu4ibM
         CQQ0k49vJNpqrGvwpirQbO3hQ6OvzoQqmKFBPY960zI4W7gC51Fzp9YgcrnKec9mB/Kk
         WIpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=xZjUby4B8cD9EpdCkA6j7K02bwTB0VbtcN7t11qFtkE=;
        b=FkjdaykF2p5L/31KFyh3ExkxYLuJhVUnkcf0OFCPLeBID1eAgZz9VZsP1SJe+RoazO
         7IFWFQUoIXyoi3c9IovuASWwpjbx3iLvDU+BNV12BLOVk33iu253QMcMYDectMXuzwGn
         64Up/Slo4mCiMaV3R9WOBtL3XGt2gPKLVwX87kCYNy0S2YPuLTMSnQzheD4nzJZRGR0p
         G6yjT2P5JrBjUP1vWHEl37p3bSXcCMmv1FePHKsrTOr+T7XApGppcXVuEh0m9voQSCa4
         UzMaROXLpZceh3NKREVc1GZ4I2mUgUuuB0NuZSvHky2PXRGzEAkBxzb/UnpN6+VT7pIJ
         VZhg==
X-Gm-Message-State: ACgBeo3UVnvtPuyRPZ59khGGxJgGWSs9xyreRjkjaw9swGobzl2azv9y
        dhv0YEvEiDePONs2IKizqVI=
X-Google-Smtp-Source: AA6agR7EevBxKD2xNZHwAzo0LXvX6dwWCRT3g52MZFOw6MTz4C/dnR/5N9vC8ZJ30MegNAvwJcWHeg==
X-Received: by 2002:a05:600c:2311:b0:3a5:af18:75c1 with SMTP id 17-20020a05600c231100b003a5af1875c1mr6309109wmo.90.1661375058030;
        Wed, 24 Aug 2022 14:04:18 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id w7-20020adfd4c7000000b0021d76a1b0e3sm17871620wrk.6.2022.08.24.14.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 14:04:17 -0700 (PDT)
Date:   Wed, 24 Aug 2022 22:04:15 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/242] 5.15.63-rc2 review
Message-ID: <YwaST4euNs6ut/Dv@debian>
References: <20220824065913.068916566@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220824065913.068916566@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, Aug 24, 2022 at 09:01:03AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.63 release.
> There are 242 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Aug 2022 06:58:31 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220819):
mips: 62 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/1695
[2]. https://openqa.qa.codethink.co.uk/tests/1700
[3]. https://openqa.qa.codethink.co.uk/tests/1702

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
