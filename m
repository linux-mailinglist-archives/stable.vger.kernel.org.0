Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 157CA682BCC
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 12:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbjAaLtK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 06:49:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbjAaLtI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 06:49:08 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670B01CAD1;
        Tue, 31 Jan 2023 03:49:06 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id d4-20020a05600c3ac400b003db1de2aef0so10386119wms.2;
        Tue, 31 Jan 2023 03:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xOuKpEZ1jj97XUC/j3mPDWi/nJBBNGvsjF3Zpzi3Ud0=;
        b=qEEyrBhq59r02hG+3psz010bdHV8K8LBFdcPjLxfk4UzbwCDBPoZkqa1N9/qNnaO4l
         YduhEmRExorbeoa1ygcZNv6c/KuBubPdXTWPOcD+TXacbDPvRKsv9IZ98eCkZ+xaHKmq
         wdEsSLFyNzKbhHaoomapYTFnncVVGHNfKNhaa6s2JEthouhh5PswNJ31HC93bwnq/PFh
         l1eT3xiXnDpmgz0SNSs1Y8MvLv5SFJ2LtMdMYOsYb8enCJZwQ193NYVgLzMTvfv++oBB
         Wudkf7ZymGjBEDxVLvRPNJs5h6TNaB0EOJJwLLBpmg0z9eLI8EdfncNUKeF3JS7kgU8U
         dWAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xOuKpEZ1jj97XUC/j3mPDWi/nJBBNGvsjF3Zpzi3Ud0=;
        b=G6JmSVEUUOGk1kFriYXKNk2PuUpmARKj11ar0xPAbo/xNzUpRjhomREqHE5ScDqBBR
         Tgd/X1qebSDiBvgY60asHnaSqpOZtGz3ViQMJY1+oc2I1cbxiPGBAT1c/djRlOLCgUwZ
         fZKBoTbj3h+BHznyc2l55Pgus4uqCT5j0PWP2V8nMKGUoYiej4grTNukficHo8nMfkkU
         t0UyQeDoV7a3ZpZDHheqbrcf1svaLJbFFCPIbCqeR8+lFAVqO1rvi6UGTUV2T25G92Qt
         6tO37Kn3ppgVjdKW5KR6cpgDGcPC93JR0f2RAVSvnxmoRrcTOpoAEr8SBrCq/oq+7mFn
         Trtw==
X-Gm-Message-State: AO0yUKUt3tfKof21k59QE4FER9wqCoyXYxokSIoEr71mkyn/ZyvD+5Mv
        d83hS29nFvf61cTFoshzjYLIewgIox8=
X-Google-Smtp-Source: AK7set/S51RBOo0S52AlhMr6xyFSsTawRhwIeQkzjCf3zToS2aDbDQi6oMgQqUd7+4IigxhDOgoIvg==
X-Received: by 2002:a05:600c:434b:b0:3dd:1982:4d14 with SMTP id r11-20020a05600c434b00b003dd19824d14mr4792279wme.1.1675165744862;
        Tue, 31 Jan 2023 03:49:04 -0800 (PST)
Received: from debian ([2a10:d582:3bb:0:63f8:f640:f53e:dd47])
        by smtp.gmail.com with ESMTPSA id j14-20020a05600c130e00b003dc541c4b13sm7333208wmf.21.2023.01.31.03.49.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 03:49:04 -0800 (PST)
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
X-Google-Original-From: Sudip Mukherjee <sudip@debian>
Date:   Tue, 31 Jan 2023 11:49:02 +0000
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/313] 6.1.9-rc2 review
Message-ID: <Y9kALqNnCA5cwfnC@debian>
References: <20230130181611.883327545@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130181611.883327545@linuxfoundation.org>
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

On Mon, Jan 30, 2023 at 07:24:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.9 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Feb 2023 18:15:14 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230113):
mips: 52 configs -> no failure
arm: 100 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/2772
[2]. https://openqa.qa.codethink.co.uk/tests/2773
[3]. https://openqa.qa.codethink.co.uk/tests/2774

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
