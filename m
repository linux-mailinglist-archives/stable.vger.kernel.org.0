Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC32290210
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406193AbgJPJkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406188AbgJPJkB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 05:40:01 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 910D5C061755
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 02:40:01 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id v12so957483ply.12
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 02:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=qyIf2DL8xE3WUTKp6yLqfv3Jnp97ZG9FodY3ixMsvTc=;
        b=roSKzE4WTgufbS/zcZtv8bsaJOIVEHTJhpnr8RjFDW1CqxBDJ7NN9SntROGclBBc/7
         oGdgkTGb4nGC5k6/ne3H7lmU6lLYGUNqliFyJxkUg2m61EM8BeWopGrI1VTWFqy5rFfN
         23+4gM6O24Eb8TVVNa13mt8xGNKONayPrAczxYoYKyk6BdJGhxWLy41z7bY7DEXsru7m
         3SYAVxFmfen9ShPJtZecQ/RZBoRFVcNL3XanAPiZJkmaCZRJh8+ZPKtoS7tjKZy533pA
         VS4KjuBPJlxlT+3zNc8zMCxPY70P6ViJ1sApywMqlZyajrLul8fb/qsXLCprBHnkttW7
         m2Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=qyIf2DL8xE3WUTKp6yLqfv3Jnp97ZG9FodY3ixMsvTc=;
        b=EfiF3cHaRo0LgkcHqj7YlovVpD0YWOc7c5IdfLCXOziKPdRE83L+2b5jjo7ybTWdm1
         n8+HG11AdKjMjkGZtah/P6pAYzk8xbl3VYckX4d0Oc9SEGc1uMGXPlyg/9znE9e4RICv
         Y4YvRe+8b5bMKLRrv2svboSFmfBMxX3++8tLqExDMzQ6Q3O5lL3S+Lz1FJJrlCZvaciO
         yHFJuSQvOpcCocvCGMgObBExy9M32EGT9iT3YAnNYItBtY3FRnMns89taWjgvdSG6Mrj
         RsZySI2Pezmv9Ew3xajZLriRE/8Vuk0i6sHHrFTVqI7c7Ftx8GSiTfYKbfxzatQ7m/N4
         kGXg==
X-Gm-Message-State: AOAM533sQQzKKUcnLVY/iidL3p6juixfXeGBbckimWVRZa14jJZ+UwYH
        EI9OawhmLmVUTiSAHU2N/SQ42yXM89H5cxKxuA==
X-Google-Smtp-Source: ABdhPJy+1wJ1dkyjRggDD+plvxmX6XhpQofSVXn7PIzIP7Ko0sGph+H1Kk0BFNUWgl5Dkj26UQwVVdgfeH/OGPIervY=
X-Received: by 2002:a17:90a:ec11:: with SMTP id l17mr3171106pjy.104.1602841201176;
 Fri, 16 Oct 2020 02:40:01 -0700 (PDT)
MIME-Version: 1.0
From:   Rui Salvaterra <rsalvaterra@gmail.com>
Date:   Fri, 16 Oct 2020 10:39:50 +0100
Message-ID: <CALjTZvZ_hesn5D34o7+X-gffN-POPzk49-ExB_r-sCpupdTtmA@mail.gmail.com>
Subject: Backport request: arm-8987-1-vdso-fix-incorrect-clock_gettime64.patch
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, jaedon.shin@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Greg,

I see the arm-8987-1-vdso-fix-incorrect-clock_gettime64.patch ("ARM:
8987/1: VDSO: Fix incorrect clock_gettime64") has been applied to the
5.7-stable tree [1], but this should have been applied to 5.3+, since
it's the first version to contain the commit this patch fixes [2].

Thanks in advance,
Rui

[1] https://marc.info/?l=linux-stable-commits&m=159628776730078&w=2
[2] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.3.y&id=22ca962288c0a1c9729e8e440b9bb9ad05df6db6
