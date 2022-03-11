Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA23C4D5F2C
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 11:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235301AbiCKKK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 05:10:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237508AbiCKKK6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 05:10:58 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D52F64BDB;
        Fri, 11 Mar 2022 02:09:55 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id q14so12175878wrc.4;
        Fri, 11 Mar 2022 02:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cXqmE+yntbh6/+uLYj4zOB2UVU7APAKaRKTsY9NU1TI=;
        b=gn2ZoFTH0QA2llSqzPeVwD2oAE8XDHs38lHwpFHKKJ6f1Hq15zS3kFO377J1KAUqZE
         359jBfZJhvhDyWDUsldNAVAu88Ycc7Acy25f+13o+eMD5BRuPlFDsU9yjXNKB3DUwuC4
         uLsH6Bpcj+SDhihxLvjdSORn3pNaJTpm23XT3g1NDttCTz08UWG+0yya9iLROUVtVNm5
         v6RhBEom1MkDVrImlnTC1Pw8f/5w/YvvUKuojZdvV51+EHEhiYb0xx1hA5aUw1Z3845y
         vgbiNNz+itAv445HGTwJ/t9UJGobMs9AYzrQTiVmp1tjNRcxaKgKtJL5fkN06wJ1rklt
         b6rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cXqmE+yntbh6/+uLYj4zOB2UVU7APAKaRKTsY9NU1TI=;
        b=BLr6hYQXY0GvLW+aIt/r6MrkOIqNAAPYpUx0xFOL1xiiYl810ihT2xGKuBvGU5ZEmS
         EfLZ8+fqVg/e5B+PTUwDQmjkLJwzSAzS/qoCGf2finLOkGNZ0PWKutkMJkzfumVoiKrO
         NeDtL7HPkILF3YfxtTKxmE3/L3wd42hVOJpwTuzyupUPMRMCXBzA10Tup7gENRdJ9h1k
         WuxfKTSSxzMl0v9DI9Oz9Ts9N25NOttLf3m3HShdpgDx72PWnXIviOsOStuD6WncSJTD
         92jwDsVi+56WSsELmPkDy/8ZMhnkcHzKVNfNax+QDqjFAbkaydt2/kBhJtGffJLd+SeH
         157g==
X-Gm-Message-State: AOAM530SIbCD9oaiNgpk5xyMmsIcqN1UR4bwdD+cy7SBkIv2HB+6ucmq
        0ufQUh6M9KGGZUFWFJFAs9U=
X-Google-Smtp-Source: ABdhPJxgVQAZjjGAhXkzdJLDemb1747MpJd+tQjoCKQHBbOvJfPIIHK5QVK+wOGtEa00/X8b8wutFg==
X-Received: by 2002:adf:e551:0:b0:1f0:4b3a:cb23 with SMTP id z17-20020adfe551000000b001f04b3acb23mr6743625wrm.391.1646993393759;
        Fri, 11 Mar 2022 02:09:53 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id p6-20020a5d4586000000b001f0436cb325sm6259581wrq.52.2022.03.11.02.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 02:09:53 -0800 (PST)
Date:   Fri, 11 Mar 2022 10:09:51 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/33] 4.19.234-rc2 review
Message-ID: <Yisf73CyDbTMnpQc@debian>
References: <20220310140807.749164737@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310140807.749164737@linuxfoundation.org>
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

On Thu, Mar 10, 2022 at 03:18:27PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.234 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220301): 63 configs -> no  failure
arm (gcc version 11.2.1 20220301): 116 configs -> no new failure
arm64 (gcc version 11.2.1 20220301): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220301): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/860


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

