Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F05A48874F
	for <lists+stable@lfdr.de>; Sun,  9 Jan 2022 02:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbiAIBov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jan 2022 20:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231803AbiAIBov (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Jan 2022 20:44:51 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1976AC06173F
        for <stable@vger.kernel.org>; Sat,  8 Jan 2022 17:44:51 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id z9so38225704edm.10
        for <stable@vger.kernel.org>; Sat, 08 Jan 2022 17:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GRwdR/q5hbUJ/kXrfX2wLNdfFsutuIv+5DRJD5If5J0=;
        b=a6VHBzMjwXJjOXH4ctqGpJ/+bKaB0uKfJ1S9wG+WZ+na8tsTV2+++72yGbw4GshStD
         p10Kdth8RPqVrJVI8k/K6lGmqeYHlO3TahxUwRNDjWizJJVGcANGuQsppXy2HUsPyfjS
         /G5AepP2yWPXWCopEpCzcA0CPtYPGtdENvWgg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GRwdR/q5hbUJ/kXrfX2wLNdfFsutuIv+5DRJD5If5J0=;
        b=KHAuKoBsHiKWAtgBl9hQa65bgPKmmrd8f3n+1sqSLYDKViDfkMlgWUvnvIfCi6YOtB
         OT8mxIuMLcKeuHO+yDMnF166xO6U93fhPpOHZwLcNTe9hhmFf0kAcOfpgcZqf+rXh5+m
         016pUFjohEeiTVukWlyw9GnDIqIsA9/j7WaP585jSom7iaIEYkAFTxWx+8mD37jjBJ3n
         nDV2ghW2yUsr0z8jgyXUHHhKwA/kBPhnlJ1zSyLsKIUkhoEIlX10gTn3KkFpN1UEAXa3
         AnQBpFQOcuk2/TDTbct89XiXlSiQ+T+IXX863pUp/4iJ6fJaq3Bk0pk8Wo0BcdoitpQd
         yUIA==
X-Gm-Message-State: AOAM5302cUKFllpWYu2nDCmWbnVbhHBbkJ2NvUKXcuQTzEYdyd8/qVzG
        nImOCr5CKYNSPrLYQr5Z08RMoT9pJ1Z71psZJdo=
X-Google-Smtp-Source: ABdhPJw6O/nlVGkKD0j17JDA7nsERcehe58Ulh61mErAqq2tGEBefPHPq42lpm0s5HGHV0l9qathUA==
X-Received: by 2002:a17:906:c14e:: with SMTP id dp14mr5098063ejc.138.1641692689363;
        Sat, 08 Jan 2022 17:44:49 -0800 (PST)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com. [209.85.128.45])
        by smtp.gmail.com with ESMTPSA id l18sm960639ejf.7.2022.01.08.17.44.48
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Jan 2022 17:44:48 -0800 (PST)
Received: by mail-wm1-f45.google.com with SMTP id l12-20020a7bc34c000000b003467c58cbdfso7166817wmj.2
        for <stable@vger.kernel.org>; Sat, 08 Jan 2022 17:44:48 -0800 (PST)
X-Received: by 2002:a7b:c92a:: with SMTP id h10mr16299982wml.26.1641692688604;
 Sat, 08 Jan 2022 17:44:48 -0800 (PST)
MIME-Version: 1.0
References: <48f73946e0f8af29ef8fd1aec1a7bed5@ercanersoy.net>
In-Reply-To: <48f73946e0f8af29ef8fd1aec1a7bed5@ercanersoy.net>
From:   Linus Torvalds <torvalds@linuxfoundation.org>
Date:   Sat, 8 Jan 2022 17:44:32 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgPMi9e9yi2rQyeSmDF8XdZgdRKak545LzMGBjFqSbHxQ@mail.gmail.com>
Message-ID: <CAHk-=wgPMi9e9yi2rQyeSmDF8XdZgdRKak545LzMGBjFqSbHxQ@mail.gmail.com>
Subject: Re: Re: [PATCH 1/1] Fix uninitialiazed variable bug
To:     Ercan Ersoy <ercanersoy@ercanersoy.net>
Cc:     Security Officers <security@kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 8, 2022 at 5:15 PM Ercan Ersoy <ercanersoy@ercanersoy.net> wrote:
>
> I'm using cppcheck 2.3.

Hmm. I don't see any warnings on Fedora with cppcheck-2.6.

So maybe the problem has already been fixed in newer versions of
cppcheck. Or maybe it's some other config difference here...

                  Linus
