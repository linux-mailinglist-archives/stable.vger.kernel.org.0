Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3364B37BC80
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 14:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbhELMaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 08:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbhELMaL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 08:30:11 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773EDC06174A
        for <stable@vger.kernel.org>; Wed, 12 May 2021 05:29:02 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id i19-20020a0cf3930000b02901c3869f9a1dso18740726qvk.5
        for <stable@vger.kernel.org>; Wed, 12 May 2021 05:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=KiTQ0tmc81ANyPOseFFrd2gfMzggs3B1zD8SVLzfwiU=;
        b=XAV5981/+tmded789DUB1YgWC6aivNlma/iKLZmEX3MMJ/z8sYzy3vuq5OUrQQZC0I
         ankuveGMJOE0IFTPqbTWaREWtCgjLcMzwxWPBS8wFvFn3O6VmCZB6LTrlmZWG3yA+bhH
         TYVIMwKu5ok/EAkQ9EOWYdi9GpPdhYOz2Gq3E8A57qMkmfE+tNf43EPgbu8KLxPMuXtZ
         26Rvc3I/f7Tz+6IJnVWmlMdGpQzdidEjcRWhlhQEukwtKxGm6bMClyvUT+MEi9WME8nC
         7kI2Kgu0YHZ8hzrl+nMFFlZyZEj71YosLA4z/wC7BYLOG+oCC8Kl9PTfrDnnveiLL5GE
         Aa0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KiTQ0tmc81ANyPOseFFrd2gfMzggs3B1zD8SVLzfwiU=;
        b=F6S850puOSk153CR2HwbQCQ3d2Aqv1HyvKutzkKht4BWjvu1scNCewZkaz4A818zbh
         A0sQzphFcTd9JZ/L7XsSRo7S3OPFDEwazYQFeDrHHthaCN8Ystj+9tgg/j5pi902IT9P
         h46UeaLYOZ4qm5zRZw4WUl6XXXNiFCykriALMW0OIDdDU6B8+9z8vMIMo8ojn5yH4EPZ
         RTrfFtmUXkiRDAsZathUXatp3n74Z3xZsqM7HM9T/xKd8vPKNfJ/7v4iWIacvkOKW6ld
         RZiXN+gG4cSIEqDvSjOE7ZNTT3kz9d1hgtk3IN0rjC527L7Qc4GZAqUjqdrysye6ZFB6
         islQ==
X-Gm-Message-State: AOAM532OyKp3f7hlVx4/UIuEv8KuUkA7cTCTWtIF8JyL1BFrCxQlaW/x
        cljIBZdjrwllxqRzn7hecllyNI9bGppVSMVPVmlhEwheiOPW+GkL6DTp96yorkfzbeTs3aK/lr2
        eiaUd9NA0Uq375jCKyT/eU8EHgzfUzXoUYvgbDO788crbkoyF9rwO0CLNe24xw7IZ
X-Google-Smtp-Source: ABdhPJx/gQRemBO9WP6bun7ufmuP9RlZaQ0dv2zlet2fL1bNcrMgPObJ2k4AwCPiXj3GsGHIi3V/Kvw8kWXe
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a0c:e3d4:: with SMTP id
 e20mr35122222qvl.10.1620822541588; Wed, 12 May 2021 05:29:01 -0700 (PDT)
Date:   Wed, 12 May 2021 12:28:53 +0000
In-Reply-To: <20210512122853.3243417-1-qperret@google.com>
Message-Id: <20210512122853.3243417-3-qperret@google.com>
Mime-Version: 1.0
References: <20210512122853.3243417-1-qperret@google.com>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH stable 5.4 2/2] Revert "fdt: Properly handle "no-map" field in
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

This reverts commit fb326c6ce0dcbb6273202c6e012759754ec8538d.
It is not really a fix, and the backport misses dependencies, which
breaks existing platforms.

Reported-by: Alexandre TORGUE <alexandre.torgue@foss.st.com>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 drivers/of/fdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 036af904e0cf..223d617ecfe1 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1154,7 +1154,7 @@ int __init __weak early_init_dt_reserve_memory_arch(phys_addr_t base,
 					phys_addr_t size, bool nomap)
 {
 	if (nomap)
-		return memblock_mark_nomap(base, size);
+		return memblock_remove(base, size);
 	return memblock_reserve(base, size);
 }
 
-- 
2.31.1.607.g51e8a6a459-goog

