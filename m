Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B7525DD2B
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 17:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730823AbgIDPXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 11:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730249AbgIDPXc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Sep 2020 11:23:32 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA421C061244;
        Fri,  4 Sep 2020 08:23:31 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id h1so3164019qvo.9;
        Fri, 04 Sep 2020 08:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V2LPJ4nXa+V+etvxBl1uYInuURWvbjbvsWUWYcsfsKg=;
        b=uXPuB5ROJAilRuY7DtE5FbCufPo+Ir9wLFSkfIT1p88kDeQ91hXOQ7SD0w2pehwr9c
         jKCNB9CndBmIjR1FrWqFXVy4dkxJS9eYLFwiBmMOEcR18/BxS9vkrj3BvseNAC9QJmvC
         HHvFpTK79JTeRUoeqD8ot2/vVCNX/pI87O2L1xpeyOqI7Dg9zIrPbCiPeIJX7XiVeaY8
         eP2aHW9DrRdzzg/Z1T2lO/vW0J0ipHvbAfybysfafMwsvezL21Fk/avM0B3XqvVtoA/n
         lJhfeh+r5NaRBfu4Jj6phd6uaV/oo6NJplS16sJ/l05VJLneUe/3SVH9mWzOwP/qadaj
         nyZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=V2LPJ4nXa+V+etvxBl1uYInuURWvbjbvsWUWYcsfsKg=;
        b=G4fc32/AFd59xbcyubjTQTOcl1oqvxKdU7mqcIlScteNerMuoqdZ6beLY5WMvH7c56
         1HdsoEhjy52RkuQ+7U+w618fDAklLU/K1DsRjxeNQ6o+BnzHSh6jP4G54BHNcskZqSIp
         pbeFSL4XJoQaH/boRJW1j1JO7WJP+JYSNFpz9WEVTXPpW9BIUw9Ed3BFTOYokWiel1jD
         M9UgBifJzbXz7bZ0g7BaCLAFvN3Ir3N73OrKQQKvEMKsjNIFmep4lF4Gf2eJDrxKEmKS
         +BGnKkG5AAd1sp/A6jns3F0i+WetKq8HIDIqbmQUPWPxzUFbA++qGmgcXmCcAlPe+Ihm
         haFQ==
X-Gm-Message-State: AOAM5304x7ZUF+s+VcIYMe/hMuH8sTMst3kgC0o+NEAZlNbbIE1J+phU
        0x0OT7rBJ06G26NuwrJMpCE=
X-Google-Smtp-Source: ABdhPJye1LWDm7F7cHcliTVZgXsLS3iUn6oVzvp0ntSZOVLs0dmA2fuyvHZccWndztw9TWEP64qytg==
X-Received: by 2002:a0c:8d4a:: with SMTP id s10mr8482213qvb.34.1599233010961;
        Fri, 04 Sep 2020 08:23:30 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id f7sm4620078qkj.32.2020.09.04.08.23.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 08:23:30 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Fri, 4 Sep 2020 11:23:28 -0400
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
Message-ID: <20200904152328.GA205145@rani.riverdale.lan>
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

Thanks.
