Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2C30603A66
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 09:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbiJSHPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 03:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiJSHPB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 03:15:01 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35AAF5E319
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 00:14:59 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id t16so4621519edd.2
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 00:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=r2jINxH4BaEr8E+N8SgANtpdn3kmuN94/fThEpE5kKs=;
        b=xQBkmMDRXSuHBMtgbusX8imr7y+CIm9VjBsTZNI7BW1s7IOSA/zCZKNZST7dJnUBGb
         7Vx9UF3mKF+JyjAtyDlyuzWjnl+8QA62icFi6qMI+Ksmn82l6mAcgaPgGyrJqWz/84Oz
         kA4fylkEo4g6MTKrmXgHxmUsEgeeTdkp8Wfjr7n/V4mYHN49fOb44+4lqyT5GdukL6hQ
         Djib4r6I213E2aGycjD+vEiZlFvvWSLbEDdNsI6pq0ZNFtHuEGsP7nLqTzkr0ve/nwxU
         dmG/r17Mu1o/EDx7a1IFEcCYvyqK3/OrUjEZsyT279VA+u1VpK8yTYG0sBlFIYw9niWw
         OIEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r2jINxH4BaEr8E+N8SgANtpdn3kmuN94/fThEpE5kKs=;
        b=2EHg6kuFECwaF+6BbAWScQyTcX9rpfAWhgjv/696TDxvgq3WPUyY4/kuu+9T00FSGr
         56tVXTyEhgw5x36oKFYQ2li2EUzCiUP2fnxEwihGoPXdbyGvnVNOmI9tK1fMtJylloc/
         HQOAlG4YhKv0JB3nUL+h9OZp0/NXmzTUfeKuJFI+ol1niv0DJ7MsbTQflqQXhJvo0qVM
         rpgqF0HXWP7ATWb3SREC5cWsHd4E0dVktYgVGYV/Np2dwWle4KWdIrVRZE8BsRgcIMTL
         dPVFLOLZE6ENr0BicABLkGt69REGaCaT6LGySJCqPZaJ+Ly0nhmDnB0YzjBP0k2psRTK
         PFhQ==
X-Gm-Message-State: ACrzQf0XyUzZYyYk6TSi5PocAWuXwYBL4mm1tto4J9NZS3GqaaJUimok
        rmLeLvbHhtgqQPmZhgb5z1ieNTIjn7kYOjJgCaL3grAoLwz/Dw==
X-Google-Smtp-Source: AMsMyM5/TfY6uQbDuECbyCS71AtAa6X21A4yCp/AqruBpZH79i/M9R/8ss3S7/FPM250AljeiIUqnl2tvrv0uzx2oB0=
X-Received: by 2002:a05:6402:3c5:b0:45b:55d8:21ff with SMTP id
 t5-20020a05640203c500b0045b55d821ffmr6053735edw.253.1666163697380; Wed, 19
 Oct 2022 00:14:57 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 19 Oct 2022 12:44:37 +0530
Message-ID: <CA+G9fYuxe6KWGt0bkKLZTfhhYdnLqp5ZBarFc4aRvpRR_xJEjg@mail.gmail.com>
Subject: stable-rc: queue/5.10: drivers/dma/ti/k3-udma.c:666:26: error:
 'struct udma_chan' has no member named 'bchan'; did you mean 'tchan'?
To:     linux-stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Following build error noticed while building arm64 defconfig on
stable-rc queue/5.10.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

drivers/dma/ti/k3-udma.c: In function 'udma_decrement_byte_counters':
drivers/dma/ti/k3-udma.c:666:26: error: 'struct udma_chan' has no
member named 'bchan'; did you mean 'tchan'?
  666 |                 if (!uc->bchan)
      |                          ^~~~~
      |                          tchan
make[4]: *** [scripts/Makefile.build:286: drivers/dma/ti/k3-udma.o] Error 1


--
Linaro LKFT
https://lkft.linaro.org
