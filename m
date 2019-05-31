Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9A8316CC
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 23:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbfEaVyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 17:54:02 -0400
Received: from mout.web.de ([212.227.17.12]:60965 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbfEaVyC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 May 2019 17:54:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1559339632;
        bh=4PnwSzytXpwFC3XqLknN/leQqVZx0q9UvCEseQqQS+4=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=jIC5Q2LtJwYGaPixV8SgrlD6n2xlnLUZMrjXre6okDNzFH+EcIRIKtX5dyJHJ1zr2
         F6jum7nSXJ4DBw+y0Syq1NWQEevxMmbJofzIMQtNHzcKgwGX1CYErJdzhakDVanY3a
         VLDQ+QsiFssVg6PlZXF47PWm/TObLqPCm6VhFatU=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from platinum.office.videantis.de ([89.15.238.249]) by smtp.web.de
 (mrweb103 [213.165.67.124]) with ESMTPSA (Nemesis) id
 0MIN2h-1haPpo39vr-00489n; Fri, 31 May 2019 23:53:51 +0200
From:   Soeren Moch <smoch@web.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Soeren Moch <smoch@web.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] Revert "usb: core: remove local_irq_save() around ->complete() handler"
Date:   Fri, 31 May 2019 23:53:40 +0200
Message-Id: <20190531215340.24539-1-smoch@web.de>
X-Mailer: git-send-email 2.17.1
X-Provags-ID: V03:K1:4pki4c77cO/q+Q4fp+esI/7+IHZntp6ARk7ufrkg7lwd/BtNRwG
 ZONH+X9My05hiGQTV64d6W5tSdlWE7RbotPQYA10uJpTdHeFjQTmo+y0465WGOkacVVpfO3
 SMdhpb4JQd03rlXmKdIMRNJLlxlJ9T+wkpg7CaPLHbHa06VLqBwVpleYOXMnLX7qthLmmW0
 RKSTX2erEBTfeSGII/HMw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:00Fs/HKfJpE=:uEzYaepEDBH2thRnu2t4VM
 j3m7F9bB23oQqaxPeOsMPIZXoRwYHT/Xx/9zyE1+38jrJGrEH9Xwy78d6Gd38G/SUXU84tRjJ
 C7EDAmc1FacNELDuF9ZjM9bF62PKthxcQQ9Pvuw3L/R491xeA9d4lW73/+tMtilFK4EqyHTNd
 UB9dKEnm9AuSroRSUUXZpeblMr4zyrffr8BhT5GGLiUjsceMdWJvkr32tonOUR2I4/dC8vDJZ
 lKZ0FeaRGX1uNaCwqVgvClEaze/3L7LnExqjIhIQ7VQrv0/8EOAI48HnmlKN5YV20JxQ/tmQj
 BG+8EBkK4AK8rRaJ0WTBgmWLvRukhdXiK4ynEAOsGqQ4tt4IJ80rh8OrhsP+hEKEcOZ5qlxUK
 4Z+iOCAwlA9OwEzsHLUxZCHMoUjI5KPJGVj2EBY1oDozymJ//dr0vGCxYxalqG3uyeCTE74FB
 6SjpJrWDjbslzR85yLp2w+qXoatdqi1hpD9N6QcHygmKBXwVHK8luzO7jFLjOjoseLkT1O8XC
 B4alIAk+rNgLZjCbjJs/9ZV0E8RVY3SX77ZfuH/OBr57qVxeosqImw0QATlURPT4UhIE2IxEG
 1F0twVmQvsDK7MVe4b/gO5r5Dnz0Dv+ano6aZCFa2RVvjjl3lAbQnGpdinPpXSjsy7NXyKK6G
 F2xO4X6aU5Y+dqArnrnqIBpwtHrdE+CZC4/U6C5e+/hxldZ91bWGAyb4hCV48+LnytHDRJWyV
 wwsh5yiKKJ0y+KffV7aCGbIFEZuuli5wRr3IXVItqOV8G64E4AeZbzyUHpCdkg5RiokklrsBM
 /DPbA90EZ9CbdyVmIjXhJJIDDkmxADqdXkPV0h2W7zICp93rDqilW7gA6zQwgRsqbKcsA4c2o
 hco2JeHF34+EqpgHlRKppY5vAiy/Yooc6PxjdSn8LNH4LbHzYO4PNbJMBuhYCVy84ZWAoQuNS
 EUK1xnNxqxODuKXF+HPc6DloRvvV0hBg=
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit ed194d1367698a0872a2b75bbe06b3932ce9df3a.

In contrast to the original patch description, apparently not all handlers
were audited properly. E.g. my RT5370 based USB WIFI adapter (driver in
drivers/net/wireless/ralink/rt2x00) hangs after a while under heavy load.
This revert fixes this.

Also revert the follow-up patch d6142b91e9cc249b3aa22c90fade67e2e2d52cdb
("usb: core: remove flags variable in __usb_hcd_giveback_urb()"), since no=
w
we need the flags variable again.

Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org # 4.20+
Signed-off-by: Soeren Moch <smoch@web.de>
=2D--
 drivers/usb/core/hcd.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 94d22551fc1b..08d25fcf8b8e 100644
=2D-- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1739,6 +1739,7 @@ static void __usb_hcd_giveback_urb(struct urb *urb)
 	struct usb_hcd *hcd =3D bus_to_hcd(urb->dev->bus);
 	struct usb_anchor *anchor =3D urb->anchor;
 	int status =3D urb->unlinked;
+	unsigned long flags;

 	urb->hcpriv =3D NULL;
 	if (unlikely((urb->transfer_flags & URB_SHORT_NOT_OK) &&
@@ -1755,7 +1756,20 @@ static void __usb_hcd_giveback_urb(struct urb *urb)

 	/* pass ownership to the completion handler */
 	urb->status =3D status;
+
+	/*
+	 * We disable local IRQs here avoid possible deadlock because
+	 * drivers may call spin_lock() to hold lock which might be
+	 * acquired in one hard interrupt handler.
+	 *
+	 * The local_irq_save()/local_irq_restore() around complete()
+	 * will be removed if current USB drivers have been cleaned up
+	 * and no one may trigger the above deadlock situation when
+	 * running complete() in tasklet.
+	 */
+	local_irq_save(flags);
 	urb->complete(urb);
+	local_irq_restore(flags);

 	usb_anchor_resume_wakeups(anchor);
 	atomic_dec(&urb->use_count);
=2D-
2.17.1

