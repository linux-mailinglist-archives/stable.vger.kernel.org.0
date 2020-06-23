Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58B2F205BC0
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 21:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387454AbgFWTYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 15:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387440AbgFWTYk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 15:24:40 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED92C061573;
        Tue, 23 Jun 2020 12:24:39 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id c4so11572311iot.4;
        Tue, 23 Jun 2020 12:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mf9Js1eSrEzYPANfjsLFha86P4LGEC3rg5oEXl/xm9w=;
        b=HGr+xeOyIK71FoE7YCb/kzmOKUUhCDLYJthrKC3aiUZDFT5wx/bap624uYK89XKRRm
         9GlMD8VT5jJNR6Xdgma1ORw39L3H+a5OQAqtEH8rLBgkJAGceey6c9WFhE7XARBYQF5T
         ChUObGe0+rFZ3bRIXTZ8ydv8w9jC/1q2+MrW0RewOthJ1wfubrYQRDrriGh0dZA9rHlp
         zH3MLtad1JCG2ETcnCyk6w1dUDv2WuU5ay0VHEg0aOTYceyUVqDLOM3NAtx8WgBbfhy7
         wxA1o+E6HHRArd82AlkOCyCknPnU7iBgRIQci1awjbxzTdcDWXWTbXuOoXMJwNdLB4QL
         qk8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mf9Js1eSrEzYPANfjsLFha86P4LGEC3rg5oEXl/xm9w=;
        b=o1BzoWnS6ZRRgBUrpsWfLPrqMxkrw7dlu3bwAsW3Xn8r9DFbfe5D01rZwn2Jdjemqx
         9iv0FBCkpKnJY3bcAJfKI+joL4qYGXADE5fB+PoKbFMNFWBNkPDR0H2vXgUFQabx0Vmp
         f9mky717mg440volZPLF5ZaPqIUja3vOsAObBOi12mWxMCJCG/rlxkZoypEA/ojdAaYf
         bjdG/TagTNmEXRe3cfKXZzbi85QE4Tu7XTnSLjIy+g0E4zNxQQqi8U3nrFtYVqJOXVa/
         RNEW2sjrEgiggf/sFXZMJQPdJ6fNZ7wsV4SpzbQkAbQSFWBxEAMBMHZbaM353mT1zRms
         l4/w==
X-Gm-Message-State: AOAM530OmAX+xOmbO0yVPN3Dv6qIIHEGMkstIgsX7+HrfyhKHT8Z//Sh
        lAHDVVlQ91vmD2Cuk6ClHLbz3P4KB84=
X-Google-Smtp-Source: ABdhPJyjDqi9F8LfgEW43E9XiO7T/3m70HaxQ8gyJDkhV98i5ZmfexmCwBAFjBTnl0ZqTfezCAhebA==
X-Received: by 2002:a6b:1ce:: with SMTP id 197mr14735915iob.76.1592940278940;
        Tue, 23 Jun 2020 12:24:38 -0700 (PDT)
Received: from james-x399.localdomain (71-218-100-23.hlrn.qwest.net. [71.218.100.23])
        by smtp.gmail.com with ESMTPSA id b21sm3901503ioc.36.2020.06.23.12.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 12:24:38 -0700 (PDT)
From:   James Hilliard <james.hilliard1@gmail.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-usb@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>,
        James Hilliard <james.hilliard1@gmail.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] HID: quirks: Ignore Simply Automated UPB PIM
Date:   Tue, 23 Jun 2020 13:24:15 -0600
Message-Id: <20200623192415.2024242-1-james.hilliard1@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As this is a cypress HID->COM RS232 style device that is handled
by the cypress_M8 driver we also need to add it to the ignore list
in hid-quirks.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
---
 drivers/hid/hid-ids.h    | 2 ++
 drivers/hid/hid-quirks.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 1c71a1aa76b2..3261de0b6bde 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1005,6 +1005,8 @@
 #define USB_DEVICE_ID_ROCCAT_RYOS_MK_PRO	0x3232
 #define USB_DEVICE_ID_ROCCAT_SAVU	0x2d5a
 
+#define USB_VENDOR_ID_SAI		0x17dd
+
 #define USB_VENDOR_ID_SAITEK		0x06a3
 #define USB_DEVICE_ID_SAITEK_RUMBLEPAD	0xff17
 #define USB_DEVICE_ID_SAITEK_PS1000	0x0621
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index e4cb543de0cd..b54fe18f1ed0 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -831,6 +831,7 @@ static const struct hid_device_id hid_ignore_list[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PETZL, USB_DEVICE_ID_PETZL_HEADLAMP) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PHILIPS, USB_DEVICE_ID_PHILIPS_IEEE802154_DONGLE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_POWERCOM, USB_DEVICE_ID_POWERCOM_UPS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SAI, USB_DEVICE_ID_CYPRESS_HIDCOM) },
 #if IS_ENABLED(CONFIG_MOUSE_SYNAPTICS_USB)
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_TP) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_INT_TP) },
-- 
2.25.1

