Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31C45533433
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 02:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238033AbiEYARD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 20:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiEYARC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 20:17:02 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F8617E2F;
        Tue, 24 May 2022 17:17:01 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id z20so11419319iof.1;
        Tue, 24 May 2022 17:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GHn9imWbM35lZ9aZLoE66UnPSUn14mE5KIF2XTLFEo0=;
        b=goKhyyuqKWVVJ20L9tbBRCQ4Y2k+5hFVbdqrF7gqdv/YG6/b6h2ChfYHblF7J6OOBX
         GA6IhqC1VuIpr/4QdPUcECnVeTcbvwK6GmUV9/Wi+A6XvqWPB/GL2JLg4DOMFA8t5xJe
         MPRpDXYfV1pL3qEZ4opXpXaCuks9Uyc/TCag8C/LQ7qFw11Bs3pYrLKjoSVxlcuR1n4j
         llsNV/FLfJFP1MOBhLmthXDI7gdlkxUpGDVnu+IaRL9NuwVko9+5BHzBXYxFWzLene7V
         tqWalZgJEkXPdDQPFkIIe6dLCbKlAVSns08xFuSUS6bF48870JLyDRRWhZy17CmJrHNP
         aAMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GHn9imWbM35lZ9aZLoE66UnPSUn14mE5KIF2XTLFEo0=;
        b=wqcIL6rqoa4QzWCjK7Vccmxfh0FS88P3FCumdbeWE5RghN1OGD/WufSZmRGZfsLQ6D
         l5OboiP2p95+XZ4ttlvAcacQh5Jfc22lbtvBu56Boa2a9rPBFwUCytoTJ/h3EJuzsN/f
         wHaWNlS1szvjO3inzs6/vLaV569gULcUDeMbEKd/ZvFZ0IPKxUHPkELmTEKD3pOZDoY6
         xVaPilbPbVkRHEbd1bVGx+jymrfTFb2F1WQ2oFX/Zb8HD2SCi4cfNlZByU7x5ibr3Ujn
         Qc3+JcvuharNWlgRe8yZhCvaZEHMCjEOezOSFPlAZmlwlyr6LAt01S4cOT0GGjuK7LY4
         dYNw==
X-Gm-Message-State: AOAM531fKz7/NkPj66GJs0ZA529641kWw+KztiwGQYldtYMJnCHkbDkc
        Tymy6WAZHec0p91RB3MNoWv8opSbzNcBb5xdDT8=
X-Google-Smtp-Source: ABdhPJzoXAGPV/UGLdemQq0FE64CLQaPx929+WK2aKx6AhcFgNG+Y9MaEkvELL6JMgKnf5ACS/x+eNJ3a3Ia2Q1VtCQ=
X-Received: by 2002:a02:b893:0:b0:32d:c698:1a3a with SMTP id
 p19-20020a02b893000000b0032dc6981a3amr14467232jam.51.1653437820767; Tue, 24
 May 2022 17:17:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220523165830.581652127@linuxfoundation.org>
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
From:   Labnan Khalid Masum <khalid.masum.92@gmail.com>
Date:   Wed, 25 May 2022 06:16:50 +0600
Message-ID: <CAABMjtEwpP36YPvF6p-5rDN4iqP9HCei1BP8fBqyXQNvD47QjA@mail.gmail.com>
Subject: Re: [PATCH 5.17 000/158] 5.17.10-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        linux-kernel-mentees@lists.linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 23, 2022 at 11:05 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.17.10 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Compiled and booted on my arch x86_64 system. No dmesg regressions.

Tested-by: Khalid Masum<khalid.masum.92@gmail.com>

thanks,
-- Khalid Masum
