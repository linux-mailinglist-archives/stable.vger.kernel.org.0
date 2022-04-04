Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 702044F122D
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 11:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354392AbiDDJlb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 05:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354258AbiDDJla (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 05:41:30 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7C022BE3
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 02:39:34 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-2e5e9025c20so92216437b3.7
        for <stable@vger.kernel.org>; Mon, 04 Apr 2022 02:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=VBtq5kN44g3n+UMYylFBwtFXXfxhetga0boAUFLgn6o=;
        b=ldxfYVNLgqbCdbT0y6eHTNkc73ckmyJNYVYiLeKfOgCUvxn8BOCtoSC59Z1+ifT0bB
         k0ovJRcc+MgZfN3sHV+nWKVcOCvrTTLoywiwALVpXrVF+k00uP4pycugaPKnyv74sjAy
         kEUehRjITwXHZGAIbVFHq9tSVuAHi0OI/DAlK74jVpjmmCgFVuvj71FfjKVO7xXbO3vE
         BNA1u5rnU1DCsfTER2sWeFmY4HCPhNKswC9OVGp2IwhyLLr9wUaboQbkKqhTLGR+3Qjz
         7BqwgaPMPmS9XNYRkMAnmpaVVLvEi7n6jac+FlNGbuZ+/JIsIRIBCpPnhD/5HgnVmg36
         RXBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=VBtq5kN44g3n+UMYylFBwtFXXfxhetga0boAUFLgn6o=;
        b=yQfYbOxIf+5P+rRpVyGpr7oEteh27RVWXvrzJte3uLet7bph/HtmJ92O6u04L9kC01
         sGd9JkW85sjR7gufBZ3RIYU2DN8G44nwgPI/zFvqzLVYjyYmBlbwAQiZCWlYFe9t3NaY
         1Mp00kjYyRuR4tY4/bqnkYx59g5hg3zNSTh3ETMrHYi03xTbl8KzVOiPEU+5zGCsuCzP
         M/3X44m5QtsFQEEpraEuBZ9CcuxCNS17DxS1lhuvfl5aIEjyAJ9y1/zdeOnIGMhQJc/F
         lXSUeH2d+yB0ICBtnMqXS70QorXXZBpCzQ+8GvIreaXJ0ZB7HC2FF59gtfsJEKTNoZK9
         xa+g==
X-Gm-Message-State: AOAM530akxMB0+8b2zhgandgEZHD0FiY0WA0OJL6BsqeGnH+AfFKmQKJ
        PHw8JsDOMbae0AqoeQjtF7H/mPHkg+O3tsjE42dUog==
X-Google-Smtp-Source: ABdhPJyAz1RdCDYXT//COuACj5PL3lsEQAS6kkfx6EIalBjFgJh7Cxl7r1eHpList/Ephz9hUmmSitH451RX4T9Qx5o=
X-Received: by 2002:a81:478b:0:b0:2ea:da8c:5c21 with SMTP id
 u133-20020a81478b000000b002eada8c5c21mr22201615ywa.189.1649065173718; Mon, 04
 Apr 2022 02:39:33 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 4 Apr 2022 15:09:22 +0530
Message-ID: <CA+G9fYs-zEGZghAXK9cqi-6avLVa_3mS62Y2jGsM9+x6+jJzcg@mail.gmail.com>
Subject: stable-rc: queues/5.15, 5.16 and 5.17 : arm64 tinyconfig builds failed
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Vijay Balakrishna <vijayb@linux.microsoft.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Pasha Tatashin <pasha.tatashin@soleen.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Following arm64 tinyconfig builds failed on queue/5.15..5.17.
   arm64-gcc-11-tinyconfig - FAILED
   arm64-gcc-10-tinyconfig- FAILED
   arm64-clang-12-tinyconfig- FAILED
   arm64-clang-13-tinyconfig- FAILED


arch/arm64/mm/init.c:90:19: error: conflicting type qualifiers for
'arm64_dma_phys_limit'
   90 | const phys_addr_t arm64_dma_phys_limit = PHYS_MASK + 1;
      |                   ^~~~~~~~~~~~~~~~~~~~
In file included from include/asm-generic/qrwlock.h:14,
                 from ./arch/arm64/include/generated/asm/qrwlock.h:1,
                 from arch/arm64/include/asm/spinlock.h:9,
                 from include/linux/spinlock.h:94,
                 from include/linux/swap.h:5,
                 from arch/arm64/mm/init.c:12:
arch/arm64/include/asm/processor.h:102:20: note: previous declaration
of 'arm64_dma_phys_limit' with type 'phys_addr_t' {aka 'long long
unsigned int'}
  102 | extern phys_addr_t arm64_dma_phys_limit;
      |                    ^~~~~~~~~~~~~~~~~~~~
make[3]: *** [scripts/Makefile.build:277: arch/arm64/mm/init.o] Error 1

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Is this the suspected commit ?

arm64: Do not defer reserve_crashkernel() for platforms with no DMA memory zones
commit 031495635b4668f94e964e037ca93d0d38bfde58 upstream.

https://qa-reports.linaro.org/_/comparetest/?project=1019&project=1110&project=1150&suite=build&test=arm64-gcc-11-tinyconfig

- Naresh
