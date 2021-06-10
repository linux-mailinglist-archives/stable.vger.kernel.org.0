Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E653A33D8
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 21:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhFJTUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 15:20:45 -0400
Received: from mail-lj1-f180.google.com ([209.85.208.180]:43818 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbhFJTUm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Jun 2021 15:20:42 -0400
Received: by mail-lj1-f180.google.com with SMTP id r14so6375265ljd.10
        for <stable@vger.kernel.org>; Thu, 10 Jun 2021 12:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aPTyDJh/FqkPC7Of53mXpiFCJnipzLbSqzQI1i7wKkI=;
        b=TUj4T7lxOrr9qEMnqhOCizt9ERRD5MAMSJj4cRHm63u6EGu7ChB1eCYd47d9FGqLjl
         MOihAMN8+mkGyhbSMPPVPDLPhmgFLcrgkk0cvoUHj0jRjdnHTebtipEYIex8b3kM5mMt
         PtdSABebDp9MCpQZlU8cKNz6UtSbPye0n/YnXiuaQuWs3ddzen6tBSUdXVynKiAspwCC
         bbVgih8HOQ3zDntPyaqW6eVgl/+rmF0ke3FeRfBsiL/2kk9Y+xccCkG0wFK/l3AsSmIo
         TfUBeyGpKUg8tEVDF7/RZYFVjKsIfMe3RyLKBb0bNxKemosihwVxfQtlke7lmpoPynCY
         ef2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aPTyDJh/FqkPC7Of53mXpiFCJnipzLbSqzQI1i7wKkI=;
        b=TZvBNKeDhyCakEOFyD7rXcEal+YbvwxDU6cWb5jO3R28cJvDAdVbJUPk+667hBQGGb
         RhSJKY5XVYxmVeZKLva97VgPeSbnrt2yI8OpdWuO8ZucIhuYOfaJDrzj3aIBMBtsvC+N
         xXLcRWPvxZbcm6qo6X1Kbr6PYqFvW2XXIazaDWeGXgxIQ6cu2wNFZXcCNCwb0FeU5PxP
         0p3gljbVEbeysUTyhD46am2ZfYb3lLuRywNw4RNwi4X29xmF11VVEItxZ4Q0AWHHtcg/
         jWdI26trbdh5DgJ5RQihWWYio+AkIZDk29bX36EMKFT0cLGLFO+n903yLepkvW3QWAYr
         KjEA==
X-Gm-Message-State: AOAM533KbAuG6H/+V99EYb5jy1eHu6q6vcJ1WWG/+HMlwK8LBRrHi/bF
        oCFy/xILpV80k7aumBOOqE91RuLjwusTAWQr3BxOzg==
X-Google-Smtp-Source: ABdhPJzcPa3ZWjUiuCZT9vcsG+t+BaG7ZWNzmhAnb13V0AEQb0YClVnreY/gDLAzgWo+WTX2EkalWOi815F5nddmsls=
X-Received: by 2002:a2e:3c06:: with SMTP id j6mr68159lja.495.1623352651424;
 Thu, 10 Jun 2021 12:17:31 -0700 (PDT)
MIME-Version: 1.0
References: <214134496.67043.1623317284090@office.mailbox.org>
 <ea01f4cb-3e65-0b79-ae93-ba0957e076fc@kernel.org> <ba06e4f5-709a-08cc-0f62-e50c64fc301f@mailbox.org>
In-Reply-To: <ba06e4f5-709a-08cc-0f62-e50c64fc301f@mailbox.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 10 Jun 2021 12:17:20 -0700
Message-ID: <CAKwvOdkpce5kjqXg_Gr8LAzqh3pZt+uJUn348wk2nESvfjB5JA@mail.gmail.com>
Subject: Re: [PATCH] x86/Makefile: make -stack-alignment conditional on LLD < 13.0.0
To:     Tor Vic <torvic9@mailbox.org>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>,
        "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 10, 2021 at 11:39 AM Tor Vic <torvic9@mailbox.org> wrote:
>
> Hi Nathan,
>
> On 10.06.21 16:42, Nathan Chancellor wrote:
> > As Greg's auto-response points out, there needs to be an actual
> >
> > Cc: stable@vger.kernel.org
> >
> > here in the patch, rather than just cc'ing stable@vger.kernel.org
> > through email.
> >
>
> Yes I misinterpreted this in the sense of "put stable mail in CC".
> So if I get this right, I should NOT put stable email in CC, but only
> add the "Cc: stable@vger.kernel.org" tag above the "Signed-off-by"?

Yep, just above the Link: tags would be perfect. Don't worry, you'll
get the hang of it.
-- 
Thanks,
~Nick Desaulniers
