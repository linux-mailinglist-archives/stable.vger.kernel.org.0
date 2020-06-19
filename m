Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82DA920080F
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 13:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731779AbgFSLtG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 07:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730957AbgFSLtD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 07:49:03 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B31C06174E
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 04:49:03 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id x18so8960994ilp.1
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 04:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to:cc;
        bh=gHc2gM/IPvgNTJeRy8bCesZKBHd5/Y+o4VDap8WCVNo=;
        b=fVPY2smMWpFKOtStBmiFfKTkNnTkBdGzl65IlxYiTe9p1aA4z+n/gLIyvPBfJo2uR1
         Xnd5TA1r/zNBGHWrx+vf5IgHb5nbvC7OIExnkmjIbAqqXk/8WErg3IzCxZQwUNr1IDcg
         hr/C27ILOA/I7YkXaKhzQMx0QvpqISOdfLfyCvXtFKHEnd/rN46w5nXb92Hpgo726oB5
         YHIhjLxumKCybAWChkwfYAvFahjE/XgXWaJCHXU356pEpL+J94D+1p5CZlxUQRljJTtK
         LaRl/LwYV39T5fQ/4hFd4wsX7W+ZtToSCl9ZuX0LldDsFticD3pFGkCXhTgcCi9VZop1
         7SRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:cc;
        bh=gHc2gM/IPvgNTJeRy8bCesZKBHd5/Y+o4VDap8WCVNo=;
        b=lbH6+x9zjpjJ8tTDO+/8KYO8AXdQlUCIrmdwnf9/rlQ+z2qSU0lxzPJySSw+j3sFKJ
         qvl47igUqpXpCTaMr3Zu/lfuvc3GSkYiRQHbm0oDHz1xzf9cKON5sYN7KQxsZZwMrMHZ
         gXaK94dXxwQWICuqKd63SEhPzuoQbrTmYUs6WRVInOTjj4pHSbNvohV6+R5nSVXGVTpt
         1LODqWo5/cTlNWeIx7rUWeFaUAW+xfB6Usc/Y7staiPxi1ptWHiVi5l69LllZaNC0QYN
         gIIrwcN4xGBn8Mr/zTCRSF+nNw0EEKFgn0UmVE1AXksStAqb1Gj2QjEVHRtBgL9NOYz7
         y7tw==
X-Gm-Message-State: AOAM530tloxRgs6/NZCeMU+cY+Hd4vM06et3qzUclH8KDC6W0Cw/KlHF
        IaOgp3saMSwnMkhkwS/WxJJMPkjiybMPAMMF9Ds=
X-Google-Smtp-Source: ABdhPJzJUpQmB1jskZ2P0Wc3XaanXS4OSW1Npy6bTCN3pUp6v6IGG6AcBFEovLkQg3cFf1grwUjrTbIrQ6witrge+/0=
X-Received: by 2002:a05:6e02:92:: with SMTP id l18mr3142045ilm.212.1592567342291;
 Fri, 19 Jun 2020 04:49:02 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Fri, 19 Jun 2020 13:48:51 +0200
Message-ID: <CA+icZUU8mXX23JHvEGjgBtTTp_zpm++wBkAgw_Rx0T-Rajz28w@mail.gmail.com>
Subject: Re: PASS: Test report for kernel 5.7.4-1d8b8c5.cki (stable-queue)
To:     Yi Chen <yiche@redhat.com>, Jianwen Ji <jiji@redhat.com>,
        Hangbin Liu <haliu@redhat.com>,
        Ondrej Moris <omoris@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi CKI maintainers,

thanks for doing automated tests.

I am interested in a report of currently released Linux v5.7.5-rc1
before doing my testing with Clang's Integrated Assembly on
Debian/testing AMD64.

Is there a browsable URL you can give me where I can see if AMD64
(x86-64) tests have passed OK?

Or is it "Be patient and wait".

Thanks.

Regards,
- Sedat -

[1] https://git.kernel.org/pub/scm/public-inbox/vger.kernel.org/stable/0.git/commit/?id=2009b13ce33bf5a474ccdda991559e39712862c8
