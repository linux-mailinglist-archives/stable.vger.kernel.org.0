Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D528E4D372D
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 18:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237007AbiCIRFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 12:05:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239473AbiCIRFC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 12:05:02 -0500
Received: from dvalin.narfation.org (dvalin.narfation.org [213.160.73.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A509DCE2C
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 08:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1646844365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=blJ9I7ldNWiYziJCrOZk0Py29a8J6nGmp/OGvs6JS7A=;
        b=MAnDM3gm8czpsYKnWM4dR+hvy2SRR91ZLrkVmfaKnYC/jSUlh2TIW9HsPJbANWIZBQCFpQ
        sVIhxJNek+vdmvU/wYb8sPV2OqJmuzsS9Z7Gsll9jZQZdRmCaO7bqFjAJsteNrHYjAaByA
        feyz4WwGpubbrVTEcD0U5SEEcUOyGC4=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 4.9 0/2] batman-adv: Fixes for stable/linux-4.9.y
Date:   Wed,  9 Mar 2022 17:45:40 +0100
Message-Id: <20220309164542.408824-1-sven@narfation.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

following two patches were backported "automatically" applied in
4.14.y, 4.19.y, 5.4.y, 5.10.y, 5.5.y and 5.16.y. But they failed
to apply cleanly in v4.9.y due to some changes in the patch context
and one missing function in the older batman-adv version.

These problems were now fixed manually.

Kind regards,
	Sven

Sven Eckelmann (2):
  batman-adv: Request iflink once in batadv-on-batadv check
  batman-adv: Don't expect inter-netns unique iflink indices

 net/batman-adv/hard-interface.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

-- 
2.30.2

