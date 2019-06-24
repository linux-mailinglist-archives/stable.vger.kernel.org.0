Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9217B5077F
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbfFXKH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:07:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730309AbfFXKH1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:07:27 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C15AF20644;
        Mon, 24 Jun 2019 10:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370846;
        bh=A1RrtKwHN0dBw+kQjkpEeeBB6NYU+o4WplT4dVU1GkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y9K+vd/VJT6RKJJFP1bXm1USd/bRsg/AIBfqGyfqyfNEqbO+kA9rmPIRqEu9IN/na
         yv4CQcUiP+MhHTuvMtK59C7jEKs6rOCpbfkzQHXao7l17a3St9o7hrlONyykiizXB4
         9loolnoutBDgNqscUkFF/JYoDiDeEMzWim4nXRMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Mikhaylenko <exalm7659@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.1 022/121] Input: synaptics - enable SMBus on ThinkPad E480 and E580
Date:   Mon, 24 Jun 2019 17:55:54 +0800
Message-Id: <20190624092321.782587200@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Mikhaylenko <exalm7659@gmail.com>

commit 9843f3e08e2144724be7148e08d77a195dea257a upstream.

They are capable of using intertouch and it works well with
psmouse.synaptics_intertouch=1, so add them to the list.

Without it, scrolling and gestures are jumpy, three-finger pinch gesture
doesn't work and three- or four-finger swipes sometimes get stuck.

Signed-off-by: Alexander Mikhaylenko <exalm7659@gmail.com>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/synaptics.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -179,6 +179,8 @@ static const char * const smbus_pnp_ids[
 	"LEN0096", /* X280 */
 	"LEN0097", /* X280 -> ALPS trackpoint */
 	"LEN200f", /* T450s */
+	"LEN2054", /* E480 */
+	"LEN2055", /* E580 */
 	"SYN3052", /* HP EliteBook 840 G4 */
 	"SYN3221", /* HP 15-ay000 */
 	NULL


