Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1C92F04B2
	for <lists+stable@lfdr.de>; Sun, 10 Jan 2021 02:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbhAJBXV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jan 2021 20:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbhAJBXV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Jan 2021 20:23:21 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA61C061786
        for <stable@vger.kernel.org>; Sat,  9 Jan 2021 17:22:41 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id p187so13999661iod.4
        for <stable@vger.kernel.org>; Sat, 09 Jan 2021 17:22:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to;
        bh=e6e1WQ0HuKFQorLeoEP/9uWxRmzhO1+fvSeoZaYFDBo=;
        b=fNzouggdPpLz0vDwfJZgUTRxQUNb/7O+MEBPhTmvnByKbKofgX6Forp6Ghuu7irN3E
         0hVIg0pESVpTdorUjdlNUfpeEXa32kLopyT29Lw1hYfj5zkdpRM6PNNyIOb9+cxmITHi
         R+Wf8/u9rfg/gKWXB2U1HnQfayWWtB3MZN+TBABC/booy0cmCXuv+M5GqEQJvKZeQqE8
         gmwi4mYnaLfdu5EyATUeH/sxVelyiZCwEUr3a1vuPtG2U61Z+MJKklTNEg8zZGQR9M2C
         Zvz0aCXqwdUajgrI1pgPzuTvUcOZq5vqIjFDRL9NLdRq2OunOO4TJCXHWOByUdsFPP9I
         sXww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to;
        bh=e6e1WQ0HuKFQorLeoEP/9uWxRmzhO1+fvSeoZaYFDBo=;
        b=ttgDZLJnDWUkVJzLXGqgaZc21ZG6sQbP4aBFqjipoE4vP9qy3cfne3MVaeHI2DgMoy
         MVObS/w8W6BccECkKx+WhuQLbBTn1UYoTEsUDBLmCjobQ4YfylRmMIOAC6tge3yyK9q+
         a/5GLOzFYG+wvFU3tzgnfxtz8W4uH6wtNpRaFItwUb62IZXYSaVT7y3l4yya7Of2SL87
         FDXyteI/OZ+5kOlwClGwJXEgIxPEz7svWNny0PM7agIqG62AaFfUsfJIGdQ7y6sbMgjX
         fwWCufYL3BfdAIKS/6+pDSBA5YmzNWTas6y+P5EWMiTq07/i4fCQtJ6fG0nCzURZUMEx
         Zm9g==
X-Gm-Message-State: AOAM532CycDmMQa0Yij34JnmqiW//6bCGc7ys9Sz96e0MGmoka6jDGGZ
        +BQddbKJUKoOGkF7Y0dHk0HI3F+WBEG+s3HBvLNuYR3aFPzQNg==
X-Google-Smtp-Source: ABdhPJz44JmFKkF05mZDzYPmtewLG/rWQOvHU+jRxjsXj/tB8aXeYT/JE3+RFxnJ62OO+DsehH5EIALXsIqSdTt946c=
X-Received: by 2002:a02:2ace:: with SMTP id w197mr9517315jaw.132.1610241760237;
 Sat, 09 Jan 2021 17:22:40 -0800 (PST)
MIME-Version: 1.0
References: <CA+icZUUq9Skdt0ws7uqa3N9P5vwhQX6DrhfNxMvkoKMEbyWE-Q@mail.gmail.com>
In-Reply-To: <CA+icZUUq9Skdt0ws7uqa3N9P5vwhQX6DrhfNxMvkoKMEbyWE-Q@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Sun, 10 Jan 2021 02:22:29 +0100
Message-ID: <CA+icZUWNc6S350i7Ct73XnLJHgHymyDvQ1twVckSsFTemxuCrA@mail.gmail.com>
Subject: Fwd: depmod fixes for linux-stable releases
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Corrected to <stable@vger.kernel.org>.

- Sedat -

---------- Forwarded message ---------
From: Sedat Dilek <sedat.dilek@gmail.com>
Date: Sun, Jan 10, 2021 at 2:18 AM
Subject: depmod fixes for linux-stable releases
To: Sasha Levin <sashal@kernel.org>, Greg Kroah-Hartman
<gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
<linux-kernel@vger.kernel.org>, <linux-stable@vger.kernel.org>


Hi,

I was CCed on the "depmod: handle the case of /sbin/depmod without
/sbin in PATH" changes to linux-stable releases.

Do you mind also pushing...?

commit 436e980e2ed526832de822cbf13c317a458b78e1
kbuild: don't hardcode depmod path

That was the origin for the depmod follow-up.

Thanks.

Regards,
- Sedat -

[1] https://git.kernel.org/linus/436e980e2ed526832de822cbf13c317a458b78e1
