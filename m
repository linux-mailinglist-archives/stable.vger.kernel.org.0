Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776B237BC8E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 14:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbhELMbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 08:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232311AbhELMbw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 08:31:52 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845B3C061574
        for <stable@vger.kernel.org>; Wed, 12 May 2021 05:30:43 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id v5-20020adf9e450000b029010e708f05b3so5778712wre.6
        for <stable@vger.kernel.org>; Wed, 12 May 2021 05:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=m93eu6W2KVcFNKC6wVksPuu7Hz/OKNSjDkQtTQ8xC0c=;
        b=eBPoG59i5CjMHvl+lM2/ALtCmAF5Z3Xc5TbqTqAd0+ZIqw3xlk/URF9UzAMZ+ycPlp
         FoSr0bwoGnzAcjnnzSvp8iuLxsSI/PB86obJX0VAKjZr/X2j43ffA5bpdYkkhozOuaKc
         LoeQ9vThZbxBOS3hPzNztSrhkM2mOx/HI4TfaaCjITPUd7OLwUekymfa1SC/ZjpzATYv
         lB1+MPHyxjFTAxIvq66dsUu3utsdHYV2X26W5+Do38IuTTMB3g161bPvfZDP62jGyOLT
         XWYjlDipyg2Qs9tMZ3D4nQ4ADYcxCYMWSf3jyafCOnvdlN8PUzWZTdelsoDXG2y4xvLB
         fMPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=m93eu6W2KVcFNKC6wVksPuu7Hz/OKNSjDkQtTQ8xC0c=;
        b=jrsJkljU5ALOsiEnbdbeRawhnNPYsALxSk+aVediyUnPUeY0C0muiT84uxi+C7PoEU
         kqGnU5YPYFUOt51B3hEKl6AHOnpbQb3n4cmW1878W9vN4J4kI29ySHQHhmClan8n6gnw
         2omtbwSw79bjqVPkf5/swgJclfM15hq/12lnzf5PhD/0anWPpScS1zuPOjAxJ8J7o6sz
         a8SPxxBNv+DdblAaHMgOxCU+KozTcRZ2EjrfDdjO8yFZ1UTdVres3cn119mgZlWp4ahH
         Jc0S4GRhqZdc8F6fTa96t1uU6ckqYZSrSPQ1kz9tpCGxeZBra7N6utjK7bNfszyykOzx
         QZ6Q==
X-Gm-Message-State: AOAM532TSMstc7RW7smyTiNqt8rQ2K9qWq4fPeAztOcD+oXNmkNAHu0k
        +rLsbxaZ/45MPExP8RuWqnv1sQ7/ug6iU+SP3paMCXz4UgF9iIr0Jgp7L2lCBffAmFgXd/t9SmW
        mBcZo0Vg3aTW3dzCNbpsGrfEgkMEQ1sd+sZT9NeDpg0Q0a6UCeDGRAqZtOZppo6pB
X-Google-Smtp-Source: ABdhPJwlfcIOyT6+f23F54ZcMBpg56iBlgiYIifLVSbWYa3JMtS9CHaN04pVLd/llgiaiv/yxDbPcBEZ/IrZ
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a7b:ca55:: with SMTP id
 m21mr11147168wml.103.1620822642221; Wed, 12 May 2021 05:30:42 -0700 (PDT)
Date:   Wed, 12 May 2021 12:30:38 +0000
In-Reply-To: <20210512123038.3287684-1-qperret@google.com>
Message-Id: <20210512123038.3287684-2-qperret@google.com>
Mime-Version: 1.0
References: <20210512122853.3243417-1-qperret@google.com> <20210512123038.3287684-1-qperret@google.com>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH stable 4.9 2/2] Revert "fdt: Properly handle "no-map" field in
 the memory region"
From:   Quentin Perret <qperret@google.com>
To:     stable@vger.kernel.org
Cc:     alexandre.torgue@foss.st.com, robh+dt@kernel.org,
        f.fainelli@gmail.com, ardb@kernel.org, gregkh@linuxfoundation.org,
        sashal@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 86ac82a7c708acf4738c396228be7b8fdaae4d99.
It is not really a fix, and the backport misses dependencies, which
breaks existing platforms.

Reported-by: Alexandre TORGUE <alexandre.torgue@foss.st.com>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 drivers/of/fdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index f90b626269ab..e9360d5cbcba 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1159,7 +1159,7 @@ int __init __weak early_init_dt_reserve_memory_arch(phys_addr_t base,
 					phys_addr_t size, bool nomap)
 {
 	if (nomap)
-		return memblock_mark_nomap(base, size);
+		return memblock_remove(base, size);
 	return memblock_reserve(base, size);
 }
 
-- 
2.31.1.607.g51e8a6a459-goog

