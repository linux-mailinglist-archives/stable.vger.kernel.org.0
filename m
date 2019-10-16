Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6407AD9FDD
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390345AbfJPWFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:05:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:52932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438322AbfJPV6z (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:58:55 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BD7221928;
        Wed, 16 Oct 2019 21:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263134;
        bh=oqYv0CdDEb9mnEpfZAfrAIcIQfo9/lGX7aRzmkFPVYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=McThITfMvukO7Wv4tEY9NrLDKQQI4DThze1NoFi6lO+yQiqb7sWJ+zUKiJaUpA7K2
         jQYoqc2vsZqZBQxFKDoyB6GoWozCwvsU18lE8TGuryb1zA4XpB6twy89b62/RD0yvy
         fs+bujywQ2IoldrV3nesua2AAtHwY6COqqW2Upkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Felsch <m.felsch@pengutronix.de>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.3 058/112] iio: light: add missing vcnl4040 of_compatible
Date:   Wed, 16 Oct 2019 14:50:50 -0700
Message-Id: <20191016214859.789977592@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Felsch <m.felsch@pengutronix.de>

commit 7fd1c2606508eb384992251e87d50591393a48d0 upstream.

Commit 5a441aade5b3 ("iio: light: vcnl4000 add support for the VCNL4040
proximity and light sensor") added the support for the vcnl4040 but
forgot to add the of_compatible. Fix this by adding it now.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Fixes: 5a441aade5b3 ("iio: light: vcnl4000 add support for the VCNL4040 proximity and light sensor")
Reviewed-by: Angus Ainslie (Purism) angus@akkea.ca
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/light/vcnl4000.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/iio/light/vcnl4000.c
+++ b/drivers/iio/light/vcnl4000.c
@@ -409,6 +409,10 @@ static const struct of_device_id vcnl_40
 		.data = "VCNL4020",
 	},
 	{
+		.compatible = "vishay,vcnl4040",
+		.data = (void *)VCNL4040,
+	},
+	{
 		.compatible = "vishay,vcnl4200",
 		.data = "VCNL4200",
 	},


