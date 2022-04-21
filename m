Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F28E50964A
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 07:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384180AbiDUFKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 01:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384188AbiDUFKo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 01:10:44 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5F212A81
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 22:07:56 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id x12so2518165qtp.9
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 22:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=WMD6BoGgj5AAoZUG7tKG58yuPyFIUqe2i9fDw1AR4nY=;
        b=LzgyyG3tDX79AEDuAKIa8zuJw8Z3woaFJz/EzuAPUdzPqFG9vDN1UqwmGmfRKYf4XJ
         K4x+PLkBBlkktiftyEO3J/cYRtn8awZuerX8IwgVO576Y0Nb+qnZUJNYbJ0dof9qDGUx
         JAV+t+fIa2eO4Jmo0YQYXRzoHMoarbk0gKmh0pdOX848wEyIRFAprTmLo/aczi/gzbtK
         EwCL1B5Stc58b/Bmp6YZ6XqFOT/8Z2seV+OfGjmhqHFLiqDK53zb3qBLt6czps62x7BF
         zdv78VPL0ecoKoKYIkAjiu3wnIA5O/YGnrSS7sNDynAXZ0NUECiwTsYStya80iaILmfn
         TduQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=WMD6BoGgj5AAoZUG7tKG58yuPyFIUqe2i9fDw1AR4nY=;
        b=XMbdOEb5VQ38LpeTRNySVGDfoc6pT9tkGSobIvDv4z2IUacQUSgCgRx59WVFduTpZe
         smM6oso2TW7hOF3e6VGpUGGnAMvsmKTl5uPsmB83ke0/9EyuwSemH8YdrznqBIKk7oGU
         mPNN5WmIkpk6Mcq1+UGIv0AHXdt2tfixvpcz4ov3T06/eEkoBVH8URsU5moYoXPovHWB
         jW8Z4GJnLEuEa48PRsus4Mj0Nj5O/pya8xe9Y9jlT3OQMuINOyey6DD0g0dg7aLjAnLJ
         Y0VK6MxeoaIkIUeXgPUvcCFwVdBrBMLyTZYPlpRN2G/gFp8TGyitHa8azZSJiaA+lpC9
         OaZQ==
X-Gm-Message-State: AOAM5314c/bJhuR1KAJgjtKUX9OU6XQCVmdmzYPoXW3Ipm7y5eyjgNmZ
        gr4fr3s18v5029LMJQVNX0SyqZIJyNWBzjsPP9HsPvotTE1tYA==
X-Google-Smtp-Source: ABdhPJz9qPz5p6rXBPGIONhPu0U34HKAR5/kWRR/HXVAPk5PbkjhAG1DDycW4XB7DGAZutTZbqQLc4oQQDlq0Y9WbTU=
X-Received: by 2002:ac8:7d08:0:b0:2f1:e349:adb7 with SMTP id
 g8-20020ac87d08000000b002f1e349adb7mr16006271qtb.616.1650517675214; Wed, 20
 Apr 2022 22:07:55 -0700 (PDT)
MIME-Version: 1.0
From:   Atul Khare <atulkhare@rivosinc.com>
Date:   Wed, 20 Apr 2022 22:07:44 -0700
Message-ID: <CABMhjYpUn4VGku+WQ1cVdbQJWp6sVfkoQg5C2PVZYyaDybA_Aw@mail.gmail.com>
Subject: [PATCH 2/4] dt-bindings: sifive: add cache-set value of 2048
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fixes Running device tree schema validation error messages like
'... cache-sets:0:0: 1024 was expected'.

The existing bindings had a single enumerated value of 1024, which
trips up the dt-schema checks. The ISA permits any arbitrary power
of two for the cache-sets value, but we decided to add the single
additional value of 2048 because we couldn't spot an obvious way
to express the constraint in the schema.

Fixes: a2770b57d083 ("dt-bindings: timer: Add CLINT bindings")
Cc: stable@vger.kernel.org
Signed-off-by: Atul Khare <atulkhare@rivosinc.com>
---
 Documentation/devicetree/bindings/riscv/sifive-l2-cache.yaml | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/riscv/sifive-l2-cache.yaml
b/Documentation/devicetree/bindings/riscv/sifive-l2-cache.yaml
index e2d330bd4608..309517b78e84 100644
--- a/Documentation/devicetree/bindings/riscv/sifive-l2-cache.yaml
+++ b/Documentation/devicetree/bindings/riscv/sifive-l2-cache.yaml
@@ -46,7 +46,9 @@ properties:
     const: 2

   cache-sets:
-    const: 1024
+    # Note: Technically this can be any power of 2, but we didn't see
an obvious way
+    # to express the constraint in Yaml
+    enum: [1024, 2048]

   cache-size:
     const: 2097152
--
2.35.1
