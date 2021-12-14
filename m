Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C733C474CF4
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 22:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237765AbhLNVGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 16:06:45 -0500
Received: from mout.gmx.net ([212.227.17.21]:44665 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237764AbhLNVGo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Dec 2021 16:06:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1639515999;
        bh=77t9vOnYT04Hp+lhTZSs/xw+1bG8RrsfmhH5ca3nPjU=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=N4sz2nw2dEHqyh0lnZMNjVLaqkvFhbH+Ekbnqo6zC5Fc3Z7X1jWqJvBENcFQ4TPGk
         2WEtmtho/YWeHubmyOeNpiCW3iHWQssmYt1abVHC/gOrghU7SDE2rekiDswcjnSqOq
         9ivvvoVQn8dUINxRz5nz5FREszdZrB75KFG5dbBk=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from esprimo-mx.fritz.box ([91.137.126.34]) by mail.gmx.net
 (mrgmx105 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1MhlKy-1mJnaB20dk-00dmaI; Tue, 14 Dec 2021 22:06:39 +0100
From:   Armin Wolf <W_Armin@gmx.de>
To:     pali@kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] hwmon: (dell-smm) Fix warning on /proc/i8k creation error
Date:   Tue, 14 Dec 2021 22:06:34 +0100
Message-Id: <20211214210634.36136-1-W_Armin@gmx.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:vu73VRAMgfJaMbXBUNVf6DQYdPTzOBD/oH+FUxXN3EY98z4EWYU
 9yPsscfN4SGt3ItwFfU6YLYnOibBb8yX9M1m2REk2mRlRqUwFKgojFOmseLcne4TpfypaK+
 LFdJGOpU1x4AFTU07Hf5g8qdZmdDc8v83n+IpdzmzzhbByLatWU51LSmjaukE6CjaqwgC5p
 OOMl97+nMmqu5XxNf70jg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:i5f74wudl6k=:fn5Z0WVKoHzOZW2F4pZNF1
 lVCo2BOwBCnU8VUOQwaqEFyd3q3pTkUxJPQMDupnBohrK613OeL4MleCtsroebBZ36gLlCf8N
 vaWkLQcNRW47Gj+S/VI9p5AuytRKjTt7tZxca4XjvBjKqdzIP9Xn+nGgPSYHnlI8O/vBTH7g/
 2WSL9jcbBBUgaGjtGac2xl28Cxy+perZmrJ+y7GOj6J7vfyoyxPXUqK+ZOcHiASX5xMfmq9Y7
 f1Wuze0cSvK8WdCnWWgadjAY8mvVB/8qL2P4Xok+6we99ZCgJo10z5ebg5UldB52UZbDe/tOy
 tPZ8QFvklOQk+uCH1kjbdAg9zO8GmotQfWihOpQI0njy/Pq2rSWnPFnE5bQBbRmhvUN+dn758
 E55wO/plOBm2maENDTvqbDvIMU4O3C99s7XiMYmamG3e7XT6a89O8twoFhJksXVMf3+XYZQVY
 ettePgfn6PKcR1IHbaclSbbspWkl9te7cYhtbpJzjpgXQ4+dyAEazRxqI0VlbQ2+Bc7IqHbON
 Pmjmj29STmDZDHgb3ZGPXfLIln+PLI2SF4OqlzJJa+a1W3d8gfKWLFH/GEKmlIxzmIpqOx8UT
 f3PQLPTw0+kbRTct5USpyhI517yGfKgP+ejyVcfVclofH0FrHhMhcC7zNBGizna+uMzPCl06q
 WPjbvo9sS5s/VBX6VY8J+Pq4WJO8JF5vLbcg+USYzYnIsWB72FVdI5slxG3ucU9OU0UpvU2DC
 0iOy+65EgnlOOQxh/i33kYQUfWj8hH6j7XtAAHM3h5H41fv9xD4N0a0cu3xQiMf3U5CYpljTK
 ZW+6hjLIPWOJX0ffMpFN3hSxobSpUgmBKkc48aEHERoCQrE3MC1XwDZwXf7KUWuaVv44QoetB
 bVPrcgWM65duPVKhgD6sj5SQV4AvLiyE4kJ3zrMsL3CLGOIWRyCgRrPs5FleR9H8zJzpc6Dpj
 l6Ol6vYkCeGH31gUb1+iF/5s3AZmtpx//qWidNPSo9WkBH1S/XN8A5VJy9zdrvkO3jjfSfVbB
 8voLN+5BZXZC03lIbIoZEleK/hqQxVD5XA5DT5W1Cw3+7gMQ3hvl0cgczf4N4J1S3D1eAO66B
 yrUS+MUfZJZel8=
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

Tested on a Inspiron 3505 for kernels 4.19/4.9.

Cc: <stable@vger.kernel.org> # 5.4.x
Cc: <stable@vger.kernel.org> # 4.x.x
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
=2D--
 drivers/hwmon/dell-smm-hwmon.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hwmon=
.c
index 35c00420d855..2eaed0008f37 100644
=2D-- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -588,15 +588,18 @@ static const struct file_operations i8k_fops =3D {
 	.unlocked_ioctl	=3D i8k_ioctl,
 };

+static struct proc_dir_entry *entry;
+
 static void __init i8k_init_procfs(void)
 {
 	/* Register the proc entry */
-	proc_create("i8k", 0, NULL, &i8k_fops);
+	entry =3D proc_create("i8k", 0, NULL, &i8k_fops);
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

