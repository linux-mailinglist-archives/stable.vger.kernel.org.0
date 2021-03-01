Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F38328ABF
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239696AbhCASW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:22:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:35640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239539AbhCASRA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:17:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DF29650AB;
        Mon,  1 Mar 2021 17:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620117;
        bh=8JMErj/tbuu+TqqPZo8l4d/F5jzJozgU4KNy7irLKlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TXYc0PQE2l2FZbn/nGp9qvwqyyqUSpD2VzjKFJxf7hgTxBLxsF1a18OpfB7LSJh4e
         rf7ucsYmOSTyQqrzQWHDAKGclwbcaQHnEG5zrEIGfUyYzABPqe30mWXXxmtDaXhN+K
         z0dPaM/vFMCHmWlYFZd7CystMsKARvJmzVWauNK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.11 006/775] scsi: libsas: docs: Remove notify_ha_event()
Date:   Mon,  1 Mar 2021 17:02:54 +0100
Message-Id: <20210301161202.017022471@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
 


