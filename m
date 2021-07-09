Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76123C1FDB
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 09:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbhGIHLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 03:11:36 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:40770 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S230121AbhGIHLf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Jul 2021 03:11:35 -0400
X-UUID: 5afdd196da154ef3924c3bb0530fd006-20210709
X-UUID: 5afdd196da154ef3924c3bb0530fd006-20210709
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <deren.wu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 811500575; Fri, 09 Jul 2021 15:08:50 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 9 Jul 2021 15:08:41 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Jul 2021 15:08:42 +0800
From:   Deren Wu <Deren.Wu@mediatek.com>
To:     <stable@vger.kernel.org>
CC:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Deren Wu <deren.wu@mediatek.com>
Subject: [PATCH 0/1] mt76: mt7921: Fix resume fail if fw was dropped
Date:   Fri, 9 Jul 2021 15:07:18 +0800
Message-ID: <cover.1625806023.git.deren.wu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Deren Wu <deren.wu@mediatek.com>

Hi,

The bug is found on some devices which power off pcie bus
in suspend mode. In this case, mt7921 would resume fail on
interactive commands. This patch could recover the failure in
command timeout.

Need to apply patches below for dependency. Those patches work
for stability improvment as well.

upstream patches:
commit f92f81d35ac2 ("mt76: mt7921: check mcu returned values in mt7921_start")
commit d32464e68ffc ("mt76: mt7921: introduce mt7921_run_firmware utility routine.")
commit 1f7396acfef4 ("mt76: mt7921: introduce __mt7921_start utility routine")
commit 3990465db682 ("mt76: dma: introduce mt76_dma_queue_reset routine")
commit c001df978e4c ("mt76: dma: export mt76_dma_rx_cleanup routine")
commit 0c1ce9884607 ("mt76: mt7921: add wifi reset support")
commit e513ae49088b ("mt76: mt7921: abort uncompleted scan by wifi reset")


Lorenzo Bianconi (1):
  mt76: mt7921: get rid of mcu_reset function pointer

 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
2.25.1

