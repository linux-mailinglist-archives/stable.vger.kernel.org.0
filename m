Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6ADE506758
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 11:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350256AbiDSJDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 05:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345748AbiDSJDl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 05:03:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F85721265
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 02:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650358859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KxwLCvfodqA/8RwmD9p2va09ylbA07FL8X2mqBuTzrk=;
        b=A5GfMAgP9DYH6wtt+3vmGpJK/OwRayJleKNknpcW/EKGdFDmUZeNrnJuTRbr0pn8uHmGoH
        t3F5XSbfwePuUvi/jAUKm5cV85FU2NlOcHFU0W3M9PVWvkqHqAxIO0N+7Dfrh7M8sM+TAS
        NBP6TorExcAlEgqw8DvoBvT49QzsO8k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-44-C8-7ryG8Pr6xOECHos8eHQ-1; Tue, 19 Apr 2022 05:00:57 -0400
X-MC-Unique: C8-7ryG8Pr6xOECHos8eHQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9DFB080418E;
        Tue, 19 Apr 2022 09:00:56 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 96CD243E775;
        Tue, 19 Apr 2022 09:00:56 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 23J90uhv008666;
        Tue, 19 Apr 2022 05:00:56 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 23J90uSV008663;
        Tue, 19 Apr 2022 05:00:56 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Tue, 19 Apr 2022 05:00:56 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     gregkh@linuxfoundation.org
cc:     snitzer@kernel.org, stable@vger.kernel.org
Subject: [PATCH v4.19] Re: FAILED: patch "[PATCH] dm integrity: fix memory
 corruption when tag_size is less" failed to apply to 4.19-stable tree
In-Reply-To: <1650273565139113@kroah.com>
Message-ID: <alpine.LRH.2.02.2204190455520.8323@file01.intranet.prod.int.rdu2.redhat.com>
References: <1650273565139113@kroah.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

Here I'm sending a backport of the patch 
08c1af8f1c13bbf210f1760132f4df24d0ed46d6 for the kernel 4.19.

Mikulas

On Mon, 18 Apr 2022, gregkh@linuxfoundation.org wrote:

> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h

It is possible to set up dm-integrity in such a way that the
"tag_size" parameter is less than the actual digest size. In this
situation, a part of the digest beyond tag_size is ignored.

In this case, dm-integrity would write beyond the end of the
ic->recalc_tags array and corrupt memory. The corruption happened in
integrity_recalc->integrity_sector_checksum->crypto_shash_final.

Fix this corruption by increasing the tags array so that it has enough
padding at the end to accomodate the loop in integrity_recalc() being
able to write a full digest size for the last member of the tags
array.

Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>

---
 drivers/md/dm-integrity.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-stable/drivers/md/dm-integrity.c
===================================================================
--- linux-stable.orig/drivers/md/dm-integrity.c	2022-04-19 10:52:45.000000000 +0200
+++ linux-stable/drivers/md/dm-integrity.c	2022-04-19 10:54:41.000000000 +0200
@@ -3504,6 +3504,7 @@ try_smaller_buffer:
 	}
 
 	if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING)) {
+		size_t recalc_tags_size;
 		if (!ic->internal_hash) {
 			r = -EINVAL;
 			ti->error = "Recalculate is only valid with internal hash";
@@ -3522,8 +3523,10 @@ try_smaller_buffer:
 			r = -ENOMEM;
 			goto bad;
 		}
-		ic->recalc_tags = kvmalloc_array(RECALC_SECTORS >> ic->sb->log2_sectors_per_block,
-						 ic->tag_size, GFP_KERNEL);
+		recalc_tags_size = (RECALC_SECTORS >> ic->sb->log2_sectors_per_block) * ic->tag_size;
+		if (crypto_shash_digestsize(ic->internal_hash) > ic->tag_size)
+			recalc_tags_size += crypto_shash_digestsize(ic->internal_hash) - ic->tag_size;
+		ic->recalc_tags = kvmalloc(recalc_tags_size, GFP_KERNEL);
 		if (!ic->recalc_tags) {
 			ti->error = "Cannot allocate tags for recalculating";
 			r = -ENOMEM;

