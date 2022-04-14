Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88F7550181E
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 18:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350285AbiDNQBW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 12:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354437AbiDNPlD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 11:41:03 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42FDBDEBB9
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 08:21:36 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id i196so350894ioa.1
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 08:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+pAklxEG3+PXR2r0+lSNzO9rI9ICP6iqjJt9y4ZtzIA=;
        b=TglNXAtXm182hCZb8FPG7zcwn4kiqh00rn55c1bdDZwrFYNKcYrgH3GqlcJe/Cns6B
         50dGfu5WUtadt3VqqCv4hPXCyjJ8yaeDbA/GW4jHil2MWOZScnip+FPP32SywvGJEpvi
         xMuWSq7E0z+o1Xm4xzFJA5g4mU4dB4rxeH6K1iyeGb7Ua0VaQsaccIxE0W5quYcmxzM4
         QT5e5pYhBWWVf70ycxpWo29lpuS4bk3UlvB1X38dnavFZZ/Zq8XHZQLlIuHPlnVnAs/K
         ZLaKKgq0v48kDvhdIec/QbBZQWBowKMCE64+XYcnlKWMGuyjYDctozCQWW2Cf6M564D6
         epPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+pAklxEG3+PXR2r0+lSNzO9rI9ICP6iqjJt9y4ZtzIA=;
        b=wCjXoZncOxkLsBTBiRUxZ8MoRL1UGUnnuu45+f7WR3+Lz763a55exDiJr1cEk+3y+C
         f+0d0otSfZJ0RFG2JXtiYz/NeENA9fCqmaet5m0QEF7oguCfk+3AQkScbhnwiFyHIoJ7
         B0GwajEa/vKTTwUoURlotjz6acIYTyxLalyHV1XDuUW36Qk3hSiu2kyZrQ8z3e+rIR+H
         GsAEonHkNdR4dMMkEzv7c0HO4h60k452y7BYWZxxHC3g0w0J1/YOp8d06acOTPoFuaiw
         +dm912jYRriF/2YU0W0oc4rqEQHisSkNg5qfM+gc8/OYJYlY4obScqR++A2uDBtiQba8
         +NSA==
X-Gm-Message-State: AOAM532zzOrk99CKErd2G2tK6Ube2NwsNDbWlRQUU+Sm0BFf7IFAzc/H
        hqCgJbGr5leBuZav/TcR3H4DaR0mPCvuQQ==
X-Google-Smtp-Source: ABdhPJyQf00B2o/F0u8R3+hdvXE5PzTDX0Yb5DGX8Ik5a2Uc0K7pXelvVyViK4QKHWZtYQvWZmCnMg==
X-Received: by 2002:a05:6602:3c7:b0:64f:cb21:a8a0 with SMTP id g7-20020a05660203c700b0064fcb21a8a0mr1290944iov.28.1649949695118;
        Thu, 14 Apr 2022 08:21:35 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id x2-20020a056602160200b006463c1977f9sm1365395iow.22.2022.04.14.08.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 08:21:34 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     stable@vger.kernel.org
Cc:     kuba@kernel.org, bjorn.andersson@linaro.org, quic_clew@quicinc.com,
        quic_deesin@quicinc.com, swboyd@chromium.org, elder@kernel.org,
        gregkh@linuxfoundation.org
Subject: [PATCH v2 0/3] net: ipa: backport for v5.15.y
Date:   Thu, 14 Apr 2022 10:21:28 -0500
Message-Id: <20220414152131.713724-1-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series is a back-port for stable branch version 5.15 *only*.
The IPA patches have already been applied to v5.16.y, and they are
not required for versions prior to 5.15.

There was a missing prerequisite commit that prevented building the
code successfully when back-porting to v5.15 was first attempted.
That commit has been added to the front of this series.  All three
commits otherwise cherry-pick cleanly.

Version 2 just adds my sign-off on the first patch (and is rebased).

					-Alex

Alex Elder (2):
  dt-bindings: net: qcom,ipa: add optional qcom,qmp property
  net: ipa: request IPA register values be retained

Deepak Kumar Singh (1):
  soc: qcom: aoss: Expose send for generic usecase

 .../devicetree/bindings/net/qcom,ipa.yaml     |  6 +++
 drivers/net/ipa/ipa_power.c                   | 52 ++++++++++++++++++
 drivers/net/ipa/ipa_power.h                   |  7 +++
 drivers/net/ipa/ipa_uc.c                      |  5 ++
 drivers/soc/qcom/qcom_aoss.c                  | 54 ++++++++++++++++++-
 include/linux/soc/qcom/qcom_aoss.h            | 38 +++++++++++++
 6 files changed, 161 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/soc/qcom/qcom_aoss.h

-- 
2.32.0

