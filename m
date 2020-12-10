Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 342A42D53AB
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 07:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbgLJGPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 01:15:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51558 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733119AbgLJGPM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 01:15:12 -0500
Received: from mail-pf1-f198.google.com ([209.85.210.198])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1knFDf-0005Qf-5g
        for stable@vger.kernel.org; Thu, 10 Dec 2020 06:14:27 +0000
Received: by mail-pf1-f198.google.com with SMTP id l11so2884393pfc.16
        for <stable@vger.kernel.org>; Wed, 09 Dec 2020 22:14:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hMBgZGgt32CSWA48nQ+ca+CSzlU2IhzOCpBY9uMG56E=;
        b=TyXQpfHQvqzFK+ihLGO9YhnlY68Bfm1IHw48/+/FAv9T52jnqcprJNMRzjkVqGJXxX
         ym5UOs7B+Ba8XlnNvvOLL8EVN4BO1HlyliAjX4EIMwxOdImIwv4M3yB3hJBXAyOdT2nn
         7hplZP9rH5c9sS5m0erRfwFe5xz88T5vdhWAgj+L5T7h549qtBL+8e9p/kScvfOiGU/p
         5A36VubJY4R7w5Ftl9P4wDozAB3a3kST9UcbMjiD3Ia5++kjt1lCuMXbziKQA9ZQUDxH
         ex1O+QBTJA+d+FIPbX9QmdbpVxrNGUll5wsAkk456s5tjFOxNznLfrhU+RP5c0v6gi8B
         It6w==
X-Gm-Message-State: AOAM533ATA0SQh2yfmQFA7yXFk9aIvTJ0uZaKMUyunQOAS1lVfyeLRpb
        0wpHjTEDNz2czyIJqRs75mjPbar7iuFLXSfgL5qEPxDEdH3r5ryX5mnF0h/mo4RoCnFcNxqHU3C
        tNQI7YX5xifo20MCF6er97nE88+qt0snN
X-Received: by 2002:a17:90a:ee8c:: with SMTP id i12mr5955337pjz.33.1607580865289;
        Wed, 09 Dec 2020 22:14:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxOQKUvb9/UCLHrJYyotnbx9mA0xz4Sx7XfNrUl74jBrf0q1jro3xMqh3sGbK0XszX/SAMp3A==
X-Received: by 2002:a17:90a:ee8c:: with SMTP id i12mr5955319pjz.33.1607580865063;
        Wed, 09 Dec 2020 22:14:25 -0800 (PST)
Received: from localhost.localdomain (114-136-167-163.emome-ip.hinet.net. [114.136.167.163])
        by smtp.gmail.com with ESMTPSA id w9sm4675153pfg.125.2020.12.09.22.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 22:14:24 -0800 (PST)
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     kernel-team@lists.ubuntu.com
Cc:     stable@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [X/B/F/G/H/Unstable][SRU][PATCH 1/1] Input: i8042 - add ByteSpeed touchpad to noloop table
Date:   Thu, 10 Dec 2020 14:14:15 +0800
Message-Id: <20201210061415.35591-2-po-hsu.lin@canonical.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201210061415.35591-1-po-hsu.lin@canonical.com>
References: <20201210061415.35591-1-po-hsu.lin@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

BugLink: https://bugs.launchpad.net/bugs/1906128

It looks like the C15B laptop got another vendor: ByteSpeed LLC.

Avoid AUX loopback on this touchpad as well, thus input subsystem will
be able to recognize a Synaptics touchpad in the AUX port.

BugLink: https://bugs.launchpad.net/bugs/1906128
Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
Link: https://lore.kernel.org/r/20201201054723.5939-1-po-hsu.lin@canonical.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
(cherry picked from commit a48491c65b513e5cdc3e7a886a4db915f848a5f5)
Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
---
 drivers/input/serio/i8042-x86ia64io.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 82ff446..1f45010 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -223,6 +223,10 @@ static const struct dmi_system_id __initconst i8042_dmi_noloop_table[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "PEGATRON CORPORATION"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "C15B"),
 		},
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ByteSpeed LLC"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ByteSpeed Laptop C15B"),
+		},
 	},
 	{ }
 };
-- 
2.7.4

