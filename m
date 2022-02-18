Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8637C4BBAC0
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 15:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236110AbiBROgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 09:36:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbiBROgh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 09:36:37 -0500
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B7328198D
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 06:36:20 -0800 (PST)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-2d07ae0b1c4so68308647b3.11
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 06:36:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=mICZMxN16YtpMTKFxVA+ZyzD5lCQCniyHtnn8EqScYQ=;
        b=R9NBEsWl0gsBBSadcoXXR6J0FErdrnZpGQRpVHk4/BiJZn2LSeCFxnmeDS4/7wbdCH
         o9kgvdAmph76nfTTLBDEeh+33gZy0c/b6BzLsK58kKL4flY5Ey4vSCGHRC6vT7qPBo1R
         4JdSJUCH13tgI7ND+jBqhCpssVUfcVhjpjSF06T7ds3xqYNDu5rQKlcSAvs3WW3k4int
         66+Q9K4NL4402fl1jJ7LHMQB99LQZkFg8Z6mYod7soqht52ejpoOFfRYbV1hegcasOHz
         UnMMMg9bTdR01BZFcZ+Xjcgf+9raOKWFnwJ9wT8QyUoGCLbwuI/8kWzAHlu8XdEYxS20
         JwKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=mICZMxN16YtpMTKFxVA+ZyzD5lCQCniyHtnn8EqScYQ=;
        b=GfKG3MixoVumOvVHxOUSk6x8Qt+tfsPUZzfTpFTEUlxhQjykQLcqpn4eEF1hCoY5Rr
         QoxJUt2StP5S3gPPVf6f8Td9LRpshim0L0zTnvcvlZWCKlcsvAZGx26cIOyYIIeISl5G
         apMTAedHHjm8EtU2pEY6XIzw4D0QTeH8qf93oWCYjCAcy98/TTJrtSqiED9HvNFksb4o
         sNQp0FL1p4hNGH3tf31vziM2Cd/x3EJERSjI/6c+IbPr2gN2Iq2vTf2y5GeQqJ4gl46v
         BjlMM5xc9cfOvX2g9omWN8JTzv+4az2PUHl8SL6JaKl50pTRGHFkEImqf2wCzzBHbH9d
         I9lA==
X-Gm-Message-State: AOAM531tVY1chFXJ7guxwfC5dTg5JaG1NyhggcZYOKANvlXXHj9PkgLR
        pzu7lBl8aNyMZtda5SRP4tAE5EoCa5Af8kd3Lzn4VBBamJdq2g==
X-Google-Smtp-Source: ABdhPJyP0ir08LgmNUZzfFvqHe8q7R74bxjiJgULJ0YAKtO3BKH/7StWB0useQjcjqoh0S+rHwLEiDuVw0UMuUaukqU=
X-Received: by 2002:a81:5454:0:b0:2d0:e7d6:ebac with SMTP id
 i81-20020a815454000000b002d0e7d6ebacmr8189188ywb.166.1645194978971; Fri, 18
 Feb 2022 06:36:18 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 18 Feb 2022 20:06:06 +0530
Message-ID: <CA+G9fYuDLxwN97GdYhyQ2kz=WD1ASKE4HzDC1GKfrhPvk2xaXA@mail.gmail.com>
Subject: stable-rc/queue: 5.15 5.16 arm64 builds failed
To:     linux-stable <stable@vger.kernel.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Lars Persson <larper@axis.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While building stable rc queues for arch arm64 on queue/5.15 and
queue/5.16 the following build errors / warnings were noticed.

## Fails
* arm64, build
  - gcc-11-defconfig-5e73d44a

Committing details,
optee: use driver internal tee_context for some rpc
commit aceeafefff736057e8f93f19bbfbef26abd94604 upstream.


build error / warning.
drivers/tee/optee/core.c: In function 'optee_remove':
drivers/tee/optee/core.c:591:9: error: implicit declaration of
function 'teedev_close_context'; did you mean
'tee_client_close_context'? [-Werror=implicit-function-declaration]
  591 |         teedev_close_context(optee->ctx);
      |         ^~~~~~~~~~~~~~~~~~~~
      |         tee_client_close_context
drivers/tee/optee/core.c: In function 'optee_probe':
drivers/tee/optee/core.c:724:15: error: implicit declaration of
function 'teedev_open' [-Werror=implicit-function-declaration]
  724 |         ctx = teedev_open(optee->teedev);
      |               ^~~~~~~~~~~
drivers/tee/optee/core.c:724:13: warning: assignment to 'struct
tee_context *' from 'int' makes pointer from integer without a cast
[-Wint-conversion]
  724 |         ctx = teedev_open(optee->teedev);
      |             ^
drivers/tee/optee/core.c:726:20: warning: operation on 'rc' may be
undefined [-Wsequence-point]
  726 |                 rc = rc = PTR_ERR(ctx);
      |                 ~~~^~~~~~~~~~~~~~~~~~~
cc1: some warnings being treated as errors



--
Linaro LKFT
https://lkft.linaro.org

[1] https://qa-reports.linaro.org/lkft/linux-stable-rc-queues-queue_5.16/build/v5.16.10-87-gb5b4ed62d295
[2]  https://qa-reports.linaro.org/lkft/linux-stable-rc-queues-queue_5.16/build/v5.16.10-87-gb5b4ed62d295
