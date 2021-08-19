Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17ECA3F185C
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 13:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238865AbhHSLkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 07:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238208AbhHSLko (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 07:40:44 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6E7C061575;
        Thu, 19 Aug 2021 04:40:08 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id w24so3627056wmi.5;
        Thu, 19 Aug 2021 04:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LH0thD0+NKJpZwefQbdyB/s2IsVbxcK0p6p/WAbflT4=;
        b=C550/W+6JNOG5Usrgj2d06WNFA7jHtLKfnCyiZeKt+9LfSl5AhYZ/wJNwW2NwU4nis
         g0a1eIcDOhRuyPzDPtBa68XNNeG9Jo7gqVhEo1MKL7s2js0fVe/imvDDBWhlC6Wkcm10
         jfTcCer5BA0v+l5jN5/8HKYMq+uwICHhww/DxpFr6jV3ADz/2TKu87UU14EAvCtaIndL
         6HJxc4W+mLWs4ls8kOw3bHoWRY6wVXE4UYRloRDnCeSecVlb+K4DvSzfdPd2/Pc3DMY5
         owwLNCutgHbH35e4VGyMu7c9DEB0DP+ZZBC4QRV/ly874mBOUfJes8cqXsDttVQmUaIl
         HkSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LH0thD0+NKJpZwefQbdyB/s2IsVbxcK0p6p/WAbflT4=;
        b=JUKvoXRi6psvmkuC2U35uOusMxsOOofrRZ3G28/xcFQnu/BonzlpIslZUdebdR/mIx
         56AxeqqPq3ozQ/pT7UM0pA1t3u/t5qB4GHek4rFSISJycaO2okY+OgAwLa6NNiUFwzBD
         5ApLSLGb/P0eCrsd2g1jhGouKHRxDP/ZdvTzbO7xqy0gf8X6awjrAYGh6WOwFmTS7DbZ
         lso6T8lt7RiQMkrNrOqQUDabXkXcji4St/WTsdjA6V/3JpxnkfzQpowQCP7YmfRXI671
         sQWcqVwyrGa2ORhVjrfFW5XsGyfjfnd/JznJC4aPUssm9lYZmF5/Nzm6ybQlbIzq8UEo
         W8/g==
X-Gm-Message-State: AOAM532AKs817RnCl7IBC6crxl8aheyQozfonzO4omdu7+Vu9wEAcZmC
        b59mctN/PvBFPWefdar7IBA=
X-Google-Smtp-Source: ABdhPJyJwLWLb/+v2ia2UarNfITG8IYmP5cNcCXX+LJHhLkfuq7vAagO8+tguzj1XUjjJcY97N4UHA==
X-Received: by 2002:a05:600c:3589:: with SMTP id p9mr3036312wmq.170.1629373207204;
        Thu, 19 Aug 2021 04:40:07 -0700 (PDT)
Received: from localhost.localdomain (arl-84-90-178-246.netvisao.pt. [84.90.178.246])
        by smtp.gmail.com with ESMTPSA id b13sm2650891wrf.86.2021.08.19.04.40.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 04:40:06 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Neuling <mikey@neuling.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        stable@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH v2 1/2] powerpc: kvm: remove obsolete and unneeded select
Date:   Thu, 19 Aug 2021 13:39:53 +0200
Message-Id: <20210819113954.17515-2-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210819113954.17515-1-lukas.bulwahn@gmail.com>
References: <20210819113954.17515-1-lukas.bulwahn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit a278e7ea608b ("powerpc: Fix compile issue with force DAWR")
selects the non-existing config PPC_DAWR_FORCE_ENABLE for config
KVM_BOOK3S_64_HANDLER. As this commit also introduces a config PPC_DAWR
and this config PPC_DAWR is selected with PPC if PPC64, there is no
need for any further select in the KVM_BOOK3S_64_HANDLER.

Remove an obsolete and unneeded select in config KVM_BOOK3S_64_HANDLER.

The issue was identified with ./scripts/checkkconfigsymbols.py.

Fixes: a278e7ea608b ("powerpc: Fix compile issue with force DAWR")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
 arch/powerpc/kvm/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index e45644657d49..ff581d70f20c 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -38,7 +38,6 @@ config KVM_BOOK3S_32_HANDLER
 config KVM_BOOK3S_64_HANDLER
 	bool
 	select KVM_BOOK3S_HANDLER
-	select PPC_DAWR_FORCE_ENABLE
 
 config KVM_BOOK3S_PR_POSSIBLE
 	bool
-- 
2.26.2

