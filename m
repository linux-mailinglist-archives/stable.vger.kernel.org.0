Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC04969F35F
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 12:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbjBVLWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 06:22:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbjBVLWx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 06:22:53 -0500
Received: from mail-ed1-x54a.google.com (mail-ed1-x54a.google.com [IPv6:2a00:1450:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE56A26AD
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 03:22:49 -0800 (PST)
Received: by mail-ed1-x54a.google.com with SMTP id t9-20020a056402524900b004af59c073abso4900476edd.6
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 03:22:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=k8GcqkkFXOmQfJIUtbmUr5k1z/whW+UlGQJ8Pnqpo3w=;
        b=byR2C1GGXLrWHhD76Mt/Tp3bc81XhWJlKfJSRUr4e0J6wKICHnj6e45RrbZdYuHGnX
         u1rg+7bBJheX2Nc6wahgC0+8ja0m2k7ymzsZvsoYTpFUrfBvxhlLjnMRvSF7ZefKYZZk
         VUHy2Qr4IPZ+Qp9mnukVY9IdNwSRSF9rF1EnR71dD9uVX5D41UVW991GnvFgYjn2+9mI
         V+MuAFCYzWR31rIsj2R4e+mVne3g8CF3pMPXQd3gHKaQilhYK1a2PomqRKk+mxeXPxup
         JcAXTEdl5nYqP8WXIZa3C/EbTY+qsNqblairpYOHy00IT73/Z/bdcjzqTIgCDkrVxPyv
         9JIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k8GcqkkFXOmQfJIUtbmUr5k1z/whW+UlGQJ8Pnqpo3w=;
        b=7mNnKeDKtOlhWCbE4NUV6oK3pV8Q9rQpo/PySxoTFYCoZjhwMmWJWsWs1W7wC3X1TA
         A/Xhlbv3iMkhx4zn9yqKVBYYCWY9lXTzVPxPQTvpkD3Q9Ii5U8iVjBcoAoTouHeJiVlR
         hAAp4s75PrWzGapEXPxw5FbFsY3tBBN9MWgOtTjI+OUQJiY0cB6pKT9ZGIHhtynhkeY0
         3y7toF9eR4nk+SEUf3SVv45S71x8xj1f6RNa9k4nm+eiaMX5jAX4xFVJUN9fr4w3BSYT
         D1CgCzAirmJoWJv81n5FwELJs1E4H0YFj0wKkCZUfoxvjWET9yrJ4TDLal+BmOgfGLGe
         +KhA==
X-Gm-Message-State: AO0yUKVV9RFHejMfiBBi0FYrL2oR/2d3VBYj8yO29SYbKAIlUzEsrk1i
        Ao9GlRL77nJzYNgeN1PnuCal5FBPuRV+aQ==
X-Google-Smtp-Source: AK7set9e4WYPVXK1XRVvrsjuSEygc+0lYmRc5aSLwtIGvMcYo8p3s1R4GwNBvn3YhptHYa7gsLOhwjyidAO5fg==
X-Received: from lux.lon.corp.google.com ([2a00:79e0:d:209:35a9:4800:d90c:e9bc])
 (user=maennich job=sendgmr) by 2002:a17:906:22db:b0:8ea:a647:ae5d with SMTP
 id q27-20020a17090622db00b008eaa647ae5dmr1111eja.13.1677064968205; Wed, 22
 Feb 2023 03:22:48 -0800 (PST)
Date:   Wed, 22 Feb 2023 11:21:39 +0000
In-Reply-To: <20220201205624.652313-1-nathan@kernel.org>
Message-Id: <20230222112141.278066-2-maennich@google.com>
Mime-Version: 1.0
References: <20220201205624.652313-1-nathan@kernel.org>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Subject: [PATCH 1/5] MAINTAINERS: Add scripts/pahole-flags.sh to BPF section
From:   maennich@google.com
To:     linux-kernel@vger.kernel.org
Cc:     kernel-team@android.com, maennich@google.com,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

Currently, scripts/pahole-flags.sh has no formal maintainer. Add it to
the BPF section so that patches to it can be properly reviewed and
picked up.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220201205624.652313-2-nathan@kernel.org
Signed-off-by: Matthias Maennich <maennich@google.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4f50a453e18a..176485e625a0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3407,6 +3407,7 @@ F:	net/sched/act_bpf.c
 F:	net/sched/cls_bpf.c
 F:	samples/bpf/
 F:	scripts/bpf_doc.py
+F:	scripts/pahole-flags.sh
 F:	tools/bpf/
 F:	tools/lib/bpf/
 F:	tools/testing/selftests/bpf/
-- 
2.39.2.637.g21b0678d19-goog

