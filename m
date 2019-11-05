Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F262AEF77C
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 09:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729597AbfKEIqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 03:46:34 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:34619 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbfKEIqe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 03:46:34 -0500
Received: by mail-ot1-f65.google.com with SMTP id t4so5471438otr.1;
        Tue, 05 Nov 2019 00:46:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MyKOhk0LoBuQhEYb9KFuzXqL5I8+dPurov3bPqiyxKA=;
        b=IV8Ysd61vx5rujwStE3sYWm1yJmXkRFfrFSDD1lc9QIP/y22ET9ma6r4yY1LdZISIC
         JjXGqxmnmIonHK3YdRdyMLAQPDvGse+J8pfU2YYo4wnNBMMewGJFyPRIaX/hzIxuTdbg
         7j1c+TLICOC9ZeH7SHw657nGFLcwKtifMpTv1lwdZgYre6SNB5WOeur90Bk+IK/HEZqy
         H0yn2bjOOZoLuqFKw5R0PI3cVRlAeTp7HQZgZtILlzhR98XFNHxclbpongcVIwwuAREi
         NzCPKbrz+KXfMSzarn7SeXAoc3qRFszTG8HdgbkZa/6zS8eEbrcBzDhdg3C0TdO9+vmh
         /93Q==
X-Gm-Message-State: APjAAAWPkCQWU6tnXjFLOdZE7YjtEsDqVWbXf1voVHYGTbfBOkoPerzn
        n+hQq1UVK/ppVnGgr7dFq4mQWhpCMDmUVehatDYoqQ==
X-Google-Smtp-Source: APXvYqyoKPt2sRuOVs5Ee4m3vs18Mr40EkrrhLwu5WtKCYg4srR5SdNJrOEQ13JmYG5w9JIgf9kRW93t24Y6XRdKeBk=
X-Received: by 2002:a9d:191e:: with SMTP id j30mr12264213ota.297.1572943593688;
 Tue, 05 Nov 2019 00:46:33 -0800 (PST)
MIME-Version: 1.0
References: <1572922092-12323-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <1572922092-12323-2-git-send-email-yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <1572922092-12323-2-git-send-email-yoshihiro.shimoda.uh@renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 5 Nov 2019 09:46:22 +0100
Message-ID: <CAMuHMdXn2ua9G6OY-zd54EC12b07kd=cECbkfgUPAPEE7j_3fQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] Revert "PCI: rcar: Fix missing MACCTLR register
 setting in rcar_pcie_hw_init()"
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     Marek Vasut <marek.vasut+renesas@gmail.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 5, 2019 at 3:48 AM Yoshihiro Shimoda
<yoshihiro.shimoda.uh@renesas.com> wrote:
> This reverts commit 175cc093888ee74a17c4dd5f99ba9a6bc86de5be.
>
> The commit description/code don't follow the manual accurately,
> it's difficult to understand. So, this patch reverts the commit.
>
> Fixes: 175cc093888e ("PCI: rcar: Fix missing MACCTLR register setting in rcar_pcie_hw_init()"
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
