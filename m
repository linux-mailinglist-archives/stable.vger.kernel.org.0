Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B37D2793CA
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 23:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbgIYVzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 17:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbgIYVzd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 17:55:33 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553E0C0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 14:55:32 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id k25so3626609ljg.9
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 14:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i6oMAURkfpsM1dUr55Vm2bufPN+8aF78G8f5BFLLR3A=;
        b=Dely0EKLau8IdL+nmqudTWOrZEDuMKsHtwbTN+Mq3/wE2V4qnSFfzqyZvmURYLANuU
         xSyUT8rfi4ZPe8YK4Uezz2oqLqzwXqT99D11x9RIVnyhCc45WjfyfpG8wCZWbW2WjG2N
         NQDXGnB9v4619n4KwHtsNwoR7N/5m1Nc6613PIJ1aVUB54m0ocrhLQTfT0QZWSqsc+mT
         jIzHDLhrM2t6QtHrm3c7DO0VzEe7ZUDozMx4uvuWJuNu6SyJlDHLlfvFoPRHasS1XqNC
         B6B0pjWRx0+rFmDjglE7D3vWINQxwAoMq5GKvtfrJcIj9R08QnRdK3qFDNKLKC02xNEA
         mWWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=i6oMAURkfpsM1dUr55Vm2bufPN+8aF78G8f5BFLLR3A=;
        b=oddFtbs9ocM77KS8Ucdj2m15++WoyzotLhHi58faQeGALJNwXy773QU3ChrlOUP3r/
         VUmgXSXwyhMsQyyQwuavUykI95PDBBaz85iAghCewixoxubsADOUTUIxg4Wdhbn64mTe
         27E4rufQRE6bNAvBB8E1p2I3E/IkUNak23afr5GIVncfcy69rsiG+6ITVx4HicxJR+tD
         IO2bGUcAv1sUqWD4e03BrreXQ/s/vgKloz5Olg1Mr64Kzm30pUXnhFlDe97LA+1qt9B9
         gwWiWxU5q8QpsNbdcmqf/xauD+5an9tMuLr8+TAkSe8VbfDl/SwVeuMvrv3Om7AheJu3
         pcTQ==
X-Gm-Message-State: AOAM530sv87/70TydfEbu3wqzt53zKxd1RELPP0XSEYSFQjZaQcYJXyf
        eYqTj5PEkUP66hDhugWKYLY=
X-Google-Smtp-Source: ABdhPJxIf8FGzG2G3JmzwlnNX51K9ts8L4rukeGTKUh4OsuMTdytpe0dTkcn46fNV0lf5jOQyhdNww==
X-Received: by 2002:a2e:8153:: with SMTP id t19mr2079197ljg.334.1601070930792;
        Fri, 25 Sep 2020 14:55:30 -0700 (PDT)
Received: from saturn.localdomain ([2a00:fd00:805f:db00:3926:b59a:e618:9f9c])
        by smtp.gmail.com with ESMTPSA id j8sm261277lfr.80.2020.09.25.14.55.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 14:55:30 -0700 (PDT)
Sender: Sam Ravnborg <sam.ravnborg@gmail.com>
From:   Sam Ravnborg <sam@ravnborg.org>
To:     dri-devel@lists.freedesktop.org, Heiko Stuebner <heiko@sntech.de>,
        Thomas Zimmermann <tzimmermann@suse.de>
Cc:     Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Sandy Huang <hjc@rock-chips.com>, stable@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH v1 0/2] drm/rockchip: fix build + warning
Date:   Fri, 25 Sep 2020 23:55:22 +0200
Message-Id: <20200925215524.2899527-1-sam@ravnborg.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix a newly introduced build breakge in drm-misc-next
Patch 1/2 should be applied to drm-misc-next

Also fix a warning in the same driver - the warning is present in v5.8
Patch 2/2 is a drm-misc-fixes candidate

	Sam

Sam Ravnborg (2):
      drm/rockchip: fix build due to undefined drm_gem_cma_vm_ops
      drm/rockchip: fix warning from cdn_dp_resume

 drivers/gpu/drm/rockchip/cdn-dp-core.c      | 2 +-
 drivers/gpu/drm/rockchip/rockchip_drm_gem.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)


