Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25ED757419E
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 04:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiGNC45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 22:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiGNC44 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 22:56:56 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C225B22BC2;
        Wed, 13 Jul 2022 19:56:55 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id fz10so1187500pjb.2;
        Wed, 13 Jul 2022 19:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K4Pp1QJgnnoEgkRYwFsx+bv/7KviqKFW6I6B8ckDsC4=;
        b=SAzSqvUaKTGJU1xLDblDE1co66IppgS/duvP++mKYLlQkiYEA2j3iKybjQqWdwE5Aq
         s9RNmmDFP34488ecYqGqLCoTzAT78pB95s47RajzcH2oqKr6Mqie0fuZBrfnXXkbb9aF
         io2rQn9fQIFSd4/plBSeE0PAsq8/+09BDGm8pKsNC90FH3YKHrOR9GEQPO+RozluDiuY
         +VTEFfJqZecsLZqDe0hrXAiFSJmaWtHcHYG2+SciY6wPjpXpLLRiHxK3cIN/G1ENj6gY
         O/y/WSyF1yZFDfn5QERwOgMUfzdpSS1sIvQLKY55jp5ulzqQ2AcFrixXx+qkQ8SoxYvW
         trEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K4Pp1QJgnnoEgkRYwFsx+bv/7KviqKFW6I6B8ckDsC4=;
        b=1ZZ87CfsU+kgKcYhSy2vaHymNONTT7KUk63le9CRLHW6mLUw44l76bcnDCrtHwBfBy
         Z+fhoiV5YtsNTZL09Md60AHgVonl0ZtJnNOxI2yfw72vbDoK2tRWzeOKkUwH0GOLqlJW
         3lAxuUC5VshNNFFIi0hhxgKsPlcuL6y47tvY1zW094ikVEPJKqzpZG3Y5g62Ng8gGIDF
         oxuIbZwpDBbmXJMgp75nQMDv+CJ9TCw26pdjStLH3fJVX8VwYjYfmlAWp6BJ2Mp48XkE
         NTt283S43CiuJ4h2DzXxODyMOZIT7DWXFOfHml5bHO+eGBcwfX9hfWoTOPmefnjH3vGO
         +2GQ==
X-Gm-Message-State: AJIora+UaIRGFCiHbWOec5D7bpONMYBimKhqDA9T24IO6ISXS+AKyXw3
        NldLZqZngai+N6+wAM+rbFs=
X-Google-Smtp-Source: AGRyM1vr8mTRl1Qv6eerY7G6HsV4kPC0lC5ACtShcpBMba1tKV/BDNBVv5Wm8N89z8haYMEeUj1VJg==
X-Received: by 2002:a17:902:9a07:b0:16c:39bc:876 with SMTP id v7-20020a1709029a0700b0016c39bc0876mr6175866plp.42.1657767415249;
        Wed, 13 Jul 2022 19:56:55 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-83.three.co.id. [180.214.232.83])
        by smtp.gmail.com with ESMTPSA id x7-20020a1709027c0700b0016cae5f04e6sm156153pll.135.2022.07.13.19.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 19:56:54 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id AAA3E103B81; Thu, 14 Jul 2022 09:56:50 +0700 (WIB)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org, linux-next@vger.kernel.org
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        David Howells <dhowells@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH next] Documentation: netfs: Use inline code for *foliop pointer
Date:   Thu, 14 Jul 2022 09:56:49 +0700
Message-Id: <20220714025649.41871-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sphinx reported inline emphasis warning on netfs:

Documentation/filesystems/netfs_library.rst:384: WARNING: Inline emphasis start-string without end-string.
Documentation/filesystems/netfs_library.rst:384: WARNING: Inline emphasis start-string without end-string.
Documentation/filesystems/netfs_library:609: ./fs/netfs/buffered_read.c:318: WARNING: Inline emphasis start-string without end-string.

These warnings above are due to unsecaped *foliop, which confuses Sphinx as
italics syntax instead.

Use inline code for the pointer.

Link: https://lore.kernel.org/linux-doc/202207140742.GTPk4U8i-lkp@intel.com/
Fixes: 157be6ddd9e438 ("netfs: do not unlock and put the folio twice")
Reported-by: kernel test robot <lkp@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: David Howells <dhowells@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Xiubo Li <xiubli@redhat.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/filesystems/netfs_library.rst | 6 +++---
 fs/netfs/buffered_read.c                    | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/filesystems/netfs_library.rst b/Documentation/filesystems/netfs_library.rst
index 8d4cf5d5822de4..73a4176144b3b8 100644
--- a/Documentation/filesystems/netfs_library.rst
+++ b/Documentation/filesystems/netfs_library.rst
@@ -382,9 +382,9 @@ The operations are as follows:
    conflicting state before allowing it to be modified.
 
    It may unlock and discard the folio it was given and set the caller's folio
-   pointer to NULL.  It should return 0 if everything is now fine (*foliop
-   left set) or the op should be retried (*foliop cleared) and any other error
-   code to abort the operation.
+   pointer to NULL.  It should return 0 if everything is now fine (``*foliop``
+   left set) or the op should be retried (``*foliop`` cleared) and any other
+   error code to abort the operation.
 
  * ``done``
 
diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 8fa0725cd64981..0ce53585215106 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -320,8 +320,8 @@ static bool netfs_skip_folio_read(struct folio *folio, loff_t pos, size_t len,
  * pointer to the fsdata cookie that gets returned to the VM to be passed to
  * write_end.  It is permitted to sleep.  It should return 0 if the request
  * should go ahead or it may return an error.  It may also unlock and put the
- * folio, provided it sets *foliop to NULL, in which case a return of 0 will
- * cause the folio to be re-got and the process to be retried.
+ * folio, provided it sets ``*foliop`` to NULL, in which case a return of 0
+ * will cause the folio to be re-got and the process to be retried.
  *
  * The calling netfs must initialise a netfs context contiguous to the vfs
  * inode before calling this.
-- 
An old man doll... just what I always wanted! - Clara

