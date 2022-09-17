Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44CE15BB8A1
	for <lists+stable@lfdr.de>; Sat, 17 Sep 2022 16:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiIQOEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Sep 2022 10:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiIQOEV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Sep 2022 10:04:21 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656B130544;
        Sat, 17 Sep 2022 07:04:20 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id t14so40301870wrx.8;
        Sat, 17 Sep 2022 07:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=+N7mSIWsME28uR3sTESoLydrgt0P7Itl5mRu1QnP8VQ=;
        b=q2RPxcJ5DNyh2374Z/k1HrPlnOhByW2/Y95QrAICgrQ4LpzqiMnFUcnKQpz+TQFlUc
         Ghd8w8X/iiqkS4cxP5lLP32oGZbm5i9EeezflwstCLnGlQ2LVGCRT2NzAuNOFcz8e1TE
         CsUBzf/pd5dSMEnbfuw9lTi8g9kdeBMnyedVktMUUnjehRSKzpET3MHbEAtO+3N9K2Lh
         Zl+pL5dgNIdYIhsejpwuXq8evTMkW6DZBAh0q3wUQDW37IIgRgsK3GZB6VqF1VNPjw4d
         yWT4/WvE+zmKIYVf66HvO28Vr5S1wrMJVnHbNlIzdKorWvqq11uPM+GAdTSSPl+ykxzm
         cEEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=+N7mSIWsME28uR3sTESoLydrgt0P7Itl5mRu1QnP8VQ=;
        b=o7ngmw4wdCOIlIY56eSiOdmFdzlf7i9qiyZp/xvsP1DIVUNZe1Cy3awTxorCwEDcqb
         xVo9skRVupWsrpmgPr+/g+1Sd0NtaqMty0NLUuK3HMyLBZeS64AVXIpgDrZtqCb9K+oO
         hFP72kct8yN0Zc9bwGekBv4Gl9xozgighfpf0uDqHsNDNoK7UsvxBoUqsxQcsKsBO+it
         LkvSHdRxc9RGXaaBp4DqDBP9ME8eObeD1yJ5SBNgAcDaZD8/HyhyXHM1szR8Yr8Rjo9X
         xwZ9mIefVZW7tZNJIfGLqzYGpmgWYonJiwRQ+ChxWjbMd9EbXXRhWKLnhjPXoi+hZYAL
         i+aQ==
X-Gm-Message-State: ACrzQf1IwVMSISdWaMRdUxOXkhOq63g6QSaef1WyXC4T+eL4x6cKFz7p
        ouqGMMXP6XvORf+NCviORiQ=
X-Google-Smtp-Source: AMsMyM7m23abd671WzVCW1eex5c8bQMB0yZBpez9SYp2iZkRGcf8BBXty6ZuWcL/i0SFISHHcalW4Q==
X-Received: by 2002:a5d:4ecd:0:b0:22a:42ec:8d74 with SMTP id s13-20020a5d4ecd000000b0022a42ec8d74mr6024826wrv.359.1663423458756;
        Sat, 17 Sep 2022 07:04:18 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id v128-20020a1cac86000000b003b476bb2624sm6219561wme.6.2022.09.17.07.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Sep 2022 07:04:18 -0700 (PDT)
Date:   Sat, 17 Sep 2022 15:04:16 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/11] 4.19.259-rc1 review
Message-ID: <YyXT4C8NTSA5RhcI@debian>
References: <20220916100442.662955946@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220916100442.662955946@linuxfoundation.org>
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

On Fri, Sep 16, 2022 at 12:07:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.259 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Sep 2022 10:04:31 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220819):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1842


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
