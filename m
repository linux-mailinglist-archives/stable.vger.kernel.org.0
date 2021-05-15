Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6C838151D
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 04:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234946AbhEOCPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 22:15:55 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:58433 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234940AbhEOCPy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 May 2021 22:15:54 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id D2ED9580A31;
        Fri, 14 May 2021 22:14:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 14 May 2021 22:14:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm2; bh=jGoXzPaLrTSMzrEWtvvGyydli2
        uRBq2EBIG4vZ4n6Zg=; b=KErnfvg+jCMxthXD2KiR7t2nvj0CgfNLo2U+9Td3QC
        CXeLFGDKffF9iOKwbJ7blXYJUUPLqmDDBg1vxTXzHC8WVM80iAQZ/uEEwTVNF9PS
        dW+X/UyNJUUJDa2SeZ7tR7X4LTD3qWC+m99xuHOndDWqHxtEM5fAOgzUUjFX0OjB
        TW2qdRrmVMEQq4Gk+xHq58xpPFlmswHGEDd5Bc4/8QCE4JLxrnsHVhN8IzqmFET6
        HYvE7khtaLKuVXedTeeFuZm+4Modtv6AUjtKv4yUoiCLeIDkEYTxiMaHlj5nbVja
        3boDLntBJGgwNibk5/acK27FVdjoa7rAbm080+MDHJzw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=jGoXzPaLrTSMzrEWt
        vvGyydli2uRBq2EBIG4vZ4n6Zg=; b=ArAENFk73SO14+CczIfwVKHG4tH1MgnWI
        6z0VGUX6GQjaUImiEx2zqg2qAqOWdueL+chYrrNEWULGHJUWubQkvSNLx6YAESPL
        hyMiFAec8FK8uvt3xOqYfEH1xSdAmNwNd7rGVdlzQyWLRWBYYDn1VElyDE8+uiPw
        FrCpVcjDp3N6rxbMJ4O2LSFSvCGw2OFdLPLtdffju/tKxIlLasUyTtBcQQjlZ2uZ
        p4N/4l2skAdm/qAwKre+7HWAwHtDiLKT3Jg64mJidm7hwp564C387kJ8YrJjd9hs
        smHf2eseDE/uRNZHDx/xW6uMcslsaesquc+j2LdGFxgaSGfmruEoQ==
X-ME-Sender: <xms:kC6fYGBIXvzwJQgEajPsxINAUYuXeT5NkvJNACQl-FUa1YnuvFdxPg>
    <xme:kC6fYAgtoWlSBDr3C19Pyc8EERQq692SRH_Zxx5PKcKkc1XwYVL3fNgeE-M7Ow33z
    GAdAVRiB_2wLwFcgw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehkedguddvjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepufgrmhhuvghl
    ucfjohhllhgrnhguuceoshgrmhhuvghlsehshhholhhlrghnugdrohhrgheqnecuggftrf
    grthhtvghrnhepieffueefheeggffhveevgfdugeeujefgudekteegueelvefgfedujeek
    tdeiheelnecuffhomhgrihhnpehgihhthhhusgdrtghomhdpkhgvrhhnvghlrdhorhhgne
    cukfhppeejtddrudefhedrudegkedrudehudenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhg
X-ME-Proxy: <xmx:kC6fYJm01TL3T-ovZJPGX0HR1eB8McVZDGjA1lQ-ynP621ztcQus-A>
    <xmx:kC6fYEzHLhUYHBavgc2gCT1DzPEdCIGyclTBkalwWI3Jgi9x4Aznug>
    <xmx:kC6fYLTnTOpOg-XmSe2PjG79KlfIOYOrxD9eUaiYoALItt4nR0uIbw>
    <xmx:kS6fYGH1rgCeXbwZSEz-ti4cwT6GRbu36nwo50sR17mi1ZDci8hQVA>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Fri, 14 May 2021 22:14:40 -0400 (EDT)
From:   Samuel Holland <samuel@sholland.org>
To:     Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ondrej Jirman <megous@megous.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev, Samuel Holland <samuel@sholland.org>,
        stable@vger.kernel.org, Roman Stratiienko <r.stratiienko@gmail.com>
Subject: [PATCH] clocksource/arm_arch_timer: Improve Allwinner A64 timer workaround
Date:   Fri, 14 May 2021 21:14:39 -0500
Message-Id: <20210515021439.55316-1-samuel@sholland.org>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Bad counter reads are experienced sometimes when bit 10 or greater rolls
over. Originally, testing showed that at least 10 lower bits would be
set to the same value during these bad reads. However, some users still
reported time skips.

Wider testing revealed that on some chips, occasionally only the lowest
9 bits would read as the anomalous value. During these reads (which
still happen only when bit 10), bit 9 would read as the correct value.

Reduce the mask by one bit to cover these cases as well.

Cc: stable@vger.kernel.org
Fixes: c950ca8c35ee ("clocksource/drivers/arch_timer: Workaround for Allwinner A64 timer instability")
Reported-by: Roman Stratiienko <r.stratiienko@gmail.com>
Signed-off-by: Samuel Holland <samuel@sholland.org>
---

The tool used for testing is here:
 https://github.com/smaeul/timer-tools

For examples of the 9-bit pattern, see the data here:
 https://github.com/8bitgc/timer-tools/tree/master/output

I was able to reproduce the same pattern (although _extremely_ rarely)
on 1 of the 8 A64 boards I currently have access to.

This explanation is consistent with the earlier report here:
 https://lore.kernel.org/lkml/20200929111347.1967438-1-r.stratiienko@gmail.com/

In that report, the time went backward 20542 ns == 493 cycles @ 24 MHz,
which matches the expected 2^9 == 512 cycles minus system call overhead.

 drivers/clocksource/arm_arch_timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index d0177824c518..f4881764bf8f 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -352,7 +352,7 @@ static u64 notrace arm64_858921_read_cntvct_el0(void)
 	do {								\
 		_val = read_sysreg(reg);				\
 		_retries--;						\
-	} while (((_val + 1) & GENMASK(9, 0)) <= 1 && _retries);	\
+	} while (((_val + 1) & GENMASK(8, 0)) <= 1 && _retries);	\
 									\
 	WARN_ON_ONCE(!_retries);					\
 	_val;								\
-- 
2.26.3

