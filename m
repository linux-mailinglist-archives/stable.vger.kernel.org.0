Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2AAD6FCA
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 09:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbfJOG7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 02:59:44 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34248 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbfJOG7m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Oct 2019 02:59:42 -0400
Received: by mail-pg1-f196.google.com with SMTP id k20so4185831pgi.1
        for <stable@vger.kernel.org>; Mon, 14 Oct 2019 23:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=WEvY8mI7wziVLeSGskg+VNlvZA9UmNy6YweIvzpqB9w=;
        b=YOT0SMP8zAfJji7EtL9vvZypd6z4pxouSQAnJufkKRSOMQ4ymp7uwYdjKZcCXY7Zr/
         vlHfrHfFTdZDS7kxk9/xC++gQjcLxWTpFf1Emh86cDYBMu9X0nyxBsOvX6zpeyDGFXg8
         sHb+qmocNkSYNxf9LblfFZD/XBXqzbvc/zUvVX/hYJjquDKKTQ0o0sY4IgVjCL2LiSi8
         qMPvK2TNwjKMR41GCEAWL3IiVLt/FAhHUOeXJouxPtHSvK/9eLS8eODPM1bEWkWRDHmr
         1L4HLAOGKmMoAC1as61Tls400S2SuDX1FGS1HRWvfX7H83dewtHM792iH76FBZw+XJya
         I/DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WEvY8mI7wziVLeSGskg+VNlvZA9UmNy6YweIvzpqB9w=;
        b=elRPOCydmx/72+cLdYQ2zKtCxJ89BLXGr3t0EgcSlEfxJ18OqtaXvAGzZSYYUpc9H1
         0Qf9F7Ski/Wcc6gdRLGSRRtL7VqMPcYuu4b8jD787HqfjT36X8Y5ruvY0VeKhx+EFAW7
         1XnjTN28Nb7SG1GQwPmHi1W6qSDDscLoPoUZKZstUU5uyKYY9ID/CPist8YjIae2ZkZq
         a1fbs97hm0OxE4ZTJr4SBaPsH5wbhYzex4gd0vw42DwdEM5+YyADy6h6APcj2s0B+NPv
         lE8Ei/LyTfGHzogKtl1QXKkEMpjthxZAcEPASwCMnOyw+tYtgoXtMA16GcgOoyn+dvTO
         6AvA==
X-Gm-Message-State: APjAAAVw/XYNlTg5hc1YN2a23E75euUKQhoCh9iSNpGP/LsgimGRCg/E
        7o32jDK9Fg0L5Z/4nuNCUsojVl3w0DE=
X-Google-Smtp-Source: APXvYqyVgzodVpkQoZfWKsHR6n19NZcAwX3aK1+mxFq1JsBD/k0LL87kiVMZ0tTHshCDkxYoswk+bw==
X-Received: by 2002:aa7:9e88:: with SMTP id p8mr38091616pfq.10.1571122779560;
        Mon, 14 Oct 2019 23:59:39 -0700 (PDT)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id i16sm17952646pfa.184.2019.10.14.23.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 23:59:38 -0700 (PDT)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [stable 4.19][PATCH 1/4] ARM: dts: am4372: Set memory bandwidth limit for DISPC
Date:   Tue, 15 Oct 2019 00:59:34 -0600
Message-Id: <20191015065937.23169-1-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

commit f90ec6cdf674248dcad85bf9af6e064bf472b841 upstream

Set memory bandwidth limit to filter out resolutions above 720p@60Hz to
avoid underflow errors due to the bandwidth needs of higher resolutions.

am43xx can not provide enough bandwidth to DISPC to correctly handle
'high' resolutions.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Cc: stable <stable@vger.kernel.org> # 4.19
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 arch/arm/boot/dts/am4372.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
index d4b7c59eec68..cf1e4f747242 100644
--- a/arch/arm/boot/dts/am4372.dtsi
+++ b/arch/arm/boot/dts/am4372.dtsi
@@ -1142,6 +1142,8 @@
 				ti,hwmods = "dss_dispc";
 				clocks = <&disp_clk>;
 				clock-names = "fck";
+
+				max-memory-bandwidth = <230000000>;
 			};
 
 			rfbi: rfbi@4832a800 {
-- 
2.17.1

