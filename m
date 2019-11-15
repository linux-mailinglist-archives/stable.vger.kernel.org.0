Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFA3FE7AC
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 23:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbfKOWSy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 17:18:54 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:47269 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726766AbfKOWSy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 17:18:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573856332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=AMgkoSicOFAnhjHIcwY0YsB6eNzSszo1NgSn0TnzlzY=;
        b=gZS6RSm2h/Ch7hdaaCKtEMhuwrGlRkul5nlmgqTGQuJUALjKGDjXrZGz5Y4fnvQp/6zx3B
        zKXmv9tBINRv8yBuj6zHsAEdgMNfYO4KcsCyIdmp2d6dnVfcrdL8QMEDUH4xy3z9ATCnGq
        IsBzNNwpfcoOIt6Hc0QG1gg2QAFnWcU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-yj32-B_rPTua7VTcMSmtLg-1; Fri, 15 Nov 2019 17:18:50 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 496E31005500;
        Fri, 15 Nov 2019 22:18:48 +0000 (UTC)
Received: from malachite.bss.redhat.com (dhcp-10-20-1-11.bss.redhat.com [10.20.1.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 73D9A608D2;
        Fri, 15 Nov 2019 22:18:41 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     linux-input@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cole Rogers <colerogers@disroot.org>,
        Joe Perches <joe@perches.com>, Teika Kazura <teika@gmx.com>,
        Alexander Mikhaylenko <exalm7659@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Input: synaptics - enable RMI mode for X1 Extreme 2nd Generation
Date:   Fri, 15 Nov 2019 17:18:13 -0500
Message-Id: <20191115221814.31903-1-lyude@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: yj32-B_rPTua7VTcMSmtLg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Just got one of these for debugging some unrelated issues, and noticed
that Lenovo seems to have gone back to using RMI4 over smbus with
Synaptics touchpads on some of their new systems, particularly this one.
So, let's enable RMI mode for the X1 Extreme 2nd Generation.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Cc: stable@vger.kernel.org
---
 drivers/input/mouse/synaptics.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptic=
s.c
index 56fae3472114..704558d449a2 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -177,6 +177,7 @@ static const char * const smbus_pnp_ids[] =3D {
 =09"LEN0096", /* X280 */
 =09"LEN0097", /* X280 -> ALPS trackpoint */
 =09"LEN009b", /* T580 */
+=09"LEN0402", /* X1 Extreme 2nd Generation */
 =09"LEN200f", /* T450s */
 =09"LEN2054", /* E480 */
 =09"LEN2055", /* E580 */
--=20
2.21.0

