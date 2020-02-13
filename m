Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C308115C1E7
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729425AbgBMP1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:27:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:50992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729419AbgBMP1b (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:31 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CEDD2467D;
        Thu, 13 Feb 2020 15:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607650;
        bh=f1s+YvCK7KWxdlT3jqyahDQ8NHLzxmyGOCafi62aq2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2leppSWDdG6Ul5tL5/eifwARXlp/vpXk8wHuZ6fFXW4e0A6lBI+he45VZUOlAKOka
         bPTzWcedr/E9itZWykEL0Fz+q5cS+QgB7NzH25Bvne7L/+syAbmMOH7G3fzgFJ3uB+
         /IzrhK0J2I7WGzI3aVG2OzlCc0STO17UJS4bzE20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 5.4 45/96] arm64: dts: renesas: r8a77990: ebisu: Remove clkout-lr-synchronous from sound
Date:   Thu, 13 Feb 2020 07:20:52 -0800
Message-Id: <20200213151856.738483541@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

commit bf2b74ce9b33a2edd6ba1930ce60a71830790910 upstream.

rcar_sound doesn't support clkout-lr-synchronous in upstream.
It was supported under out-of-tree rcar_sound.
upstream rcar_sound is supporting
	- clkout-lr-synchronous
	+ clkout-lr-asynchronous

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/87mubt3tux.wl-kuninori.morimoto.gx@renesas.com
Fixes: 56629fcba94c698d ("arm64: dts: renesas: ebisu: Enable Audio")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/renesas/r8a77990-ebisu.dts |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm64/boot/dts/renesas/r8a77990-ebisu.dts
+++ b/arch/arm64/boot/dts/renesas/r8a77990-ebisu.dts
@@ -636,7 +636,6 @@
 	/* audio_clkout0/1/2/3 */
 	#clock-cells = <1>;
 	clock-frequency = <12288000 11289600>;
-	clkout-lr-synchronous;
 
 	status = "okay";
 


