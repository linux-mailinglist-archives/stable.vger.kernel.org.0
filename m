Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33D3378852
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239156AbhEJLVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:21:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236998AbhEJLLI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8135B6147D;
        Mon, 10 May 2021 11:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644776;
        bh=Sht9UlYuc1zR0I48Z9NL0+YGbKIspwqwADzI2nXB2+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AfD9qhygyiErizlfXvASxAgqY0PH3cdDXEz0R+2PzLjLQvuf01wPLV0MyaXguVv3N
         CYjEzNWKVGDw+r+rSJuJpaq5HmpWLvovOcLw7FcIMExLWYn8VcAhEbeDkt1kS92Hyk
         Pow7YhLtTL+tSZ6tF9K04pOlSCW9lTUKkdSkQDw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Benesh <scott.benesh@microchip.com>,
        Scott Teel <scott.teel@microchip.com>,
        Martin Wilck <mwilck@suse.com>,
        Kevin Barnett <kevin.barnett@microchip.com>,
        Don Brace <don.brace@microchip.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 218/384] scsi: smartpqi: Add new PCI IDs
Date:   Mon, 10 May 2021 12:20:07 +0200
Message-Id: <20210510102022.088105814@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

[ Upstream commit 75fbeacca3ad30835e903002dba98dd909b4dfff ]

Add support for newer hardware.

Link: https://lore.kernel.org/r/161549386882.25025.2594251735886014958.stgit@brunhilda
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Acked-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 156 ++++++++++++++++++++++++++
 1 file changed, 156 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 52e4d5618dc7..c30f6047410f 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8221,6 +8221,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x152d, 0x8a37)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x193d, 0x8460)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x193d, 0x1104)
@@ -8293,6 +8297,22 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1bd4, 0x004f)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1bd4, 0x0051)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1bd4, 0x0052)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1bd4, 0x0053)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1bd4, 0x0054)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x19e5, 0xd227)
@@ -8453,6 +8473,122 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADAPTEC2, 0x1380)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1400)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1402)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1410)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1411)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1412)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1420)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1430)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1440)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1441)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1450)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1452)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1460)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1461)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1462)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1470)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1471)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1472)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1480)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1490)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1491)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x14a0)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x14a1)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x14b0)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x14b1)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x14c0)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x14c1)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x14d0)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x14e0)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x14f0)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADVANTECH, 0x8312)
@@ -8517,6 +8653,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_HP, 0x1001)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_HP, 0x1002)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_HP, 0x1100)
@@ -8525,6 +8665,22 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_HP, 0x1101)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1590, 0x0294)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1590, 0x02db)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1590, 0x02dc)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1590, 0x032e)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1d8d, 0x0800)
-- 
2.30.2



