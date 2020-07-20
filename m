Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF7C226658
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732670AbgGTQC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:02:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732667AbgGTQC1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:02:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B7C720773;
        Mon, 20 Jul 2020 16:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260946;
        bh=YKuN1e9nj+vT0ZACDA0Wb9WbZ52t3QdCAHvvnz8SdeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yHcf3C3nweBcPnzLMhbSInTfWi5pPOOgfQw9ja2hrl+JHzXIbH0ooF1KiC0iKpD1O
         f3LUma1JihZEO7yIRR97g5y6uoUKnsp6JfmqK5KhQTfEkEK5jQAl/7lC+J1Qskth9u
         3BcjWI7sp6pCQB/fmdkmT584bJFpktuyv1x+j2fA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 153/215] ALSA: hda/realtek - Enable Speaker for ASUS UX533 and UX534
Date:   Mon, 20 Jul 2020 17:37:15 +0200
Message-Id: <20200720152827.467905901@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit 473fbe13fd6f9082e413aea37e624ecbce5463cc upstream.

ASUS UX533 and UX534 speaker still can't output.
End User feedback speaker didn't have output.
Add this COEF value will enable it.

Fixes: 4e051106730d ("ALSA: hda/realtek: Enable audio jacks of ASUS UX533FD with ALC294")
Cc: <stable@vger.kernel.org>
Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/r/80334402a93b48e385f8f4841b59ae09@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7101,6 +7101,8 @@ static const struct hda_fixup alc269_fix
 			/* Set EAPD high */
 			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x40 },
 			{ 0x20, AC_VERB_SET_PROC_COEF, 0x8800 },
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x0f },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x7774 },
 			{ }
 		},
 		.chained = true,


