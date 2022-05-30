Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 959905388B2
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 23:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238626AbiE3VyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 17:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238722AbiE3VyI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 17:54:08 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD55353B65
        for <stable@vger.kernel.org>; Mon, 30 May 2022 14:54:07 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-f3381207a5so4642851fac.4
        for <stable@vger.kernel.org>; Mon, 30 May 2022 14:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4p32GEuTMGI9oMmOtqkzKTHBHF2Kr46ihYOqGaUec2g=;
        b=pplyD/50N3pQ1Kic5z4t4Mn9L9nMQ98OX694u+DtyQvfi0DPmogGQhaGVvIuYc8TEE
         xJLU87pmcc/K1V9daiWT4T2J2IRm5gVkWXxrG3wc8WzdFK2fwOD8p8POfJ29vQKrL5II
         p4tNTlZiEx8VaZwk25ABmB7MiRpR7wkENOAE8VrwF69A8g1eT/peUc3432Mu1ZMyFxhT
         RrZeQVgcpIn34F8RuX1omiflD9NnrnOwWYkqxpGlcihlGVB5Kr7ql05FQ7c6K5dbSn7P
         E+jTDndvPTIsrMVCFJfHHc9DSxgd2vt8p/pDZs3FyQZEIxjV8tJmBkJv5HCaDGpjBRsG
         KE6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4p32GEuTMGI9oMmOtqkzKTHBHF2Kr46ihYOqGaUec2g=;
        b=RkuiiNp4m9YKFv5etEDFqxLjIjpap94wkuA5+khj+4U4BJNHCnGjdw73TjfNYZ4inT
         wgFotG7h/0b2IKRmI+X6RAvgyaRmJvUiUBvaNuDqIVzJ2Xc6UWArtFkw6JiuDKzSvc/f
         E8wQsV4UF+BP/f1X2Uv6SyW2S62mStAsFWWkUPUFDEvubnroWEhkEW1153KrHQNbWYDA
         JUmCfFk+S5jfJDHkXcGXqOR3dVuWovQfNqjwcBkeJ9qeQc0ZxB1lwL5vdn5OOMHRsJTh
         eWd4pWif+AMXxLdfmsqH8R5ZJ6TUMyd+RTO/qaCarjFj6iCBscrOf1+IDyVC2tgIQnDA
         1vxw==
X-Gm-Message-State: AOAM533HO+3OlXCOPZRnxTm9A12gXTV3SipXOtasKLVzuzyCLE81qlTK
        r+dJgmoCI6sq0BQsxtIwWObR+w==
X-Google-Smtp-Source: ABdhPJzu+B/bQqocsmErKvFXIvYU6Z8ETES5x0chWa2J28udLBMQFij8gvGlclizW30qqhvSo0fYwA==
X-Received: by 2002:a05:6870:479f:b0:f2:bdee:1461 with SMTP id c31-20020a056870479f00b000f2bdee1461mr11313814oaq.299.1653947647211;
        Mon, 30 May 2022 14:54:07 -0700 (PDT)
Received: from alago.cortijodelrio.net ([189.219.75.147])
        by smtp.googlemail.com with ESMTPSA id fq11-20020a0568710b0b00b000f23989c532sm4230425oab.8.2022.05.30.14.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 14:54:06 -0700 (PDT)
From:   =?UTF-8?q?Daniel=20D=C3=ADaz?= <daniel.diaz@linaro.org>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Cc:     Ben Hutchings <ben@decadent.org.uk>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?UTF-8?q?Daniel=20D=C3=ADaz?= <daniel.diaz@linaro.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 4.19 1/3] libtraceevent: Fix build with binutils 2.35
Date:   Mon, 30 May 2022 16:53:23 -0500
Message-Id: <20220530215325.921847-2-daniel.diaz@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220530215325.921847-1-daniel.diaz@linaro.org>
References: <20220530215325.921847-1-daniel.diaz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

[ Upstream commit 39efdd94e314336f4acbac4c07e0f37bdc3bef71 ]

In binutils 2.35, 'nm -D' changed to show symbol versions along with
symbol names, with the usual @@ separator.  When generating
libtraceevent-dynamic-list we need just the names, so strip off the
version suffix if present.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Tested-by: Salvatore Bonaccorso <carnil@debian.org>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Daniel Díaz <daniel.diaz@linaro.org>
---
 tools/lib/traceevent/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 05f8a0f27121a..b7f7e4e541d7b 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -263,7 +263,7 @@ define do_generate_dynamic_list_file
 	xargs echo "U w W" | tr 'w ' 'W\n' | sort -u | xargs echo`;\
 	if [ "$$symbol_type" = "U W" ];then				\
 		(echo '{';						\
-		$(NM) -u -D $1 | awk 'NF>1 {print "\t"$$2";"}' | sort -u;\
+		$(NM) -u -D $1 | awk 'NF>1 {sub("@.*", "", $$2); print "\t"$$2";"}' | sort -u;\
 		echo '};';						\
 		) > $2;							\
 	else								\
-- 
2.32.0

