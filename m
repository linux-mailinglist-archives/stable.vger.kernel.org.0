Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1735152149
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 20:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbgBDTnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 14:43:52 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:43198 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727369AbgBDTnw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Feb 2020 14:43:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580845431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=lsoNUoMV4vBOi3CPpbacYms7z1QF2+WViGfskW8UZPY=;
        b=EiSNzbCv9eWEE9+DP/yPZyuYnyLoqFWZ+SqQ+0/TKuqq2trzSBDyr9+hFG4nYWccBoDswR
        si8fsgwfRKVoFTXGjNH/lb4aFbtbjYqqb6+9WJL3uGra7H6MDajnSVS/eNcSJYRZBGNU4g
        mbCfQ2zzAOZ/S7aS338qthAaJ7olqus=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-XskHuP98NoCY9FAlBtCTVA-1; Tue, 04 Feb 2020 14:43:49 -0500
X-MC-Unique: XskHuP98NoCY9FAlBtCTVA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BBF878018A5;
        Tue,  4 Feb 2020 19:43:47 +0000 (UTC)
Received: from malachite.bss.redhat.com (dhcp-10-20-1-90.bss.redhat.com [10.20.1.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A585A100164D;
        Tue,  4 Feb 2020 19:43:37 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     linux-input@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Alexander Mikhaylenko <exalm7659@gmail.com>,
        Enrico Weigelt <info@metux.net>, Joe Perches <joe@perches.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Nick Black <dankamongmen@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Input: synaptics - switch T470s to RMI4 by default
Date:   Tue,  4 Feb 2020 14:43:21 -0500
Message-Id: <20200204194322.112638-1-lyude@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This supports RMI4 and everything seems to work, including the touchpad
buttons. So, let's enable this by default.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Cc: stable@vger.kernel.org
---
 drivers/input/mouse/synaptics.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synapt=
ics.c
index 1ae6f8bba9ae..8cb8475657ca 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -169,6 +169,7 @@ static const char * const smbus_pnp_ids[] =3D {
 	"LEN004a", /* W541 */
 	"LEN005b", /* P50 */
 	"LEN005e", /* T560 */
+	"LEN006c", /* T470s */
 	"LEN0071", /* T480 */
 	"LEN0072", /* X1 Carbon Gen 5 (2017) - Elan/ALPS trackpoint */
 	"LEN0073", /* X1 Carbon G5 (Elantech) */
--=20
2.24.1

