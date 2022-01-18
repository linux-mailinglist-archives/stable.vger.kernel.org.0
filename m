Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634344928C1
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 15:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344467AbiAROyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 09:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344573AbiAROwy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 09:52:54 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C333CC061401
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 06:52:53 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id cx27so7170567edb.1
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 06:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=bQERr3f96sJZo3fyx626TSqkOY/yxktD2TT4mdcbVt0=;
        b=KCJy185T3knEUP0VU5+2Kb/w2dJCfUi+R6QqFj+D9M67B41I9YRspxvjurd51sI6Zl
         k3O25OzU2iU2CnyEV9fCL5a5zDqzd/+BWQ3ly8IA/yvKjERUWr8Er55BFVpta/sUOiKK
         1nZYN2ZhdzcNB5idjud8rbQgozBmb76SUMTUHOA+JrI34xyswedIOT48UbbgYecQEUhb
         AqfbTt4rOeaVRgLm/DftzRtDHFJRD+LW/T0e1YTefu03dVAj7EVS9g7M4OSNeSQqVcR4
         ql/Nay9DcVbY0CA2jlhzNNwxWZfsz/73aKSJwaqjh7WBy3nv5WlMtkVKMBmpsqFEV1RA
         ycKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=bQERr3f96sJZo3fyx626TSqkOY/yxktD2TT4mdcbVt0=;
        b=61uxMR++Us1RwIp2WGmWbv+MjNDuYmBoXUoWXpizRxZ1MUVYclvKJ/QfpTXmQKOXrj
         LFKfxQ/VtlOEjoZofCJHBj0t+9FHcaSlmaEoovEptVqbexwXeow9VOr0ntkPyMMQrZbd
         P1tkQ7YVUmUDl/FT0UjoUC22/EioajMqU2vj3GZTHewNZDtV3VJjG1e6/1IclEXSlqev
         msscfAMVMlHrKihcVILIziSCeXC9lJ9EVElXNdwuENZ6NMzbRZ2VaE84lWo+osM9/fNL
         mjTEChQSshWdX3LYwVaK9nKyEK/BPu4honvc5dP/nEuGbd6ymfxQpJXTEoa89iZ1p0qp
         B0Qg==
X-Gm-Message-State: AOAM531nldfklCYG9JZpZR6RUl29ngLmuNlNpFxIl9rqwRLByJvLRYJA
        +eAA9G/c38pmwWMlrdTHrFWBKroLqgh1EfNu8xBk4JcgGUMXrg==
X-Google-Smtp-Source: ABdhPJxfgwnkMBqH0O3rYm2cgpBCiEyYsIzDkff7975I6IoDtQRPDlXXhxmN/92M2MY+QHAL6+sdUoU9Mp1Exv+3Zcc=
X-Received: by 2002:aa7:c917:: with SMTP id b23mr10498043edt.309.1642517572296;
 Tue, 18 Jan 2022 06:52:52 -0800 (PST)
MIME-Version: 1.0
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Tue, 18 Jan 2022 15:52:41 +0100
Message-ID: <CADYN=9LE7-9BHPEJBtL2sXChv2OfRcJTQnG+_Ug3HWAouBwHUQ@mail.gmail.com>
Subject: backport patches to linux-5.4.y+
To:     linux-stable <stable@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Can these two patches be backported please?

603362b4a583 ("mtd: fixup CFI on ixp4xx") to v5.4+
28187dc8ebd9 ("ARM: 9025/1: Kconfig: CPU_BIG_ENDIAN depends on
!LD_IS_LLD") to v5.4+

Patch 603362b4a583 ("mtd: fixup CFI on ixp4xx") solves:

drivers/mtd/maps/ixp4xx.c:57:4: error: CONFIG_MTD_CFI_BE_BYTE_SWAP required
#  error CONFIG_MTD_CFI_BE_BYTE_SWAP required
   ^
1 error generated.

Patch 28187dc8ebd9 ("ARM: 9025/1: Kconfig: CPU_BIG_ENDIAN depends on
!LD_IS_LLD") solves:

ld.lld: error: arch/arm/common/dmabounce.o:(.rodata.str1.1): offset is
outside the section
make[2]: *** [scripts/Makefile.build:262: arch/arm/common/dmabounce.o] Error 1
make[2]: *** Deleting file 'arch/arm/common/dmabounce.o'
make[2]: Target '__build' not remade because of errors.


Cheers,
Anders
