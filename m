Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E84B59FD8A
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 16:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236248AbiHXOsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 10:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237112AbiHXOsL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 10:48:11 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3857D792
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 07:48:10 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id h24so21060501wrb.8
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 07:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=ZjqB1S6EBYp+nhqQhoseoRfWLH3D3hlZAFeYBHq074M=;
        b=ejF4UF5gmjiLV8bdnt0cmi9iY83xQ1AathDKNCmyc7G1xHLyKcpTpL7QYlMYY6NNu3
         u5jecBRx9b0/XoxOrnfwIF82rE6uk9R0iEpp4Rlw3tsFgW4RXAesVxVVajkNkHAJRv0r
         tKensK/XP1igEz8+R9bmv8uCDZZheRRfuZC6pBxXcT6aMvsbA4kcXKNyhiy3uZCiJZPm
         YEvJi/Bwfgd6W340mLkSu44G73LIRqVmSXZzCqAadku6uyUNmkclEndjaJTOYNi706Qu
         oB7hBm5c0Zxz8Qz6OausriJVZTyWcvH+bRWLMq7cnxLFIuLiRpsKKdJCcoy/fSTAjSI9
         kx8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=ZjqB1S6EBYp+nhqQhoseoRfWLH3D3hlZAFeYBHq074M=;
        b=SJat0ntEOgBOtPv5xIQnTuQ/Jtdy9Xu/q+/LTwJ0JtX6Rdg9A76gk3rFOS+Xz06d9w
         RtTwyTbAFgKfzQWYdSUWIl9M2KCvRRqMUu7aNbTL5U00wlq6Mwq97XztycRExWM79ZVj
         2b9AldKAX/eQ2+q3VDflWGXeX2gMGLWtiJkVoVWUbMHjPuD8O/7kLDEM/qKEOb3VcK+p
         IKf8JXHvakc1xQZ+aSCqbmdJd6OOrMr9Wztev6n2oCbgs1+n36/OaCp8Igb/EwIwiP78
         olDm32H5R6Y0078HGZVNtNImsrl2Bkef/fQKEcTn0Iu+Znk+JC3mGrVPn9K2cu8oRpFN
         Qp6A==
X-Gm-Message-State: ACgBeo3LBLs6GK5O4yakw2yhooF1SqjgP+AsPdpRA9qJkNxUvGKYmdFn
        l9f3pmcTtEHCYhQ1PUl9f2p2paG94nzBS/pv
X-Google-Smtp-Source: AA6agR7peIEGE6rFulIupAMXq5OyfryiEeXNV/85lPbOSoIIuRp00MiqQZe7H5f0hD0/KMFFeMTM2A==
X-Received: by 2002:a05:6000:186f:b0:225:5b8d:fc89 with SMTP id d15-20020a056000186f00b002255b8dfc89mr7920495wri.577.1661352488902;
        Wed, 24 Aug 2022 07:48:08 -0700 (PDT)
Received: from localhost.localdomain (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id m6-20020a056000008600b0021d6dad334bsm17277031wrx.4.2022.08.24.07.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 07:48:08 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, raajeshdasari@gmail.com,
        ovidiu.panait@windriver.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH 5.4 0/2] Revert BPF selftest fixes in 5.4.y
Date:   Wed, 24 Aug 2022 15:43:26 +0100
Message-Id: <20220824144327.277365-1-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Rajesh reports [1] that the test_align BPF selftest is broken in
5.4.210. Three patches were added since 5.4.209:

(A) 7c1134c7da99 ("bpf: Verifer, adjust_scalar_min_max_vals to always call update_reg_bounds()")
(B) 6a9b3f0f3bad ("selftests/bpf: Fix test_align verifier log patterns")
(C) 6098562ed9df ("selftests/bpf: Fix "dubious pointer arithmetic" test")

(A) fixes an issue in the BPF verifier, which changes the verifier trace
output. (B) fixes those trace changes in the selftests.

Unfortunately (B) also address changes to the verifier output from other
patches that weren't backported to v5.4, so the test now fails.
(C) also addresses a different verifier change that is not in v5.4.

Therefore revert (C), and partially revert (B).

[1] https://lore.kernel.org/all/CAPXMrf-C5XEUfOJd3GCtgtHOkc8DxDGbLxE5=GFmr+Py0zKxJA@mail.gmail.com/

Jean-Philippe Brucker (2):
  Revert "selftests/bpf: Fix "dubious pointer arithmetic" test"
  Revert "selftests/bpf: Fix test_align verifier log patterns"

 tools/testing/selftests/bpf/test_align.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

-- 
2.37.1

