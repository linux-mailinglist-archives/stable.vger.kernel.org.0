Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0810474CEB
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 22:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhLNVBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 16:01:02 -0500
Received: from mout.gmx.net ([212.227.17.22]:34625 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234794AbhLNVBC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Dec 2021 16:01:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1639515657;
        bh=i1ASyorKaz3Pu+B92JnVMvt83kvDHXC3g7nxE5LjD7o=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=GoGLtUG7N6G0s1rvZxtnarAGKExpFP31DovLkj5R2s+G3Hvy9k6B2wL2Y7KjHcfnT
         zthWo0r2BXx8sWfQL2CIFw+n+zPVxm3dcrFeZal1QWcebrKLlBIB5/IYqfr/17F/w9
         HnMhLQ1X9P2exSGvd3DGG8s8NAC/jK3EjTIqVIRU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from esprimo-mx.fritz.box ([91.137.126.34]) by mail.gmx.net
 (mrgmx104 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1MgNh1-1mIyYR44JL-00hwCS; Tue, 14 Dec 2021 22:00:57 +0100
From:   Armin Wolf <W_Armin@gmx.de>
To:     pali@kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] hwmon: (dell-smm) Fix warning on /proc/i8k creation error
Date:   Tue, 14 Dec 2021 22:00:47 +0100
Message-Id: <20211214210047.33489-1-W_Armin@gmx.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:vTRxkKYW5ptspk5VI0X++lrW43y4B48acg8EqDuAL5LscM8Y/Kg
 us007KXt+xrXfBsmq0MZ9qenHNMKlIDwpUw7eTx8JQ4GsYxFrIHxcimu9wTqc2hMBcqtRnz
 LZ+G4loAkzCsPe7K52UOzKX2Hk4oayD69jO0I+eP8nTt474VamfDlB7GU/bt+dxeTbXm6r3
 6/0MAzcCVmPTNj5U94ZTQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:PqFh4pl2IYg=:ir7HFZ4N6BwAaQr2JaT4Zy
 v8yg67MZ46NFkshO5od7qIAOyTF9eUc/Ymb63UZF14XTjvl3aJiXJe8tVUVdJ+inYB23c4/hr
 wVrXT8vKDX2PzBAFVPy5weamZdf5p3qFC/ifiFm31nR7trv7rI2PfXDxnu4itW+dCpMW/rEwi
 6N8VQrAhIcpZWZuNNkTbaX3JREm2ha0yz7CfN+hzjhGVMn/Fr0IzsuF3QRKOWRXWo8A+FquW1
 YIPef6x3uNrBE5BSLSVqF7o0nb7u3MEY28bVgFDQOuphSo26xxbXV6sr8ooKeqmz5JdTlTBY0
 BYzOOg+lRnyBk6t7igdPQFZZt0CpuvZXIjeK50gHpD9uNxUQMN7yx+198yO8L61ejtXwXdkWW
 Ep8KB0Cqgke8Hx5plhPhlhgo1b6S0Wy369S1xiWGcAU4NB5bGlOCZ6YPMgmkDfWGxNyGYk+YS
 5O7qDXVyS33scRrMesmeOIaAzH4sAkJnemhdkGvCQH8x82o137qggGP4Z5XvPSjXi/L/4L7Gq
 hrQ8uJFCCEMod3JD1qfvW1+xqrixZWqguKw5EGseAfawALaKGiUd/3A17BvDiOWfChLG7tHLK
 fIwNDh3gY9D+/3Q1YKTyMu8mvJkkytmjvWPTjTiU7dzMh4ZJtno3BY5/oGCK57Al6pNdAahm4
 dh0zTI4zbBIyVU6KJfY15F0sz/6GAfHPKP7dNPIfSJabAOm8FQiqTDZuC25d4FKex7DHIScUU
 YuzsxGqVMzX/ds+0l2YsoBhdTNBGg7WRKvaTa06RJKpdKi6LvBf1O1TPYCoNo/ZarrG0+IyCO
 RqWUbaojtSom/1R3c+2OEnb17Qm+k1WjzjYwoFv+ddgPNpcRCjlTAhg7RE/tGD6wdD1uN0vdq
 9b24n34FF9vN5k16GQbNsLbF6Bs2iSRbOo2pn1E9F6ZrBdUVUJc7dnhAprX5YD8Qb5k01KoHD
 HkXlxP9MiK6qukUbQ0Cwrc/Ra0sKSDSOYArYqHzY6QnzZooQm5Ku0jFI+XrKg0ASvaWcY55+q
 UMWVnqftBN/EfZETrlh1pHfUzD2ST7uRLgelthJvpf749YiR5iOnqU5Si+znD6hgT62HSLK7P
 Q3Ivs31i1nEqFw=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit dbd3e6eaf3d813939b28e8a66e29d81cdc836445 upstream.

The removal function is called regardless of whether
/proc/i8k was created successfully or not, the later
causing a WARN() on module removal.
Fix that by only calling the removal function
if /proc/i8k was created successfully.

Since the original patch depends on the driver
registering a platform device, the backported patch
stores the return value of proc_create() and only
calls proc_remove_entry() on exit if proc_create()
was successful.

Tested on a Inspiron 3505 for kernel 5.10.

Cc: <stable@vger.kernel.org> # 5.10.x
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
=2D--
 drivers/hwmon/dell-smm-hwmon.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hwmon=
.c
index 63b74e781c5d..87f401100466 100644
=2D-- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -603,15 +603,18 @@ static const struct proc_ops i8k_proc_ops =3D {
 	.proc_ioctl	=3D i8k_ioctl,
 };

+static struct proc_dir_entry *entry;
+
 static void __init i8k_init_procfs(void)
 {
 	/* Register the proc entry */
-	proc_create("i8k", 0, NULL, &i8k_proc_ops);
+	entry =3D proc_create("i8k", 0, NULL, &i8k_proc_ops);
 }

 static void __exit i8k_exit_procfs(void)
 {
-	remove_proc_entry("i8k", NULL);
+	if (entry)
+		remove_proc_entry("i8k", NULL);
 }

 #else
=2D-
2.30.2

