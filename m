Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B78737737F
	for <lists+stable@lfdr.de>; Sat,  8 May 2021 19:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbhEHR4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 May 2021 13:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbhEHR4u (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 May 2021 13:56:50 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7592C061574;
        Sat,  8 May 2021 10:55:48 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id bf4so13996820edb.11;
        Sat, 08 May 2021 10:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AtrZK8p1bxA/0S7KZ9KGxrz9Kd73OP1j4xQqST3FpQM=;
        b=rYLF2tQNY98nt0Q4C4cxJl5OCR2GGIyrS0eOTczS4Q9dLJJrmss/1Kg4tta1Lq6QZw
         0XeSeh82SWbpGRo5jBf5w9hrGQH9NG3jeRUtcjOWhmaZNU6iF067DOMg/kw/w118Iv6z
         4gwqAurx0sZP2WY0VZ1k4aS1Xr3wfYZEyKnTo/e4kkDHL2TZdkhqX9V69hOyzCZfJQgX
         BD8q8Hu5hmE1StvxEEKf7YR+vELWA7fykR+Ss81JxN2O1I7IJTPFBCL44to6kSrFzSGT
         HSKhB8vfAeRo61tIRnIp79Xkq8J3VmRYZ/6g1yUZsCQxkxipTd/pekWRVVOmX0zKUATR
         B/HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AtrZK8p1bxA/0S7KZ9KGxrz9Kd73OP1j4xQqST3FpQM=;
        b=uQWGK7KG84UNnOAOdAVQ0avrHzlomQ6xSwa60jKggrnjH5Xp9uHKhafYohTHliFkgJ
         ez89cYpjFWgxcp1LVo8/SQVddjv2EZQd8d8FjrcBZSHd0Ya3atNRenaBT286PPIJuVlb
         KAFcMmszgwYbwwBY5xxITCdRC+ydVgLuikgAw3dltqZDzb91CNDRvDouxcpweeducQvD
         +rSPlhlKiSyeWjot79tL8iY4lCGVRFiCOdLvjiROcyk7g/LDxqwyzDe8HfbbKmhj0miv
         codRDIPfIZeBPqaTgY+Y4r/5UL9BH/UmC+dsWACxwfoIHcxAwgQK98YFlXghd0Hx0rXq
         e1lQ==
X-Gm-Message-State: AOAM530fskm01VNkyRBNP4PwpOMKR1Rc6aph9DTOcUDeLvEf1aFdpwb7
        W34Kn7uCXoORRZ5NBxq3AA4=
X-Google-Smtp-Source: ABdhPJwWeu784vMbi58aOXEGdWyc5pSUwA6HilBGdnTfSWOQMVuPBnnD76ctJKchXIPyLKmoYMQYrQ==
X-Received: by 2002:a05:6402:683:: with SMTP id f3mr18591580edy.22.1620496547401;
        Sat, 08 May 2021 10:55:47 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id j4sm5622474ejk.37.2021.05.08.10.55.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 10:55:47 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Russell King <linux@armlinux.org.uk>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, stable@vger.kernel.org,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH] arm: Enlarge IO_SPACE_LIMIT needed for some SoC
Date:   Sat,  8 May 2021 19:55:35 +0200
Message-Id: <20210508175537.202-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ipq8064 SoC requires larger IO_SPACE_LIMIT or second and third pci port
fails to register the IO addresses and connected device doesn't work.

Cc: <stable@vger.kernel.org> # 4.9+
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 arch/arm/include/asm/io.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
index fc748122f1e0..6f3e89f08bd8 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -197,7 +197,7 @@ void __iomem *pci_remap_cfgspace(resource_size_t res_cookie, size_t size);
 #ifdef CONFIG_NEED_MACH_IO_H
 #include <mach/io.h>
 #elif defined(CONFIG_PCI)
-#define IO_SPACE_LIMIT	((resource_size_t)0xfffff)
+#define IO_SPACE_LIMIT	((resource_size_t)0xffffff)
 #define __io(a)		__typesafe_io(PCI_IO_VIRT_BASE + ((a) & IO_SPACE_LIMIT))
 #else
 #define __io(a)		__typesafe_io((a) & IO_SPACE_LIMIT)
-- 
2.30.2

