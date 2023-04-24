Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87A3F6ED001
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 16:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbjDXOJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 10:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbjDXOJl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 10:09:41 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BA7A5E7
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 07:09:20 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-2f8405b3dc1so2681666f8f.3
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 07:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1682345359; x=1684937359;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+e6Liem8K70XXf0wfZkdfebMBxwD1YskEbNt6re7ILo=;
        b=oHd+l+mOls4aa6N57uHf5Xxpq5x5rluyb24AfDOtSaeZ5fKKQS6F48jmq+p2HHRsbX
         Plc7iq4v5xT6C9c59C7ZJbsHLC4SRgTHRu1bGNpbGFUClj7RMwCEKzprE4H1WNYtPuyk
         dGeiI4JQndwEWAjCcRGw/0MdPA8TxIjlOptWlKxNOGvNKfOTP6T+CrUXj7A978rFicHx
         EE2eWJbDzwwQf9VuX46KDXTHI/bKTIGPkzgE0VrDMWZlKs2Fw1OV65iT1Mb02MbYMint
         6EmGrK53XOm4MXe3Mfh58TLbUmEXqeQ1qGwvsTFRDkpXJl615O8UFFv+cW1Q05Wq0LyQ
         u8vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682345359; x=1684937359;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+e6Liem8K70XXf0wfZkdfebMBxwD1YskEbNt6re7ILo=;
        b=KuBbJ8wN+Ru8IDPHCU6Rn7YQ3CcMhpzmQFBbFB7FfdS5K3XAcAhFuHVmGDAsURP8KS
         IMkHsVz9hfbnj27saSC640OYVQHub8BryDf7IRlJY0DMj+uFpvOUR7yXv82xcVWJED2B
         59y7wFXMacJcJb13+SZBbH3by+NsxRVpsecsuTM2CukaUinzg5C2sO560/MMbjPiJ44M
         TrDZeH6Ynd/+28+LoX6D0fFm3vTRZ7PkNA1HHI64G7YvJvd7eyoPNO6hhYxuPs+fUIH0
         ywP9RI4M9cwE0JwEwzpVvFAs0XUyzqn6vx2taS2WwtqOe5pIVtIhxB4w3H5wHhsMPxBQ
         qDGQ==
X-Gm-Message-State: AC+VfDxPjdNOd6OjUyHZ0629wiCGemxhZfZTSgIb6JE7cxMYrsxtIOg+
        sYDPaIrMhwNaT3o0z+atk5HuHw==
X-Google-Smtp-Source: ACHHUZ6Sk/a6imDY/42Ob7uZkQeRm8HDtlOUdBWVPskn5eD4GHhjv3MyeCWkZa1HSJRHiyQisCuzDQ==
X-Received: by 2002:a5d:48ca:0:b0:304:7ff3:9b2 with SMTP id p10-20020a5d48ca000000b003047ff309b2mr1297160wrs.39.1682345358761;
        Mon, 24 Apr 2023 07:09:18 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id m6-20020a05600c4f4600b003ee5fa61f45sm15729235wmq.3.2023.04.24.07.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 07:09:18 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH 6.1 0/2] mptcp: Stable backports for v6.1.26
Date:   Mon, 24 Apr 2023 16:09:07 +0200
Message-Id: <20230424-upstream-stable-20230424-conflicts-6-1-v1-0-b054457d3646@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIONRmQC/z2NQQrCMBBFr1Jm7UiaphG8irhI4sQOtGnIRBFK7
 27qwuV7H97fQKgwCVy7DQq9WXhNDfpTB2Fy6UnIj8aglR6U0QZfWWoht6BU52fC/xDWFGcOVdB
 ij3HQY6SLDaNR0GLeCaEvLoXpyNUlHzYXivz53d/Annu47/sX1D52g5MAAAA=
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, stable@vger.kernel.org,
        mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Christoph Paasch <cpaasch@apple.com>,
        "David S. Miller" <davem@davemloft.net>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1310;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=wwy461Gwfpcpa0cZnYPEfeHm78stYVLC5xvQOo8KG88=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkRo2Nf0YGcxa0eCStciXodepJljVP9g6kBTma7
 CEO79FsFtaJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZEaNjQAKCRD2t4JPQmmg
 c4H4D/9gCiQqqb60CKjNTF36wi+DEWgTDxzCRGcWTlut9aTJfsdFhxmpPpZcXLlZDiHzyVtyBT0
 ThyJeBiM5Z25BOChTyJOe9Q+2TkdXH7C9pw/GuumLrfsGQu0EtjVVjYqBWbqiiwNqwJNJnwQvTI
 9eAP9lZzv0yHBoOIdNV8jG1tcyTb+NMMQzZtZJ571QDbU6VdjZUorKNj4YU+Xyg2sv2p6Emqq9U
 iJTfWkJZqgzk7juGZDiGeTltQpj4E0oIdYajBtyfQ2/h2ciEoRoHf7GDhiGigaFTp/Hq/Gf8XRW
 ug2VQciqS5QRQaV+cuSEwlEvXH+pOgDupxSP1USxOoari3DtIpZBCWUHGJYy7ofnwSMNgQxPfYc
 kbqCExlK5SgcAP7+hhKvPHFJlc0hc4MbpYwaHjovhQD1i6hHohk6wx6uZQ8LUirGUdw/3xnFWYR
 71q9RVss6M43voZDUz3cPnGIuDwUKTdFpI4TZKDUM8oq0lj9UCEpFW/ldHp4FU/WJ1FpB4X1RZq
 frmhBl4IDMI2o1z1+Y9gFPqLwSaYe0Ixf6avghB16HQJvC2VLFmBu7feG3z2cIMyGD1aEeAgVqq
 nnoTryIAgn61q1P4WeL9KjaOk3VQxggVUjxhEKLHchSp5gTvrU4P1CeSqeKr9jYSqzTa0KwyyzR
 ngmRcMLkdCVoKcw==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Sasha,

Recently, 2 patches related to MPTCP have not been backported to v6.1
tree due to conflicts:

 - 2a6a870e44dd ("mptcp: stops worker on unaccepted sockets at listener close") [1]
 - 63740448a32e ("mptcp: fix accept vs worker race") [2]

I then here resolved the conflicts, documented what I did in each patch
and ran our tests suite. Everything seems OK.

These patches are based on top of the latest linux-stable-rc/linux-6.1.y
version.

Do you mind adding these two patches to v6.1 queue please?

[1] https://lore.kernel.org/r/2023042259-gravity-hate-a9a3@gregkh
[2] https://lore.kernel.org/r/2023042215-chastise-scuba-8478@gregkh

Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
Paolo Abeni (2):
      mptcp: stops worker on unaccepted sockets at listener close
      mptcp: fix accept vs worker race

 net/mptcp/protocol.c | 74 +++++++++++++++++++++++++++++++++---------------
 net/mptcp/protocol.h |  2 ++
 net/mptcp/subflow.c  | 80 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 130 insertions(+), 26 deletions(-)
---
base-commit: e4ff6ff54dea67f94036a357201b0f9807405cc6
change-id: 20230424-upstream-stable-20230424-conflicts-6-1-f325fe76c540

Best regards,
-- 
Matthieu Baerts <matthieu.baerts@tessares.net>

