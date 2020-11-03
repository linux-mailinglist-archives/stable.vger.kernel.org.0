Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 562F52A4B73
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 17:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbgKCQ3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 11:29:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727883AbgKCQ3M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 11:29:12 -0500
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9DBC0613D1
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 08:29:12 -0800 (PST)
Received: by mail-qk1-x743.google.com with SMTP id 12so11289237qkl.8
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 08:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JiRzfR09Qc2pF+19ltfDThXVly8u3TNa2NmUVV+PfKg=;
        b=lwV6Po06e/9ghyO6L9YCrceE9VbyVtfU00TPhDciHMZhT+/kygSm2wO4E/hjGLm98+
         oOwENyl1TjuyHjx2wrngpbQ6SZAa3VMKybq5K/IBJDHBr+OYpI3XDozP0G/f0OuCh26J
         CBDAw/Ek9bHHidM5ZBDi7kd7D45OcsNW0Y6fKKBQ5evgK8sp9LXvIXNhYyhyBrN5xTT/
         V0RQ9b7gKq+O7DWtgMpaPXfaUkz3icd3afP1jjQfDpwovQ4elzXRFHR6HUexcbanKIVA
         NLLqk50y7MtiDae6p03iCUXVF7Rts4xEc9FhO9CDuzKVx2RUv7kPViZlUKvPk/IJgYAq
         NP7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JiRzfR09Qc2pF+19ltfDThXVly8u3TNa2NmUVV+PfKg=;
        b=sOzNHM5im7lAhS0s3zQ6w32dAGgV6ulUnzSg7k1SBL9lwlVPOXNs4tL0QIQE6dwR0+
         4vIFsRBMJYHQxsqT8uh4RE1DQbOl4eJ31Z01jqVkxvyabuRqt0ILGwid2gp9qf/A02VB
         0yoQ0qEWffXy9IX+K2VxPS1DH9E61HwIuqAdkTsnnYx60a6ug8h72PSLdUk3RdExdoFw
         s8RgJ2daUdOItv62pjQVFEtBxWDaixfKJTX0IzbT5nXF1JkrzzAQ2N0I5XfBfSK7Knh/
         wqWuC9C+xFXBo5G8FzLbBSrzwkHcEe1tZ6ImaLi06sl6AbEVQC6RglKSIRj6BwJtd1zD
         ttdQ==
X-Gm-Message-State: AOAM533K7Nn+BUFkIGpQqXXG7cilfrBv0/QTBlefYyLs2KN4vlaZjSqR
        dcSXhu9rstQ/zcQCUbdQNkseaMLI47k=
X-Google-Smtp-Source: ABdhPJyddLPjKzLn38ZuGWCtQgSoDTnYnQRZhWLHFR9FFuUgwG1vS/xyMIARHmUGq3RS41kAriFJLQ==
X-Received: by 2002:a37:4b4f:: with SMTP id y76mr21155397qka.108.1604420951075;
        Tue, 03 Nov 2020 08:29:11 -0800 (PST)
Received: from localhost.localdomain ([71.219.66.138])
        by smtp.gmail.com with ESMTPSA id d48sm10171434qta.26.2020.11.03.08.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 08:29:10 -0800 (PST)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 0/7] backports of upstream fixes for stable
Date:   Tue,  3 Nov 2020 11:28:55 -0500
Message-Id: <20201103162903.687752-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These commits failed to apply cleanly to stable so I have
cherry-picked them from Linus' tree and fixed up the conflicts.
The original uptream commit is referenced in the commit message
as I used cherry-pick -x.

Please apply!

Thanks,

Alex

Alex Deucher (1):
  drm/amdgpu/swsmu: drop smu i2c bus on navi1x

Andrey Grodzovsky (1):
  drm/amd/psp: Fix sysfs: cannot create duplicate filename

Evan Quan (1):
  drm/amd/pm: increase mclk switch threshold to 200 us

Kenneth Feng (1):
  drm/amd/pm: fix pp_dpm_fclk

Kevin Wang (1):
  drm/amd/swsmu: add missing feature map for sienna_cichlid

Likun Gao (2):
  drm/amdgpu: add function to program pbb mode for sienna cichlid
  drm/amdgpu: correct the cu and rb info for sienna cichlid

 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c       |  3 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c        | 71 +++++++++++++++++++
 .../gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c  |  2 +-
 drivers/gpu/drm/amd/powerplay/inc/smu_types.h |  1 +
 drivers/gpu/drm/amd/powerplay/navi10_ppt.c    | 26 -------
 .../drm/amd/powerplay/sienna_cichlid_ppt.c    |  6 ++
 6 files changed, 81 insertions(+), 28 deletions(-)

-- 
2.25.4

