Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45998652AD3
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 02:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234040AbiLUBPk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 20:15:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbiLUBPj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 20:15:39 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF5B1E736
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 17:15:38 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id o12so14170379pjo.4
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 17:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+ecA2KXfjiKAstKqFn0Kl2sfLSWuL9dSPL6PdGndRJc=;
        b=HLhMHTdtTaY+RzmPvx3EykrQea2pY8Rqo0th90WsLsGFLpc0t1uVM8lpLvzai3MiaM
         A5Z3lIQWq/k++BdsWInnJlXL6IkvDxqoVBR9yuwpCksa+EDOFoySF6sOpeXyZJhMqXIL
         7/GWSeWENTy3TDSqvvCHd/IHuKS8PGsEcYj5aP7xlPv9rGTjvwnUZr3i+MNiBxMcgo1C
         /xoThY/k/NeSRI3W3yTpNnMkXOg4wLOAB0q1u+GLeArOyG3rsB4qLn47/Wqcnje+yr/e
         liku4EaRFuEA4Zuj/SwnXZRSsi/Jp+mgDirEOUDMgtZdZQNuqjGMx7R8n0eX9zFsoJiC
         byaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+ecA2KXfjiKAstKqFn0Kl2sfLSWuL9dSPL6PdGndRJc=;
        b=02ALYm1FynsjeTFbeanaTgj4w8xuRAsQwz4aIMAq2u3iszgLt4r+ZI3mzLogTMetby
         jxcvvUZetBKe2zm9qMs8bZZE5swKcLeOxmXXFlV/gyg6pgOyEhr3NM3OLq2lNUpB+M5Y
         Y0fFIvSxOxGSfdj9n5HY09DcG02Iqv2sIrAqsdP8utNXTE3htKvoSjJCGv7zdr9RjDbK
         dWNXKlDBRiB4DjndFg8J3dGzt8zbe8J1aj5fCd1V82bORAhKnuspJyHtr59edCzE/Tpv
         5/pM8D2Iff/AkmxUWUdF4MftuMaxdUwAj9AkhsDRWRVsbA/dMsb4MI+qGRaGrVvFuCqT
         9NOQ==
X-Gm-Message-State: AFqh2kqv68mnX25S+aNv+PeSLoXEQxcCKJO6NQBCqke+2WXcGW77uJO1
        frl7W6D7JEOaOmRqvW9BWCAppp5TQ5hmVFanNOtsAQ==
X-Google-Smtp-Source: AMrXdXsOZC8o3lMenbRvAifZAxKpZqUVvFbfth8W2cnPbqoe6AHhagMGsxRpAaMf3Lvn469gMvUswW7LwzTYnvEZLLY=
X-Received: by 2002:a17:90a:af91:b0:219:536b:41ef with SMTP id
 w17-20020a17090aaf9100b00219536b41efmr15187pjq.71.1671585338288; Tue, 20 Dec
 2022 17:15:38 -0800 (PST)
MIME-Version: 1.0
References: <20221219182940.701087296@linuxfoundation.org> <CA+pv=HMdmd5E=yH-1_dbF316EQ=KkriAPgLg8e+7m6wbinchaQ@mail.gmail.com>
In-Reply-To: <CA+pv=HMdmd5E=yH-1_dbF316EQ=KkriAPgLg8e+7m6wbinchaQ@mail.gmail.com>
From:   Slade Watkins <srw@sladewatkins.net>
Date:   Tue, 20 Dec 2022 20:15:27 -0500
Message-ID: <CA+pv=HMJ1K5Hhho7FgsGEf=7i2ZROT6y8X9Q6m1LXSyxj9h4Qw@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/18] 5.10.161-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 19, 2022 at 5:36 PM Slade Watkins <srw@sladewatkins.net> wrote:
>
> On Mon, Dec 19, 2022 at 2:28 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.161 release.
> > There are 18 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> > Anything received after that time might be too late.
>

Hi,
I noticed that the original message was missing my Tested-by...

> Compiled and tested on my x86_64 test systems, no errors or
> regressions to report.

Same applies.

Tested-by: Slade Watkins <srw@sladewatkins.net>

Sorry,
-- Slade
(via his corrected script)
