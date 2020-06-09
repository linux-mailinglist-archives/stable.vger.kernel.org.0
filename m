Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F8C1F44A5
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387928AbgFISG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:06:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41494 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388188AbgFISGA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:06:00 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidG-0001pP-Da; Tue, 09 Jun 2020 19:05:54 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidF-006Vvx-Bi; Tue, 09 Jun 2020 19:05:53 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Hannes Reinecke" <hare@suse.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Hannes Reinecke" <hare@suse.com>,
        "Johannes Thumshirn" <jthumshirn@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Christoph Hellwig" <hch@lst.de>
Date:   Tue, 09 Jun 2020 19:04:21 +0100
Message-ID: <lsq.1591725832.74048788@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 30/61] scsi: sg: remove 'save_scat_len'
In-Reply-To: <lsq.1591725831.850867383@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.85-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@suse.de>

commit 136e57bf43dc4babbfb8783abbf707d483cacbe3 upstream.

Unused.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Tested-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/sg.c | 2 --
 1 file changed, 2 deletions(-)

--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -154,7 +154,6 @@ typedef struct sg_fd {		/* holds the sta
 	int timeout;		/* defaults to SG_DEFAULT_TIMEOUT      */
 	int timeout_user;	/* defaults to SG_DEFAULT_TIMEOUT_USER */
 	Sg_scatter_hold reserve;	/* buffer held for this file descriptor */
-	unsigned save_scat_len;	/* original length of trunc. scat. element */
 	Sg_request *headrp;	/* head of request slist, NULL->empty */
 	struct fasync_struct *async_qp;	/* used by asynchronous notification */
 	Sg_request req_arr[SG_MAX_QUEUE];	/* used as singly-linked list */
@@ -2069,7 +2068,6 @@ sg_unlink_reserve(Sg_fd * sfp, Sg_reques
 	req_schp->pages = NULL;
 	req_schp->page_order = 0;
 	req_schp->sglist_len = 0;
-	sfp->save_scat_len = 0;
 	srp->res_used = 0;
 	/* Called without mutex lock to avoid deadlock */
 	sfp->res_in_use = 0;

