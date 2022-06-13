Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87B20549B26
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 20:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244964AbiFMSKd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 14:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244839AbiFMSKH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 14:10:07 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7EC880C9
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 06:59:46 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id x62so7260483ede.10
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 06:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=MhFx2AEsWTiVTgmCZAb4BbYQKJ3l8cjVI2GSOLedpHM=;
        b=FieYKowYx/1Wx7ArBl7nNlApTw8APh9U3b6aknuwxJC0LMbYCmw0/PComrEAZYpZRW
         R/1IFbZrEow2kOC/tgRK/H86IBMSNIbTV/I4NdeMLlVRutiSU0Wt4JunkSwyK92Z1w4Q
         wFhbddBAO8ZQiqCg4CZ5VJ5R08bMoqS52CBxRq/ksjwp+/SEqMx+XsJ8izgWItmAED0E
         cCUgdC2S8CNptxaV0Axyzbzel4sJMRD1c2ibo+JvlYN9fmYJ6XijdcJ91t22zQ1UEgDN
         Tt3SKbzfAoBerI/2/USTZTc9MdAG4OnySDmviQ+4OtSI7Rwhdi8BXoAVCbEH7Hk4Gvkb
         4RQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=MhFx2AEsWTiVTgmCZAb4BbYQKJ3l8cjVI2GSOLedpHM=;
        b=H46jIRpzL3mXpgBSsa3L6wdP7xHIm4MY8188Em7I5w6JNW/0oFw2hd54ROLaD9Ucum
         QukBBWCOn8IkqP8k89OqwCNtS8aH8RqVgQU0ITXQf2c9FU5aaAPWPALv8ulaZ0Nj9kfh
         SlYDecA3v8FCdP7JpAF6HY8KHByXOft26gwHQHx+Pel6pwGXMUlnlt4YPr6UvsI6bsnm
         4ljy6B/Xr1xYf9LNmZ9Fya39GARLURBWX+Sluvjztr+lJqTWfyj5fgvfgqlI6hC3VgNv
         vCNIVqTGlDB1Sni+cpjmLc2wJ5MMar9U0RnqzV2FXLGVk4wNWHz2ori9xraX7ypnefxH
         lAhA==
X-Gm-Message-State: AOAM531fq6f0B4G+odZUGMcmlO88gpl203SO3f1gZlxAX938fXV4SbAm
        3vM/TWQAtcBkn0lRKGIoM/w8UNa4kWBm9rlmUGOED6M90o4=
X-Google-Smtp-Source: ABdhPJy/ehZS/Af0y7Yb6kQsYgJ+dYVatacZbSWm40jtlk2H1JHmUnxN/mS+8grtcYc2t2eeoNLCENGjHcS9Zk+Nk1I=
X-Received: by 2002:a05:6402:4396:b0:42f:b88e:5429 with SMTP id
 o22-20020a056402439600b0042fb88e5429mr53760466edc.298.1655128785015; Mon, 13
 Jun 2022 06:59:45 -0700 (PDT)
MIME-Version: 1.0
From:   Adam Ford <aford173@gmail.com>
Date:   Mon, 13 Jun 2022 08:59:34 -0500
Message-ID: <CAHCN7x+8dcUkE_n+EEtYnKU=3=VMQ7kXSBB8vWZ-JP1KeiUe9Q@mail.gmail.com>
Subject: arm64: dts: imx8mn-beacon: Enable RTS-CTS on UART3
To:     stable <stable@vger.kernel.org>
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

Please backport 5446ff1a6716 ("arm64: dts: imx8mn-beacon: Enable
RTS-CTS on UART3") to 5.15+

This fixes an issue where attempting to use hardware handshaking on
the DB9 port fails.

Thank you,

adam
