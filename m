Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7873D417E
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 22:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbhGWTrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 15:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhGWTrX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 15:47:23 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB39C061575
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 13:27:55 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id n12so38497wrr.2
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 13:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Skxv9A9ojE2ZyaEIPLdKqqIi7pS/J6Hd0Z2xw2NOcAw=;
        b=t8f8vJZdQNRTehfASlMQctOHsmqDzSBmNXAfEbQEuzG4l4isCDKdkNVSZ7dAF2UjpW
         zLXf62zWWeSvpI33ZEQqmFpfuR1fW/Y2l54nmMkFIc7ybquR3ixhcKkQf+Xv9ssLNHgh
         TjcMCjDQMFk98FfPSKMXhkqMwRJ7cMycM8cmyvnQPdEdvCZNY0dOBETXAyvj72LSRwxf
         YQakb8hXykxLK2115cHQPT4Nx6IkLA3SJ9/gsgU26oihok+Jhnu7M2AhceRI7ScGSNnr
         BBMCFzrJtSUT8vbo7RX1G2zSYjm8AyscFmBNyBTk+/jW6ui0d5OLabbnm3LC2xW0ICN6
         zv2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Skxv9A9ojE2ZyaEIPLdKqqIi7pS/J6Hd0Z2xw2NOcAw=;
        b=qBuNsAwtVFgScLxWPbm2JTqzoTjqbwBZoyBdrfWT4XLPjylEUk5XFXo2Ruuy3FmoJ0
         C2ff3aKipWQ84D5+QmZpnmJEzmWDLBXW7QFckca1876+FFtL9P/uDPDT8kz6qDyHdmOa
         KEofMhPti3Bsgjdt8HMKOSer9gAIH9G4ov9mZkC0TDnt0b3PnAreSoo3iRFh6hAwoKqs
         35y7kaVUc2to+IIOFIE59ZS1ZPon9aJuwEuxTkrJoUDUKxZLX1wGFmMe/WxnUi3XtRFk
         jUn5e3jr8WHfP6oipp099se1qxv1ssx9MeoioapZbjuvNnS0AINF87yDzHRabgb8vMYH
         vK4w==
X-Gm-Message-State: AOAM533PKk+DRADpwXZqKR8akWMP6W8igAXVyYrNbimkmJ2MaNliWs/y
        HgpYVMDDW923DLUtUYrZ/So=
X-Google-Smtp-Source: ABdhPJz/1Yxil65RjoOiazkRAzlj7sBDm3p70VNXeaGOx1H/sgrmCn8wl+OKy2UZN6w0Hi1vAg8GrQ==
X-Received: by 2002:a5d:6da9:: with SMTP id u9mr6966218wrs.7.1627072073230;
        Fri, 23 Jul 2021 13:27:53 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id p5sm37209980wrd.25.2021.07.23.13.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 13:27:52 -0700 (PDT)
Date:   Fri, 23 Jul 2021 21:27:50 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     christophe.jaillet@wanadoo.fr, broonie@kernel.org,
        olteanv@gmail.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] spi: spi-fsl-dspi: Fix a resource leak in
 an error handling" failed to apply to 4.19-stable tree
Message-ID: <YPsmRiIXK/Fc+hcm@debian>
References: <162238346339174@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VmswqxmVlZ8lsQd8"
Content-Disposition: inline
In-Reply-To: <162238346339174@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--VmswqxmVlZ8lsQd8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Sun, May 30, 2021 at 04:04:23PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport, will also apply to 4.14-stable.

--
Regards
Sudip

--VmswqxmVlZ8lsQd8
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-spi-spi-fsl-dspi-Fix-a-resource-leak-in-an-error-han.patch"

From ae0359c102c982850c59f159f5d575b46c4df6e3 Mon Sep 17 00:00:00 2001
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Sun, 9 May 2021 21:12:27 +0200
Subject: [PATCH] spi: spi-fsl-dspi: Fix a resource leak in an error handling
 path

commit 680ec0549a055eb464dce6ffb4bfb736ef87236e upstream

'dspi_request_dma()' should be undone by a 'dspi_release_dma()' call in the
error handling path of the probe function, as already done in the remove
function

Fixes: 90ba37033cb9 ("spi: spi-fsl-dspi: Add DMA support for Vybrid")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://lore.kernel.org/r/d51caaac747277a1099ba8dea07acd85435b857e.1620587472.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/spi/spi-fsl-dspi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 1b003dba86f9..25486ee8379b 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -1124,11 +1124,13 @@ static int dspi_probe(struct platform_device *pdev)
 	ret = spi_register_master(master);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Problem registering DSPI master\n");
-		goto out_free_irq;
+		goto out_release_dma;
 	}
 
 	return ret;
 
+out_release_dma:
+	dspi_release_dma(dspi);
 out_free_irq:
 	if (dspi->irq)
 		free_irq(dspi->irq, dspi);
-- 
2.30.2


--VmswqxmVlZ8lsQd8--
