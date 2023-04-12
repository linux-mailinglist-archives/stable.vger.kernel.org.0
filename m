Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72CDE6DFB8F
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 18:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbjDLQnH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 12:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjDLQnG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 12:43:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39AD7EC2
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 09:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681317736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=09jtKKMdBkZ99/jQ3MHG3Gpu4kZKeE61xD5S9ADSCnE=;
        b=Oq/WKgWMZ2Ulm7JgNl9hSq84NT2+mzVlCuGDkYm1RwQvrCu2d7wj+7BuVGElQRVCA0d4HB
        ntmt5c/HIH/acp46GzlVaXsHP3TIeYMKjB5v7s9IIKrhgKGs15fZb5JcSSu014keXgvT+R
        WU9CgkbxePjOOKK0a4DGG1LCx+rnFwM=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-443-5zu6I2CCOJiWfyD93Rz4Ig-1; Wed, 12 Apr 2023 12:39:31 -0400
X-MC-Unique: 5zu6I2CCOJiWfyD93Rz4Ig-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-74a9035256eso54212985a.0
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 09:39:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681317565; x=1683909565;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=09jtKKMdBkZ99/jQ3MHG3Gpu4kZKeE61xD5S9ADSCnE=;
        b=XAzoREU3DvXIK0JTLObPZrkDfU9xBe+mEsOGhWSulvnBDdrmhttESsMJ5VFsHHGZfo
         0dPu5j5erQv4y+/sW1hTO4yqZmQt0Y1IOlKSXoewrEpwyndGgXK8yvLWH4rPmnajXARu
         rTg1Agdcb55NnGqZ2ll5eYfbahHW1VqU8oEpD4ZPfsJzW7eH/srgF+09Es40k2qpSSr1
         sEWi99hJ56OIIMfhKDvH0RVLhfcjr/ywZifV1EXtp0pKe7MAMEo3BlElH7cPLVMCTMCQ
         0MzmO4iNH+ib3lMzRAK//8LTU6uoLM8j/SCWn2UfhXhX2Wl3vJ40jyFt5ougJ4Vvu6WG
         rZsw==
X-Gm-Message-State: AAQBX9djRVE+wx0yNbZN11+WuSPAANZFK+a+ga0ZcAFOwiNXum3YHqnD
        sTKUp3aGeHSn+GOP09z/Wt1jsEUJB4LpYocgqJBwTCA295Knf3GhQgNEe+t15GeR3h9N4UrJKRH
        AH0SVMyQojts0U0H4
X-Received: by 2002:a05:6214:401a:b0:5ea:a212:3fe1 with SMTP id kd26-20020a056214401a00b005eaa2123fe1mr4433904qvb.4.1681317565694;
        Wed, 12 Apr 2023 09:39:25 -0700 (PDT)
X-Google-Smtp-Source: AKy350Yg5QWvOjiNFwdYfa/fZm9pN7qYxhapB7GAqOu9LrBAaJTeYn6HJOMM2S2srwUeyNYUeY/ZiA==
X-Received: by 2002:a05:6214:401a:b0:5ea:a212:3fe1 with SMTP id kd26-20020a056214401a00b005eaa2123fe1mr4433881qvb.4.1681317565461;
        Wed, 12 Apr 2023 09:39:25 -0700 (PDT)
Received: from x1n.redhat.com (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id u13-20020a0cc48d000000b005ead602acfesm2669536qvi.35.2023.04.12.09.39.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 09:39:24 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     Leonardo Bras Soares Passos <lsoaresp@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        David Hildenbrand <david@redhat.com>, peterx@redhat.com,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        linux-stable <stable@vger.kernel.org>
Subject: [PATCH v2 01/31] Revert "userfaultfd: don't fail on unrecognized features"
Date:   Wed, 12 Apr 2023 12:38:52 -0400
Message-Id: <20230412163922.327282-2-peterx@redhat.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230412163922.327282-1-peterx@redhat.com>
References: <20230412163922.327282-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a proposal to revert commit 914eedcb9ba0ff53c33808.

I found this when writting a simple UFFDIO_API test to be the first unit
test in this set.  Two things breaks with the commit:

  - UFFDIO_API check was lost and missing.  According to man page, the
  kernel should reject ioctl(UFFDIO_API) if uffdio_api.api != 0xaa.  This
  check is needed if the api version will be extended in the future, or
  user app won't be able to identify which is a new kernel.

  - Feature flags checks were removed, which means UFFDIO_API with a
  feature that does not exist will also succeed.  According to the man
  page, we should (and it makes sense) to reject ioctl(UFFDIO_API) if
  unknown features passed in.

Link: https://lore.kernel.org/r/20220722201513.1624158-1-axelrasmussen@google.com
Fixes: 914eedcb9ba0 ("userfaultfd: don't fail on unrecognized features")
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: linux-stable <stable@vger.kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 fs/userfaultfd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 8395605790f6..3b2a41c330e6 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1977,8 +1977,10 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
 	ret = -EFAULT;
 	if (copy_from_user(&uffdio_api, buf, sizeof(uffdio_api)))
 		goto out;
-	/* Ignore unsupported features (userspace built against newer kernel) */
-	features = uffdio_api.features & UFFD_API_FEATURES;
+	features = uffdio_api.features;
+	ret = -EINVAL;
+	if (uffdio_api.api != UFFD_API || (features & ~UFFD_API_FEATURES))
+		goto err_out;
 	ret = -EPERM;
 	if ((features & UFFD_FEATURE_EVENT_FORK) && !capable(CAP_SYS_PTRACE))
 		goto err_out;
-- 
2.39.1

