Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 895E8EBCB9
	for <lists+stable@lfdr.de>; Fri,  1 Nov 2019 05:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfKAEEq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Nov 2019 00:04:46 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34751 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726351AbfKAEEq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Nov 2019 00:04:46 -0400
Received: by mail-pf1-f196.google.com with SMTP id x195so2618647pfd.1;
        Thu, 31 Oct 2019 21:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=08I8Csakb/FJpc9+zhSa3AH7GF33zFbnxUkBfkJsftM=;
        b=p9nj8c/+Y4Dn/Y+cks+5GLyIOFg1vNceurXpq2i/oNz28mm03GLm/+Q/M/Myar+Tg0
         DLkdQd6eMbFjGE+NwcOhXOi76rpiQ+Uv0Uj+BHInTeDAQYxwSeZ9UWbpkE3uDx/yt7Ok
         udND9f8c3QWPnoyyogNEoCA82gWLrEAn4ciRUQe4+syGN0dOFgrKwz3z/iT9d7a2IdiQ
         CZgd1cO/nB/FvoCvtH3kXIZ25zqkYBVqDJ3qNd+UYG7Opu8d3pBghI/azOOrM+obP9Ic
         kvEW5lTAAS1LN4F9nu+V/TmjiyaOlZN+wd3zpjTBmmjG9+jUM4nYo9cpmazXVxWhbn4b
         xzKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=08I8Csakb/FJpc9+zhSa3AH7GF33zFbnxUkBfkJsftM=;
        b=IV9A+v2KcGw6bqFvSEiylyUOAmNwRWR7+Qo1EztvQqsZ7QRVkQiyC/+IAdTm2udaqX
         XOCD3/wFO+ecgOCt4xk///frvFZDA065GqXhQZJdx2sV4CEQRMw4TDG/+O3Nnvga9pAz
         6YQP3CrjfaJRYlyg9akTKfmoFBaUjJIqgZl099Yp5c84wCKRALFnFpl9sFmpKXE7qH7+
         ZGc44ACF8v3GaJnV/RQsHzNehBnv5dkSgEeTmVaXOk5w0TjWIQwGEL2rAcW5P8IM321r
         PogVLFY9BIx0g0UkumVDjp9EzRVdwqaKWy6+V7nsWOmAvvePNqRneSWLJWdBYA7HAaWb
         ixgw==
X-Gm-Message-State: APjAAAXmVHeukpvr8JUNm7Xi5/sBRZSemkqgbXu64L5sVg+wem4/t2/7
        Qoqv3zebpEE2X2FNMZGMhTU=
X-Google-Smtp-Source: APXvYqyM5IZ2AEbIqGuyFLtdzxODXNGV0EzKGN62z9TOrEITDP1J0TNIT/dzLvBN+NUVrn9aLmYzkQ==
X-Received: by 2002:a17:90a:6346:: with SMTP id v6mr12307596pjs.4.1572581085352;
        Thu, 31 Oct 2019 21:04:45 -0700 (PDT)
Received: from masabert (i118-21-156-233.s30.a048.ap.plala.or.jp. [118.21.156.233])
        by smtp.gmail.com with ESMTPSA id a12sm502160pfo.136.2019.10.31.21.04.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Oct 2019 21:04:44 -0700 (PDT)
Received: by masabert (Postfix, from userid 1000)
        id 24F02201277; Fri,  1 Nov 2019 13:04:42 +0900 (JST)
From:   Masanari Iida <standby24x7@gmail.com>
To:     linux-kernel@vger.kernel.org, mhocko@suse.com,
        ebiederm@xmission.com, akpm@linux-foundation.org,
        stable@vger.kernel.org, corbet@lwn.net, linux-doc@vger.kernel.org,
        mingo@redhat.com
Cc:     Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 1/2] docs: admin-guide: Fix min value of threads-max in kernel.rst
Date:   Fri,  1 Nov 2019 13:04:37 +0900
Message-Id: <20191101040438.6029-1-standby24x7@gmail.com>
X-Mailer: git-send-email 2.24.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since following patch was merged 5.4-rc3, minimum value for
threads-max changed to 1.

kernel/sysctl.c: do not override max_threads provided by userspace
b0f53dbc4bc4c371f38b14c391095a3bb8a0bb40

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/admin-guide/sysctl/kernel.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
index 032c7cd3cede..38e0f10d7d9f 100644
--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -1101,7 +1101,7 @@ During initialization the kernel sets this value such that even if the
 maximum number of threads is created, the thread structures occupy only
 a part (1/8th) of the available RAM pages.
 
-The minimum value that can be written to threads-max is 20.
+The minimum value that can be written to threads-max is 1.
 
 The maximum value that can be written to threads-max is given by the
 constant FUTEX_TID_MASK (0x3fffffff).
-- 
2.24.0.rc1

