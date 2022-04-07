Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B5C4F888D
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 22:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiDGUcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 16:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiDGUcY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 16:32:24 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BBFB48E206
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 13:17:02 -0700 (PDT)
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 0A1FF3F9AB
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 20:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1649362618;
        bh=oXbDH3jf9DCCtADiw9ZiV+oTwRq1LbJ3hddxIrjTof0=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=EZW5/9wfPKR8LuVUQ5BgJdDz6HUjflhAwoBb3TkLx2i6pjCD90ZFH/PBSg+YVOlwJ
         dSdHAOAb0u50FISn9xGwRyMg047BSWkW2a9X+ESHQqvNBjyS1xLpdMtknYnK8z7gIc
         yZ52CWwAFtvOhdtoYZKJzqKaIS7gwhX+shUY0U57GNpTVN4ej1GOI0DzjImYAsQM+k
         t1JynsqhTbDZeZ2MJ7IwZlPKvUDkWt/6R0YTzLyQb4YTcWZh3RtsyGbOXKt9S9aE4L
         SMt9PxMOaTiBC06rkl27+jNmsjZrGwKlFHY0bTi2wDpQEKSQrHIZkG6HoS21w3y4Oa
         3ghRjBwrkjcjw==
Received: by mail-io1-f70.google.com with SMTP id y4-20020a6bd804000000b0064c68fa4f70so4364283iob.2
        for <stable@vger.kernel.org>; Thu, 07 Apr 2022 13:16:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oXbDH3jf9DCCtADiw9ZiV+oTwRq1LbJ3hddxIrjTof0=;
        b=Glw2YrtdXO5CWwBOicp38KD6CrugwuFS/QHNGO1Bt1XzzkAeENPLSaOCmX9ZtB1MgU
         qszjpmPeesoICKDAL9mhjQajXSVO5ncofndbu2F/KYyPzw8EGmVTl5fZw8Z8m4pEsaLI
         /oL6tGp4BTsDu4CbP4dV2NqYOGEBD0huNnaKoPCPxe8oagA7Td2V/wqnvey2waTX1Dkq
         0mJyttni5pQvLCntZj7T9A0EzSJsuNVa89UMKWRKa5jMDyCdScxug0+IBvyuptcr3m9l
         Ib9ghW4yx/rgdx/QWZ+LVfkMIUdFrzTWDDEudbARsuJT2XxzBAIUmT9Ol2oDTamKAyAj
         JR8Q==
X-Gm-Message-State: AOAM532tTIcJ7NzwJOgYHu2qFudxLBOQG3jPNQEsVaEeNkmCis5zaeIS
        qQW0d403Cvl0qwdIawdP7fzfVJVD2L/mbPcsfxRDCCpqzFJQbXnlbnx3MhQHZvDLvjOEAjKFgBs
        RIcC3ODusHigiCA+FTBlIsfJzZkQU1YV6eQ==
X-Received: by 2002:a5d:860d:0:b0:649:be05:7b0b with SMTP id f13-20020a5d860d000000b00649be057b0bmr7108007iol.22.1649362615857;
        Thu, 07 Apr 2022 13:16:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwzDnxY2sxNHrVnCIDUBu6DT18zGmV/COtDfuaVDyowEIA+b5xF6Hd/5UWi/TDV68Dkx3UGzg==
X-Received: by 2002:a5d:860d:0:b0:649:be05:7b0b with SMTP id f13-20020a5d860d000000b00649be057b0bmr7107998iol.22.1649362615642;
        Thu, 07 Apr 2022 13:16:55 -0700 (PDT)
Received: from localhost (c-73-14-97-161.hsd1.co.comcast.net. [73.14.97.161])
        by smtp.gmail.com with ESMTPSA id y6-20020a056e02174600b002c7f247b3a7sm13185975ill.54.2022.04.07.13.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 13:16:54 -0700 (PDT)
From:   dann frazier <dann.frazier@canonical.com>
To:     stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Cc:     amirtz@nvidia.com
Subject: [PATCH 5.15.y] Revert "net/mlx5: Accept devlink user input after driver initialization complete"
Date:   Thu,  7 Apr 2022 14:16:42 -0600
Message-Id: <20220407201642.1770157-1-dann.frazier@canonical.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 9cc25e8529d567e08da98d11f092b21449763144.

This patch was shown to introduce a regression:

  # devlink dev param show pci/0000:24:00.0 name flow_steering_mode
  pci/0000:24:00.0:
    name flow_steering_mode type driver-specific
      values:

  (flow steering mode description is missing beneath "values:")

  # devlink dev param set pci/0000:24:00.0 name flow_steering_mode value smfs cmode runtime
  Segmentation fault (core dumped)

  and also with upstream iproute
  # ./iproute2/devlink/devlink dev param set pci/0000:24:00.0 name flow_steering_mode value smfs cmode runtime
  Configuration mode not supported

Note: Instead of reverting, we could instead also backport commit cf530217408e
("devlink: Notify users when objects are accessible"). However, that makes
changes to core devlink code that I'm not sure are suitable for a stable
backport.

Signed-off-by: dann frazier <dann.frazier@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c    | 12 ++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/main.c       |  2 --
 .../net/ethernet/mellanox/mlx5/core/sf/dev/driver.c  |  2 --
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index d7576b6fa43b..7d56a927081d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -793,11 +793,14 @@ int mlx5_devlink_register(struct devlink *devlink)
 {
 	int err;
 
-	err = devlink_params_register(devlink, mlx5_devlink_params,
-				      ARRAY_SIZE(mlx5_devlink_params));
+	err = devlink_register(devlink);
 	if (err)
 		return err;
 
+	err = devlink_params_register(devlink, mlx5_devlink_params,
+				      ARRAY_SIZE(mlx5_devlink_params));
+	if (err)
+		goto params_reg_err;
 	mlx5_devlink_set_params_init_values(devlink);
 
 	err = mlx5_devlink_auxdev_params_register(devlink);
@@ -808,6 +811,7 @@ int mlx5_devlink_register(struct devlink *devlink)
 	if (err)
 		goto traps_reg_err;
 
+	devlink_params_publish(devlink);
 	return 0;
 
 traps_reg_err:
@@ -815,13 +819,17 @@ int mlx5_devlink_register(struct devlink *devlink)
 auxdev_reg_err:
 	devlink_params_unregister(devlink, mlx5_devlink_params,
 				  ARRAY_SIZE(mlx5_devlink_params));
+params_reg_err:
+	devlink_unregister(devlink);
 	return err;
 }
 
 void mlx5_devlink_unregister(struct devlink *devlink)
 {
+	devlink_params_unpublish(devlink);
 	mlx5_devlink_traps_unregister(devlink);
 	mlx5_devlink_auxdev_params_unregister(devlink);
 	devlink_params_unregister(devlink, mlx5_devlink_params,
 				  ARRAY_SIZE(mlx5_devlink_params));
+	devlink_unregister(devlink);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 097ab6fe371c..4ed740994279 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1541,7 +1541,6 @@ static int probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		dev_err(&pdev->dev, "mlx5_crdump_enable failed with error code %d\n", err);
 
 	pci_save_state(pdev);
-	devlink_register(devlink);
 	if (!mlx5_core_is_mp_slave(dev))
 		devlink_reload_enable(devlink);
 	return 0;
@@ -1564,7 +1563,6 @@ static void remove_one(struct pci_dev *pdev)
 	struct devlink *devlink = priv_to_devlink(dev);
 
 	devlink_reload_disable(devlink);
-	devlink_unregister(devlink);
 	mlx5_crdump_disable(dev);
 	mlx5_drain_health_wq(dev);
 	mlx5_uninit_one(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
index 3cf272fa2164..052f48068dc1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
@@ -46,7 +46,6 @@ static int mlx5_sf_dev_probe(struct auxiliary_device *adev, const struct auxilia
 		mlx5_core_warn(mdev, "mlx5_init_one err=%d\n", err);
 		goto init_one_err;
 	}
-	devlink_register(devlink);
 	devlink_reload_enable(devlink);
 	return 0;
 
@@ -66,7 +65,6 @@ static void mlx5_sf_dev_remove(struct auxiliary_device *adev)
 
 	devlink = priv_to_devlink(sf_dev->mdev);
 	devlink_reload_disable(devlink);
-	devlink_unregister(devlink);
 	mlx5_uninit_one(sf_dev->mdev);
 	iounmap(sf_dev->mdev->iseg);
 	mlx5_mdev_uninit(sf_dev->mdev);
-- 
2.35.1

