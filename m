Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D336147F26
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732762AbgAXK77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:59:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:58502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbgAXK76 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:59:58 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C052D21569;
        Fri, 24 Jan 2020 10:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863598;
        bh=9uhcRE8frcx+UQvoR7f2PSMOun2s5/UKwyZpytWgAJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=isXTwmjeoHFZp9DHa/l5ksjnwLUpABQFD11o/HvDK5hjYfor1XlUx+oeCMe18/mit
         cXBFILNNqvECEFXW6ydTbdyyO7F2zoSBknujjUDsjlcqrKkZiBJwQXWXztalDoTIR4
         hUMqRnZNfUYZZ0OBaAwjqMnqGpLt4Qw0l4AAwa2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 023/639] iio: fix position relative kernel version
Date:   Fri, 24 Jan 2020 10:23:13 +0100
Message-Id: <20200124093050.098914123@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugen Hristev <eugen.hristev@microchip.com>

[ Upstream commit 21eab7861688aa4c69fcb88440cc0c4a422bdcd6 ]

Position relative channel type was added in 4.19 kernel version

Fixes: "3055a6cfa04ba" ("iio: Add channel for Position Relative")
Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-bus-iio | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
index a5b4f223641d9..8127a08e366d8 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio
+++ b/Documentation/ABI/testing/sysfs-bus-iio
@@ -199,7 +199,7 @@ Description:
 
 What:		/sys/bus/iio/devices/iio:deviceX/in_positionrelative_x_raw
 What:		/sys/bus/iio/devices/iio:deviceX/in_positionrelative_y_raw
-KernelVersion:	4.18
+KernelVersion:	4.19
 Contact:	linux-iio@vger.kernel.org
 Description:
 		Relative position in direction x or y on a pad (may be
-- 
2.20.1



