Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6691443E9
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 19:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729425AbgAUSCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 13:02:43 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24519 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729399AbgAUSCn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jan 2020 13:02:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579629762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=51skyVgnir1Juz69ea/QcSjmb0q3DrHvHOo3EAm0A90=;
        b=MtsAAolTADDcfDmk2ILQFdBPXk0pwkueuJbwWiE5oFrI56bUfHaxZdrSRWHrYXRJU3+04z
        cNeG8ecfFuypyMDggLIPT/T1WVId/GF8pV8PEdBsxSAegQRDCfpVADKAcZBIvtknRc9yHz
        +qnib2+3YGOpTQ6zRxISMCRB7K4y/YA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-mq6xSIprOl-gHZvBJ8WJhA-1; Tue, 21 Jan 2020 13:02:37 -0500
X-MC-Unique: mq6xSIprOl-gHZvBJ8WJhA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F761DBA6;
        Tue, 21 Jan 2020 18:02:32 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.36.118.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 96E435C1C3;
        Tue, 21 Jan 2020 18:02:27 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     stable@vger.kernel.org
Cc:     linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Baoquan He <bhe@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Oscar Salvador <osalvador@suse.de>,
        Wei Yang <richard.weiyang@gmail.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH for 4.19-stable v2 08/24] mm, memory_hotplug: update a comment in unregister_memory()
Date:   Tue, 21 Jan 2020 19:01:34 +0100
Message-Id: <20200121180150.37454-9-david@redhat.com>
In-Reply-To: <20200121180150.37454-1-david@redhat.com>
References: <20200121180150.37454-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 16df1456aa858a86f398dbc7d27649eb6662b0cc upstream.

The remove_memory_block() function was renamed to in commit
cc292b0b4302 ("drivers/base/memory.c: rename remove_memory_block() to
remove_memory_section()").

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/base/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index b384f01ad29d..119b076eb5e2 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -743,7 +743,7 @@ unregister_memory(struct memory_block *memory)
 {
 	BUG_ON(memory->dev.bus !=3D &memory_subsys);
=20
-	/* drop the ref. we got in remove_memory_block() */
+	/* drop the ref. we got in remove_memory_section() */
 	put_device(&memory->dev);
 	device_unregister(&memory->dev);
 }
--=20
2.24.1

