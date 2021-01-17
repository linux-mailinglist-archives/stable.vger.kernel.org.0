Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB412F951F
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 21:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729485AbhAQU3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 15:29:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729386AbhAQU3F (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 15:29:05 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CFD6C061573
        for <stable@vger.kernel.org>; Sun, 17 Jan 2021 12:28:25 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id n11so16145258lji.5
        for <stable@vger.kernel.org>; Sun, 17 Jan 2021 12:28:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=bdlDZ5HCqqG29aLBSd5XOL3zXvPRTuCQNFUkqtWA3iY=;
        b=Ks03LzNM0wfNIt4nxfavwIDe3pBuANkgtAH6uwEk8fJYbE8pHJbAESUka+k6zvSH9s
         Ratv3StGBAcCrSglYNVsdF3OqFAFvsMFUJoyLT2wy6kYhB/bHAjdwSRPlVOOm+Jscvqr
         svaiQAi5Ps89UXExpAR6whpB1IvUpg+zrmWV8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=bdlDZ5HCqqG29aLBSd5XOL3zXvPRTuCQNFUkqtWA3iY=;
        b=llXddDe0iS78Fgw8HbPVJanxIuYXxoSWeLEIvhjvZ6YweDSyYf8zck1UfIUGRw3Um5
         U+s6++a3XvWhAvDPwQ1J3pF4tx3EwBTnH/5xpHUIj5b6Ybzrvp0JvrsJpIPnVwipILxi
         xcD6doeHIQGlZQCvFoN4Ryncv2KS9C55ANh6+b0WPgF6yw0lvzyLiBWZROjGlLETGqVs
         aAnx2ZTjHQ7j8UOCXQ2il6yJ8bk2aXywIsAWyBMGZ30z1KP7FJcijt1SD/9CdAHe4nqG
         wW7JNjDGfVcZ+BBQPwW108imuXvmqLkdn8B1tNswvS719ADdLlw+FBYlcG+XaQSULFkr
         SE3w==
X-Gm-Message-State: AOAM530kJoCsT22hxtU5InH+5kETf/yCGmDtykgNhanaGLi0YUSPtamA
        NIomuDObbvLJX1i3RCHlF7Uscr/134Gpcg==
X-Google-Smtp-Source: ABdhPJwt9tM0pqLXrLiySElFVCB/I+erhCmeklgoh1EKLbbRMVH58e1T5KTIxAoxAcvj+UH5H6p55Q==
X-Received: by 2002:a2e:2244:: with SMTP id i65mr9456082lji.111.1610915303530;
        Sun, 17 Jan 2021 12:28:23 -0800 (PST)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id o11sm1660625lfi.267.2021.01.17.12.28.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jan 2021 12:28:22 -0800 (PST)
Received: by mail-lj1-f174.google.com with SMTP id p13so16163294ljg.2
        for <stable@vger.kernel.org>; Sun, 17 Jan 2021 12:28:22 -0800 (PST)
X-Received: by 2002:a2e:3211:: with SMTP id y17mr8884724ljy.61.1610915302316;
 Sun, 17 Jan 2021 12:28:22 -0800 (PST)
MIME-Version: 1.0
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 17 Jan 2021 12:28:06 -0800
X-Gmail-Original-Message-ID: <CAHk-=whCEy=fVcCZ+s6JABgKGrGTTue4pJCV8Z5GDvcjVyipaw@mail.gmail.com>
Message-ID: <CAHk-=whCEy=fVcCZ+s6JABgKGrGTTue4pJCV8Z5GDvcjVyipaw@mail.gmail.com>
Subject: Please add feb889fb40fa ("mm: don't put pinned pages into the swap cache")
To:     stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It's missing a stable tag only because I initially committed it
without confirmation from the reporter that it actually fixed the
problem. I did that because I didn't think I'd get a test result back
on a Sunday before doing rc4.

But the reporter came back and confirmed it fixed things, and because
I hadn't pushed out yet, I amended the commit to have that
"Reported-and-tested-by".

... but I didn't think to add the Cc: stable until after I _had_ pushed it out.

So here's a slightly belated note that commit

  feb889fb40fafc6933339cf1cca8f770126819fb
  ("mm: don't put pinned pages into the swap cache")

should go into any v5.9+ stable kernels.

            Linus
