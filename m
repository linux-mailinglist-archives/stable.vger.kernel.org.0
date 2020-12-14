Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 795322DA40E
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 00:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgLNXTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 18:19:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgLNXTN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 18:19:13 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C55C061793;
        Mon, 14 Dec 2020 15:18:33 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id k65so3554501pgk.0;
        Mon, 14 Dec 2020 15:18:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cy5+nb3a0dSIGsiUUPc3iQidez+Phr48KktH/YxEMmQ=;
        b=hHQI60c9sE6WrPTmn8orRED8IkFXLZWkiX83UJ2ENIiyTiIJU3sGVOIGBmOV568SUO
         5o8F6TerM7xa7WsWeBIsoMDNpAxUWBKC8KrYx6GDFQoCz0sYuCO9yozK5mZ5YZYE3msc
         bDigUwaW8ry5XHclIaNzq64f5ORYjUogUm3Fmo7LAf/6klmGAw8LZa9VVhTruYx4Q7wn
         WtGPuD8yJWmZ/Ta3vvMiotVZFNOBQfuCnixBR3wRB0p5U8zf4dShbhV4FFJpuxO0PPcH
         BNJn+mPfhWOiNd1wcUIOlrh595NLrqo6cAj3qunAz60lte9MHxl64uzkfnPOJtglBIwQ
         2F5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cy5+nb3a0dSIGsiUUPc3iQidez+Phr48KktH/YxEMmQ=;
        b=SDIj7hvk1ERsUa0wUpgxOHjs+rjAaszHgs0FCFXsRqTrciQMe/Zfk0uai+nuVX/31H
         Gs5nO4Ybf3EqV5B/ShzlAXwj+u7H5TznIrmQ4lMmLr4znGoq/gpH9IEvg/d9sXrcDGnA
         nf63yoS+x1gXy/tTKY7GYRBlP4280ZkXcW7dZMc+8TzpCUbYqTlLAEAfO9Ck3UzvRRkO
         2xpiujIBxjjqZV3iGLkpLQN/MYz696rvY5i/PWjPN3O3NY+NVNZ3i0Ugj/ImVkhq0u4X
         AQLA2AvZ9VREBLHCaX/4aeZuJfcI/mBRf9i064QDdDjHk2LxZW9J2+UwDljX0wSigdRm
         7tYQ==
X-Gm-Message-State: AOAM530mwWrPCxhbA+0CaDPMDi9VZiWmh8HME61YeykZgW32iZI4qePa
        mjNb+EZAChGJyvyinU85Tr2s6/ORoomqow==
X-Google-Smtp-Source: ABdhPJzyHb8JB2CtR88j8zHWZrn1qMJhhcJzF5HIzVScHKsGXTvaRsNSOElZB/fa4z0LhaD0vzzl5w==
X-Received: by 2002:a63:1d59:: with SMTP id d25mr2636879pgm.259.1607987913173;
        Mon, 14 Dec 2020 15:18:33 -0800 (PST)
Received: from bubble.grove.modra.org (158.106.96.58.static.exetel.com.au. [58.96.106.158])
        by smtp.gmail.com with ESMTPSA id h4sm22508539pgp.8.2020.12.14.15.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 15:18:32 -0800 (PST)
Received: by bubble.grove.modra.org (Postfix, from userid 1000)
        id D755681792; Tue, 15 Dec 2020 09:48:27 +1030 (ACDT)
Date:   Tue, 15 Dec 2020 09:48:27 +1030
From:   Alan Modra <amodra@gmail.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        kernel-team <kernel-team@android.com>,
        Will Deacon <will@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Smith <Peter.Smith@arm.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        =?utf-8?B?RsSBbmctcnXDrCBTw7JuZw==?= <maskray@google.com>,
        Quentin Perret <qperret@google.com>
Subject: Re: [PATCH] arm64: link with -z norelro regardless of
 CONFIG_RELOCATABLE
Message-ID: <20201214231827.GG8873@bubble.grove.modra.org>
References: <20201016175339.2429280-1-ndesaulniers@google.com>
 <160319373854.2175971.17968938488121846972.b4-ty@kernel.org>
 <CAKwvOdnYcff_bcWZYkUC5qKso6EPRWrDgMAdn1KE1_YMCTy__A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdnYcff_bcWZYkUC5qKso6EPRWrDgMAdn1KE1_YMCTy__A@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 14, 2020 at 01:44:06PM -0800, Nick Desaulniers wrote:
> aarch64-linux-gnu-ld: warning: -z norelro ignored
> 
> So we set the emulation mode via -maarch64elf, and our preprocessed

The default linker emulation for an aarch64-linux ld.bfd is
-maarch64linux, the default for an aarch64-elf linker is
-maarch64elf.  They are not equivalent.  If you choose -maarch64elf
you get an emulation that doesn't support -z relro.

Now I don't know why the kernel uses -maarch64elf so you shouldn't
interpret my comment as a recommendation to use -maarch64linux
instead.  That may have other unwanted effects.

-- 
Alan Modra
Australia Development Lab, IBM
