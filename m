Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B74E1DFA9D
	for <lists+stable@lfdr.de>; Sat, 23 May 2020 21:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbgEWTKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 May 2020 15:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726790AbgEWTKr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 May 2020 15:10:47 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CBBAC061A0E
        for <stable@vger.kernel.org>; Sat, 23 May 2020 12:10:47 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id z13so6905266ljn.7
        for <stable@vger.kernel.org>; Sat, 23 May 2020 12:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bPVlPhew8dfbVslQICn0yPbyyO1M5AJGUTcDYlXCCuQ=;
        b=PmcDHo5TDVjmactGyJauJx2vquRisjETelm5YCAZsL/PWW/8gtghY4b8iacXkMIe3k
         bl22kofKBJdtVoo2sxyq93gkdH28uokIlIRHNTJqVCv9IeaRpHWkrHAC3q5CSb7HG9s8
         3HrXSr+5qMPzvhbU5HVJbVr3oygsjBkVcbPQE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bPVlPhew8dfbVslQICn0yPbyyO1M5AJGUTcDYlXCCuQ=;
        b=F1fkBnf3fgHyMj1s4wOjNxrx6X/23Sq+TCKkXNS4Ci/Oe6F/3idZXaV9ClTv+z15uq
         B/OcaVVcXkCwbaoe1ska8Ess0QSTRkKoHVT36DrGze8fRzH15uadz/rAX7nDPyrdBaEJ
         0vYY2qku4dbO7Rr87ZVhLFnkVc2ZUn8zy2ysQa6q6wPw6x4xH635R0RduX5RNOVK7YFZ
         OF3J9BGPtW6ZvbPTfrMCG/J9lJUbXW4pbmh8ylYpBZGParNLfqR68PMVR0ksl4Mig0oR
         x2mqbUfUedbHE0eIAj78pyx7RdKKkig3pC6cCHD3OLTNeRnU8f+/yRoMtPFU187P6AGf
         OV8g==
X-Gm-Message-State: AOAM531SBa17hr84AdyVc1hfJIh831CvHoTEQp+rYWsqCwlVqDbBLyMb
        9Tp4vZkkqTjrI/b+Azy8SyS0XyQVB8Q=
X-Google-Smtp-Source: ABdhPJxAtBCgd+ywTgpuJM0o7UOJ9ka8g8rcHkWtrkoBvxuOvWp3Tux2p2DBKDrAt4hOC3d9+tfhdA==
X-Received: by 2002:a2e:87d2:: with SMTP id v18mr10841366ljj.121.1590261045246;
        Sat, 23 May 2020 12:10:45 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id p23sm2601776ljh.117.2020.05.23.12.10.43
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 May 2020 12:10:44 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id z13so6905222ljn.7
        for <stable@vger.kernel.org>; Sat, 23 May 2020 12:10:43 -0700 (PDT)
X-Received: by 2002:a2e:150f:: with SMTP id s15mr10043967ljd.102.1590261043584;
 Sat, 23 May 2020 12:10:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
 <20200523052309.4caVN81-C%akpm@linux-foundation.org> <20200523190145.GX1059226@linux.ibm.com>
In-Reply-To: <20200523190145.GX1059226@linux.ibm.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 23 May 2020 12:10:27 -0700
X-Gmail-Original-Message-ID: <CAHk-=wisORTa7QVPnFqNw9pFs62UiwgsD4C4d=MtYy1o4JPyGQ@mail.gmail.com>
Message-ID: <CAHk-=wisORTa7QVPnFqNw9pFs62UiwgsD4C4d=MtYy1o4JPyGQ@mail.gmail.com>
Subject: Re: [patch 09/11] sparc32: use PUD rather than PGD to get PMD in srmmu_nocache_init()
To:     Mike Rapoport <rppt@linux.ibm.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Linux-MM <linux-mm@kvack.org>, kernel test robot <lkp@intel.com>,
        Anatoly Pugachev <matorola@gmail.com>,
        mm-commits@vger.kernel.org, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 23, 2020 at 12:02 PM Mike Rapoport <rppt@linux.ibm.com> wrote:
>
> Unfortunately, this fixes a compile warning but breaks the boot :(

Argh. I delayed applying/merging this overnight to see if there were
any reports, but this came in after I'd already merged Andrew's
patches and pushed them out.

So it's in my tree now as commit c2bc26f7ca1f ("sparc32: use PUD
rather than PGD to get PMD in srmmu_nocache_init()")

> The correcteted patch is below, boot tested with qemu-systems-sparc.

Mind sending a patch relative to the previous one that already got merged?

Also, would it perhaps be worth it to just make __nocache_fix() not
throw the type away? IOW, make it do something like

  #define __nocache_fix(VADDR) \
        ((__typeof__(VADDR))__va(__nocache_pa(VADDR)))

or whatever? Wouldn't that show when those pgd/p4d/pud pointers get
mis-used because they don't end up dropping the type info..

              Linus
