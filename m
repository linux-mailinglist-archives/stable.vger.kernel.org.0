Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3132B9C62
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 22:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbgKSU6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 15:58:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgKSU6o (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 15:58:44 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FD6C0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 12:58:43 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id r17so7936736wrw.1
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 12:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xc7/x1MaFb524IrN8KAFjf+6KBwAmpGFVqSr2wK43OM=;
        b=kNwRG7r/+zTkxeswl45j6u8h/oY8ijzKgErX93btVhinHYSFibM1mW+dx+07liSof9
         Xbwv0DQg/t0jFtFYzOJV+uM715Rn7rPbFz2g+FYQ8Y8BD/e6LUTL32n/lByjtxHzt6xW
         Q/OfppzKQ/fTuNm8Fx+rEsc/azssjKmuW5nLdeuCZDijJGvD1p8tKxTAyVYpMmrttFpa
         k2Cc4A0+WpO6nwiPjQuD1fKSoNFvFkxzLBCxq76DoHIvhO1iotqVj1KouhQely7g39fK
         RIf7ldR93xQuVciD5GqX9WZwkTyd6sl3SN5bpVTHcNKWMdEHDEdh4jz9YjP/B/gJ0l0x
         Bodw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xc7/x1MaFb524IrN8KAFjf+6KBwAmpGFVqSr2wK43OM=;
        b=dTbH9Cgb4a4KBINUjH6gRJMjhnxN18P/x4A/K5bHcVOmxEAsj9FTom+VT5lOsJ0X+H
         bTM2LCVBOvt4ZwW4dwivQH7k3VTah+JzqT7P9LUv8ONONlfn6QLmkKLdcOaRgJo83yff
         VNVDeMgPXI4Dw4PnhC31rzG26oVna8b1opXno6qKT4ykeRxCW0t19sH8lTXpW+i6R4m2
         +1aP/6eIC8EBxpbwcpVe7zXIZYDoU3E/Q8oPurWdsY1okgjUG7CiK3CuX+E7ev+X9cp7
         eP4i0+n2jEAAujFkgoXIlQ4AtTYy/jPVMzpJDanDIESdP/Is76CDIKe8fOa44S0N8Rua
         eWhg==
X-Gm-Message-State: AOAM531HXuQihDdZnBb/CQet1VW39XLaVBHInv6QS2K8y3GWYCvVCVrI
        64idHNZnuOqaQxb3pd1lqbaligxlK2pkIHb3
X-Google-Smtp-Source: ABdhPJyD83eTdJswEHiSaYQID4teDiioFtMgjskaH2dn9NvgFhV+eezzh9e95V7OkFaFfvTOQJqIYw==
X-Received: by 2002:adf:fa10:: with SMTP id m16mr11972521wrr.194.1605819522522;
        Thu, 19 Nov 2020 12:58:42 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id k3sm1565238wrn.81.2020.11.19.12.58.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 19 Nov 2020 12:58:41 -0800 (PST)
Date:   Thu, 19 Nov 2020 20:58:39 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     bgolaszewski@baylibre.com, andriy.shevchenko@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] gpio: mockup: fix resource leak in error
 path" failed to apply to 4.14-stable tree
Message-ID: <20201119205839.u7sbd4ytxjivybts@debian>
References: <160180783111955@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="27ylru5jiy5aeisb"
Content-Disposition: inline
In-Reply-To: <160180783111955@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--27ylru5jiy5aeisb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Sun, Oct 04, 2020 at 12:37:11PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport. Please consider for 4.14-stable.

--
Regards
Sudip

--27ylru5jiy5aeisb
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-gpio-mockup-fix-resource-leak-in-error-path.patch"

From 9c0dde685fd7e37a444a927fb9c9aca740444816 Mon Sep 17 00:00:00 2001
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date: Tue, 8 Sep 2020 15:07:49 +0200
Subject: [PATCH] gpio: mockup: fix resource leak in error path

commit 1b02d9e770cd7087f34c743f85ccf5ea8372b047 upstream

If the module init function fails after creating the debugs directory,
it's never removed. Add proper cleanup calls to avoid this resource
leak.

Fixes: 9202ba2397d1 ("gpio: mockup: implement event injecting over debugfs")
Cc: <stable@vger.kernel.org>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/gpio/gpio-mockup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-mockup.c b/drivers/gpio/gpio-mockup.c
index d99c8d8da9a0..a09a1334afbf 100644
--- a/drivers/gpio/gpio-mockup.c
+++ b/drivers/gpio/gpio-mockup.c
@@ -350,6 +350,7 @@ static int __init mock_device_init(void)
 	err = platform_driver_register(&gpio_mockup_driver);
 	if (err) {
 		platform_device_unregister(pdev);
+		debugfs_remove_recursive(gpio_mockup_dbg_dir);
 		return err;
 	}
 
-- 
2.11.0


--27ylru5jiy5aeisb--
