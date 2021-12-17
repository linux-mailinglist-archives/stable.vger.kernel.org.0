Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578F4478E29
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 15:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237492AbhLQOl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 09:41:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237490AbhLQOli (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 09:41:38 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91DD6C061748
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 06:41:37 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id e3so8695973edu.4
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 06:41:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WJLLtim2zy2Cp+CHKaq9b1jzJ0TEP3xfBC/wmHNF3bg=;
        b=RXAJP/Ljc7BKS562r7tAOgwR5c/8YjoX5CroBrwznu3Ai/i3VwkcpNTdjojdsGasoe
         VWh1V7Mq9pBHdXIhwdz9NcWmSu3VVwlRXX2/jZx8nbvQZnZW/FZesH0iqN0JJjVZaLOG
         YgkYab9zCaCpyjeTj/K5U3p5uuFSoPvWqtHV6/8QiUukzgtwLuio52DorRl3yodBU1gn
         fHqVdmNb0VTTn16Lw/97jCIsXFgzfNSsSutHFt0wvP0tFnTaPIdQ2VgyXdhKjzSPXeKS
         t0hBeV6VBZpzvwyywLsXXu5djw9f0VnvvxXYbmE6UlJeWApTc2mqc1syyEA0s6mTZZq3
         R2xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WJLLtim2zy2Cp+CHKaq9b1jzJ0TEP3xfBC/wmHNF3bg=;
        b=kI9r65V4DEInEo4gy9xRimVLmTmLUKCie1cXH01PJv/Fl+5CnYlmm1P5bg3JXc39Xq
         /19w/dLqG5Tf4DzTZIE0N1sKZLtoPo1zZ/FBQ5ngedGxd42xCSyLOLd2GsJbRfI48q2D
         hKUTEJmq4TF7UjgbbRlH/DIAIhocCQO+i66WcsO+cf77sfopM5vKSlPhYP5aBxHh0IwD
         FxXTkkKJYubOyw7ISJA812DWnA0ij4Dnx8916LCM5QXw9Hh8hG5sFHm1LeGnWmHlg2Br
         gI5wQVLR4ZONAj4tvjPQacj9zEetu1q+DkpzilrWVHWiAMMw+iU1gZnFALMCIa5UeT6c
         uhbw==
X-Gm-Message-State: AOAM533P0bYIaQcDYeCK3gI1JCFPuM6X7BdUmt6hB+tkYu/cwV3mgBte
        qfOrTOBCp1ZlaIpm6d51HUI3NZPU/EwDK0gW
X-Google-Smtp-Source: ABdhPJyfryGUY2pGisS+WhHVurJ4oep8frNBDovNq/9Nj8nBpt/Y3r/uar2rNGTrerkS4bcf9jZyCw==
X-Received: by 2002:aa7:dad0:: with SMTP id x16mr3251578eds.404.1639752096108;
        Fri, 17 Dec 2021 06:41:36 -0800 (PST)
Received: from localhost (c-9b28e555.07-21-73746f28.bbcust.telenor.se. [85.229.40.155])
        by smtp.gmail.com with ESMTPSA id cs12sm2967751ejc.15.2021.12.17.06.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 06:41:35 -0800 (PST)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        clang-built-linux@googlegroups.com, ulli.kroll@googlemail.com,
        linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org,
        amitkarwar@gmail.com, nishants@marvell.com, gbhat@marvell.com,
        huxinming820@gmail.com, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, dmitry.torokhov@gmail.com,
        ndesaulniers@google.com, nathan@kernel.org,
        linux-input@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH 4.19 6/6] Input: touchscreen - avoid bitwise vs logical OR warning
Date:   Fri, 17 Dec 2021 15:41:19 +0100
Message-Id: <20211217144119.2538175-7-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211217144119.2538175-1-anders.roxell@linaro.org>
References: <20211217144119.2538175-1-anders.roxell@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit a02dcde595f7cbd240ccd64de96034ad91cffc40 upstream.

A new warning in clang points out a few places in this driver where a
bitwise OR is being used with boolean types:

drivers/input/touchscreen.c:81:17: warning: use of bitwise '|' with boolean operands [-Wbitwise-instead-of-logical]
        data_present = touchscreen_get_prop_u32(dev, "touchscreen-min-x",
                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This use of a bitwise OR is intentional, as bitwise operations do not
short circuit, which allows all the calls to touchscreen_get_prop_u32()
to happen so that the last parameter is initialized while coalescing the
results of the calls to make a decision after they are all evaluated.

To make this clearer to the compiler, use the '|=' operator to assign
the result of each touchscreen_get_prop_u32() call to data_present,
which keeps the meaning of the code the same but makes it obvious that
every one of these calls is expected to happen.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lore.kernel.org/r/20211014205757.3474635-1-nathan@kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 drivers/input/touchscreen/of_touchscreen.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/input/touchscreen/of_touchscreen.c b/drivers/input/touchscreen/of_touchscreen.c
index 9642f103b726..b9baad7d34a7 100644
--- a/drivers/input/touchscreen/of_touchscreen.c
+++ b/drivers/input/touchscreen/of_touchscreen.c
@@ -80,8 +80,8 @@ void touchscreen_parse_properties(struct input_dev *input, bool multitouch,
 	data_present = touchscreen_get_prop_u32(dev, "touchscreen-size-x",
 						input_abs_get_max(input,
 								  axis) + 1,
-						&maximum) |
-		       touchscreen_get_prop_u32(dev, "touchscreen-fuzz-x",
+						&maximum);
+	data_present |= touchscreen_get_prop_u32(dev, "touchscreen-fuzz-x",
 						input_abs_get_fuzz(input, axis),
 						&fuzz);
 	if (data_present)
@@ -91,8 +91,8 @@ void touchscreen_parse_properties(struct input_dev *input, bool multitouch,
 	data_present = touchscreen_get_prop_u32(dev, "touchscreen-size-y",
 						input_abs_get_max(input,
 								  axis) + 1,
-						&maximum) |
-		       touchscreen_get_prop_u32(dev, "touchscreen-fuzz-y",
+						&maximum);
+	data_present |= touchscreen_get_prop_u32(dev, "touchscreen-fuzz-y",
 						input_abs_get_fuzz(input, axis),
 						&fuzz);
 	if (data_present)
@@ -102,11 +102,11 @@ void touchscreen_parse_properties(struct input_dev *input, bool multitouch,
 	data_present = touchscreen_get_prop_u32(dev,
 						"touchscreen-max-pressure",
 						input_abs_get_max(input, axis),
-						&maximum) |
-		       touchscreen_get_prop_u32(dev,
-						"touchscreen-fuzz-pressure",
-						input_abs_get_fuzz(input, axis),
-						&fuzz);
+						&maximum);
+	data_present |= touchscreen_get_prop_u32(dev,
+						 "touchscreen-fuzz-pressure",
+						 input_abs_get_fuzz(input, axis),
+						 &fuzz);
 	if (data_present)
 		touchscreen_set_params(input, axis, maximum, fuzz);
 
-- 
2.34.1

