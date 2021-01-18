Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE5FF2FA41B
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 16:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405537AbhARPGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 10:06:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:37770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390450AbhARLmj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:42:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5281C22CA1;
        Mon, 18 Jan 2021 11:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970093;
        bh=tALdK/PGeftXdhZzddPeapCKfDy5PFPz96UrAG9ROa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h6Q81tNnnp2mM4Q5W9dovF+cxub0GeqlsD+8RE1nMeGt8r4Cxm9iAJfkuxDZcnio2
         3X5iBIimKCMzkq5xzPuKQG/0MAVQle5OEeZggqds/z/9xF244iYQURyEy4tZz12PeN
         h7yuo2kGJ9LkRJJ5iIAeT8igZegNeAtzLcRkOR4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 004/152] ALSA: doc: Fix reference to mixart.rst
Date:   Mon, 18 Jan 2021 12:32:59 +0100
Message-Id: <20210118113352.973808537@linuxfoundation.org>
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

From: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

commit 3e096a2112b7b407549020cf095e2a425f00fabb upstream.

MIXART.txt has been converted to ReST and renamed. Fix the reference
in alsa-configuration.rst.

Fixes: 3d8e81862ce4 ("ALSA: doc: ReSTize MIXART.txt")
Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210101221942.1068388-1-j.neuschaefer@gmx.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/Documentation/sound/alsa-configuration.rst b/Documentation/sound/alsa-configuration.rst
index fe52c314b763..b36af65a08ed 100644
--- a/Documentation/sound/alsa-configuration.rst
+++ b/Documentation/sound/alsa-configuration.rst
@@ -1501,7 +1501,7 @@ Module for Digigram miXart8 sound cards.
 
 This module supports multiple cards.
 Note: One miXart8 board will be represented as 4 alsa cards.
-See MIXART.txt for details.
+See Documentation/sound/cards/mixart.rst for details.
 
 When the driver is compiled as a module and the hotplug firmware
 is supported, the firmware data is loaded via hotplug automatically.


