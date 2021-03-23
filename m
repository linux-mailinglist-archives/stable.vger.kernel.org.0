Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7373A345D0D
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 12:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhCWLgz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 07:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbhCWLfu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Mar 2021 07:35:50 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539E9C061756;
        Tue, 23 Mar 2021 04:35:49 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id x7-20020a17090a2b07b02900c0ea793940so12081904pjc.2;
        Tue, 23 Mar 2021 04:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EEklaGbWfb1yo1FO7Z4wlaHPpfFsNPyJGcvRz1oeefM=;
        b=b5naPsgQpGmYSNTZQEtpOVUOEncxeX6nHd+zt5WJrai18i4iXngstNQKAZcgcgXW36
         oAUvlnuRnUWzIMG4JOvHaMPlshJwY7/rLJY4NKPei41RC8wofdNKmbPe7XAY9ocA9hUj
         Z5NylNkIvmpfwT/RE7dQBaqSDE0r5R3kGBXiBXwy4lGQok8qO0hRnAMfQUQd0c2nvX3R
         qKjqlQKHPfa3iWzGsPgZtMmxekYWahvC8VirPvT0mhucwlDqIZQGFFfXF1ubFIn9H/Tu
         KIwfOzdE4tq4CRX+S5iva+wc7PZYVNNm8ZqXFQ3B4s/zzn5E5R5lDMqYmG347gygEOix
         3BlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EEklaGbWfb1yo1FO7Z4wlaHPpfFsNPyJGcvRz1oeefM=;
        b=l+s8EqGG/ZlDP+jsvWo9pegYFFIwFlTZNlGuUfIZJ1+xc8BqTfaA2nu44TcKoosVan
         NjFEzIgGJ/DYMb5/s08ZtBcWF+v88mUBNq3U6WoLJXUG32cMRUMZHy4Gvq26HJPn1EgT
         BJVXjDHFxr4McfV70VuSFizvXhrHhwcHqh+6dug+t0sRauYX+ptmCg8t5sm+KqsGGfuB
         dE3TEIZyFxE2Bi1u2AxWTjjQe6PgWTVUUNg22fmgGno9bQvMFYTdrKOSGVqQ/uWEeaGL
         hS+xXKgdBJIBjxHuzXsLScEXno8fOjKdch5jRd8DY7cHSI+QM1j/Y8mXZQDcJTWh9BZO
         8M3g==
X-Gm-Message-State: AOAM532I/FdQrkAE1+iFiik9ZSfSkz5K0K29BS5udSoaNIfRYgKvjilv
        44uapDv0JTkJQxwfiwI1QjNghtl5e9U=
X-Google-Smtp-Source: ABdhPJyfnT0JqtXQArzGmf6c+wju8uckrWOxq3OUqeecMhVAl0hDKux9CILkfrbFR7IfsAr+cqNMxQ==
X-Received: by 2002:a17:90a:9103:: with SMTP id k3mr4267739pjo.157.1616499348929;
        Tue, 23 Mar 2021 04:35:48 -0700 (PDT)
Received: from localhost.localdomain ([122.174.244.83])
        by smtp.gmail.com with ESMTPSA id l22sm2750385pjl.14.2021.03.23.04.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 04:35:48 -0700 (PDT)
From:   Atul Gopinathan <atulgopinathan@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Atul Gopinathan <atulgopinathan@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 2/2] staging: rtl8192e: Change state information from u16 to u8
Date:   Tue, 23 Mar 2021 17:04:14 +0530
Message-Id: <20210323113413.29179-2-atulgopinathan@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210323113413.29179-1-atulgopinathan@gmail.com>
References: <20210323113413.29179-1-atulgopinathan@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The "u16 CcxRmState[2];" array field in struct "rtllib_network" has 4
bytes in total while the operations performed on this array through-out
the code base are only 2 bytes.

The "CcxRmState" field is fed only 2 bytes of data using memcpy():

(In rtllib_rx.c:1972)
	memcpy(network->CcxRmState, &info_element->data[4], 2)

With "info_element->data[]" being a u8 array, if 2 bytes are written
into "CcxRmState" (whose one element is u16 size), then the 2 u8
elements from "data[]" gets squashed and written into the first element
("CcxRmState[0]") while the second element ("CcxRmState[1]") is never
fed with any data.

Same in file rtllib_rx.c:2522:
	 memcpy(dst->CcxRmState, src->CcxRmState, 2);

The above line duplicates "src" data to "dst" but only writes 2 bytes
(and not 4, which is the actual size). Again, only 1st element gets the
value while the 2nd element remains uninitialized.

This later makes operations done with CcxRmState unpredictable in the
following lines as the 1st element is having a squashed number while the
2nd element is having an uninitialized random number.

rtllib_rx.c:1973:    if (network->CcxRmState[0] != 0)
rtllib_rx.c:1977:    network->MBssidMask = network->CcxRmState[1] & 0x07;

network->MBssidMask is also of type u8 and not u16.

Fix this by changing the type of "CcxRmState" from u16 to u8 so that the
data written into this array and read from it make sense and are not
random values.

NOTE: The wrong initialization of "CcxRmState" can be seen in the
following commit:

commit ecdfa44610fa ("Staging: add Realtek 8192 PCI wireless driver")

The above commit created a file `rtl8192e/ieee80211.h` which used to
have the faulty line. The file has been deleted (or possibly renamed)
with the contents copied in to a new file `rtl8192e/rtllib.h` along with
additional code in the commit 94a799425eee (tagged in Fixes).

Fixes: 94a799425eee ("[PATCH 1/8] rtl8192e: Import new version of driver from realtek")
Cc: stable@vger.kernel.org
Signed-off-by: Atul Gopinathan <atulgopinathan@gmail.com>
---
 drivers/staging/rtl8192e/rtllib.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192e/rtllib.h b/drivers/staging/rtl8192e/rtllib.h
index b84f00b8d18b..4cabaf21c1ca 100644
--- a/drivers/staging/rtl8192e/rtllib.h
+++ b/drivers/staging/rtl8192e/rtllib.h
@@ -1101,15 +1101,15 @@ struct rtllib_network {
 	u8 hidden_ssid[IW_ESSID_MAX_SIZE + 1];
 	u8 hidden_ssid_len;
 	struct rtllib_qos_data qos_data;
 
 	bool	bWithAironetIE;
 	bool	bCkipSupported;
 	bool	bCcxRmEnable;
-	u16	CcxRmState[2];
+	u8	CcxRmState[2];
 	bool	bMBssidValid;
 	u8	MBssidMask;
 	u8	MBssid[ETH_ALEN];
 	bool	bWithCcxVerNum;
 	u8	BssCcxVerNumber;
 	/* These are network statistics */
 	struct rtllib_rx_stats stats;
-- 
2.25.1

