Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B35615E5FDC
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 12:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbiIVK21 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 06:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiIVK20 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 06:28:26 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B9FB40F2;
        Thu, 22 Sep 2022 03:28:21 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id t7so14718036wrm.10;
        Thu, 22 Sep 2022 03:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=39GM4exFZ1dlE3OVAWRYlZvqw5JA5gOJ994ehU2e7TA=;
        b=IaQ2doisxZ4iy0vO/Fy/iyDjQS812rqvmA2Xwt5Bo0rUC56kb9HTznzxVItWqctf5K
         TSyYThm9BI/ZN+oSGRMQ+w6L0F6qrmilljNJ5s78zQL3tEqaySWm12z23GBpo1PV4Zh9
         vq18gyXCEI7AVIFDDaoy/W9d19ncieQt5xxCK5CV2VxxCl/SMkHQJVLUzX52Cn0U+DtU
         fEbMjPqxq9nwfQt+dTcBXWG3Vo8UAETGjOpewkPLfiNC6pjF2s2gy9X+7bB0wSmO8eMB
         cpphVv3uUk9fg6jO/7GhWQV/RWeNdXtqv6JIkMalplHWRx3kYyJWc+2AzSmIznXy7baj
         pFsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=39GM4exFZ1dlE3OVAWRYlZvqw5JA5gOJ994ehU2e7TA=;
        b=XyRyWurIdLhiepsgrbTZ9kohQabmRvr6D1M1bGXYXKx1hSStmCjIQdTwHfZTLOg5Jd
         ojCdZnwLQqloXL8c6tRi/GqbwZRTd6hGA5+2OxVTOp7Z323G7cvX82fN9yjkKQQZK0s9
         Pex55NarKbPG5LtCkPQjrNt2BcbRVfs73WuDv3FiPgMUBlD/hmstLSLDzfCbYqXW8aFi
         e/DQs9cjdfX+hyifVOkUv6EMR2nhuVN8mDIHhTn9RQPCiv+5NQq9AkIzxksZxh8j483L
         hZkn486oYjeWPIBEelo+kVSErD1MbfBd5r339yp3X2ViFJfqWXSYWJC6xkA3ht6ZfQ1K
         oGtw==
X-Gm-Message-State: ACrzQf2buPVHjT4MdaaNh5nkStu0Ltb9pTA6aOaOJDt0QnP28/qVLn2q
        v3D8PoSO6LmtCM5G+iGoR6I=
X-Google-Smtp-Source: AMsMyM6ijGzvdt6xuyU9mbrG3Pj+NoJ0cXXesSnCUTizB9B4aaDio2CiF9/AxrJ7fv5lxqNdzknY8A==
X-Received: by 2002:adf:b646:0:b0:221:76eb:b3ba with SMTP id i6-20020adfb646000000b0022176ebb3bamr1510666wre.237.1663842499939;
        Thu, 22 Sep 2022 03:28:19 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id w12-20020a05600c474c00b003a5f3f5883dsm5712398wmo.17.2022.09.22.03.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 03:28:19 -0700 (PDT)
Date:   Thu, 22 Sep 2022 11:28:17 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/39] 5.10.145-rc1 review
Message-ID: <Yyw4wfkUvhlIg3I4@debian>
References: <20220921153645.663680057@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921153645.663680057@linuxfoundation.org>
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

On Wed, Sep 21, 2022 at 05:46:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.145 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Sep 2022 15:36:33 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220919):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1875
[2]. https://openqa.qa.codethink.co.uk/tests/1879


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
