Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945212534E1
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 18:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgHZQ2k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 12:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728010AbgHZQ2i (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 12:28:38 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C4FC061756
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 09:28:37 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id b207so2100114qkc.12
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 09:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=3gLPYefMec5H8GHlFzYJXoe4HOMZrqzA+M+p7WPcWm8=;
        b=cZxp+5exXrwdK/i19MMaCRu5rUR3WSECshB9rYjwYBuyhy3nLzrcZTEg1FwROAkDPK
         K4F00SdoNsKaAGqiv8pOW57Jm8cuojHbiAJkSbgTk6/QXMvyMgS/0eqUUhVf5u3D0yT/
         cWKeefqrAIQf2Qws9oOMwR2Mx5jB6XdT6BHM5QNiyXzlIfSQIsgosmUUX0ApcEJsyB0p
         nTVBpzWxjQw7tLaqqjHwtfIaCEDU5xjbtb7wU2qtWm+nbcjzFcyHXi9vK9Vu1qHAPcbd
         RaZ+YB+Q3D3hNJWTEAaiKtDskY/Gg1+XbN1KRCbWxtxQM14S6g6YREUtxmaXx5SHvjk3
         7mdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3gLPYefMec5H8GHlFzYJXoe4HOMZrqzA+M+p7WPcWm8=;
        b=Ll7rsQWVC5pWKgwkuA/Cm4Su2bsWFOO2GtUB5S3lY5AVzXiaZIly+UwU0+7mJsXAa+
         9wm88MGJCvCvzMgwJRsBv6xtJrVne9Te9VzRhEN1K32KbBwcEbXAoL8kZmZvQVuxyesN
         K+iwEoNwICmTrMVdnAFw5mNWUNIXz6JiKfRSN7kUh1fmoIxkYJ0uICFQLxVKk5Cm2Eey
         2caZCWsIfPH0v6OF3V4d+WL891Ts94VwSWmpcdXg4fZQKorODiu/5rWEfX28y2V+Y7bo
         fRdc9r4rcNzqUU/Xlxf1/TKxMrZa7IRRWudPbprYFq3NH9ovuGe3WMCvIjEtnHUB36TP
         VFFg==
X-Gm-Message-State: AOAM53147CW2qmto/ZLzqTzlfr7map8aRSRE6JBkvk6fNS6mTxZTWs/W
        +s6eD1g0MzNTTXU36QWFPLM/PYd8BmIUUhA7d1f9gHUtAS/0qIS+PnGqrqk9Z/PqAdTdfeOPvWG
        RjS8qNcaexh2G90U+QJZUQw3PpJ3PL2AyuB2Y4O/aJmriot9qA29FwMBgu/Fkpsx9h+I=
X-Google-Smtp-Source: ABdhPJycNu2YnWFK1NTL+QzSc70AYIET5wiTJY6H55WHHR0/B8M7s+S5jxuU9/GwE0G/y7SrhzGgT2uRrEYXpw==
X-Received: from lux.lon.corp.google.com ([2a00:79e0:d:110:7220:84ff:fe09:a3aa])
 (user=maennich job=sendgmr) by 2002:a0c:f74b:: with SMTP id
 e11mr14439994qvo.167.1598459316875; Wed, 26 Aug 2020 09:28:36 -0700 (PDT)
Date:   Wed, 26 Aug 2020 17:28:23 +0100
In-Reply-To: <20200826162828.3330007-1-maennich@google.com>
Message-Id: <20200826162828.3330007-2-maennich@google.com>
Mime-Version: 1.0
References: <20200826162828.3330007-1-maennich@google.com>
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
Subject: [PATCH v5.4 1/6] kheaders: remove unneeded 'cat' command piped to
 'head' / 'tail'
From:   Matthias Maennich <maennich@google.com>
To:     stable@vger.kernel.org
Cc:     kernel-team@android.com, maennich@google.com,
        Denis Efremov <efremov@linux.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

The 'head' and 'tail' commands can take a file path directly.
So, you do not need to run 'cat'.

  cat kernel/kheaders.md5 | head -1

... is equivalent to:

  head -1 kernel/kheaders.md5

and the latter saves forking one process.

While I was here, I replaced 'head -1' with 'head -n 1'.

I also replaced '==' with '=' since we do not have a good reason to
use the bashism.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
(cherry picked from commit 9a066357184485784f782719093ff804d05b85db)
Signed-off-by: Matthias Maennich <maennich@google.com>
---
 kernel/gen_kheaders.sh | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/gen_kheaders.sh b/kernel/gen_kheaders.sh
index 5a0fc0b0403a..b8054b0d5010 100755
--- a/kernel/gen_kheaders.sh
+++ b/kernel/gen_kheaders.sh
@@ -41,10 +41,10 @@ obj_files_md5="$(find $dir_list -name "*.h"			   |
 this_file_md5="$(ls -l $sfile | md5sum | cut -d ' ' -f1)"
 if [ -f $tarfile ]; then tarfile_md5="$(md5sum $tarfile | cut -d ' ' -f1)"; fi
 if [ -f kernel/kheaders.md5 ] &&
-	[ "$(cat kernel/kheaders.md5|head -1)" == "$src_files_md5" ] &&
-	[ "$(cat kernel/kheaders.md5|head -2|tail -1)" == "$obj_files_md5" ] &&
-	[ "$(cat kernel/kheaders.md5|head -3|tail -1)" == "$this_file_md5" ] &&
-	[ "$(cat kernel/kheaders.md5|tail -1)" == "$tarfile_md5" ]; then
+	[ "$(head -n 1 kernel/kheaders.md5)" = "$src_files_md5" ] &&
+	[ "$(head -n 2 kernel/kheaders.md5 | tail -n 1)" = "$obj_files_md5" ] &&
+	[ "$(head -n 3 kernel/kheaders.md5 | tail -n 1)" = "$this_file_md5" ] &&
+	[ "$(tail -n 1 kernel/kheaders.md5)" = "$tarfile_md5" ]; then
 		exit
 fi
 
-- 
2.28.0.297.g1956fa8f8d-goog

