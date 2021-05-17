Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1CD0382BED
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 14:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236960AbhEQMTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 08:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236959AbhEQMTI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 08:19:08 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB4FC061573
        for <stable@vger.kernel.org>; Mon, 17 May 2021 05:17:51 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id u19-20020a0568302493b02902d61b0d29adso5322205ots.10
        for <stable@vger.kernel.org>; Mon, 17 May 2021 05:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zEU6CzFgEsXFctNNyZP0I8tPhrQAXlBinqVRaGycqaw=;
        b=nQh/rgWDfcKxibJ1P5lnanSBbO/cAyfCxVquNA3WeP7GaaOAcSoYbw88Y0Kab281IH
         VNRvUXiWxUwVBM+JyU3M/5pUaW233FtE/mUDw3goDeePBFZ4Rwi/yq8jlSMXCMlkQZTL
         TN11iGLhiydgCxmE9Q1TS7STAeCrfyQK/9olpD4BotQCgN/Z9JYjW2/mIvqsPkHHOO9S
         WnseZxDOda5cHggwVaQFMZnQZ9ckc9tG+mJBPwVbgqZhz/biAdZq71qefsAAKOS+PgVc
         1IfxUeFA3CwccAa6NX3Av2i1B4nXlXtvbBCh5v77MyMZKMKwCq4P8vBjxl89Ma9uPpJ2
         3J7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zEU6CzFgEsXFctNNyZP0I8tPhrQAXlBinqVRaGycqaw=;
        b=mMdWgm1CMBAIjVvUCvZAlB9qTOT0sX5X/gWbWa70dQRDdd+8/FTkmvdCi6CMtDodec
         XpOe2qMI/niHObsWeNtJtbgxuiTG2+rcV8XirgT0eyxdHyySPglPWVMXUmBg7s/kQoNu
         F5jmA+3yxxO0pWw0uF17oqfxYr8UQktfXL/P+cMA8wAnp0mRZB/XNlfF8ZSgeQ6nFZ6c
         44yV03RmGpALeokNw6dOLvanSfGJBOIq6aB2EDIE81F4X5tpiKYST2ocLEDBr/xXy/5Q
         E7R4Z7eQEVzgCTfbbU02SammQeWy35EDYSUPbTbQg6o2XmTxaQEuT89AZds++NuQH+Hq
         gDqA==
X-Gm-Message-State: AOAM531qes58Aw1yMHYsiWJPKtnEM6TsLeXcAosrXnVpwYbmkqc0uh3m
        Vw+2KICJze/LDR2ra7mcw1Pmcjx0banrFQ7dG9mM5jh/
X-Google-Smtp-Source: ABdhPJwLn1YFkqRfXLgmIKLo5xNZffSk6I/sK/iwtQhUKND0ZTqHq9MTOqVk0U69ENPn8I9ygRoZSzHbWRW9F5WqebQ=
X-Received: by 2002:a9d:4e96:: with SMTP id v22mr31832024otk.134.1621253870688;
 Mon, 17 May 2021 05:17:50 -0700 (PDT)
MIME-Version: 1.0
References: <e0e9ecf4-cfd7-b31a-29b0-ead4a6c0ee40@charleswright.co>
 <1621180418@msgid.manchmal.in-ulm.de> <YKI/D64ODBUEHO9M@kroah.com>
 <1621251453@msgid.manchmal.in-ulm.de> <1621251685@msgid.manchmal.in-ulm.de>
In-Reply-To: <1621251685@msgid.manchmal.in-ulm.de>
From:   Jack Wang <jack.wang.usish@gmail.com>
Date:   Mon, 17 May 2021 14:17:39 +0200
Message-ID: <CA+res+RHyF22T-sGwCG5zA6EBrk_gWbnZETX_iAgdRdWaPLbfw@mail.gmail.com>
Subject: Re: 5.10.37 won't boot on my system, but 5.10.36 with same config does
To:     Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Cc:     stable <stable@vger.kernel.org>, iommu@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+cc iommu list.

Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de> =E4=BA=8E2021=E5=B9=
=B45=E6=9C=8817=E6=97=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=881:52=E5=86=99=
=E9=81=93=EF=BC=9A
>
> Christoph Biedl wrote...
>
> > Thanks for taking care, unfortunately no improvement with 5.10.38-rc1 h=
ere.
>
> So in case this is related to the .config, I'm attaching it. Hardware is,
> as said before, an old Thinkpad x200, vendor BIOS and no particular modif=
ications.
> After disabling all vga/video/fbcon parameters I see the system suffers
> a kernel panic but unfortunately only the last 25 lines are visible.
> Possibly (typos are mine)
>
>     RIP: 0010:__domain_mapping+0xa7/0x3a0
>
> is a hint into the right direction?
This looks intel_iommu related, can you try boot with
"intel_iommu=3Doff" in kernel parameter?
>
>     Chistoph

Regards,
Jack Wang
