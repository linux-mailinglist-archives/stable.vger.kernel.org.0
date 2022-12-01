Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6E0563EF4D
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 12:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbiLALT5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 06:19:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiLALTT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 06:19:19 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E3CAC19A;
        Thu,  1 Dec 2022 03:16:03 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id bx10so2207831wrb.0;
        Thu, 01 Dec 2022 03:16:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jUQOzDiUxwTumDFoldjkk+yvnQZDgT2KS3JBUye/v7o=;
        b=pHKN+se2n8Z3MICZNzkaHf0bxTESel6QK8U6CzDkvlr3VigKjX4JyoDN4V1LbkFdpV
         BMJFrprcwRoRYSbNkwxDs+2VQWig81TyIy1aq8+iDs6W8/cQUNH3irTM6ejRSMh7cw0L
         huat9PPIQ1nL2ZqzHuZfGbAJPgmLP7JFEmbnhePAXLgME0s3bBvtPzfc7q31clcAMIDo
         nC5OOoyhecZSiINz7iS1cU8eLZxnKRzENqZGEf0CT0kXTC+qdCBR68JSms9cDmv15jvT
         3JC5zY6AdZMTS/kx0yO234b3hTveMIYKer1tK7n57e7iPU6SOndCXnokhqNc3R01mJqw
         AjWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jUQOzDiUxwTumDFoldjkk+yvnQZDgT2KS3JBUye/v7o=;
        b=QiNWx1gifdxUrZghDEAuZd5LWHUQqhTze9acADOsZsRTLJ+sKenjiFNS+EFQSL83LU
         xLDST12FOQIelawOsokeRDpEaqv7jV3DYGWM1nEYJBkWsHKGHa+wsUED0rNcjUfUivwE
         OWmJinX5ffPYkUYgEYniXtcK4QP7lj7+wi5OsfrYHAcvuJ7o7hw6WCmGQdptaufhsrJo
         P2Iub+pW79bTGeNIGUybmjxBOjwSpVZyglBs8wgvOrJy47RsHKsrY0DCilvrN2XRMYYu
         F+UQapvGGo+zI0rSKaQrufr15TolHmWwo87BYhTCo1Ol5EA/8aReY/NE4KliOGk/IqMM
         x4tg==
X-Gm-Message-State: ANoB5pkMdx8DPHmeCT1AgJrILcgOapALM5r1msz1xYkicq/gCwcuDIJz
        sBBfVnmd5G6/aS3fgFfizEgHBygWPiw=
X-Google-Smtp-Source: AA0mqf4Qt172xYQzaUt2b8VniS1BwtVR1653RAlbiuTT7FnZxfmCW4p6gYOs95m+haSVLhqhhdYc2g==
X-Received: by 2002:a5d:4a8c:0:b0:242:165e:7a79 with SMTP id o12-20020a5d4a8c000000b00242165e7a79mr12118833wrq.343.1669893362132;
        Thu, 01 Dec 2022 03:16:02 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id t12-20020adfeb8c000000b0023662245d3csm4091806wrn.95.2022.12.01.03.16.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 03:16:01 -0800 (PST)
Date:   Thu, 1 Dec 2022 11:16:00 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/206] 5.15.81-rc1 review
Message-ID: <Y4iM8Dx3NvQKyZGQ@debian>
References: <20221130180532.974348590@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
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

On Wed, Nov 30, 2022 at 07:20:52PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.81 release.
> There are 206 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221127):
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
mips: Booted on ci20 board. No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2252
[2]. https://openqa.qa.codethink.co.uk/tests/2257

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
