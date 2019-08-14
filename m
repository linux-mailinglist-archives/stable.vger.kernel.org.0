Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3A2D8DBC7
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbfHNRDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:03:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728793AbfHNRDF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:03:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B69C9208C2;
        Wed, 14 Aug 2019 17:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802184;
        bh=Ai9mdzmAQV6krN547EwEtMM1Fzq6SgfTUAV5HDQIVTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTRpDLmOt2Fek0N1XfKkYE9lpCimXXwaOV7bNW7EnoFPoIxJZQU951gHCf2VtcC4V
         /IKmB/84FhJdIh6+3vMxcNnD0QSDAAU+eeb5ADi18rgetmv/b3U/0ZlZ+nj/wX5B9T
         g8aNVG1tijmx/SU/uGovckOeYVAqjhpz98CP8i90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nate Graham <pointedstick@zoho.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.2 026/144] Input: synaptics - enable RMI mode for HP Spectre X360
Date:   Wed, 14 Aug 2019 18:59:42 +0200
Message-Id: <20190814165800.938400177@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 25f8c834e2a6871920cc1ca113f02fb301d007c3 upstream.

The 2016 kabylake HP Spectre X360 (model number 13-w013dx) works much better
with psmouse.synaptics_intertouch=1 kernel parameter, so let's enable RMI4
mode automatically.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204115
Reported-by: Nate Graham <pointedstick@zoho.com>
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/synaptics.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -182,6 +182,7 @@ static const char * const smbus_pnp_ids[
 	"LEN2055", /* E580 */
 	"SYN3052", /* HP EliteBook 840 G4 */
 	"SYN3221", /* HP 15-ay000 */
+	"SYN323d", /* HP Spectre X360 13-w013dx */
 	NULL
 };
 


