Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 598F7191096
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgCXN3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:29:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729486AbgCXNX5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:23:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 968CF208CA;
        Tue, 24 Mar 2020 13:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056237;
        bh=C6V82WfR0WiPhesQkqIHwf7eUT1pzEcPp6KnE4TR6zY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bnnLn7ZD0QvkeWYvHVkGpDviXz2kTPfjZiUrMgZ+d62+8u3Exdvlqu14Od1zuU7ru
         H8m9NW5EKWcaxrv/R642rWRRf6/BcdWYQOq3cBvKuZM7mW+CRyI99M2ECZNP/N6kQe
         i85dGCiqM2TjUtJoIIjxJ/ucarZWGPI7WUldQ4l0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.5 065/119] iio: accel: adxl372: Set iio_chan BE
Date:   Tue, 24 Mar 2020 14:10:50 +0100
Message-Id: <20200324130814.694004371@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Tachici <alexandru.tachici@analog.com>

commit cb2116ff97859d34fda6cb561ac654415f4c6230 upstream.

Data stored in the iio-buffer is BE and this
should be specified in the iio_chan_spec struct.

Fixes: f4f55ce38e5f8 ("iio:adxl372: Add FIFO and interrupts support")
Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/accel/adxl372.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/accel/adxl372.c
+++ b/drivers/iio/accel/adxl372.c
@@ -237,6 +237,7 @@ static const struct adxl372_axis_lookup
 		.realbits = 12,						\
 		.storagebits = 16,					\
 		.shift = 4,						\
+		.endianness = IIO_BE,					\
 	},								\
 }
 


