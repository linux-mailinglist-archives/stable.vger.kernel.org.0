Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2DDF66DD98
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 13:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236069AbjAQM3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 07:29:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236446AbjAQM3e (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 07:29:34 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69CD536B3A;
        Tue, 17 Jan 2023 04:29:33 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id j17so3572607wms.0;
        Tue, 17 Jan 2023 04:29:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sIPwfdU6WBiamrmleJs7zzgMl1VkSUfaRUm8g+vAhuo=;
        b=Hp/fhK1xj2ToriNTJOVi6I9HW8OWuN67U4w0giHmfYvaSFu6n4GRy/LiPXju4Np+YG
         NAJxgilmF+gZda677dOo7Wu8nfIRVdWWvEtRJXge/Poyfjc9YA2oG4Rs2rye0Y8fNr4k
         VRet7LOckPHPAyiyDk1gCMIyoyG0uREJnYiZxMZ9AUkZRkaDGWsFsbPmMwIvLoyqQ0qc
         MeQCb12I+duEuPXL4IAK1Dn97fPttzNZNI3LsrbrUu4A7N3woYpkuL34kN3b6BXeSMCl
         Kkup1q9hJsxbk2oD9Zpstv6aeh+E9adRETir60KMwD7iHf7u/2MY/XLphtau0QCWIMKo
         9woA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sIPwfdU6WBiamrmleJs7zzgMl1VkSUfaRUm8g+vAhuo=;
        b=6SRvGy4bZYWYzz1DuSHlTe7UJTKDct3MayS1IHLSMxnzkHWlpbFP67Im/uz8lAg6+4
         7TYgNoGgWlewJ9FeqycrlrWgSIQ3A399T0zQDeCIQxA7XjOFLgv5St3Pj9xoLUaF+jSh
         IQTMFuEqiAvsQxYf6VEYnFYotWgs1kHoqtGNxGsq1MxKiGe97WFpfTbuBzlaxOKj8fs1
         v54jtbxTI5dfkSioH0TQevnjRMgwirNtD4Dt5Ku0F2uDv32+dARUpAk85HqLAMD9unNw
         ClxFUKi0xlFyQHn7x6IaPh57YZanggj7vcyBYJL3zaDMEg6ZCEbvrj9gvkUUWORZ4knV
         QGKw==
X-Gm-Message-State: AFqh2kqcwT89NYu16BhwW/8/gjLto2DY6p9tiqqTOY1E8o6Q5vHimT/U
        20KJOv1KonoF7p0Wni3ctAc=
X-Google-Smtp-Source: AMrXdXuBD+g9X/0JHy10W5gsLH9p4UhqxemkZGOEXUTWwojs0GPVspnvFRhKsj3NYwLibqChHi+Smw==
X-Received: by 2002:a05:600c:4691:b0:3d3:4877:e556 with SMTP id p17-20020a05600c469100b003d34877e556mr3056177wmo.29.1673958571903;
        Tue, 17 Jan 2023 04:29:31 -0800 (PST)
Received: from debian ([67.208.52.125])
        by smtp.gmail.com with ESMTPSA id ay15-20020a05600c1e0f00b003dab77aa911sm10068209wmb.23.2023.01.17.04.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 04:29:31 -0800 (PST)
Date:   Tue, 17 Jan 2023 12:29:29 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/658] 5.4.229-rc1 review
Message-ID: <Y8aUqXPAtoEIwTP0@debian>
References: <20230116154909.645460653@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
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

On Mon, Jan 16, 2023 at 04:41:28PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.229 release.
> There are 658 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221127):
mips: 65 configs -> no failure
arm: 106 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> fails
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Note:
riscv build fails with the error (same error as v4.19.270-rc1)
arch/riscv/kernel/stacktrace.c: In function 'walk_stackframe':
arch/riscv/kernel/stacktrace.c:66:36: error: 'struct pt_regs' has no member named 'epc'; did you mean 'sepc'?
   66 |                 if (regs && (regs->epc == pc) && (frame->fp & 0x7)) {
      |                                    ^~~


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/2660


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
