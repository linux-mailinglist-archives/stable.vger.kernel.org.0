Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E17251B8B
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 16:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgHYO5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 10:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbgHYO45 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 10:56:57 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7B4C061574;
        Tue, 25 Aug 2020 07:56:57 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id p36so5744732qtd.12;
        Tue, 25 Aug 2020 07:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=z9DSDteeZJv4hk8JXSzJvId3t2KMGCEta9aR2INYf9c=;
        b=jzKWZK9+iabHZTy/+oByBf/DB0UO3kEcJXtCWBGaAxH/7S7QXX2LcYlMPLnHJhQ7ng
         NTadvJ4po0Y1wD6x/+gS0hyH5/vOGl+/zyPTzc4kbkP6GPxrhYqPsyurjLYb17hJLn+M
         hh7aA8JofwjIArmW9BCLgwO32iEu99xoMoi+XAR/N3vCHdwQgUtea1hi78RV63YcsNJX
         U3Ioc8lL24csAcqwNw+dBZVxk4EYshOOYC0PjskDjeADV+hioBcpiaM242FrmDCRYOZJ
         NlXIun761uUxViNEhwbp3KaJRhXJphnD4GQTrqxH63ZWtvUqJLJ3iXopsWFLhqqX+vGi
         mSAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=z9DSDteeZJv4hk8JXSzJvId3t2KMGCEta9aR2INYf9c=;
        b=kFKhjGla9KhUl1dIpoWuwqnYdH958xIRidKXrwdh239ssedVrh0mhUzAjBLBSjKrOj
         5brhMifJZrX9oJ0480tH6R1KKh5HW3U76AusvPpXuVQVRx85B6/Jv+CYRDxtYF2E4w3k
         5YyHaZOB97EmoJ/zLI/Ljrp6LIDjkK9vSIpNirIABss5BrI4KyQQ1V+3fwVAtxmlx4v7
         t3ebLU3MLLTsLXLpqeUWjAUZQTeLnG0D+sCB/5Dxf7um2GLbu8ZQJaazf+uh4oOfnwat
         08QmJ8e27V+VlJIkTLuqokeW8lDFxrkRKB4d8Ap3QagSNBxpGj1tNuyp3xGpOeLvuWqC
         o8Og==
X-Gm-Message-State: AOAM531Pu0cTphYQW+ZoFRtz3D+l2iO8+04s0F4IEMQIliMODqHXHYIR
        USmtgemkmErzuVN7qTjE+0M=
X-Google-Smtp-Source: ABdhPJwLmRxnnwai3QxV7g/Rp6NzPdtViYVJhBQu9ofEHqp5BrW0C4RxbaArqA6NSw7Sp5WU5zGZLw==
X-Received: by 2002:aed:3728:: with SMTP id i37mr9734610qtb.347.1598367415092;
        Tue, 25 Aug 2020 07:56:55 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id n128sm12140750qke.8.2020.08.25.07.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 07:56:54 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Tue, 25 Aug 2020 10:56:52 -0400
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arvind Sankar <nivedita@alum.mit.edu>,
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
Message-ID: <20200825145652.GA780995@rani.riverdale.lan>
References: <20200812004158.GA1447296@rani.riverdale.lan>
 <20200812004308.1448603-1-nivedita@alum.mit.edu>
 <CA+icZUVdTT1Vz8ACckj-SQyKi+HxJyttM52s6HUtCDLFCKbFgQ@mail.gmail.com>
 <CAKwvOdmHxsLzou=6WN698LOGq9ahWUmztAHfUYYAUcgpH1FGRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKwvOdmHxsLzou=6WN698LOGq9ahWUmztAHfUYYAUcgpH1FGRA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 15, 2020 at 01:56:49PM -0700, Nick Desaulniers wrote:
> Hi Ingo,
> I saw you picked up Arvind's other series into x86/boot.  Would you
> mind please including this, as well?  Our CI is quite red for x86...
> 
> EOM
> 

Hi Ingo, while this patch is unnecessary after the series in
tip/x86/boot, it is still needed for 5.9 and older. Would you be able to
send it in for the next -rc? It shouldn't hurt the tip/x86/boot series,
and we can add a revert on top of that later.

Thanks.
