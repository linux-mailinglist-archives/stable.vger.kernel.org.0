Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984C52A8987
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 23:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732414AbgKEWHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 17:07:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732295AbgKEWHk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 17:07:40 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A7A9C0613CF
        for <stable@vger.kernel.org>; Thu,  5 Nov 2020 14:07:40 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id i26so2319708pgl.5
        for <stable@vger.kernel.org>; Thu, 05 Nov 2020 14:07:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F1tdU0iwEt5U3ppZ6QF+sxIWHxGyMRLX1KSyIl5H+7c=;
        b=E+zXExFkDfVmGinOt8VDqlwA0EfPbDTb0NTmsUNl69HvU7WIbJrljijQi8PYt9iKz6
         Ad+2uM0tlAVliGn3kDzGRw7vms3IGD3K1CNtj2yMO9WAX36Eut1UMGgKoFlT83S2gAEq
         W7DO2kJ1S1FnwlCYV3nN39pxs9rvkzVQ8t6dti5tN+smLjp78ubJy5/WhpPlfuXtWSKD
         BAqdMUtZxpoOQ6jKN1N46cAA1LVAg4PGoEHzDbdLfCxyTQz8BduL4xArlji+JBS3AAMc
         8K6YEYaBycokAUDrrAX+BOtJT8UVBapdARs+LOGaZIhl9wl+uunmvXkgKGk4Ivkg13of
         8NEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F1tdU0iwEt5U3ppZ6QF+sxIWHxGyMRLX1KSyIl5H+7c=;
        b=ATekp2cCOICKIluRw6AxZG2Mb1aMEZXE46BixDcMA70bWZm0X6Cy20b5ukuz2yNd8d
         Jd0fu89h583USbBxBAsnxoyI9BXqbXIehjrX1d6QAamFfoG4zbctC87IYJ20S237so2V
         fw6AsWMIZDpPE8wo/VhWD/QsVI1HzLVU69lxmD55AGkCZ/OC0nIMufuKBx2P1GIbLjxE
         pLqo/7zGGIEwHvu9nMQGbFokcB2CQYKeHXOPkU5ooZAHoeJu6YcNs3oSe89xbvEMHSlf
         1Vk8DmfOu1K0UBCsyN0wtGj2eBRtyxsMUn2TlfdRtSqdlUVdg7ZjDH7x+IOB4lN9TRil
         pyzg==
X-Gm-Message-State: AOAM532ZuPiUagdMRSpbob/jgYAs8Ylyxvv4Fflw5HloIs5jYvNDXqEB
        mRAaHUVHesYK8ohF8cDGMAInD9KXJ/qcZYwJca3caQ==
X-Google-Smtp-Source: ABdhPJyo7ToAv1S6l6D26TlrBY+eJ24kdm4+HA9qAi0JlaxUfzi8Nwp13XzTPT8urE+aLSz502+6V0UkSxfj1Tpsqgs=
X-Received: by 2002:a17:90b:110b:: with SMTP id gi11mr4335085pjb.25.1604614059556;
 Thu, 05 Nov 2020 14:07:39 -0800 (PST)
MIME-Version: 1.0
References: <CA+SOCLJMyUZ8c0e5xkvm+r0pMxBoUxmQRaoasKOS2T28Z10Ziw@mail.gmail.com>
 <20201105215226.GC2123793@kroah.com>
In-Reply-To: <20201105215226.GC2123793@kroah.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 5 Nov 2020 14:07:28 -0800
Message-ID: <CAKwvOdkKcKru44CPmPiT9_5ACWiz50Gi12yKTR=pq4MeSPGvGg@mail.gmail.com>
Subject: Re: Patches for building kernel 5.4 with LLVM's integrated assembler
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jian Cai <jiancai@google.com>, "# 3.4.x" <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Fangrui Song <maskray@google.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dmitry Golovin <dima@golovin.in>, Borislav Petkov <bp@suse.de>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Nathan Chancellor <natechancellor@gmail.com>, mbenes@suse.cz,
        Manoj Gupta <manojgupta@google.com>,
        Luis Lozano <llozano@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 5, 2020 at 1:51 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Nov 03, 2020 at 02:51:32PM -0800, Jian Cai wrote:
> > Dear Stable kernel maintainers,
> >
> > Please consider cherry picking the following commits (ordered by commit
> > time) ino linux-5.4.y.
> >
> > ffedeeb780dc linkage: Introduce new macros for assembler symbols
> >
> > 35e61c77ef38 arm64: asm: Add new-style position independent function
> > annotations
> >
> > 3ac0f4526dfb arm64: lib: Use modern annotations for assembly functions
> >
> > ec9d78070de9 arm64: Change .weak to SYM_FUNC_START_WEAK_PI for
> > arch/arm64/lib/mem*.S
> >
> > The first three are required to apply the last patch. This would unblock
> > Chrome OS to build with LLVM's integrated assembler (Please see
> > http://crbug.com/1143847 for details).
>
> I've done this, but does this also provide this functionality for x86?

We're in the process of fixing this for x86 and 32b ARM.  The aarch64
patch made it to mainline the fastest.  Patches have been
posted+reviewed for the other two, just not merged up yet.
-- 
Thanks,
~Nick Desaulniers
