Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93E1B677A0C
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 12:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbjAWLVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 06:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231566AbjAWLVV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 06:21:21 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5FEE061;
        Mon, 23 Jan 2023 03:21:19 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id y1so5954359wru.2;
        Mon, 23 Jan 2023 03:21:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NQ6F7ByEyXvgljzDRhRD+1sz/yBJjJzITDLGLQ6hLZU=;
        b=M6pzUXi97lLe5CYbkWn2+KGor77imMV4cmfzdqss7U3wsnK9vCQAZibugu9ETkXaT6
         ltol4zbtJtGjQyO2QpmVOm4p/7R2QnACbsOpwsnEsiBPP7kFUQS4moq1XlUw6WK7tjFE
         D3E0If3TNy/GE2TAippT7pK0p5hoPpAkbViFRHg4vT5TxVChjnTmnODRTmfGv4O0+yOq
         2nzHk2j1QlDUHlI1JJ7lxY4cSdKXXnk4GpJQnBhYo3OXpCmTs5iHEefAWAFhoWeafU4Q
         Rab/PgbnXM71qHEcPGpVb8LbFKmmkMx6ip4ymRajcmB49YVxkWJQkc4H3NkvtMz4sh/t
         KX3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NQ6F7ByEyXvgljzDRhRD+1sz/yBJjJzITDLGLQ6hLZU=;
        b=37Beck0RmCycb2WiXIGxPPUaX92VisJKl6G5gBFngGP4iZ1kpIZcaJR9QmssqESkFi
         scIJkSpi99wkiyiDNvRxnY2sGiNtik0OK+h3m6xUnQ9wp3FN8W2cWzr33kozidrUevPC
         CkAU+2BxKePTLcKcM2Njj20CIk0SZ44X+AcCfCrjfXV3e9PokorjJXCJmILxkYpGLhdp
         s3N0tWP52yPOVULcyiHXiHmy9Rk5yA3GP6CJyNdKGuoBFjjqLPafkmdtBYvuxu1u3Va+
         Pk32iLJFngflM4ytHndV+Wlv9fRtCp5HbKziZTnOlj8jz81NzX9oaUY23PxtFonplbeg
         Cr1Q==
X-Gm-Message-State: AFqh2kr+yiZoIyLrP9Whfz3+Eoq+ZTYRyLczES41ewi3eApqENRYvehz
        /87J3Z1hplb6aGggjbwweeU=
X-Google-Smtp-Source: AMrXdXvk1U0ANXNTh0jAyGxCB5b5XB0odlB2XbaDvisVSZcyC1Nw5JvRCfNbrL9ll7DlBXzERy67Sw==
X-Received: by 2002:a5d:5107:0:b0:2be:1b37:7f46 with SMTP id s7-20020a5d5107000000b002be1b377f46mr16759745wrt.71.1674472877971;
        Mon, 23 Jan 2023 03:21:17 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id o2-20020a5d58c2000000b002bdbead763csm31343788wrf.95.2023.01.23.03.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 03:21:17 -0800 (PST)
Date:   Mon, 23 Jan 2023 11:21:15 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/37] 4.19.271-rc1 review
Message-ID: <Y85tq8crdNCZLGZy@debian>
References: <20230122150219.557984692@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230122150219.557984692@linuxfoundation.org>
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

On Sun, Jan 22, 2023 at 04:03:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.271 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230113):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2694


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
