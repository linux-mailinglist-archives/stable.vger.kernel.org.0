Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5C035A8A7
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 00:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234654AbhDIWPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 18:15:15 -0400
Received: from mail.zx2c4.com ([104.131.123.232]:52004 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234517AbhDIWPP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 18:15:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1618006496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UASekFbVhQj5MYvWTJ3Pb9W7iYXFe8RQLalyImAe1zE=;
        b=ZUdMEW9IzGwdnwc4qtASbp1hQHuGe9OB3hTR50Gq61PjoS9KKHLhUAXT4sWKDko68g4fGo
        tJcaW25sKcQB5nPT/25OFn9wr9TWeXt9buxnxuIhd7PcdypVBRRQQXVSysUV1I3Tm91lK5
        qPaiWvKaa4wkkikWnnm2AglqBH4qLao=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 080918ed (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 9 Apr 2021 22:14:56 +0000 (UTC)
Received: by mail-yb1-f170.google.com with SMTP id g38so8185638ybi.12;
        Fri, 09 Apr 2021 15:14:55 -0700 (PDT)
X-Gm-Message-State: AOAM532gNqM6ijjgivA6J9Y8l8/VjrUCRNmAlAxKLr5d7GUdggpfVeD1
        TvSKybCEWl38iXNCSls+llv1I3q3nv4RYR4zAiY=
X-Google-Smtp-Source: ABdhPJxTGz5VnzVclm7kInmXeFjGoBq+fXJaQfGzxNC0FZkkiyxe81tTTrrCAKrChon8v1JflKVgYgqAYnHt0+jpuLg=
X-Received: by 2002:a25:a3e3:: with SMTP id e90mr19023469ybi.279.1618006495224;
 Fri, 09 Apr 2021 15:14:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210409221155.1113205-1-nathan@kernel.org>
In-Reply-To: <20210409221155.1113205-1-nathan@kernel.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 9 Apr 2021 16:14:44 -0600
X-Gmail-Original-Message-ID: <CAHmME9raNqAftSHuJZ1VE0Xp=yGfuVN+i1j2tCAEDSynsgqy7w@mail.gmail.com>
Message-ID: <CAHmME9raNqAftSHuJZ1VE0Xp=yGfuVN+i1j2tCAEDSynsgqy7w@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm/curve25519 - Move '.fpu' after '.arch'
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Jessica Clarke <jrtc27@jrtc27.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Seems reasonable to me.

Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>
