Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0212B63E1
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387442AbgKQNmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:42:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:55078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387440AbgKQNmb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:42:31 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CC9520729;
        Tue, 17 Nov 2020 13:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620551;
        bh=8tw9+Xn/S8KkVCfwmBYzaM8x8dYawQMuzZce+Kn6gfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kEYVCSGGaDoMyKhZRnpwWyAII8LCGf9YqrTl1hK7FQqBntx9SKWYdYFFdOdpKEQfW
         n/1yTO8AOOIdOTl/EVZSRpxm11T72OeZ6rxB1RestkYX0g1OMLZKuuoMYiEabfanpR
         1KMdoHSn5pz8iZuLoU3LqLfumfskdDg9KZurgJ0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Naveen Krishna Chatradhi <nchatrad@amd.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.9 218/255] hwmon: (amd_energy) modify the visibility of the counters
Date:   Tue, 17 Nov 2020 14:05:58 +0100
Message-Id: <20201117122149.547521228@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naveen Krishna Chatradhi <nchatrad@amd.com>

commit 60268b0e8258fdea9a3c9f4b51e161c123571db3 upstream.

This patch limits the visibility to owner and groups only for the
energy counters exposed through the hwmon based amd_energy driver.

Cc: stable@vger.kernel.org
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Naveen Krishna Chatradhi <nchatrad@amd.com>
Link: https://lore.kernel.org/r/20201112172159.8781-1-nchatrad@amd.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/amd_energy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/amd_energy.c
+++ b/drivers/hwmon/amd_energy.c
@@ -209,7 +209,7 @@ static umode_t amd_energy_is_visible(con
 				     enum hwmon_sensor_types type,
 				     u32 attr, int channel)
 {
-	return 0444;
+	return 0440;
 }
 
 static int energy_accumulator(void *p)


