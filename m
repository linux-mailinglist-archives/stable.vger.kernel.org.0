Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D2347DE26
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 04:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346254AbhLWDwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 22:52:20 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:38683 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242010AbhLWDwT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 22:52:19 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 9F4C73200645;
        Wed, 22 Dec 2021 22:52:18 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 22 Dec 2021 22:52:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=turner.link; h=
        from:to:cc:subject:date:message-id:mime-version:content-type; s=
        fm1; bh=zfn54E2SBrZu6H5DGu4dRs4BpFYiiAH0eP8Vbw7z++g=; b=g5MFb7PX
        Vh9Ktk6G/uJRagauc+M9gwPpFy8wg0jHFRzwUKu5DKdRj6fzIQiorkacmCaY2Tf0
        MuvqHOGSE5ioUG/2CQfwb01bMOeB5CR9Jy1F1PsJKtrTXbqX8yZ1Lepa583++uCx
        OJleL4pwa4a0wWzRa7FPftxvqzBs++FPkDw62gEI4/IyHavDm2/Oqt79hJQjcuoi
        EJqLgB4Qrn6vLKiRMFq+q3Mws32lZqiOqgSBqwXbvANS2WjZPzjfICrx6qaqJFw9
        0/Oq51UmMnqsOMFUmGMWxIO6JTxK9gJ3YEXkrjMqNH+T1uTUITV/M2tNL3AS/12p
        PVO5tbOTqHpjkg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm1; bh=zfn54E2SBrZu6H5DGu4dRs4BpFYii
        AH0eP8Vbw7z++g=; b=dBEVlp9MwvpibRr2Lq1hZrLDQvISD3aWqthztsyHiSeZH
        BAZg++MhbVIcxxB/+DwUx8ym56TUrRaD9EwG7vgbGiFUg4VyIpY6bQcVL7Ig5Wwv
        10oQAQ9Nh3MseZkfRN2089jLiKShSURZTssRtVqysffCnMz0kJizQAbFWYO8jLiu
        7TX6broVlcEnrC5K3T3ruWysiUq2/We8EqEBb0V9XkZPU22y3o6CJCFTo401wTsk
        p+b/QCu6RsM8xaExer72p66vpkzSZ+OVRoVn81pUzAS2KO95iHyRW2v6MGrynvBj
        doUTh7EdwXRUKuHuSAixvz9SGk1cIO6sskuvk7EAg==
X-ME-Sender: <xms:cfLDYZ125QeC9YVQx9Z7ygsuVII-wF7Furas8WzU5w5ir8JS-L0UhQ>
    <xme:cfLDYQGr9ksdD9x9APO2by__Kc1R843PoUgjLgIPkbIbZeayt88XlG1jrIGJeKQD9
    RpCGL6fIcSLP-hPpg>
X-ME-Received: <xmr:cfLDYZ4N9m9BmoaP8tIkfXYkw34Oq82VLwCRcY8jn0TiAQdFlI5yAFKUFtOkKo--SjlWBrRBIQ7C2xfmNQcJ_lFy995gbrEm6Q4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddruddtjedgieegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkfggtgesthdtredttddttdenucfhrhhomhepfdflrghmvghsucff
    rdcuvfhurhhnvghrfdcuoehlihhnuhigkhgvrhhnvghlrdhfohhsshesughmrghrtgdqnh
    honhgvrdhtuhhrnhgvrhdrlhhinhhkqeenucggtffrrghtthgvrhhnpedttdelffeuhedt
    fedtteeitdejueegfefgvefgkeejkeefffejheelieetheehhfenucffohhmrghinhepkh
    gvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomheplhhinhhugihkvghrnhgvlhdrfhhoshhssegumhgrrhgtqdhnohhnvgdrth
    hurhhnvghrrdhlihhnkh
X-ME-Proxy: <xmx:cfLDYW0si5J9avodckNPtsdhW4F97cc2szlwQoQFDAvjMsXdYiglyg>
    <xmx:cfLDYcGc6yU7ytz2h5DwsGhHvbAU7-6d877g6RiQ8fBFtaAELl8yNw>
    <xmx:cfLDYX_A-TSvEynL5tjkFJSAWw6TkBcHi6OTtLEyFEuahfihDHT4RQ>
    <xmx:cvLDYR69wRYI_i7XG9dpJD11r6YrUtXJ0ke1XU5Tf1oK6eyvMOF-8Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 22 Dec 2021 22:52:17 -0500 (EST)
From:   "James D. Turner" <linuxkernel.foss@dmarc-none.turner.link>
To:     linux-kernel@vger.kernel.org
Cc:     "Jiri Kosina" <jikos@kernel.org>,
        "Benjamin Tissoires" <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] HID: holtek-mouse: start hardware in probe
Date:   Tue, 21 Dec 2021 21:21:41 -0500
Message-ID: <875yrgf05r.fsf@turner.link>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The holtek_mouse_probe() function is missing the necessary code to
start the hardware. When an Etekcity Scroll X1 (M555) USB mouse is
plugged in, the mouse receives power and the kernel recognizes it as a
USB device, but the system does not respond to any movement, clicking,
or scrolling of the mouse. Presumably, this bug also affects all other
mice supported by the hid-holtek-mouse driver, although this has not
been tested. On the stable linux-5.15.y branch, testing confirms that
the bug was introduced in commit a579510a64ed ("HID: check for valid
USB device for many HID drivers"), which was first included in
v5.15.8. Based on the source code, this bug appears to be present in
all currently-supported kernels (mainline, stable, and all LTS
kernels). Testing on hardware confirms that this proposed patch fixes
the bug for kernel v5.15.10. Fix holtek_mouse_probe() to call the
necessary functions to start the hardware.

Fixes: 93020953d0fa ("HID: check for valid USB device for many HID drivers")
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: linux-input@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: James D. Turner <linuxkernel.foss@dmarc-none.turner.link>
---
This is my first time submitting a kernel patch. I think I've followed
all the directions, but please let me know if I should do something
differently.

In addition to testing this patch for the stable v5.15.10 kernel on real
hardware, I also tested it for the latest master of the hid repository
(commit 03090cc76ee3 ("Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/hid/hid")) using a VM with
USB passthrough.

 drivers/hid/hid-holtek-mouse.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-holtek-mouse.c b/drivers/hid/hid-holtek-mouse.c
index b7172c48ef..29e41c97ec 100644
--- a/drivers/hid/hid-holtek-mouse.c
+++ b/drivers/hid/hid-holtek-mouse.c
@@ -65,9 +65,16 @@ static __u8 *holtek_mouse_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 static int holtek_mouse_probe(struct hid_device *hdev,
 			      const struct hid_device_id *id)
 {
+	int ret;
+
 	if (!hid_is_usb(hdev))
 		return -EINVAL;
-	return 0;
+
+	ret = hid_parse(hdev);
+	if (!ret)
+		ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
+
+	return ret;
 }
 
 static const struct hid_device_id holtek_mouse_devices[] = {

base-commit: 03090cc76ee3298cc70bce26bbe93a0cb50e42a2
-- 
2.34.1

