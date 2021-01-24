Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2167F301AE3
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 10:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbhAXJni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 04:43:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbhAXJnf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jan 2021 04:43:35 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2974DC061573;
        Sun, 24 Jan 2021 01:42:55 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id o20so6671968pfu.0;
        Sun, 24 Jan 2021 01:42:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PQ44xik+7XANT2IZc6LuepYmbWe770X4q0h/Z2Y6KZ0=;
        b=ocbfbjE+PcOlCirBDsX3looE6wpG9CM3KRicaLbJhIsE3dABo3LpqmaTEsl7F0cvJJ
         5Xm1Dhebz3hO/X54G3hqHxLoMsYjHYzaxvzwKdTC0w0+/vEdXGw3ikkzs9s8DVSwGX60
         1rk/zt0jH8AbkbM7nOpIw3LSf/xui2V/Bct5Q5vBIt+RnntRUr+HNhXXHysigRKydfnc
         XgsBy6c4qWVYK9XA1R+YaDstSrXUoQMJP8BT+88WlMu5JvulrJNSLQp73+s0oLGcLfE+
         zlix7kk/rX+4zBnP0YyMnDyYaG8qXoitvfBG9ePBujPPQw+GuvJYM1/ws5GgbPZaaPtQ
         +zlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PQ44xik+7XANT2IZc6LuepYmbWe770X4q0h/Z2Y6KZ0=;
        b=mNBc+Hh+tTYjscnG7W3L4Bpz4fW8XB8rtfpmHP1Pp1LYe6RujzgHWRbnbJ4emzGedp
         HKs1moeVTi2kzr9pkr52utGG59TQ6LmTKBhYNMEmFW9yaata1SBtsc9NK3NJAl5B9XmL
         W9ex115+3fPT2MLjTvRbrItNoNjuDrJjwl30TtAsO6cBvbhSPMub/TeM5cATIU1wsV7T
         f8JE61MOIKqYxbLRWwIP7Y5gk6ojKIG/aoYNFFThzf56dHa6iAlPUXYJWbBZWmHd8Gwn
         5PdsPlb8TqEJODaeVhikXG7PSD2o52Ay0/qivKOFh9Z6Z5hPvSnd57elyy/ZBOLgae7K
         dx3w==
X-Gm-Message-State: AOAM532hTAEb6u/T/WIs26GL+qBih1GYBTJ+RtVAiaMXZQ5RBKOOr4Zm
        A99qZ3l9PIhSnmixwOdTQjU=
X-Google-Smtp-Source: ABdhPJylWVk9gJ3aB7g8AYW6A+WAtsMqrJclv+1l46vYVLUKnpqiP266oyIKAa80hT3NspJ9beAnBQ==
X-Received: by 2002:a05:6a00:854:b029:1b7:6233:c5f with SMTP id q20-20020a056a000854b02901b762330c5fmr13120233pfk.73.1611481374763;
        Sun, 24 Jan 2021 01:42:54 -0800 (PST)
Received: from localhost (42-3-19-066.static.netvigator.com. [42.3.19.66])
        by smtp.gmail.com with ESMTPSA id z29sm13352972pfk.67.2021.01.24.01.42.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jan 2021 01:42:54 -0800 (PST)
From:   Qiujun Huang <hqjagain@gmail.com>
To:     paul@crapouillou.net, vkoul@kernel.org, kishon@ti.com,
        zhouyanjie@wanyeetech.com, aric.pzqi@ingenic.com
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qiujun Huang <hqjagain@gmail.com>
Subject: [PATCH v2] PHY: Ingenic: Fixes: compile phy-ingenic-usb only if it was enabled
Date:   Sun, 24 Jan 2021 17:42:49 +0800
Message-Id: <20210124094249.51591-1-hqjagain@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We should compile this driver only if we enable PHY_INGENIC_USB.

Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
---
v2:
Add a Fixes:tag and Cc linux-stable
---
 drivers/phy/ingenic/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/ingenic/Makefile b/drivers/phy/ingenic/Makefile
index 65d5ea00fc9d..a00306651423 100644
--- a/drivers/phy/ingenic/Makefile
+++ b/drivers/phy/ingenic/Makefile
@@ -1,2 +1,2 @@
 # SPDX-License-Identifier: GPL-2.0
-obj-y		+= phy-ingenic-usb.o
+obj-$(PHY_INGENIC_USB)		+= phy-ingenic-usb.o
-- 
2.25.1

