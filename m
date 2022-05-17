Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2B75295DA
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 02:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiEQAIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 20:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbiEQAIl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 20:08:41 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8718DAE6E
        for <stable@vger.kernel.org>; Mon, 16 May 2022 17:08:40 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2fecfc7a95aso58245457b3.22
        for <stable@vger.kernel.org>; Mon, 16 May 2022 17:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=xXfmk9THNxFLTjiR20rdY0JYzx/jlDpsm6dSlkEJ0EM=;
        b=BSYn2uXFQOjCS7BNv45Wk4Ui/KG1HEjz7hFeTt0r90CjmlBTgjKvMcag+qLYfFDsS3
         WNhyRJ0PNT6iOZ9nwzv0TRnIVcRnfRmiceM87QxsurDDoq1cr2b5Mm0JT+CY084Tkqnh
         YOS3t890kiuAc2+Tsi0Noh7XFWn8ZnHEkjtJ2slEuwt+iBX/lOQpujgD3EFi+5NiZVX1
         F0r7G4lYdUciyxGaYp6hw+jWB3SMnz7TSouuwpyzgb6LBx7YqbMV2dOlX3bMVevxCwqx
         +Fy+eO7ZBCy00ZABM9ftcHViE/1MxSjVEiOW+A/dmb4pCVx08pujaDYr7NB/A9txsQL8
         15NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=xXfmk9THNxFLTjiR20rdY0JYzx/jlDpsm6dSlkEJ0EM=;
        b=H1Hwhxr9sVAUuwEACcJmhIR/bEhYKDFr+TWEr4AgBUYEtt8i4bJFKLGsz3CbsgjAnt
         TIqavGwkuioY+2JP+xlEwwBcNW3ACET45FxBUmSrHtwzCY9Wb8/m9DZg6YEJN1jtJybK
         one1QhbYNub+3djYnifJzf+NPyf6s3RjnKqYs8lkqJSn1Z7j/yo9XzIoT06LTc2O3v8G
         Gc2FMq+dQcCC6M1SAS0USTzAl2m3s3ilZ0Tu2fUuCy+saNtxHbm0cVDlUbHWNBT6dmwc
         cqJ/pDvRcGjSJTbz3wYhzzZZvk8TGF9mXlbuy6gUrejg+CJDXK21byAZoFurRYpI7eaL
         /bOg==
X-Gm-Message-State: AOAM531ofVvYuVbcg+2/yTPvIvfVYbnqr7aZb89P8aAXKUxrPtz8EGsR
        swYG457/PcRHrcn1O7Xxy3AQ2/34yc5as/w0jFcOicq6StLWyWsTw+44MWQLEGmenenXZ9W7LYJ
        qikpRW3RFeIyHuS9qKtb/bk07VJjQusEpmyjxm8NFy0CGVBfuvjzOab7p34CTZoBl
X-Google-Smtp-Source: ABdhPJyteGdgc01+rBc7/S/ziRKK+S9sMqFzuozTyzLeKFzU3TF/D5U8ujOy8cu60n0IU4M2LHGkD7h/LAVt
X-Received: from gthelen2.svl.corp.google.com ([2620:15c:2cd:202:c23e:864e:4846:4ac0])
 (user=gthelen job=sendgmr) by 2002:a5b:b91:0:b0:64d:e020:e420 with SMTP id
 l17-20020a5b0b91000000b0064de020e420mr3888983ybq.209.1652746119683; Mon, 16
 May 2022 17:08:39 -0700 (PDT)
Date:   Mon, 16 May 2022 17:08:35 -0700
Message-Id: <20220517000835.2450573-1-gthelen@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH 5.10] Revert "drm/i915/opregion: check port number bounds for
 SWSCI display power state"
From:   Greg Thelen <gthelen@google.com>
To:     stable@vger.kernel.org
Cc:     Jani Nikula <jani.nikula@intel.com>,
        Greg Thelen <gthelen@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit b84857c06ef9e72d09fadafdbb3ce9af64af954f.

5.10 stable contains 2 identical commits:
1. commit eb7bf11e8ef1 ("drm/i915/opregion: check port number bounds for SWSCI display power state")
2. commit b84857c06ef9 ("drm/i915/opregion: check port number bounds for SWSCI display power state")

Both commits add separate checks for the same condition. Revert the 2nd
redundant check to match upstream, which only has one check.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 drivers/gpu/drm/i915/display/intel_opregion.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_opregion.c b/drivers/gpu/drm/i915/display/intel_opregion.c
index 6d083b98f6ae..abff2d6cedd1 100644
--- a/drivers/gpu/drm/i915/display/intel_opregion.c
+++ b/drivers/gpu/drm/i915/display/intel_opregion.c
@@ -376,21 +376,6 @@ int intel_opregion_notify_encoder(struct intel_encoder *intel_encoder,
 		return -EINVAL;
 	}
 
-	/*
-	 * The port numbering and mapping here is bizarre. The now-obsolete
-	 * swsci spec supports ports numbered [0..4]. Port E is handled as a
-	 * special case, but port F and beyond are not. The functionality is
-	 * supposed to be obsolete for new platforms. Just bail out if the port
-	 * number is out of bounds after mapping.
-	 */
-	if (port > 4) {
-		drm_dbg_kms(&dev_priv->drm,
-			    "[ENCODER:%d:%s] port %c (index %u) out of bounds for display power state notification\n",
-			    intel_encoder->base.base.id, intel_encoder->base.name,
-			    port_name(intel_encoder->port), port);
-		return -EINVAL;
-	}
-
 	if (!enable)
 		parm |= 4 << 8;
 
-- 
2.36.0.550.gb090851708-goog

