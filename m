Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34DE14C1F6A
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 00:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235448AbiBWXPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 18:15:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236982AbiBWXPU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 18:15:20 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B931257B06
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 15:14:51 -0800 (PST)
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 4255D3FCA6
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 23:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1645658090;
        bh=SdSFtO1rSinMLHqycdPYTP37a9+JdTLx2fBuhSKZuRk=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=p2CUkxr+3w43ER7ImhIXu9Tmgsv4XZfVHDpu9B7GgMA5HSz5CoLHyuVI2XDR7HK2P
         UAhA3GWtHa21x0hZb1XEq3SEWR/J/LEVV4LfPaAWgdWazOV42CAoI85MXwnmCubwqu
         dfHsnkwCGYMamUhJ/oAC/7Kizy4Y58cZwhqCuoVDUrofYMXodT8v6MqT+h0Q0/d7wc
         xA7uZvJ6xD2GCCzhFUFnepgV1lYFuzln3yiqNt7PQF1CawPjs9rzfeTCtO0pIUhLKb
         IFOCd9UEpE0W6Uk3vTiCAa/RVvicm6f44NfoV+zbw+k9fVOpNrkNhXGzkWqR3z49JX
         qsDa/kFuQY6Kw==
Received: by mail-io1-f72.google.com with SMTP id y11-20020a056602164b00b00640ddd94d80so363546iow.11
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 15:14:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SdSFtO1rSinMLHqycdPYTP37a9+JdTLx2fBuhSKZuRk=;
        b=L2QOMb+G1C0NmqJInWFjTP5I3EtjylsOursjs5hJZGmxgtH7I83OQ+AAWWwMNJXwhr
         2//UbI2vs92wXonLJgXpgNCkHBzaJxWOoCwfHbLE0YWB89l1OtZ8NHnDhszkZErNa84d
         ZOEZVYSNqy/GPmse2ZNCkKB8M6D7Hdx/tv1cjG1zIBIitXSZyPiJHfnGsqw7aT4nsbIY
         kwEU3pvFQM2E+j0EUk/UnclnMOCYtuglIYdWrN2EzZakM3K1y1aV4Nu0lYitMDdw5JW5
         AmhmAUfzn6s2eBZAlPQAV7LgF6KxDan+QqHzL/I3zRHHUh4tUu0oVrSuwpszFVPoBuJb
         8eYg==
X-Gm-Message-State: AOAM531JEadCDHEeotNYlsqWR7Gv++SurtJDB6PiknK2ib3qemVAwK3t
        QyYDKCZf+ZJ7MlaFXdMfpYfmm59F/nWT7/X/5948SnBT6L7nHPJE+5bseZiauxpQIzRFaNoObfA
        JI2V5AdyUKtMbJ3W3gl7fIGPi5tn5KYiNUw==
X-Received: by 2002:a92:c549:0:b0:2b7:4d6a:fb4d with SMTP id a9-20020a92c549000000b002b74d6afb4dmr1662864ilj.270.1645658088427;
        Wed, 23 Feb 2022 15:14:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx1BrqZ77hWVHGzSb5+JM7iuCPbrLWhhV1TbLMhAMuXemHoGje+b2cbiBpPg8S6TAHeVpu/zg==
X-Received: by 2002:a92:c549:0:b0:2b7:4d6a:fb4d with SMTP id a9-20020a92c549000000b002b74d6afb4dmr1662848ilj.270.1645658088190;
        Wed, 23 Feb 2022 15:14:48 -0800 (PST)
Received: from localhost (c-71-196-238-11.hsd1.co.comcast.net. [71.196.238.11])
        by smtp.gmail.com with ESMTPSA id r7sm637219ilm.55.2022.02.23.15.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 15:14:47 -0800 (PST)
From:   dann frazier <dann.frazier@canonical.com>
To:     stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Alessandro B Maurici <abmaurici@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4] lan743x: fix deadlock in lan743x_phy_link_status_change()
Date:   Wed, 23 Feb 2022 16:14:32 -0700
Message-Id: <20220223231432.186725-1-dann.frazier@canonical.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit ddb826c2c92d461f290a7bab89e7c28696191875 ]

Usage of phy_ethtool_get_link_ksettings() in the link status change
handler isn't needed, and in combination with the referenced change
it results in a deadlock. Simply remove the call and replace it with
direct access to phydev->speed. The duplex argument of
lan743x_phy_update_flowcontrol() isn't used and can be removed.

Fixes: c10a485c3de5 ("phy: phy_ethtool_ksettings_get: Lock the phy for consistency")
Reported-by: Alessandro B Maurici <abmaurici@gmail.com>
Tested-by: Alessandro B Maurici <abmaurici@gmail.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/40e27f76-0ba3-dcef-ee32-a78b9df38b0f@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[dannf: adjust context]
Signed-off-by: dann frazier <dann.frazier@canonical.com>
---

The patch this Fixes: was applied back through 5.4.y. But this fix for it
was only applied back through 5.10.y. It did require some minor context
adjustment for 5.4.y, perhaps that is why? At any rate, this looks to
be a fix for a problem one of our users reported on our 5.4-based kernel.

Compile-tested only.

 drivers/net/ethernet/microchip/lan743x_main.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 22beeb5be9c4..c69ffcfe6168 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -916,8 +916,7 @@ static int lan743x_phy_reset(struct lan743x_adapter *adapter)
 }
 
 static void lan743x_phy_update_flowcontrol(struct lan743x_adapter *adapter,
-					   u8 duplex, u16 local_adv,
-					   u16 remote_adv)
+					   u16 local_adv, u16 remote_adv)
 {
 	struct lan743x_phy *phy = &adapter->phy;
 	u8 cap;
@@ -944,22 +943,17 @@ static void lan743x_phy_link_status_change(struct net_device *netdev)
 
 	phy_print_status(phydev);
 	if (phydev->state == PHY_RUNNING) {
-		struct ethtool_link_ksettings ksettings;
 		int remote_advertisement = 0;
 		int local_advertisement = 0;
 
-		memset(&ksettings, 0, sizeof(ksettings));
-		phy_ethtool_get_link_ksettings(netdev, &ksettings);
 		local_advertisement =
 			linkmode_adv_to_mii_adv_t(phydev->advertising);
 		remote_advertisement =
 			linkmode_adv_to_mii_adv_t(phydev->lp_advertising);
 
-		lan743x_phy_update_flowcontrol(adapter,
-					       ksettings.base.duplex,
-					       local_advertisement,
+		lan743x_phy_update_flowcontrol(adapter, local_advertisement,
 					       remote_advertisement);
-		lan743x_ptp_update_latency(adapter, ksettings.base.speed);
+		lan743x_ptp_update_latency(adapter, phydev->speed);
 	}
 }
 
-- 
2.35.1

