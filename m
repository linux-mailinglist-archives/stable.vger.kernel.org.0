Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5D2345CC
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 13:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbfFDLqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 07:46:33 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42266 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727433AbfFDLqd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 07:46:33 -0400
Received: by mail-wr1-f67.google.com with SMTP id o12so8353163wrj.9
        for <stable@vger.kernel.org>; Tue, 04 Jun 2019 04:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to:cc;
        bh=YOjdYwR7sHqhYE5bIaMWfTHA7B/onkn4M3zU+Ab8ggc=;
        b=ReQ8rlSHEn4ng8iZhBZvUpur3LBv+t8ja/hPfMRdjB+Zo1HDnT2Xbc1zwL3oePRRLa
         hgqQ4zUu0hI84jR6wV/w7f+HWTKaUd73UlcGDjwITS/Vud/5l12IhpE2aVjKcg4aSX0i
         /UkXsAOh/ZjIEL8iRf2oWBdUH8Dn1g8+PriacjDlW+UvzN5wCa2YYTJqbAGkYQWHQwBt
         hqgVdA+r8Ih1hHolLEkcnwYE2F2vkEx6BSohqBMeXh7fFvR4Po5SsDhFXGire72lvIpL
         fNDHbdKh9biasESxRhq7qF1h7tnscAkkiEPmNXh/9TTSgChulAa4SiOFM1soRkDbB8ke
         DRog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:cc;
        bh=YOjdYwR7sHqhYE5bIaMWfTHA7B/onkn4M3zU+Ab8ggc=;
        b=LB9BdVn/etQhO94m5kZJE7ISiHP2Yz7ZDqAdgsOF0wbxEDDCbwpuIt93lIbrZg1tsC
         c7quJ2wUEvYpcw6AYSVf4PMkCY5hl/ModCYsKSbmyH/2H7tIk5UJsHG+xNCe9Qs21DrW
         eTOG228wYd3+00Ox/oy0iysCvSM4rX0mJV3BCGm+fd9Lfeq1Jlx8w2rhwtQ5g4Tr/4xk
         VM7B2iUnn0wEx8nGZwnbvzOjI071MB1HH+Z7sZuNIX6JJRcm53VmMYiP3n272CeHBU7j
         RbAzQ92hLBsJT/cd5Ywapcp9yRxKGVOGl6j3B2EY5HONLojSmrITylvRkK2Hf7Ja9XhY
         diBw==
X-Gm-Message-State: APjAAAWI7c/242vqR2OTpwm0NdekZvnrK9RM7hxTqvC98TQs56d60o4X
        9qWyXQeG5rgsHrqVvXl5ybTcFbbVOkPGtnCBE28=
X-Google-Smtp-Source: APXvYqzyniBjBrTNVLn9Vcc4isjPlRRivzfw0HJnc1QB+FxI7XoUU+A9kE+49QaG2Z1viQ6JOvZw28YAtZGfRiqv3EE=
X-Received: by 2002:adf:e9cc:: with SMTP id l12mr6551045wrn.29.1559648791435;
 Tue, 04 Jun 2019 04:46:31 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Tue, 4 Jun 2019 13:46:20 +0200
Message-ID: <CA+icZUXaXhvm46tA2aHO=85Lv16Y4=DOnz7OBRyfztp=i0_a5Q@mail.gmail.com>
Subject: Re: [v5] x86/mm/KASLR: Fix the size of vmemmap section
To:     Baoquan He <bhe@redhat.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ CC me I am not subscribed to linux-stable ML ]
[ CC Greg and Sasha ]

Hi Baoquan,

that should be s/Fiexes/Fixes for the "Fixes tag".

OLD: Fiexes: eedb92abb9bb ("x86/mm: Make virtual memory layout dynamic
for CONFIG_X86_5LEVEL=y")
NEW: Fixes: eedb92abb9bb ("x86/mm: Make virtual memory layout dynamic
for CONFIG_X86_5LEVEL=y")

Also, you can add...

Cc: stable@vger.kernel.org # v4.19+

...to catch the below.

[ QUOTE ]
You can see that it was added in kernel 4.17-rc1, as above. Can we just
apply this patch to stable trees after 4.17?

>
> v5.1.4: Build OK!
> v5.0.18: Build OK!
> v4.19.45: Build OK!
[ /QUOTE ]

I had an early patchset of you tested (which included this one IIRC),
so feel free to add my...

   Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

Hope this lands in tip or linux-stable Git.

Thanks.

Regards,
- Sedat -

[1] https://lore.kernel.org/patchwork/patch/1077557/
