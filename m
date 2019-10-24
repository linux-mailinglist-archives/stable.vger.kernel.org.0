Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7A81E32CC
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbfJXMs5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:48:57 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33065 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbfJXMs5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:48:57 -0400
Received: by mail-wr1-f66.google.com with SMTP id s1so17172972wro.0
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZLTRCrb6OKFWui+gzD/m98CPKkoAbtO0hB2TzILD7yE=;
        b=xwZ27ovf8hDHLQZRtgYF/29Miymwrwotyi0HnqfkdFUCettBOLn//a7NqCyY78aZyk
         uLx82IqO+ZZfxmSZr7UEA/nbV1TvrEOySS6IctKRuybfkRnXiY5JgtIcd6N4HmUjTZXH
         MRP9rg/KCC+9ShswgnJWEO50kku8R11JrkbY7x4I9G0NoyIJaziiOSNivnY5qiCZxsfQ
         sxFPVqsvY/5VKb/Qx5a52lE6+PwEQHWMx0TQmpB/PTAgwsujANjLpbXpnK2jIm7w76f+
         wHbmpJRg2JEg5QbQ9CrR1gAd4/X3ujnOqVJ8LI6OfINheGF6EGsx3Qmko5zK3RbiGJ2g
         2hOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZLTRCrb6OKFWui+gzD/m98CPKkoAbtO0hB2TzILD7yE=;
        b=YFSZyknxebXXdGcoefHUC7WMOgedEYOSE3gbGU+mowOImX+i7WGUn//t3Qnj3eLe/M
         nsbKAIbHcbVDwtF48ZONJUbagwnIBgkRu/k9mcfSWGDollvNEFP2cehstM6G04K/6/NR
         0kBUzllEfxOhVqF+SuT56Ii1lavidyvmjrmOlLuRKv0fgCeQbh3s5B465WOEoZ+ijN3S
         mWQQgLl4UbYJ+fy3ZldhkGT1eEqVq2u4jQh+DPeoNAjYxy/9TGBrN59SnjQPIiJgr+Dp
         ROTc+a1wizwLXKshjx+vboO6JaDTILL5Py5saNElL4rnS7wqZiIdDJMBXUYkmhoDgxcU
         Imsg==
X-Gm-Message-State: APjAAAWJ22BYaCegDcVCRXKJPLaUinVw8oNRteyXCXm4QEYZQldgUFjX
        qxbidENjTVQYeGj3llkDbB50t6WUl47af17D
X-Google-Smtp-Source: APXvYqwK73a0bRkdISJ0NitktNuAiKMXOoHgBFV+Bt0Ysrwh81Ptf+NGVvP6Vj0zE15QDZmWP3TcNg==
X-Received: by 2002:a5d:4dd2:: with SMTP id f18mr3612797wru.4.1571921334811;
        Thu, 24 Oct 2019 05:48:54 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:48:53 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     stable@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Dave Martin <dave.martin@arm.com>
Subject: [PATCH for-stable-4.14 05/48] arm64: Documentation: cpu-feature-registers: Remove RES0 fields
Date:   Thu, 24 Oct 2019 14:47:50 +0200
Message-Id: <20191024124833.4158-6-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit 847ecd3fa311cde0f10a1b66c572abb136742b1d ]

Remove the invisible RES0 field entries from the table, listing
fields in CPU ID feature registers, as :
 1) We are only interested in the user visible fields.
 2) The field description may not be up-to-date, as the
    field could be assigned a new meaning.
 3) We already explain the rules of the fields which are not
    visible.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Dave Martin <dave.martin@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
[ardb: fix up for missing SVE in context]
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 Documentation/arm64/cpu-feature-registers.txt | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/Documentation/arm64/cpu-feature-registers.txt b/Documentation/arm64/cpu-feature-registers.txt
index ddd566fea3f2..22cfb86143ee 100644
--- a/Documentation/arm64/cpu-feature-registers.txt
+++ b/Documentation/arm64/cpu-feature-registers.txt
@@ -110,7 +110,6 @@ infrastructure:
      x--------------------------------------------------x
      | Name                         |  bits   | visible |
      |--------------------------------------------------|
-     | RES0                         | [63-52] |    n    |
      |--------------------------------------------------|
      | FHM                          | [51-48] |    y    |
      |--------------------------------------------------|
@@ -124,8 +123,6 @@ infrastructure:
      |--------------------------------------------------|
      | RDM                          | [31-28] |    y    |
      |--------------------------------------------------|
-     | RES0                         | [27-24] |    n    |
-     |--------------------------------------------------|
      | ATOMICS                      | [23-20] |    y    |
      |--------------------------------------------------|
      | CRC32                        | [19-16] |    y    |
@@ -135,8 +132,6 @@ infrastructure:
      | SHA1                         | [11-8]  |    y    |
      |--------------------------------------------------|
      | AES                          | [7-4]   |    y    |
-     |--------------------------------------------------|
-     | RES0                         | [3-0]   |    n    |
      x--------------------------------------------------x
 
 
@@ -144,7 +139,8 @@ infrastructure:
      x--------------------------------------------------x
      | Name                         |  bits   | visible |
      |--------------------------------------------------|
-     | RES0                         | [63-28] |    n    |
+     |--------------------------------------------------|
+     | SVE                          | [35-32] |    y    |
      |--------------------------------------------------|
      | GIC                          | [27-24] |    n    |
      |--------------------------------------------------|
-- 
2.20.1

