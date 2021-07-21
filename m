Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D237D3D119F
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 16:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbhGUOIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 10:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbhGUOIL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Jul 2021 10:08:11 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6961FC061575
        for <stable@vger.kernel.org>; Wed, 21 Jul 2021 07:48:48 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id j1-20020a0568302701b02904d1f8b9db81so2244205otu.12
        for <stable@vger.kernel.org>; Wed, 21 Jul 2021 07:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=6ql2ECn7cezJEfRqzBduTSAmQUaRaUT19pW0jz2l/iU=;
        b=Yf+e/n8baFKxqGC6hy+rAs0CgGHc6Q0ejhYIKnPHhRbF3zkQwDIEy2EuOocWExGuHX
         VNBjVcpvlK+35FigbimJyoxBKOJVdhilMD1XVf69MAXMwLiVm0BMkPJYth+0naR1DUmm
         d/0YIgVseMdWLCHCTpixpROYZ608s+vyXL71qdPpkq+nV48L0B/3TLWmPG+NT6Qc4VA/
         SvcNopPHbKOIcBSoJo2Y1xnCuyyj2eULWYQfqkY5m5ZEeGr2lfleoNw/yik72vb28Kvx
         zaUOvD0AbdE5voZlsB/BRVGGlI3n1fSp/gRxTvp/9Oce3Z3mkvpVedspcWZ5AD5uYeX0
         I/cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition;
        bh=6ql2ECn7cezJEfRqzBduTSAmQUaRaUT19pW0jz2l/iU=;
        b=Rf/qMwC1UgPcLBqlBHeZ/bRn4oqO8ZY3HIRP9NhPnAFVhraIvRJ0udKUKIxgJMwKx3
         BqLSB0WF7a+zESlduMpx4wT4DHZxEPe231O7ol2BVzbtsZA0pMmckNunvwun+3qbsNcs
         85uLalzVirTV8eQ/yDzaFTtO/jrRO/VNYdcv6g/7RNQjIpVp+8WcHv9VBBB9/tMKg7L4
         9vJgfOZJonA7sHVAKr7a/mQgutmQalf8PhJWxfNyMIEWGBfH3rlhrbNvnqcddnu9uEe2
         mmatNCWj0VpeMmE6zah8DpF+9wOZv4P38uetQV5pm7lMufYXX3S9IsPpAXeCCvoeYhdP
         nc6w==
X-Gm-Message-State: AOAM531Lr52b+KBSCC+u8mfowf3BVMHGzQWSAis/VRqTTlUz9riTsTfG
        Og25pvmbz80/F2nXI8fOX5NYlo3VSO0=
X-Google-Smtp-Source: ABdhPJxeCQJtSgpIYAfEPEeGDkBAHuWU+g5Xo91YiJNb2YSeudbXoy1w6NQsOW9tKVTfanmXJ1aG2w==
X-Received: by 2002:a05:6830:2413:: with SMTP id j19mr26630525ots.332.1626878927585;
        Wed, 21 Jul 2021 07:48:47 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x16sm134713ooj.1.2021.07.21.07.48.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 07:48:47 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 21 Jul 2021 07:48:45 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: v4.4.276: Build failure for powerpc:mpc85xx_defconfig
Message-ID: <20210721144845.GA3445926@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

As of v4.4.276, linux-4.4.y fails to build powerpc:mpc85xx_defconfig and
other powerpc images enabling the fsl_ifc driver.

drivers/memory/fsl_ifc.c: In function 'fsl_ifc_ctrl_probe':
drivers/memory/fsl_ifc.c:308:28: error:
	'struct fsl_ifc_ctrl' has no member named 'gregs'; did you mean 'regs'?

Guenter
