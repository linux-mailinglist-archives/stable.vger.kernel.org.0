Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3F54FF952
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 16:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233478AbiDMOuh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 10:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiDMOug (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 10:50:36 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C909A644C3
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 07:48:15 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id q11so2139866iod.6
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 07:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jtRc6QXWQkbIq0/poXr9GBsVz7MozDYCv+wgZHr1xfo=;
        b=fV7LsnNOAGKCxt3GTMGVDJvWK5RrnzqU0vrtAf/ErIOYJuPK0XXvp1ucEoGXxeUBD9
         PEBSqtJ/efre5xpAYSQ/qaCYP1xBK8AsgGoaFcbHug6siE/a47avzdR3JCmgl/HBqNBD
         DZ3mUu2MUxRLqdYr0rHd5X/RdOo1yCxaduhZOmlwBflb0vQFED+RTydkL2JGSZ99hCNZ
         4OUR1U1S9gyXO4d8uZIPQTJR5QFYNvKY5vJoFrbzfuQecJ8zs2IyNI7q3PdPaNwfx1+b
         57/v7T4RAy+VaIoSwb9NMX+H8ciI8JaTNgXxmrL5WRxkBrGUyxFjXNq3RNqJW3ZBzni+
         PTuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jtRc6QXWQkbIq0/poXr9GBsVz7MozDYCv+wgZHr1xfo=;
        b=0Gm0RQltra9T9rvlbTKP95OzMSFC0Et00gZMxknMYIHNhOisL9l8iw+usJ4RIfhlCw
         wRbjJGMSVGqX9vdUjziFAbOegNnMBY7KjSujhtuUS+faG79NW/hEF4XMjpOqDssgeb2Y
         rmcSsTavm8iWkvmlTxBjHv6jG3D0cBuJIKH7QKFMxhB7rK6mPc1GqnMeG+O5nNRuG4Dj
         7FpCI0WkjLR65C1h9tnMGKCziyvx+RH5E1wWxtOUIMfAzDi4gB8XtMVbbi992AJaHUFj
         n2HBChSmktvFJsZNlWcQ7N17ibGEqirnwhW9snuzq87+zLpWPFXbqlk4Jz0D0qUp6I/E
         Ej7g==
X-Gm-Message-State: AOAM532iB0N90miWPDG2Go0eVesUURNZ0rwbUVku+wlOtw2sA71/tZZL
        LyrXs5LtCSRYT5YGPQ4J63c+c1e40XdUwQ==
X-Google-Smtp-Source: ABdhPJzNJHiz0qy+IgmHvg76pLt3qbgCEHE0zWxpYlfK4H3MEAIXFb2q0YknAx0gL3cD8jgXDBihXA==
X-Received: by 2002:a05:6638:328e:b0:326:3501:d923 with SMTP id f14-20020a056638328e00b003263501d923mr6191657jav.19.1649861294831;
        Wed, 13 Apr 2022 07:48:14 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id u15-20020a056e021a4f00b002c665afb993sm108381ilv.11.2022.04.13.07.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 07:48:14 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     stable@vger.kernel.org
Cc:     kuba@kernel.org, clew@codeaurora.org, deesin@codeaurora.org,
        swboyd@chromium.org, bjorn.andersson@linaro.org, elder@kernel.org,
        gregkh@linuxfoundation.org
Subject: [PATCH 0/3] net: ipa: backport for v5.15.y
Date:   Wed, 13 Apr 2022 09:48:08 -0500
Message-Id: <20220413144811.522143-1-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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

