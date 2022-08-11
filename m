Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5383458FD16
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 15:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235022AbiHKNKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 09:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234133AbiHKNKF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 09:10:05 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710966FA0B
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 06:10:03 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id t5so22829948edc.11
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 06:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=ucfBP/53P+UnzU4Fa8i2eVWM9uv5/ktiToZlI9Ntdqk=;
        b=NSbbNPqjvWfdwSYpAG4Xy3FS3qBHPq+OAXBz/qlrnN8kLAJqu707xfUJchvfsw4I4N
         DXFkEof+pN0oul6LkwxLyXNgWKIsen0Er2mPPHp5Faw5BIv7jLe124nvftk1Louy2xdX
         95BjKuN4xgMNugJ2DqadtrsaKsubR91EAeFuo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=ucfBP/53P+UnzU4Fa8i2eVWM9uv5/ktiToZlI9Ntdqk=;
        b=B7DnG0hCSaKLDDpxL4WPYPm7PlCiiDMvChEfNz1TKsaZqDwWbUcD3DRL5tWxiDSUso
         e/fXyC28j26YPwKxmtJS2s+Pv23i8zgrjWumuwZSh32gPjogkta3nJgy9zkxD63ADP7y
         f8KoniDsUMfaHkmJksHepdBWSFTkQkIcqqsV5zbmuGQ86J1BCkgKPapiYFl5zv/HWLRj
         HwablAoDCnHFnFcTyo7dRRRZG1z2bBvSTT18poZ5u6MeuGtKkIVGwWcjhtuhqX+EbfTj
         t94FX6Q9W2VQvwxtR0OW09B4mR23uFVQlmvspgZiTOhndSQ+B7ocHtdKdlls1zmuA8W/
         Lvjg==
X-Gm-Message-State: ACgBeo07bEeE2af7309MuLPZC0OAju0S0HPN3ju+vSONL2q0c4dc/hyr
        i5WJRe5Y8Lh2rzRpFNV/RNXtGcL7zFVfp2z7
X-Google-Smtp-Source: AA6agR5dTZOlQNgJ/pBptRkHoZPqLgqCcGQdiRWR/3O46KMukdOUqhKKC3HKWCaseAIfBS1hZ6LPWQ==
X-Received: by 2002:a05:6402:24a4:b0:440:8c0c:8d2b with SMTP id q36-20020a05640224a400b004408c0c8d2bmr19012459eda.311.1660223401831;
        Thu, 11 Aug 2022 06:10:01 -0700 (PDT)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id v12-20020aa7dbcc000000b0042de3d661d2sm9161637edt.1.2022.08.11.06.10.00
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Aug 2022 06:10:01 -0700 (PDT)
Received: by mail-ed1-f53.google.com with SMTP id x21so22892100edd.3
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 06:10:00 -0700 (PDT)
X-Received: by 2002:a05:6512:b87:b0:48b:2247:684f with SMTP id
 b7-20020a0565120b8700b0048b2247684fmr11707556lfv.593.1660223389777; Thu, 11
 Aug 2022 06:09:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220809193921.544546-1-svenva@chromium.org> <YvSNSs84wMRZ8Fa9@kernel.org>
In-Reply-To: <YvSNSs84wMRZ8Fa9@kernel.org>
From:   Sven van Ashbrook <svenva@chromium.org>
Date:   Thu, 11 Aug 2022 09:09:38 -0400
X-Gmail-Original-Message-ID: <CAM7w-FX4NfeQy9chKgzjAj6gvvoK3OxCK0VYq9DT5qrdB=_tDA@mail.gmail.com>
Message-ID: <CAM7w-FX4NfeQy9chKgzjAj6gvvoK3OxCK0VYq9DT5qrdB=_tDA@mail.gmail.com>
Subject: Re: [PATCH] tpm: fix potential race condition in suspend/resume
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Hao Wu <hao.wu@rubrik.com>, Yi Chou <yich@google.com>,
        Andrey Pronin <apronin@chromium.org>,
        James Morris <james.morris@microsoft.com>,
        stable@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 11, 2022 at 1:02 AM Jarkko Sakkinen <jarkko@kernel.org> wrote:
>
> What about adding TPM_CHIP_FLAG_SUSPENDED instead?

Thank you for the feedback, Jarkko. After thinking this over, I
believe this patch only moves kernel warnings around. Will re-post
soon with a fresh approach, intended to fix the underlying issue
rather than the symptom.

So please disregard this patch.
