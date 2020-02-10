Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80FB1158131
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 18:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbgBJRS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 12:18:29 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45118 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727598AbgBJRS3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Feb 2020 12:18:29 -0500
Received: by mail-pl1-f193.google.com with SMTP id b22so3059073pls.12
        for <stable@vger.kernel.org>; Mon, 10 Feb 2020 09:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=29xLBkG6ZsGvvZoV6NquOYgL0DhsT5ED6pKhcVtl/rI=;
        b=l+T5X3Wha8PqXHaprTLj3dBFJ8ltPC3PyxWqpmP216h0uk6KKDfRXq2kQ1VTiuNYJ9
         AnVlBbEKS1U45FgVnY9ruwuW8eY1HVyD+JQwE2xy7hORgQ+p14ehknBMwSDtvfoyh7Pp
         Y4hxaQ7T4iC3dDN9MXG+fOkE1jPmW4L0gQDz94dYd8wvkt0TkDCQddDmpbOWp3VpMCuV
         l6UJGFWaBxiFdv6/FSTTW14aL/hbgNvntg7ucPrQQi/rBj351apxJKTBd66Bwsiw2fqA
         GefCUSFiSPWZYndOjdIrMTwDMcNo4ill1gYqPB1sZJLUGZjDP0COBXQmja/dDU78csrE
         FKfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=29xLBkG6ZsGvvZoV6NquOYgL0DhsT5ED6pKhcVtl/rI=;
        b=ZUj8u66Ishjb9UOexFsu9/uYy1cLyTWMELgc3LJKeGjvP0GtXI/rGkMlGmNJXEnuPd
         jUcAoQ5F1eToyYqvXQGb9MAsPK6YAi6d3ZZJ11mnt8yu8gH3GUM2B4qjQ0fkRZhu+usq
         i8OIetC1cGR/hmQ6CaR0ms7DH0EfPDBUAk0zN1FDg1iIOjB7wrdWOxRnXSToLmEzSD3y
         lZiRRL+C7cNZJHw+Va8Yk1Yz6sqxfn/9SNzyRT1Mlqg64qzXosruGJbrzOhiIJUbZB44
         lmjOlb9m7fCLfVsTGZQwZnmwnSYvs935xXd2uSw0IcdR4AaVCIJdkx3RwpT3xRI/yPRN
         YzJA==
X-Gm-Message-State: APjAAAXRou/+jFWPAmWuUUAdSbB/Ca5wpYk5SxNIKigAlH1UG5NcJ03I
        x1oaxuFtuXGlRsP/WnVCiw6hMbZTEVs=
X-Google-Smtp-Source: APXvYqyNmiA1Sf8vj3Zf3miE+vqfT90qjkUFTIkGqrjiiF01+UeKO5rOY7tmO4+P5cQ/hEnrAGnm7A==
X-Received: by 2002:a17:902:b587:: with SMTP id a7mr14047693pls.82.1581355109073;
        Mon, 10 Feb 2020 09:18:29 -0800 (PST)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id u12sm927912pfm.165.2020.02.10.09.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 09:18:28 -0800 (PST)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [stable 4.19][PATCH 0/3] stable: Candidates for 4.19.y
Date:   Mon, 10 Feb 2020 10:18:24 -0700
Message-Id: <20200210171827.29693-1-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please consider for 4.19.y - applies cleanly on 4.19.102.

All three patches are already in 5.4.y so no need to apply them there as well.

Thanks,
Mathieu

Boris Brezillon (1):
  spi: spi-mem: Add extra sanity checks on the op param

Brandon Maier (1):
  gpio: zynq: Report gpio direction at boot

Shubhrajyoti Datta (1):
  serial: uartps: Add a timeout to the tx empty wait

 drivers/gpio/gpio-zynq.c           | 23 +++++++++++++
 drivers/spi/spi-mem.c              | 54 ++++++++++++++++++++++++++----
 drivers/tty/serial/xilinx_uartps.c | 14 +++++---
 3 files changed, 81 insertions(+), 10 deletions(-)

-- 
2.20.1

