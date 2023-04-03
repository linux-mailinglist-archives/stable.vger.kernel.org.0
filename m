Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6C06D41EA
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 12:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbjDCKZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 06:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbjDCKZN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 06:25:13 -0400
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960622137
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 03:25:09 -0700 (PDT)
Received: by mail-vs1-xe2e.google.com with SMTP id c1so24899908vsk.2
        for <stable@vger.kernel.org>; Mon, 03 Apr 2023 03:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680517508;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1VFclJDxQE7oyhZ5D9iKuLTgySdqBilcBX7wtdGB8sM=;
        b=c9nnbVn2+lxNapP69w8OXShMcYIPqJtcCMbqpFMrZ7+VYTM+Y6nfAUucj9bC3NHUOw
         4V6NAmLW8JsaAsWDhpjOqWA9IxYwMWznR42kaSxPscDZcnbIdg+bBbE5vUq2H8F+F9rf
         BnV8N+0Sp591z7CbYZGHkdaI3+kZFXio5pQsFCQx/x8TGelZ0/IwOt4E/iCJ0DNutIpJ
         En+JvwdFJqrgA4WQEQN7Ud3XoXmEJTbPdZXdAReHMXpwQ+0teUsz9BHYQyiOPx4vqozt
         npL26YAPVjq57mbunjpFrSqH/IyAVB+mZ8dkmd5IewUR2yBJWaFzpZLW/EFHPPWbSs4X
         K/5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680517508;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1VFclJDxQE7oyhZ5D9iKuLTgySdqBilcBX7wtdGB8sM=;
        b=5BnUTpw1t63BqnKu7GHQcIRGUMm05jbaN/oMOBaO5cQzFngpLQ5z7g4ZqSTSqC9L/A
         vvykktDRiw1etdDfYIrN1VvmEx3yIWCXWfAhJS/Abwv9EcO6W6GzkyZYOcdd9eKOaSof
         0UOhYK74/EKSB1Qef3PHMfQ370x2hu7d89/BXIhHLVeTrwzzPQ3/As7nW8dFjYdfJFIv
         9abjRODf7Dg+hFgyhmCULXO1kISkelO93oltBAbATUcB+Ln3ZzBRRC1zq1F/6zfY4T0M
         I2rG8qe6jq3fZC1VgpqP630XI+ikSMMdZAYlbAewfq27Z0uoWTA+4XLm0T/J2UcYEoOf
         7xiA==
X-Gm-Message-State: AAQBX9cBBpjsaVXqI8LKEXHxz/hSZohNrZ6DZRCXj7tZea3XmaWUqiEx
        tsUnYmdNQBQjh8tPgLY+VgS3ht19MkKue3oPIvtYIqrelFWWRQ0BF6k=
X-Google-Smtp-Source: AKy350ZrjnnRU+xkPb6+qM2BRgs9+BqoCIm1Gu2mbFfI879t4vOBGuL022o3+z5BoB2cjzAFeouUgTLdUgZ/a8HGgP0=
X-Received: by 2002:a67:e116:0:b0:426:df00:9b12 with SMTP id
 d22-20020a67e116000000b00426df009b12mr7856838vsl.1.1680517508213; Mon, 03 Apr
 2023 03:25:08 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 3 Apr 2023 15:54:57 +0530
Message-ID: <CA+G9fYu_4iKLXTn1pSgUfAJTVLduT+XUMvs6w4E_DCpofRGD4Q@mail.gmail.com>
Subject: stable-rc: queue/4.19: drivers/gpu/drm/meson/meson_drv.c:316:17:
 error: 'struct meson_drm' has no member named 'afbcd'
To:     linux-stable <stable@vger.kernel.org>, lkft-triage@lists.linaro.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        martin.blumenstingl@googlemail.com,
        Neil Armstrong <narmstrong@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Following build errors noticed on stable-rc queue/4.19.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


Supecting commit:
  drm/meson: Fix error handling when afbcd.ops->init fails
  [ Upstream commit fa747d75f65d1b1cbc3f4691fa67b695e8a399c8 ]

Build log:
---------
drivers/gpu/drm/meson/meson_drv.c: In function 'meson_drv_bind_master':
drivers/gpu/drm/meson/meson_drv.c:316:17: error: 'struct meson_drm'
has no member named 'afbcd'
  316 |         if (priv->afbcd.ops)
      |                 ^~
drivers/gpu/drm/meson/meson_drv.c:317:21: error: 'struct meson_drm'
has no member named 'afbcd'
  317 |                 priv->afbcd.ops->exit(priv);
      |                     ^~
make[5]: *** [scripts/Makefile.build:303:
drivers/gpu/drm/meson/meson_drv.o] Error 1

details link,
https://qa-reports.linaro.org/lkft/linux-stable-rc-queues-queue_4.19/build/v4.19.279-77-gb60454c8d9bc/testrun/16027306/suite/build/test/gcc-11-defconfig-lkftconfig/log
https://qa-reports.linaro.org/lkft/linux-stable-rc-queues-queue_4.19/build/v4.19.279-77-gb60454c8d9bc/testrun/16027306/suite/build/test/gcc-11-defconfig-lkftconfig/history/


--
Linaro LKFT
https://lkft.linaro.org
