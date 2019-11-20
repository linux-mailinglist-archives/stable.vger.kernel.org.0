Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2AA8104641
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 23:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbfKTWCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 17:02:43 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36502 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfKTWCm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 17:02:42 -0500
Received: by mail-pl1-f193.google.com with SMTP id d7so464210pls.3
        for <stable@vger.kernel.org>; Wed, 20 Nov 2019 14:02:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=0iSgGf1Xbkp2g9TWb93HnJQKGbVSv8sx/8dSfMMcIDg=;
        b=FPH8hYqxcyyLuOwz5nNUimDEYKD357z5rCtbYLYc5rKTtC7PWo/67A/UNgtVwTXw9a
         5fd+Dv32rCOdg59naTSEGUSln7nX44Xd2cvgBJeapdjWnHD78aHxVRlhnw2XrtihbW3K
         I0Ne5gy7HLVkQUq/Y5vXTmEZq72pXj5Bjr0GuSahU7DRjaI+dLXAkCmi2mQvRFgAvmVF
         fyyuqE13PCh9PEiDxlfTbplSN3WeZBybrThZSkQMGhlvqnZhS8J4kUFQWVC3qrOQnqiK
         LfQQxfuwbKzUxGzqrPoPUhSQPIvCb5eCoXFwd01o4jhN4DMZaMLcdxe8DMMG3Zh/Ye7m
         3Ovg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:subject:message-id
         :mime-version:content-disposition:user-agent;
        bh=0iSgGf1Xbkp2g9TWb93HnJQKGbVSv8sx/8dSfMMcIDg=;
        b=bJR2KjwhrK4YdzuaoYfAAaMbZJsKUME5Gc6Dniy5fp/ODCc6sXPo7u0yfJ7uQ/OAbW
         LIIKDxrte7XUcE1r2RNPJOSYOpYKePJnceg1aozQeltZZxAvhCI7YV5Psi5FyiyXOcCM
         o9H88oZzcoF0gxA1Yn16i1nCMLCeOua9lJCslfpfmYH9+Cw/UBzEnY6YSa4S7VW7a9PO
         JPrhWZ3GsngXxlmpdUYSRxxlhBoDgTabifCd+8sg6VTvNBL5yNaE7XQ/36b4ycurNdcm
         14cmaANwBBj01BbHeNuNnP/WK6DkRQfDHTbL+azt0fVi8+ysXaTvuQ6Kt0hdLqCJ0FC8
         f7+Q==
X-Gm-Message-State: APjAAAV0uQ4M2P2RW1u/ew2zxt8F9gwB7ePJPbUnM5Vekkk7OOFCjtPs
        JgR1hN/gagHrRuxlyX9rvB3MPATb
X-Google-Smtp-Source: APXvYqw+DfuYVwz6y7Rab3wj7kgzNfaf7OAHBood5OWuJhFSlUQZ8ARMUu1d37rOS9Lk3tUrzdzXaA==
X-Received: by 2002:a17:90a:db43:: with SMTP id u3mr6959401pjx.56.1574287361723;
        Wed, 20 Nov 2019 14:02:41 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f24sm240581pjp.12.2019.11.20.14.02.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Nov 2019 14:02:39 -0800 (PST)
Date:   Wed, 20 Nov 2019 14:02:38 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        sashal@kernel.org
Subject: Patches missing from v4.14.y/v4.19.y after most recent stable release
Message-ID: <20191120220238.GA21382@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

when merging the most recent stable releases into chromeos-4.14 and
chromeos-4.19, I noticed that the following patches are missing
in v4.14.y and v4.19.y. In both cases a backported fix was later fixed
upstream, but the fix of the fix was not backported.

v4.14.y, v4.19.y:

commit a4d8f64f7267 ("spi: mediatek: use correct mata->xfer_len when in fifo transfer")

        Fixes commit 6237e9d0715a ("spi: mediatek: Don't modify spi_transfer
        when transfer."), but is not marked for stable/fixes.

v4.19.y:

commit bc1a7f75c85e ("i2c: mediatek: modify threshold passed to i2c_get_dma_safe_msg_buf()")

        Fixes: fc66b39fe36a ("i2c: mediatek: Use DMA safe buffers for i2c transactions")

Please consider applying the missing patches to future stable releases.

Thanks,
Guenter
