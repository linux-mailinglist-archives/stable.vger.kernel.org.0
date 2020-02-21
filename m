Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F79316760A
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732021AbgBUIG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:06:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:41014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731880AbgBUIG7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:06:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6F0D20578;
        Fri, 21 Feb 2020 08:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272418;
        bh=Xdz5g+eobi2ZEQdasmCypMVgaHUhILG5k0/pdY3tblI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e0M15LmYlGU8r22BMWlH0Edn4d5ibRvgK7ZGekzdJJBae1hdnxQD+6340hfSESgZd
         fqFxmQDPsZE3vK/jUXRauK0YK3B1s/z9HukFNY42izOq7eFRm6Xp+ls4gU+AK+JYxh
         lDO5Xx7V+avKK5YTpNn8mlOgqEgQtl6xIzlXtkVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 134/344] ALSA: usx2y: Adjust indentation in snd_usX2Y_hwdep_dsp_status
Date:   Fri, 21 Feb 2020 08:38:53 +0100
Message-Id: <20200221072401.013059337@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit df4654bd6e42125d9b85ce3a26eaca2935290b98 ]

Clang warns:

../sound/usb/usx2y/usX2Yhwdep.c:122:3: warning: misleading indentation;
statement is not part of the previous 'if' [-Wmisleading-indentation]
        info->version = USX2Y_DRIVER_VERSION;
        ^
../sound/usb/usx2y/usX2Yhwdep.c:120:2: note: previous statement is here
        if (us428->chip_status & USX2Y_STAT_CHIP_INIT)
        ^
1 warning generated.

This warning occurs because there is a space before the tab on this
line. Remove it so that the indentation is consistent with the Linux
kernel coding style and clang no longer warns.

This was introduced before the beginning of git history so no fixes tag.

Link: https://github.com/ClangBuiltLinux/linux/issues/831
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Link: https://lore.kernel.org/r/20191218034257.54535-1-natechancellor@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/usx2y/usX2Yhwdep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/usx2y/usX2Yhwdep.c b/sound/usb/usx2y/usX2Yhwdep.c
index d1caa8ed9e681..9985fc139487b 100644
--- a/sound/usb/usx2y/usX2Yhwdep.c
+++ b/sound/usb/usx2y/usX2Yhwdep.c
@@ -119,7 +119,7 @@ static int snd_usX2Y_hwdep_dsp_status(struct snd_hwdep *hw,
 	info->num_dsps = 2;		// 0: Prepad Data, 1: FPGA Code
 	if (us428->chip_status & USX2Y_STAT_CHIP_INIT)
 		info->chip_ready = 1;
- 	info->version = USX2Y_DRIVER_VERSION; 
+	info->version = USX2Y_DRIVER_VERSION;
 	return 0;
 }
 
-- 
2.20.1



