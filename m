Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAD62FA418
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 16:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390777AbhARPGt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 10:06:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:37806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390778AbhARLmj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:42:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF5A022CA2;
        Mon, 18 Jan 2021 11:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970096;
        bh=iJ9dwxxKVTbHRA0+ItZ7xjrXG7nFtJ2LRSKf4A9zPow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TAH00SkF8lLp+9BjbV44q/nv5ekjLcsvJfxUY5VRc3tfitrbBw9wFITx7Vzw+2FhP
         8+vhUTUYlI5RA+e1eH0HSj+HsO7+s/PBLEi4cUgQJYRNGUh8NBag/8OZJXmYnqsS4N
         vYW0qGmi5xfSgCzC/PNBKkckLh0KJ7j28i0trpAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Jaroslav Kysela <perex@perex.cz>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 005/152] ASoC: AMD Renoir - add DMI entry for Lenovo ThinkPad X395
Date:   Mon, 18 Jan 2021 12:33:00 +0100
Message-Id: <20210118113353.021277889@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaroslav Kysela <perex@perex.cz>

commit 1f092d1c8819679d78a7d9c62a46d4939d217a9d upstream.

The ThinkPad X395 latop does not have the internal digital
microphone connected to the AMD's ACP bridge, but it's advertised
via BIOS. The internal microphone is connected to the HDA codec.

Use DMI to block the microphone PCM device for this platform.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1892115
Cc: <stable@kernel.org>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20201227164109.269973-1-perex@perex.cz
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/amd/renoir/rn-pci-acp3x.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/soc/amd/renoir/rn-pci-acp3x.c
+++ b/sound/soc/amd/renoir/rn-pci-acp3x.c
@@ -171,6 +171,13 @@ static const struct dmi_system_id rn_acp
 			DMI_EXACT_MATCH(DMI_BOARD_NAME, "LNVNB161216"),
 		}
 	},
+	{
+		/* Lenovo ThinkPad X395 */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "20NLCTO1WW"),
+		}
+	},
 	{}
 };
 


