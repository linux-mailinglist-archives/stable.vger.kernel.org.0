Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83914198F2D
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730527AbgCaJBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:01:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730521AbgCaJBO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:01:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B293C20848;
        Tue, 31 Mar 2020 09:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645273;
        bh=h/JNQ+2tDnREXItSe9CGEeJX602SDVdH+hs3zHL9yF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uNHWtbqSLvA9og6ogJHYgFQ/rLCLfLrBTwhW5xH/aRGA/GaqWcE2+n17x6noNAT5u
         Ld//ayx+dGWALY8HSSapvvV3pAVobIrPymLp0u+gUR0L3gTv8OjSn9mSRSOixad5Cl
         b2QNu3CcPdpHleQdOqDr46ZHSZoCRsHcwD2vc0UI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.6 17/23] ahci: Add Intel Comet Lake H RAID PCI ID
Date:   Tue, 31 Mar 2020 10:59:29 +0200
Message-Id: <20200331085316.082152479@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085308.098696461@linuxfoundation.org>
References: <20200331085308.098696461@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit 32d2545462c6cede998267b86e57cda5d1dc2225 upstream.

Add the PCI ID to the driver list to support this new device.

Cc: stable@vger.kernel.org
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/ahci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -401,6 +401,7 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(INTEL, 0xa252), board_ahci }, /* Lewisburg RAID*/
 	{ PCI_VDEVICE(INTEL, 0xa256), board_ahci }, /* Lewisburg RAID*/
 	{ PCI_VDEVICE(INTEL, 0xa356), board_ahci }, /* Cannon Lake PCH-H RAID */
+	{ PCI_VDEVICE(INTEL, 0x06d7), board_ahci }, /* Comet Lake-H RAID */
 	{ PCI_VDEVICE(INTEL, 0x0f22), board_ahci_mobile }, /* Bay Trail AHCI */
 	{ PCI_VDEVICE(INTEL, 0x0f23), board_ahci_mobile }, /* Bay Trail AHCI */
 	{ PCI_VDEVICE(INTEL, 0x22a3), board_ahci_mobile }, /* Cherry Tr. AHCI */


