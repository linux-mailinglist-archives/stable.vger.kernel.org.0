Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A907262D697
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 10:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239931AbiKQJWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 04:22:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239933AbiKQJW0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 04:22:26 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFC16E56E
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:22:25 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-373569200ceso14128477b3.4
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:22:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=81PV7eQ82wZtT/VGDxs+jIe4AApJyHnlMlHWD6JrGrM=;
        b=F3/Op6WSMMmv5RhmNSmGi+exGfsS9gdsED8NVxclY8kenOQPoz1DEOoaMF7o7L7uyw
         hu/+pyzzxWHRKtpijx7NBD5xxeXPs8B3U4kiKEGQ14Eq54ux2eosD7hK23rXbRJLXzNF
         SyH5AvAarVc3w5iBYoozjqW085WGVm/zkrH7erK0Gc/tkwlh8WHxB00k5T81tN+aTZiK
         ZOuA86+vaK1psxie9Awyu2GoAkE0BsiSiRA4pLdFgS+y3iaZ273EmaNrxarHJPCYmaYf
         Yi0QSh5Xr41oWRqTWf7qIq6Y/MdGe+2lCViG9MoJY6DNmD6uSfPMKCr9usowEO9qyuSc
         tFjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=81PV7eQ82wZtT/VGDxs+jIe4AApJyHnlMlHWD6JrGrM=;
        b=M6/LQwMd0EtRh2mPN8ske0+09H9sICmle/MYQrWwRJuSnWZ40DaqlrZ+CFftaAaBvK
         JFiew5G593V/XVouY9+yI6ryERadMlIlxB76pzRlWBh6jUYK+BeqTHLb7SeGowTEzsAD
         uc8ES3aqMlF+jI39zNB0LoDh/XIchMXJlyizOf3EtFIjcyDtYzBLgQpdeLxGIYY1GWNL
         nX2W6D7tU5aFNLUMduU8jYvHYMT6+M3zTeso1YuqZJB7yjfg+zfW0ZD3Guu3vqnjJ25F
         KoijJ5ziR/JonkKQ6vU/jpxkqUqFnUu7pEsO6isoOwrG1hHO9mPgD3ENNO8gwoksMGCG
         hEww==
X-Gm-Message-State: ANoB5pmGD2e5g+okBctjn+m/riHujrCsA4UIrdvufBWWjcXkR9EJ4qnq
        3bFFYNcR9tOFHwmb98Hu0h/0qN2cIfB+KGilKGNUYOLFfgF4v1sXSFU0YG2OjVlaywHWUjy+7bT
        L7x4qKkp24SUph5idAkcKRGeAMHWoAm05hAPdPWxgECXQvj33HPDqVmGnt5yKE6Y97Xc=
X-Google-Smtp-Source: AA0mqf4VqWTzSEfBTfP7cw84aOqVhzOG+oj4GggA0/jixSpErKHUFqThF0SRpGy/ql+OqMDlOUs3d+3Rtc0Gwg==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:416e:f3c7:7f1d:6e])
 (user=suleiman job=sendgmr) by 2002:a05:690c:c19:b0:391:70ef:9e76 with SMTP
 id cl25-20020a05690c0c1900b0039170ef9e76mr683757ywb.42.1668676944266; Thu, 17
 Nov 2022 01:22:24 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:19:48 +0900
In-Reply-To: <20221117091952.1940850-1-suleiman@google.com>
Message-Id: <20221117091952.1940850-31-suleiman@google.com>
Mime-Version: 1.0
References: <20221117091952.1940850-1-suleiman@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH 4.19 30/34] x86/bugs: Add Cannon lake to RETBleed affected CPU list
From:   Suleiman Souhlal <suleiman@google.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org,
        cascardo@canonical.com, surajjs@amazon.com, ssouhlal@FreeBSD.org,
        suleiman@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit f54d45372c6ac9c993451de5e51312485f7d10bc upstream.

Cannon lake is also affected by RETBleed, add it to the list.

Fixes: 6ad0ad2bf8a6 ("x86/bugs: Report Intel retbleed vulnerability")
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
[ bp: Adjust cpu model name CANNONLAKE_L -> CANNONLAKE_MOBILE ]
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/kernel/cpu/common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index c70be58b0a9b..da3819a43418 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1053,6 +1053,7 @@ static const struct x86_cpu_id cpu_vuln_blacklist[] __initconst = {
 	VULNBL_INTEL_STEPPINGS(SKYLAKE_DESKTOP,	X86_STEPPING_ANY,		SRBDS | MMIO | RETBLEED),
 	VULNBL_INTEL_STEPPINGS(KABYLAKE_MOBILE,	X86_STEPPING_ANY,		SRBDS | MMIO | RETBLEED),
 	VULNBL_INTEL_STEPPINGS(KABYLAKE_DESKTOP,X86_STEPPING_ANY,		SRBDS | MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(CANNONLAKE_MOBILE,X86_STEPPING_ANY,		RETBLEED),
 	VULNBL_INTEL_STEPPINGS(ICELAKE_MOBILE,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS | RETBLEED),
 	VULNBL_INTEL_STEPPINGS(ICELAKE_XEON_D,	X86_STEPPING_ANY,		MMIO),
 	VULNBL_INTEL_STEPPINGS(ICELAKE_X,	X86_STEPPING_ANY,		MMIO),
-- 
2.38.1.431.g37b22c650d-goog

