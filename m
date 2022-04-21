Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAAE50963C
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 07:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384189AbiDUFKe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 01:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383064AbiDUFKe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 01:10:34 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45369B7CC
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 22:07:44 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id b17so2915052qvf.12
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 22:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=mn5UCdiRBJwtZVlvBXm+yjZ+Fy8TfgecZK4kunLQV5A=;
        b=b+gtLyv4wHnV3NYuJEzvIAdfwp58UVw6BFY2NTMp1VDywItjSEbgD380WsKNCPgZnm
         IjqW9YvGV3HfT6KH67fncWXTcDrwBihZx4ryNB19fQ2AWr7CE8YSayj9V9Eo2lIJQeDA
         DrRynAQ5bPyXgP65ULUKkKYvlfwsjAiOrjuWwom6fyi8KRkpKlTcgAZPe50aAh4cgHRO
         tQSMokhxgQGWavoMdpYMat31rjeJg2tZEaQf9BGvgTAP89Go4wtzoIPD9TTMyZBwqmKj
         5EVA0tqflajslrzD8iRS/cLn82Gq83zkc+AmoHpcOCGZmxjNK1hN3kHqZaMLRvVDf/PA
         HL/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=mn5UCdiRBJwtZVlvBXm+yjZ+Fy8TfgecZK4kunLQV5A=;
        b=PMDUcK+dI8svCz5AseMaGsQOL0PuHwKW/YN6LCetHKC7A8v1bknKk52fpUFodL2FJo
         XnebU3zVno6PgE0Flo76nQgqlbyxchdXTvTCPGRrBjoYbCCNDcq6p1kIwy3Fr1buPOL5
         PAeXSKeC0uI4I5AtdvmiXsBxOUNWphxU9P4QuxKwIbrOqGuk+zTLp9aNGGhLiBS9VvOz
         RQ/KTs3PkG+Az3FnUvTR2eZM4f+Fqq8JqPG6oM8acrKaWp+GaWVTotUW1S8o15VgPGyY
         YB9wo8vUcsTDBqhyBo2BoC174VKyafcxdKt8Eo6wE8vdQHhpuZ48A74hNKnkXusgjrzc
         wUPQ==
X-Gm-Message-State: AOAM533UEXmUipbNM6BLnXcFoDXrzQxV99gtnBI23c/7zD1kaKOB2dsj
        6ouJf9GjoyrEE4KqI+JCISWn7WBO+s2yrJlPg7OcLNm8/OysVQ==
X-Google-Smtp-Source: ABdhPJzpsIOmasPKBVYDGiPd6jF4JZw0MIgU8auZbLvxU10FXO0ACvPOx2iok3zgX98FTkm43qtfgaH0ur9oBgCuHJY=
X-Received: by 2002:a05:6214:e85:b0:449:9a6d:5eaf with SMTP id
 hf5-20020a0562140e8500b004499a6d5eafmr4671095qvb.6.1650517663448; Wed, 20 Apr
 2022 22:07:43 -0700 (PDT)
MIME-Version: 1.0
From:   Atul Khare <atulkhare@rivosinc.com>
Date:   Wed, 20 Apr 2022 22:07:32 -0700
Message-ID: <CABMhjYrkenxuo-tiMmR0-eHtBv1=cYDmzcc5RydtzVP6DG=nnA@mail.gmail.com>
Subject: [PATCH 1/4] dt-bindings: sifive: Support 1024 hart contexts
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

Fixes device tree schema validation error messages like 'clint@2000000:
interrupts-extended: [[3, 3], [3, 7] ... is too long'.

The CLINT bindings don't define an "interrupts-extended: maxItems",
which trips up the dt-schema checks. Since there's no ISA-mandated
limit, we arbitrarily chose 1024 to reflect the soon-to-be maximum of
NR_CPUS=512 (systems typically have two hart contexts per CPU).

Fixes: a2770b57d083 ("dt-bindings: timer: Add CLINT bindings")
Cc: stable@vger.kernel.org
Signed-off-by: Atul Khare <atulkhare@rivosinc.com>
---
 Documentation/devicetree/bindings/timer/sifive,clint.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/timer/sifive,clint.yaml
b/Documentation/devicetree/bindings/timer/sifive,clint.yaml
index 8d5f4687add9..4a1f6d422138 100644
--- a/Documentation/devicetree/bindings/timer/sifive,clint.yaml
+++ b/Documentation/devicetree/bindings/timer/sifive,clint.yaml
@@ -44,6 +44,8 @@ properties:

   interrupts-extended:
     minItems: 1
+# Based on updated max(NR_CPUS) (512) * (2 contexts per CPU)
+    maxItems: 1024

 additionalProperties: false

--
2.35.1
