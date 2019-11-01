Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23E79EBCBB
	for <lists+stable@lfdr.de>; Fri,  1 Nov 2019 05:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbfKAEEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Nov 2019 00:04:48 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39136 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726351AbfKAEEs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Nov 2019 00:04:48 -0400
Received: by mail-pg1-f194.google.com with SMTP id p12so5612729pgn.6;
        Thu, 31 Oct 2019 21:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QsWota2Z/1CKC8Q2G+ABbLlBht6wDe5bQYoK9v/iJIQ=;
        b=YuaqAmiZ8VGIpENUY9ZbesjxC4hTJg6sflDLOXoSgfCgxGYPHp8xKKj95T/3A0nsM7
         NfQ0PGpocPsSiqoaJi9y6XPApw/yZbqhSj8I1ZYHAOkdZFQnF/IBq4YSvpsZZ8v5m01v
         4dDxVTO0Cdqo9FE7X7KdOVOyjIMK6JRxf7scDVF2qpiYP4X+oYkKJ8+9jxwbdUoS5OKG
         NDVckaOBmeMADxMgo0wJLLLjFhW7HhQ0GWNT3999Hmk3Fiw3ea/sYxJ3YhBjQ+R3Gtql
         NSf6QXqRjxKYTL0+F7fJvI4+uoFkmpu/0OSEDceUKCE3hsd0BBZzBCzuVzfv8etjZF9K
         WC/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QsWota2Z/1CKC8Q2G+ABbLlBht6wDe5bQYoK9v/iJIQ=;
        b=KUi3RalP/YfZoTI0R5BA4oamKxPGQ0jXnSr4YRHc2JubXXmjoCHRyHLdWm5E2/wEuE
         M57G7lWp6CAviQyKg3nh0Sy1lFEDJg46onUUALl78PsZ18UBdW/YRumTNUczLFuH7dtr
         Y4mshi8LjtGbAxC/Apnf2x7oCmaIdbX0kn3AASLA//GsgXm30xLMiG64DFeU93Ma7vHC
         nPgbN09Uh7NrLoX6nHj/GoSnaXtSmMwbLhzTI+hmJaOF71bgE3KLuHzL30UG8hBP4I9M
         fnkZG/WvcN8MjmKgr1dJusaWcyp6vpTj9O2SxjeOH0gTJFyMyPfmWLQMP2BFCiGsbRh9
         SWAw==
X-Gm-Message-State: APjAAAUlxRMsNuDpTHpvDrL7tE8I3MgrzMQcaCs1p9jsEs5RIu86Doue
        vz6jpqxIXvKo0jGajYd7oNA=
X-Google-Smtp-Source: APXvYqzhDiYlZFckPQVD6GH/zbn70eZz0om2uIJE636BdWD7xClrh4P979cJfbsJRoQntMNNzq+CvA==
X-Received: by 2002:a17:90a:cc07:: with SMTP id b7mr4015780pju.135.1572581087105;
        Thu, 31 Oct 2019 21:04:47 -0700 (PDT)
Received: from masabert (i118-21-156-233.s30.a048.ap.plala.or.jp. [118.21.156.233])
        by smtp.gmail.com with ESMTPSA id a33sm4660713pgb.57.2019.10.31.21.04.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Oct 2019 21:04:46 -0700 (PDT)
Received: by masabert (Postfix, from userid 1000)
        id AF86920128D; Fri,  1 Nov 2019 13:04:44 +0900 (JST)
From:   Masanari Iida <standby24x7@gmail.com>
To:     linux-kernel@vger.kernel.org, mhocko@suse.com,
        ebiederm@xmission.com, akpm@linux-foundation.org,
        stable@vger.kernel.org, corbet@lwn.net, linux-doc@vger.kernel.org,
        mingo@redhat.com
Cc:     Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 2/2] docs: admin-guide: Remove threads-max auto-tuning
Date:   Fri,  1 Nov 2019 13:04:38 +0900
Message-Id: <20191101040438.6029-2-standby24x7@gmail.com>
X-Mailer: git-send-email 2.24.0.rc1
In-Reply-To: <20191101040438.6029-1-standby24x7@gmail.com>
References: <20191101040438.6029-1-standby24x7@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since following path was merged in 5.4-rc3,
auto-tuning feature in threads-max was not exist any more.
Fix the admin-guide document as is.

kernel/sysctl.c: do not override max_threads provided by userspace
b0f53dbc4bc4c371f38b14c391095a3bb8a0bb40

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/admin-guide/sysctl/kernel.rst | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
index 38e0f10d7d9f..9035adbdff58 100644
--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -1109,10 +1109,6 @@ constant FUTEX_TID_MASK (0x3fffffff).
 If a value outside of this range is written to threads-max an error
 EINVAL occurs.
 
-The value written is checked against the available RAM pages. If the
-thread structures would occupy too much (more than 1/8th) of the
-available RAM pages threads-max is reduced accordingly.
-
 
 unknown_nmi_panic:
 ==================
-- 
2.24.0.rc1

