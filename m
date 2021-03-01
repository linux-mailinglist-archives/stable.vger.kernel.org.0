Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 547B6328EB2
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242100AbhCATfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:35:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:48632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241871AbhCAT3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:29:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 359A8650CC;
        Mon,  1 Mar 2021 17:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621058;
        bh=bGtGg8MitEcULIwlNW9UgD8oEquBOhO0LawppJcwG+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K3rV2WkPWkdlnsOAAXkOVKl2y5QaXEBwsXmr1dkn0bb72WvAhdMNrgsE0OYy/nLja
         g7CtJBDqHtNURCGHgFHmYKBShaiYqEo4B3cQAJTMIhXpZr/isgAkWSo5qnA26BgoEJ
         Les8egTCs+nchaSuMcTUnviqiXtIyh7z25yOFSRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Miguel Ojeda <ojeda@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 379/775] auxdisplay: Fix duplicate CHARLCD config symbol
Date:   Mon,  1 Mar 2021 17:09:07 +0100
Message-Id: <20210301161220.332217075@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit b45616445a6e346daf8a173a0c51413aec067ebb ]

A second CHARLCD config symbol was added instead of moving the existing
one.  Fix this by removing the old one.

Fixes: 718e05ed92ecac0d ("auxdisplay: Introduce hd44780_common.[ch]")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/auxdisplay/Kconfig | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/auxdisplay/Kconfig b/drivers/auxdisplay/Kconfig
index a2b59b84bb881..1509cb74705a3 100644
--- a/drivers/auxdisplay/Kconfig
+++ b/drivers/auxdisplay/Kconfig
@@ -507,6 +507,3 @@ config PANEL
 	depends on PARPORT
 	select AUXDISPLAY
 	select PARPORT_PANEL
-
-config CHARLCD
-	tristate "Character LCD core support" if COMPILE_TEST
-- 
2.27.0



