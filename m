Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111A247984A
	for <lists+stable@lfdr.de>; Sat, 18 Dec 2021 04:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbhLRDDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 22:03:46 -0500
Received: from mx-lax3-3.ucr.edu ([169.235.156.38]:5313 "EHLO
        mx-lax3-3.ucr.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbhLRDDp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 22:03:45 -0500
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Dec 2021 22:03:45 EST
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1639796625; x=1671332625;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Vhh2Wojmk5xxnlKfiyWrawrHKzGyzr84ZKM1o8pV+po=;
  b=O2XolIVzpNshDbmWywthd0wuB/bUkwUl6OYaRRAF7jv7Cumea2IXQ/lE
   AowwsTxFn3W4w5EMi7bi7CN7H99HSjKO1puFuarKKKEzsTq/Etvba2a3H
   /fjICFIFVcUOXnBdR51PlXWI7qytRlQUpJhA9qZHRZ7Rmz4VmqMKEqHI6
   BhS09jZvKWf9RpzmSKaiS+I6H1v5aoTS4kpWuU0AN3j4OOP1jq23l8c92
   NmdcVc8v51KhTW2SWUQNdXJYHbAoPyqA4v+MoArIiqsNwwG3RphoeYHk3
   skfGoKq7gUm7gA9NcQa7vA5gCLjb+8sS4mOnQId34u5evoXWFsGuXMFKr
   Q==;
IronPort-SDR: zVKZD/iVri8w/MIkgTfj9Nx01V3erOgS9x9xKD8RKMCo6GdZDiMzNeJiqrr/T4NJ1d72mehoZk
 clBwHJT+9k3pIu+D6WdxjHfbBFfuJz9j6wc2Xzl6wQhjCmhjazINA6O1Ig5WOrIjOgVFAlluiS
 y95vojMZdhPubAKhD0xQgwMw2WYDY3dasIPWhS86aU1MNfoFnGoR9jBN/gyPW0YtPE2T5XmfXB
 s2WivV1jA8ZXQO7n4pJ78EQMwvIJYBsR2lKueM94M525caDq+XLsdIOlYdJAxhVLowVL1e6q7z
 haar+dBHsp1rSsgTeae+e8fa
X-IronPort-AV: E=Sophos;i="5.88,215,1635231600"; 
   d="scan'208";a="95150631"
Received: from mail-qv1-f71.google.com ([209.85.219.71])
  by smtp-lax3-3.ucr.edu with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Dec 2021 18:56:39 -0800
Received: by mail-qv1-f71.google.com with SMTP id jr15-20020a0562142a8f00b00410bbd78818so4290419qvb.12
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 18:56:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ucr.edu; s=rmail;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W/oW4xcGaHD/Q9q+L8wKlfwu0bwPMu3EEaXJ1rCZ7r8=;
        b=Q1p+R3mC+VX9kDcyIZHntGkxKhbBd1chuPJ73wN16OAQ/DfnmvLJpQcHRIU2WoU7Zq
         tMDLlXWxqTIUo1WvrzD36E0gfnySwXT6rY6UQs9nb+9GXnekte7W8LvZLG6zEtyWu/Al
         FsP2C5hPSiTsbWEQBzH3/3CSPKY18FDzVtEgk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W/oW4xcGaHD/Q9q+L8wKlfwu0bwPMu3EEaXJ1rCZ7r8=;
        b=GInt8wYF1aE8J0rxqugdJw+yBEQ4tTFO/qm7xz6ELqiHQ4VJSIC85nPuTSQtWYJ4hX
         BLYJ2Aj9XoL8eFwmHo+bTsTSRJD7+UVLdcV7VguOT+lngfKgtcTkco/rtYsDyuylXgKg
         lMeew7v0LDDqM2xju9+qaFuY+99yitq+Bza1YV1/qElZMwY8DyIaxfjcTdu0U8/1D1Kf
         LFbzlL1fCug/gNys9K1D5UNLV9EDRJQ7Ef770C5r2UcHTJHFR5TFJVWdMxzo/o4Oe31Y
         KPeV43Zh6S0/Fm4bOX5OOR+MLc64h2IkPH4SE4Ywb1IuqGaGbpkN0n68RL68zvn6ZJ8S
         orXg==
X-Gm-Message-State: AOAM532gFQm42zpD+4SVotIbmhoNZlzkfKgrh8YfsKtDys5tw9CbDCwg
        kAmIek0lWDt2cj8+FggNridK0o00RwakTzFcBXlhnqmN3EJ5/VAHlbjJX8yPNLzhvpOI9+b3Ele
        B6nwC5pczeG9LkkX0xg==
X-Received: by 2002:ad4:594e:: with SMTP id eo14mr5090067qvb.99.1639796197997;
        Fri, 17 Dec 2021 18:56:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzNSeR5+Y93fUCIc7POaHKnPLRzL0hlcG5CdAYxVV5YFjohfuBdG0RQ94oMtIxeknO4m2da8g==
X-Received: by 2002:ad4:594e:: with SMTP id eo14mr5090057qvb.99.1639796197839;
        Fri, 17 Dec 2021 18:56:37 -0800 (PST)
Received: from kq.cs.ucr.edu (kq.cs.ucr.edu. [169.235.27.223])
        by smtp.googlemail.com with ESMTPSA id m1sm8455617qtk.34.2021.12.17.18.56.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 18:56:37 -0800 (PST)
From:   Yizhuo Zhai <yzhai003@ucr.edu>
Cc:     lyude@redhat.com, Yizhuo Zhai <yzhai003@ucr.edu>,
        stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drm/nouveau/core/object: Fix the uninitialized use of "type"
Date:   Fri, 17 Dec 2021 18:56:30 -0800
Message-Id: <20211218025632.2514288-1-yzhai003@ucr.edu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In function nvkm_ioctl_map(), the variable "type" could be
uninitialized if "nvkm_object_map()" returns error code, however,
it does not check the return value and directly use the "type" in
the if statement, which is potentially unsafe.

Cc: stable@vger.kernel.org
Fixes: 01326050391c ("drm/nouveau/core/object: allow arguments to be passed to map function")
Signed-off-by: Yizhuo Zhai <yzhai003@ucr.edu>
---
 drivers/gpu/drm/nouveau/nvkm/core/ioctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nvkm/core/ioctl.c b/drivers/gpu/drm/nouveau/nvkm/core/ioctl.c
index 735cb6816f10..4264d9d79783 100644
--- a/drivers/gpu/drm/nouveau/nvkm/core/ioctl.c
+++ b/drivers/gpu/drm/nouveau/nvkm/core/ioctl.c
@@ -266,6 +266,8 @@ nvkm_ioctl_map(struct nvkm_client *client,
 		ret = nvkm_object_map(object, data, size, &type,
 				      &args->v0.handle,
 				      &args->v0.length);
+		if (ret)
+			return ret;
 		if (type == NVKM_OBJECT_MAP_IO)
 			args->v0.type = NVIF_IOCTL_MAP_V0_IO;
 		else
-- 
2.25.1

