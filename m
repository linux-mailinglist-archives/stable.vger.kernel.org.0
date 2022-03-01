Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8E744C9233
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 18:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbiCARx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 12:53:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234228AbiCARx1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 12:53:27 -0500
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A2ED94;
        Tue,  1 Mar 2022 09:52:46 -0800 (PST)
Received: by mail-vs1-xe33.google.com with SMTP id e5so17342196vsg.12;
        Tue, 01 Mar 2022 09:52:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X1IK4US6CM2/zrH+SvI8dyvnbVOcPAJt+AaTUhbe0ac=;
        b=lZmbDkOIFjH7d5EHgbzAT+fgrgW17yP4V/8xKtjMEZ9U3oXaMFKlIdecnV4q6hDXaN
         xlCpHR52kPIEEALP88yvMMiG2Bn1blrfpmVZFWYMKPhygtgnFEGjEc7co4up0CtI2ZhB
         qLgE3rcC8HimqK7pl7iuWt30I4eP2fmFSiM493IWJw899zGV6fzSjC1+hIdA0o4+Af3g
         MlVSqPPcQutY80g6TURBKN9P3hivDiLSfePmlC3FZMvHtLMP8Uv4FHJ0vQfpppIRzb8R
         HbY27coirK5OEWW9IY8k9Q+SC7X99xyvgpZTtER2NCKtTdfRpwHNz6MwzJ0asnLjKpQ4
         VD8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X1IK4US6CM2/zrH+SvI8dyvnbVOcPAJt+AaTUhbe0ac=;
        b=2E+2yftwwHjCQrz1vI5lja+VAn333pSczfLLkuy9/nINArE0Vxo6zXH9QPj58Os5uG
         lnGWksGpMErzvk0n9h0g50BVyvRmwQnDCjuwQRDfcA1mHQ6JKqr07MX0VZPZwvkCQpU0
         iRoaIfqmTlOp0GvJrbj4akacUtCWFmhzEY5TiwfLtzSVqqAm4kGbzOSFwCcUTeBw6VRD
         Imzki9nuF4q7ZT2oi8bL/mYQNp4K0InneZuvjmED61pABISFKGjOzfn4Bl7vGXhAt8Y5
         PTWsl//IJrFT7ihA5Sxg6c6aRILVdR92Q3tEzYf9IJceX9CYlR2auILVVo4IeOrZ3z/d
         enMg==
X-Gm-Message-State: AOAM531047mZ1jlanf8cicpCFkLrOh4q9Ymo3xJUDzObls4AHHLIUnLx
        PWulYgRINGRH5piS2q+hfCKy11QCydIO0ubrOyQ=
X-Google-Smtp-Source: ABdhPJzIRwU8cbIvgAP4MaPTqzhXi2w6K01ppDdJovf2CYfRu29H7VXTuG6mS1pCWG5Vu4JjgrQqjB4NDM7oqkBCLrI=
X-Received: by 2002:a67:d317:0:b0:31b:9b12:dd6b with SMTP id
 a23-20020a67d317000000b0031b9b12dd6bmr10052420vsj.27.1646157165323; Tue, 01
 Mar 2022 09:52:45 -0800 (PST)
MIME-Version: 1.0
References: <20220228172347.614588246@linuxfoundation.org>
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Tue, 1 Mar 2022 09:52:34 -0800
Message-ID: <CAJq+SaDpS4tvH2JYV7nQm4D90ZMu=0hHBBc1P9e9S8_FpniFaQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/139] 5.15.26-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>
> This is the start of the stable review cycle for the 5.15.26 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>

Compiled and booted on my test(x86/arm64) systems. No regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
