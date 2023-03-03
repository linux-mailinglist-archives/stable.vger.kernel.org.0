Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 862846A93DA
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 10:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjCCJY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 04:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbjCCJYp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 04:24:45 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F455551E
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 01:24:18 -0800 (PST)
X-UUID: 27f31ca2b9a511ed945fc101203acc17-20230303
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:Message-ID:Date:Subject:To:From; bh=52SBbb9aiQmQTooDBIu/BcXMI+ioAaywBywk9VDYQV0=;
        b=Acu5LDHgE6GOMQB7rcHDbZ4mrau/1FUrHyZhYtX3cFFN7kZl+FfGRAW1PugJXWIz5Az53oKpwCcuB1zCBCsbcu8gr9dt2VLKI8WRHPfIy2lPQb9UGsdiYmM1LMov8+rt5FjUYjlbbsEMGU7a+DUFcfWwl4wvMgQHggNp9VHT4is=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.20,REQID:0abee45b-6d85-40a3-8c2f-9012b9a8fccc,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:100,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
        N:release,TS:100
X-CID-INFO: VERSION:1.1.20,REQID:0abee45b-6d85-40a3-8c2f-9012b9a8fccc,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:100,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTIO
        N:quarantine,TS:100
X-CID-META: VersionHash:25b5999,CLOUDID:b364abf4-ddba-41c3-91d9-10eeade8eac7,B
        ulkID:230303172413400Q7WD4,BulkQuantity:0,Recheck:0,SF:29|28|17|19|48,TC:n
        il,Content:0,EDM:-3,IP:nil,URL:1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OS
        I:0,OSA:0,AV:0
X-CID-BVR: 0
X-UUID: 27f31ca2b9a511ed945fc101203acc17-20230303
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <cheng-jui.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1566335122; Fri, 03 Mar 2023 17:24:10 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.186) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Fri, 3 Mar 2023 17:24:09 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Fri, 3 Mar 2023 17:24:09 +0800
From:   Cheng-Jui Wang <cheng-jui.wang@mediatek.com>
To:     <stable@vger.kernel.org>
Subject: [PATCH 00/10] Backport patches to fix lockdep splat in 6.1
Date:   Fri, 3 Mar 2023 17:23:22 +0800
Message-ID: <20230303092347.4825-1-cheng-jui.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These patches fix the lockdep splat reported in this thread:
https://lore.kernel.org/lkml/20220822164404.57952727@gandalf.local.home/


