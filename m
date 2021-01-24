Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19F2F301E2F
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 19:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbhAXSgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 13:36:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbhAXSgm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jan 2021 13:36:42 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604F5C061573
        for <stable@vger.kernel.org>; Sun, 24 Jan 2021 10:36:02 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id 3so12620291ljc.4
        for <stable@vger.kernel.org>; Sun, 24 Jan 2021 10:36:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1tHvmvm8LfHj3VWe0O1lgUCfuyanyS5i+ivU3PE49c4=;
        b=bKqf8Rh488wt+m4JpGDauueNTTicFPfb/kBoQI0TImDJDMvp4ZFYLBKOLhpdp6xYdM
         d3KW+1+bStbBDAIOgTlKOdqEqm5gKTIsG7lEMM8T57hNTB+NUZvowiUYNZsvcHv8s5vo
         1rlX0exebqE6omdYhEzkRtcKDbRP25kR3clPw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1tHvmvm8LfHj3VWe0O1lgUCfuyanyS5i+ivU3PE49c4=;
        b=eqZ4spg1ovz/ZXBcmsDw7uE/plNPjKp9ak89O0Dc0EkW50tjUPqlOGzN7uwckSiI4s
         B0p0YWJDUX8JcgfqBQ15ghQOlUsrn93w8IoYFzGgT6qDL2g9Fz4LkSAhjGrn7FHNsADo
         SBwtQQk83PdgWm5f+jPwwvUbBzQ/Recu6ZN9V6sToxD43Ms7/x+B0lH00D2FgawDiXqh
         iKCNT1eavIzrnsHFs//YBPey8NUaIWeGVDZOaSYFZ9rXsMi8f5Q6wvLttrjoQqBi1rtz
         5qCLAwJnk98Bqxi4zQ0EERdvpf6blhfZO+2CnlP6pZ4b/yCw3Js1QyRzlGNNFkrl8vNk
         GMFw==
X-Gm-Message-State: AOAM531ZPcRRFCsNHn4Gvi9FUJURkS2p4imBSCUQmyECFBSQKbRgjP6P
        NeyYe2UgFxIw/mUARLImAlZP8U0HG4BNxQ==
X-Google-Smtp-Source: ABdhPJwqSKa/TeyyYjEjRoUGiHNNHglQnX6t587H8sybP104hZjmP6WiseGfqN/snQ7hu+wRANDiLg==
X-Received: by 2002:a05:651c:544:: with SMTP id q4mr2495341ljp.253.1611513360292;
        Sun, 24 Jan 2021 10:36:00 -0800 (PST)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id e20sm1534149lfn.221.2021.01.24.10.35.59
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Jan 2021 10:35:59 -0800 (PST)
Received: by mail-lf1-f44.google.com with SMTP id h7so14609558lfc.6
        for <stable@vger.kernel.org>; Sun, 24 Jan 2021 10:35:59 -0800 (PST)
X-Received: by 2002:a05:6512:a8c:: with SMTP id m12mr105242lfu.253.1611513358889;
 Sun, 24 Jan 2021 10:35:58 -0800 (PST)
MIME-Version: 1.0
References: <20210123210029.a7c704d0cab204683e41ad10@linux-foundation.org>
 <20210124050119.34lm1Gw1Q%akpm@linux-foundation.org> <CALvZod7vf=NF40xSFqtugaZUaVx7X75LS10dpF6Q8LR=R=JhDA@mail.gmail.com>
In-Reply-To: <CALvZod7vf=NF40xSFqtugaZUaVx7X75LS10dpF6Q8LR=R=JhDA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 24 Jan 2021 10:35:42 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgdgR-kLmOGsRdc63zXcr6-h3gfizYVGHNdAr5Fu0UkkA@mail.gmail.com>
Message-ID: <CAHk-=wgdgR-kLmOGsRdc63zXcr6-h3gfizYVGHNdAr5Fu0UkkA@mail.gmail.com>
Subject: Re: [patch 06/19] mm: memcontrol: prevent starvation when writing memory.high
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <guro@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linux MM <linux-mm@kvack.org>, Michal Hocko <mhocko@suse.com>,
        =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
        mm-commits@vger.kernel.org, stable <stable@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 24, 2021 at 10:02 AM Shakeel Butt <shakeelb@google.com> wrote:
>
> Johannes requested to replace this patch with
> https://lore.kernel.org/linux-mm/20210122184341.292461-1-hannes@cmpxchg.org/

I've dropped it (not replaced it - will wait for Andrew to
comment/send) from my queue.

          Linus
