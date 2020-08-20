Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4BE224B9ED
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729150AbgHTL4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:56:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730296AbgHTKA7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:00:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 034C122B40;
        Thu, 20 Aug 2020 10:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917658;
        bh=LAo3eUTJ8Bt40oLpcmUz9zx4hJiT9FLsAnd1QJarXcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xuIsCzGU5URhu7OHbLYMmGY9ycj0gpiZthR9gttwMxBdCEElccfowPQ5ONAXf9owe
         /g1uPfYPoFCTs2T+yrU6sFOEuHeQYVv35RFXm3xA8N1GVVOUcpcFYuBr5/8Eb3EPhi
         WHggG9EadxBnUsIIoXvadQXetM0YRpyUBh1fR0iY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tomasz Duszynski <tomasz.duszynski@octakon.com>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 111/212] iio: improve IIO_CONCENTRATION channel type description
Date:   Thu, 20 Aug 2020 11:21:24 +0200
Message-Id: <20200820091607.951901676@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomasz Duszynski <tomasz.duszynski@octakon.com>

[ Upstream commit df16c33a4028159d1ba8a7061c9fa950b58d1a61 ]

IIO_CONCENTRATION together with INFO_RAW specifier is used for reporting
raw concentrations of pollutants. Raw value should be meaningless
before being properly scaled. Because of that description shouldn't
mention raw value unit whatsoever.

Fix this by rephrasing existing description so it follows conventions
used throughout IIO ABI docs.

Fixes: 8ff6b3bc94930 ("iio: chemical: Add IIO_CONCENTRATION channel type")
Signed-off-by: Tomasz Duszynski <tomasz.duszynski@octakon.com>
Acked-by: Matt Ranostay <matt.ranostay@konsulko.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-bus-iio | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
index 0406076e44059..743ffbcc6b5f0 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio
+++ b/Documentation/ABI/testing/sysfs-bus-iio
@@ -1491,7 +1491,8 @@ What:		/sys/bus/iio/devices/iio:deviceX/in_concentrationX_voc_raw
 KernelVersion:	4.3
 Contact:	linux-iio@vger.kernel.org
 Description:
-		Raw (unscaled no offset etc.) percentage reading of a substance.
+		Raw (unscaled no offset etc.) reading of a substance. Units
+		after application of scale and offset are percents.
 
 What:		/sys/bus/iio/devices/iio:deviceX/in_resistance_raw
 What:		/sys/bus/iio/devices/iio:deviceX/in_resistanceX_raw
-- 
2.25.1



