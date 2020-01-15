Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5679C13C7D9
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 16:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728992AbgAOPeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 10:34:13 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24622 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728912AbgAOPeN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 10:34:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579102452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CMhlALS8chXAuKdNfTi5rqj1JdBc100CwXWLC+OZ/nA=;
        b=HHn+SBgsmIaX34EoyYkzmb2tTGPYD5U7X9SK1zSX/8c+P2y8ZwrJ79qIYXrz7CBEbk+Uv0
        GRHR/Lv6Dn7nAR6vOswourb0zwKuswuwJafbUeDU3mqfOCM8xTEOdFIMrbwFCxs50wsfdQ
        627t/vfhn1gtrsiuZhxpGbbtNiiJz7Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-64w7NrgIMFakkyVtaXEX2g-1; Wed, 15 Jan 2020 10:34:08 -0500
X-MC-Unique: 64w7NrgIMFakkyVtaXEX2g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C9A81A2C3A;
        Wed, 15 Jan 2020 15:34:06 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.36.118.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 285B38886D;
        Wed, 15 Jan 2020 15:34:01 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     stable@vger.kernel.org
Cc:     linux-mm@kvack.org, Oscar Salvador <osalvador@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Baoquan He <bhe@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH for 4.19-stable 08/25] mm, memory_hotplug: update a comment in unregister_memory()
Date:   Wed, 15 Jan 2020 16:33:22 +0100
Message-Id: <20200115153339.36409-9-david@redhat.com>
In-Reply-To: <20200115153339.36409-1-david@redhat.com>
References: <20200115153339.36409-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

