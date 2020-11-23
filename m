Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05282C021F
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 10:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725275AbgKWJSF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 04:18:05 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:37545 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725287AbgKWJSF (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 23 Nov 2020 04:18:05 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id EEF6EF50;
        Mon, 23 Nov 2020 04:18:04 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 23 Nov 2020 04:18:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=wWpvYw
        ua0Vx02VJP2c2hP04ZAihbRUouQhGk4VFnrNw=; b=U2bEyYhCjX1iuqRmQi/ruA
        ReBhpdmfV/zBWA0TQrP8OqYemYohUEWbgxdlaPBk4Sj/b6RzkfTMYjzxGT9x+AsD
        5oMPxiND4iJ4kW1FEhD367dQLk+CosQU+T9O0WJm0JkqAunyuE26WUP+QZwzq6zP
        5SaXFGE6R99ESlG4eoSUnSmyjsFQNMp3rBYePWQ4dS2tMMKMqCPqM648H7jkC3Up
        TUZDKMkIJG0mfrK1vbjIg2a2nWR41OX4TdoQ/FxI3bqQGUm61+SXumKVmiE01ijx
        X7W6WXpiFjoaDSVF+uI+4Z6J2+91NE83nKY9HqDWb1mrz6LlJME7cNSGwhLpTSNg
        ==
X-ME-Sender: <xms:S367X9IuVBn3bBL0iLFmr7CSyW43HkILwMMwmbUYXtpNsSlaaOJ17Q>
    <xme:S367X5K3dvg1XOWqMitUApQ_IJ-Wnjcg43sr1K7A70ljY3lkW-EZYt1k6dTAIx2Vs
    DjKqIlOL3yKmA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudegiedgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:S367X1utcUE8TDsvNVrk1sAAwRyMm4hQnhYKPF5fZpE7UMtzzyWzSA>
    <xmx:S367X-b97f3ervxKNU4LOkxFipar6Mje05folOeijy523N8Khcsrgw>
    <xmx:S367X0aDvbBPc2Ovmgf0kbQ1zwJvLwYi_UH3X81HxuQyP27FWINqPA>
    <xmx:TH67X_yf9DOE76_cf3KWbpWYPafuy2ozQ2Gr_FG-jx0jLdD4gsKa_Da0WR8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8D3BE3064AAF;
        Mon, 23 Nov 2020 04:18:03 -0500 (EST)
Subject: FAILED: patch "[PATCH] iio: accel: kxcjk1013: Add support for KIOX010A ACPI DSM for" failed to apply to 4.9-stable tree
To:     hdegoede@redhat.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, russianneuromancer@ya.ru
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Nov 2020 10:19:14 +0100
Message-ID: <1606123154215107@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e5b1032a656e9aa4c7a4df77cb9156a2a651a5f9 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Tue, 10 Nov 2020 14:38:35 +0100
Subject: [PATCH] iio: accel: kxcjk1013: Add support for KIOX010A ACPI DSM for
 setting tablet-mode

Some 360 degree hinges (yoga) style 2-in-1 devices use 2 KXCJ91008-s
to allow the OS to determine the angle between the display and the base
of the device, so that the OS can determine if the 2-in-1 is in laptop
or in tablet-mode.

On Windows both accelerometers are read by a special HingeAngleService
process; and this process calls a DSM (Device Specific Method) on the
ACPI KIOX010A device node for the sensor in the display, to let the
embedded-controller (EC) know about the mode so that it can disable the
kbd and touchpad to avoid spurious input while folded into tablet-mode.

This notifying of the EC is problematic because sometimes the EC comes up
thinking that device is in tablet-mode and the kbd and touchpad do not
work. This happens for example on Irbis NB111 devices after a suspend /
resume cycle (after a complete battery drain / hard reset without having
booted Windows at least once). Other 2-in-1s which are likely affected
too are e.g. the Teclast F5 and F6 series.

The kxcjk-1013 driver may seem like a strange place to deal with this,
but since it is *the* driver for the ACPI KIOX010A device, it is also
the driver which has access to the ACPI handle needed by the DSM.

Add support for calling the DSM and on probe unconditionally tell the
EC that the device is laptop mode, fixing the kbd and touchpad sometimes
not working.

Fixes: 7f6232e69539 ("iio: accel: kxcjk1013: Add KIOX010A ACPI Hardware-ID")
Reported-and-tested-by: russianneuromancer <russianneuromancer@ya.ru>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201110133835.129080-3-hdegoede@redhat.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/accel/kxcjk-1013.c b/drivers/iio/accel/kxcjk-1013.c
index abeb0d254046..560a3373ff20 100644
--- a/drivers/iio/accel/kxcjk-1013.c
+++ b/drivers/iio/accel/kxcjk-1013.c
@@ -129,6 +129,7 @@ enum kx_chipset {
 enum kx_acpi_type {
 	ACPI_GENERIC,
 	ACPI_SMO8500,
+	ACPI_KIOX010A,
 };
 
 struct kxcjk1013_data {
@@ -275,6 +276,32 @@ static const struct {
 			      {19163, 1, 0},
 			      {38326, 0, 1} };
 
+#ifdef CONFIG_ACPI
+enum kiox010a_fn_index {
+	KIOX010A_SET_LAPTOP_MODE = 1,
+	KIOX010A_SET_TABLET_MODE = 2,
+};
+
+static int kiox010a_dsm(struct device *dev, int fn_index)
+{
+	acpi_handle handle = ACPI_HANDLE(dev);
+	guid_t kiox010a_dsm_guid;
+	union acpi_object *obj;
+
+	if (!handle)
+		return -ENODEV;
+
+	guid_parse("1f339696-d475-4e26-8cad-2e9f8e6d7a91", &kiox010a_dsm_guid);
+
+	obj = acpi_evaluate_dsm(handle, &kiox010a_dsm_guid, 1, fn_index, NULL);
+	if (!obj)
+		return -EIO;
+
+	ACPI_FREE(obj);
+	return 0;
+}
+#endif
+
 static int kxcjk1013_set_mode(struct kxcjk1013_data *data,
 			      enum kxcjk1013_mode mode)
 {
@@ -352,6 +379,13 @@ static int kxcjk1013_chip_init(struct kxcjk1013_data *data)
 {
 	int ret;
 
+#ifdef CONFIG_ACPI
+	if (data->acpi_type == ACPI_KIOX010A) {
+		/* Make sure the kbd and touchpad on 2-in-1s using 2 KXCJ91008-s work */
+		kiox010a_dsm(&data->client->dev, KIOX010A_SET_LAPTOP_MODE);
+	}
+#endif
+
 	ret = i2c_smbus_read_byte_data(data->client, KXCJK1013_REG_WHO_AM_I);
 	if (ret < 0) {
 		dev_err(&data->client->dev, "Error reading who_am_i\n");
@@ -1262,6 +1296,8 @@ static const char *kxcjk1013_match_acpi_device(struct device *dev,
 
 	if (strcmp(id->id, "SMO8500") == 0)
 		*acpi_type = ACPI_SMO8500;
+	else if (strcmp(id->id, "KIOX010A") == 0)
+		*acpi_type = ACPI_KIOX010A;
 
 	*chipset = (enum kx_chipset)id->driver_data;
 

