Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9816C2681B8
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 00:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725960AbgIMWfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Sep 2020 18:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbgIMWe6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Sep 2020 18:34:58 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7948CC06174A;
        Sun, 13 Sep 2020 15:34:58 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id n133so15155257qkn.11;
        Sun, 13 Sep 2020 15:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gRT2lvKQ6w4yfe5SUHmT13C8VjhF2YaVCB4H7BehIqc=;
        b=Y4WebwZCYYsL9zVsJayi1Xok+CzD/EQ5oD+Wax+xLJfAyX4BjHsbIGDR1ut2ACWbw/
         eUHIhxuLnCiBG6TFwagB0zN2tzAgaPUVVA542JjdRq2sm8g73UYGf+POajH01Vj8xws/
         LWAFgzB06M2QdLhEDtD+gZKie79mF5aTIP+y8Lg48BeVXfW7kO5ByND+NX0xVDa652OM
         rzcwmpyTByi+Yjp6z6fXp9GgwOk2A3asu5TwsZpDg1KQP5x6tb7OGlrc6hiDw21qjhJG
         4dBzDexonqkS6w3YwGA/Hq68Wr0PeFpCbmJHO2A2WoGNezp2hvEv5MctwH6krdDSg7lI
         pKQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=gRT2lvKQ6w4yfe5SUHmT13C8VjhF2YaVCB4H7BehIqc=;
        b=PKspO+ziZN77DarlV+OVs0IRty7NDXeqGb0zA2qdVqCGkxx1oEBKqV7IJkOwGzP5H/
         UDNuOAuK4LaYWlqXhcCzermXk99RsAW0SOw7X3noyAe4zWMY2TEPJQXKwVYAYwI8X7WJ
         2nP6pIMDuUdh0rP9DABqv2JcJB0qsybTukFRM2zkz5vu9Pl6p5J5sqdZs/bpiI8CdTFS
         FPq86tdm061mE+Pnq0sHvGuxNLPOQiX1MaJPsqxfKPWm2vkZ7fMy9A+J0IGnVlGxRc8P
         hcTFQ44B9Qz1eH9RCPClVM9OxUWgp5NBaIBbQaoFz/3FRGZXeQJFognGQ2teytribpHZ
         HSWg==
X-Gm-Message-State: AOAM530O2x4u4rZPKt+ilGpBLNbBSaifgVSOuG6i9K//+VeE5CKsjIyK
        29rcXy2cYUbW9eSNtFm8U1c=
X-Google-Smtp-Source: ABdhPJwvtVPOQU3UvxKlqa1AMeivAERjRBvSz82AC9XKvcUkPA4LB0pnyhQbm3Wp4OZpAwm37N+U7Q==
X-Received: by 2002:a05:620a:815:: with SMTP id s21mr10073585qks.0.1600036497627;
        Sun, 13 Sep 2020 15:34:57 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id p20sm12931803qtk.21.2020.09.13.15.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2020 15:34:57 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Sun, 13 Sep 2020 18:34:55 -0400
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fangrui Song <maskray@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        e5ten.arch@gmail.com,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH v2] x86/boot/compressed: Disable relocation relaxation
Message-ID: <20200913223455.GA349140@rani.riverdale.lan>
References: <20200812004158.GA1447296@rani.riverdale.lan>
 <20200812004308.1448603-1-nivedita@alum.mit.edu>
 <CA+icZUVdTT1Vz8ACckj-SQyKi+HxJyttM52s6HUtCDLFCKbFgQ@mail.gmail.com>
 <CAKwvOdmHxsLzou=6WN698LOGq9ahWUmztAHfUYYAUcgpH1FGRA@mail.gmail.com>
 <20200825145652.GA780995@rani.riverdale.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200825145652.GA780995@rani.riverdale.lan>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 25, 2020 at 10:56:52AM -0400, Arvind Sankar wrote:
> On Sat, Aug 15, 2020 at 01:56:49PM -0700, Nick Desaulniers wrote:
> > Hi Ingo,
> > I saw you picked up Arvind's other series into x86/boot.  Would you
> > mind please including this, as well?  Our CI is quite red for x86...
> > 
> > EOM
> > 
> 
> Hi Ingo, while this patch is unnecessary after the series in
> tip/x86/boot, it is still needed for 5.9 and older. Would you be able to
> send it in for the next -rc? It shouldn't hurt the tip/x86/boot series,
> and we can add a revert on top of that later.
> 
> Thanks.

Ping.

https://lore.kernel.org/lkml/20200812004308.1448603-1-nivedita@alum.mit.edu/
