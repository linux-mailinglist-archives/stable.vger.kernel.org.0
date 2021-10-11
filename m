Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA122428CCD
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 14:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236512AbhJKMPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 08:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236420AbhJKMOz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 08:14:55 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E46C061570
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 05:12:55 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id t2so55529157wrb.8
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 05:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=227cM71+a882UBw3kPMNC7S+XfFg4wBs4k6lX88wrfo=;
        b=CqvWy1fLKJDXJ68PJggmmhC5OlW0HH5g/KIE9v8SDY9b3FcqkEfV3j0hX+WAh+cfnQ
         e/oJva19SGNG319ku4+WRy+zD2VbyyL4wWK7KX2wM60WFbYyKxCd5d3HydY0kg414u6v
         9zTx63loAajGY5FgkU/qyPYB6KQoDqCtYLCqAJBzW/8qjL6IKhkmAJg1sTzE5TluvfBg
         n/4+7D8lLamMzb4lPBJJhnb/9DG0HOzkXSfUYx5EJNmLQPyEgFioFi7i1DnOUZhZ6tGA
         keq3OM8ZErcWsBZXKl7MuJvMc972ssA+sGdorYz8wnNUFThjgN2f9Mp6PyC0sR+QS7dn
         FsBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=227cM71+a882UBw3kPMNC7S+XfFg4wBs4k6lX88wrfo=;
        b=B2/KIJMPIhf+DQURooDKjubohYjrRPvyl+6xT2NT8F9piyzGjhiXD45t9b9ii4d0wb
         xdBZOfdvBud1LgkvFEYCm5D5GCIjgRTYI8+guPZyLFcBz+5vLImdFTMiJT/5OVd7e3o1
         L8AhjaSjpTF7wHFp2svHtxJC2bMLh7IwT8lm6yxX+2/NonOdr/Xsgtb23eeF3g44X97+
         CLZBzrJ8NESzGPMNg4NoT8yyGR8zbKsuXkT+H4Y+E2s3gKXGMZXZ6vkqNv8XALv2l6qu
         gl09MkvGON4sHfRxBBerxQsUKYYRuK4fL6AfwSCVGqS/TLWHLaLCD3AHkpiCBUHkL2Iv
         l+xA==
X-Gm-Message-State: AOAM530jHpsx6rgPdtbjV735Jrxe7PoP73RUAWL5WgrMdvDgJE7dt0Ug
        /hO8jFHjnfA3qwtYpSMZgtGkF9awc3c=
X-Google-Smtp-Source: ABdhPJwAcPR/X3qx8dqMD6GhpLwLgvZQw8nrQWLk50GSjc+KNUfCFpXa8DFFXlEnghL45fKl5zrabg==
X-Received: by 2002:a1c:770b:: with SMTP id t11mr2842006wmi.19.1633954373610;
        Mon, 11 Oct 2021 05:12:53 -0700 (PDT)
Received: from localhost.localdomain (i577BCB28.versanet.de. [87.123.203.40])
        by smtp.gmail.com with ESMTPSA id r27sm7692365wrr.70.2021.10.11.05.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 05:12:53 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Borislav Petkov <bp@suse.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-stable <stable@vger.kernel.org>
Cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH backport for v5.4 and before] x86/Kconfig: Correct reference to MWINCHIP3D
Date:   Mon, 11 Oct 2021 14:03:09 +0200
Message-Id: <20211011120309.16365-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 225bac2dc5d192e55f2c50123ee539b1edf8a411 upstream.

Commit in Fixes intended to exclude the Winchip series and referred to
CONFIG_WINCHIP3D, but the config symbol is called CONFIG_MWINCHIP3D.

Hence, scripts/checkkconfigsymbols.py warns:

WINCHIP3D
Referencing files: arch/x86/Kconfig

Correct the reference to the intended config symbol.

Fixes: 69b8d3fcabdc ("x86/Kconfig: Exclude i586-class CPUs lacking PAE support from the HIGHMEM64G Kconfig group")
Suggested-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20210803113531.30720-4-lukas.bulwahn@gmail.com
[manually adjusted the change to the state on the v4.19.y and v5.4.y stable tree]
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
 arch/x86/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d994501d9179..3dd2949b2b35 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1387,7 +1387,7 @@ config HIGHMEM4G
 
 config HIGHMEM64G
 	bool "64GB"
-	depends on !M486 && !M586 && !M586TSC && !M586MMX && !MGEODE_LX && !MGEODEGX1 && !MCYRIXIII && !MELAN && !MWINCHIPC6 && !WINCHIP3D && !MK6
+	depends on !M486 && !M586 && !M586TSC && !M586MMX && !MGEODE_LX && !MGEODEGX1 && !MCYRIXIII && !MELAN && !MWINCHIPC6 && !MWINCHIP3D && !MK6
 	select X86_PAE
 	---help---
 	  Select this if you have a 32-bit processor and more than 4
-- 
2.26.2

