Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDB468F11A
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 15:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbjBHOrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 09:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbjBHOrB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 09:47:01 -0500
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC535581;
        Wed,  8 Feb 2023 06:46:59 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 4674E32009CE;
        Wed,  8 Feb 2023 09:46:56 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 08 Feb 2023 09:46:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=squebb.ca; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1675867615; x=1675954015; bh=zT
        Kt6m4JRxgdH3kPT8jiwVvp3WR5nsieULsMsf+pmy4=; b=gN7mOFSsTovMyFLh8Q
        +dk/qMl5fe7didaUnElSb5RhWVWTFOvi55Gg0ZcAUwh/VKTL9ef8jCTjGxS8VWoK
        esby4my2t/GgW74tfCRiErbpL66Lx5E2WfHK9KjkMP6t7EQ7HrGi9JWj7VsixRf9
        GwpVjMARX6XX3TENbIIyTZ8s5309Hkio0PeNc5irUDVJM8OhsrP92GgCvcXk11bs
        q1HHWlKPkdmZM88JuC3pSDS3HO6f91j2hnkEcKB4/IkVw6n/PxzSmln//jVO69as
        fUZbsGIYEJxpb2bRHiVgHL4sBT0VtPt0IVsEe2waKaBPhYQobPfM+VozIB/kRq4i
        qBhw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1675867615; x=1675954015; bh=zTKt6m4JRxgdH
        3kPT8jiwVvp3WR5nsieULsMsf+pmy4=; b=NBT9Cm/BIRe/Tw+n9QxOEeqYve8IQ
        /CC/pxN9nHbZXB93OkXqWrY0ESRFZIZPbHyJyJeO72Kcq2W89iQqP3KkA8aP/kfp
        TSqxrKOTjvKBWNkHKGUxljEIV4K9aDF69hi0A3bkS1mkkuvWSQC6cMDLiSjKbgRP
        Ym4D8FbzVQ5YNMpnAaK41jznAXOZ6eGsqZG1ziMjjTeIGPkX/Xyfs0fJjX2L65qe
        7tWNHp3ecUQOrA4cnzzyWnahwTwmBdi0YrhELz8d6rPHVmvIIPVbgpLys3t5VkL5
        U+Bz6zJVJ9QGAS3iEm5Z65+b52g+S5yWTdS1PazcxkPDOyvMMntQPSYGA==
X-ME-Sender: <xms:3bXjY8Wi5erjuNOUg6dbBJC0KZBqPUXHzIBorW909CssraVmWsi--Q>
    <xme:3bXjYwlolX_s6MtUjZYxCpfJoV7aI4Ipy4wNtyJZoxW42a3LmdC1cyOqO0omMF0T7
    5VcCHZDVjzGrbRO_H8>
X-ME-Received: <xmr:3bXjYwa6wTu36hDtbnJBrGNGK3heQf2A9douVDZ8KM7F-Q-kfMQIJ9Y63InGSmW7HsNV6urpuXEy-GrElnNNtb8OPraahmoKks2Z9dHl_U85De2oTJlMLkpH>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudehuddgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goteeftdduqddtudculdduhedmnecujfgurhephffvvefufffkofgjfhgggfestdekredt
    redttdenucfhrhhomhepofgrrhhkucfrvggrrhhsohhnuceomhhpvggrrhhsohhnqdhlvg
    hnohhvohesshhquhgvsggsrdgtrgeqnecuggftrfgrthhtvghrnhepfedtvdejfeelffev
    hffgjeejheduteetieeguefgkefhhfegjeduueethefgvdffnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmhhpvggrrhhsohhnqdhlvghnohhv
    ohesshhquhgvsggsrdgtrg
X-ME-Proxy: <xmx:3bXjY7UECXWqqdoa5Qa6T31JVLfaPrE3wpjesQeXYsQvvMDo0Kh-DQ>
    <xmx:3bXjY2ljMXgcvf3BUENoV4WZCjPF6WP7AgnUbLM43o3fhYvwsVtCgA>
    <xmx:3bXjYwdGCsAYpT5Js8AZZgHEe3P0WDByI-Wu7vfYg4vUu54EeIuzkw>
    <xmx:37XjY4jFfIDs4ZUxXYNlFIBR4CWIrfzXoAPi9XGLfoAzc8qTZhgDuw>
Feedback-ID: ibe194615:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 8 Feb 2023 09:46:53 -0500 (EST)
From:   Mark Pearson <mpearson-lenovo@squebb.ca>
To:     mpearson-lenovo@squebb.ca
Cc:     linux-usb@vger.kernel.org, Miroslav Zatko <mzatko@mirexoft.com>,
        Dennis Wassenberg <dennis.wassenberg@secunet.com>,
        stable@vger.kernel.org
Subject: [PATCH] usb: core: add quirk for Alcor Link AK9563 smartcard reader
Date:   Wed,  8 Feb 2023 09:46:48 -0500
Message-Id: <20230208144648.1079898-1-mpearson-lenovo@squebb.ca>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <mpearson-lenovo@squebb.ca>
References: <mpearson-lenovo@squebb.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Alcor Link AK9563 smartcard reader used on some Lenovo platforms
doesn't work. If LPM is enabled the reader will provide an invalid
usb config descriptor. Added quirk to disable LPM.

Verified fix on Lenovo P16 G1 and T14 G3

Tested-by: Miroslav Zatko <mzatko@mirexoft.com>
Tested-by: Dennis Wassenberg <dennis.wassenberg@secunet.com>

Cc: stable@vger.kernel.org

Signed-off-by: Dennis Wassenberg <dennis.wassenberg@secunet.com>
Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
---
 drivers/usb/core/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 079e183cf3bf..9b1c56646ac5 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -535,6 +535,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* INTEL VALUE SSD */
 	{ USB_DEVICE(0x8086, 0xf1a5), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Alcor Link AK9563 SC Reader used in 2022 Lenovo ThinkPads */
+	{ USB_DEVICE(0x2ce3, 0x9563), .driver_info = USB_QUIRK_NO_LPM },
+
 	{ }  /* terminating entry must be last */
 };
 
-- 
2.39.1

