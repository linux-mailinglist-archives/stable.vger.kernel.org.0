Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC88328A70
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239573AbhCASRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:17:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:58156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239121AbhCASJW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:09:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EDE465149;
        Mon,  1 Mar 2021 17:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618287;
        bh=8JMErj/tbuu+TqqPZo8l4d/F5jzJozgU4KNy7irLKlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2g4B3CiZT4yp9a8I1pKMgBdodSgBbEwc6EcEFtQUu6XvffzWZKH7FURsqyTJju32C
         9sL2O2jp+aw6zP0E7R21jwS1CA3g2HccBwME4eHpdJc2jQAh/RgLQ36l3OZwfhfssD
         OL2J8vNYOa8e/HgJn/EzWQQ44fmga4PFwu4JQwdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 005/663] scsi: libsas: docs: Remove notify_ha_event()
Date:   Mon,  1 Mar 2021 17:04:13 +0100
Message-Id: <20210301161142.044432864@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahmed S. Darwish <a.darwish@linutronix.de>

commit 3f901c81dfad6930de5d4e6b582c4fde880cdada upstream.

The ->notify_ha_event() hook has long been removed from the libsas event
interface.

Remove it from documentation.

Link: https://lore.kernel.org/r/20210118100955.1761652-2-a.darwish@linutronix.de
Fixes: 042ebd293b86 ("scsi: libsas: kill useless ha_event and do some cleanup")
Cc: stable@vger.kernel.org
Reviewed-by: John Garry <john.garry@huawei.com>
Reviewed-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/scsi/libsas.rst |    1 -
 1 file changed, 1 deletion(-)

--- a/Documentation/scsi/libsas.rst
+++ b/Documentation/scsi/libsas.rst
@@ -189,7 +189,6 @@ num_phys
 The event interface::
 
 	/* LLDD calls these to notify the class of an event. */
-	void (*notify_ha_event)(struct sas_ha_struct *, enum ha_event);
 	void (*notify_port_event)(struct sas_phy *, enum port_event);
 	void (*notify_phy_event)(struct sas_phy *, enum phy_event);
 


