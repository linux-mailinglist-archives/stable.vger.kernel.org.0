Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCA6334BA8
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 23:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbhCJWhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 17:37:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233007AbhCJWhR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 17:37:17 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F295FC061574
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 14:37:16 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id v9so36365916lfa.1
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 14:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=JjiVuZG/FcA7sZQ3RFg5K+v5XBVbHxIpROPFR1JKrfw=;
        b=YNA/6Wh40Voh7EckB0exeAV/sRpZZjR5sT8GrVzcRLqwxqCV2e3zIrOOLhCRR9IhL1
         Xe3Hzf91aCJEuApKrBaIf3+VePJ5eMvStqfsHY/STI7rPFI9X3NwfvyfGRDu4mvH4afU
         GNT3z3y+UIyxjohbKDQWd3C6/lQrH7FGXHyS5FxI6oOIbjNnGEy+Mn9qAb/i/0ZWGIY4
         ST71fD2LcL9B2BZ+2whmqStH8wf4iUVdNqympgWhrmJ41BIpEIRQCPULAlTbA0XkVWBh
         uYEx5KvnX206dsHHAoSoHwChTcTIffD2ZEVsEmD1TlMNOA8dHYv/I53u/NBbZqznDcCm
         rWLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=JjiVuZG/FcA7sZQ3RFg5K+v5XBVbHxIpROPFR1JKrfw=;
        b=Zkqjz+p0wPMsQdNefj8LZIAvLsQMOcbJl7a75wsnSm+t0JqeTo/VYP8r47No4Aj+yX
         qXY0KpP8weBR5EkpVI8t59RXHmi4AGO1BK7HBJQ/aReHevKly333Wla7aG3KvW8DNzIG
         FE5m5+8ohZhDxdRIrT6KKiHSN5cmGVxzcFQ9vdX98CV3e9+Tsk5Nmm8kb3/jAyRyPkDs
         v0fYiI2GWhzsSPUH58gvtf6m6upoAA6afcefwiB8BSzDbuVyhOtxLUlbErBo3KFiAteu
         CSxJIDVYGqy0SNJ4d6S6lsB8UekGeGzv7whS/ZlOsQEATJqBX4m/YjImacPFMFKk2UlN
         A0Uw==
X-Gm-Message-State: AOAM5314SZavmE7GXfI0bhewIPDd7Lq6LhN6gXwqRLL6KiegHP5y9oT2
        1KWt4XXswBbbjNNBGR1Pg6ZUvQirS4i6l4AhmLAr/h8FRcnaGw==
X-Google-Smtp-Source: ABdhPJz4iCJyGzqCWgMB14xw+IrZLTOvy5BZXuXF+JL3rXXXLlDY0v9/EERcf7nDn/imqiNVedD4fQJblBd+lrRwB08=
X-Received: by 2002:a19:da19:: with SMTP id r25mr384756lfg.368.1615415835168;
 Wed, 10 Mar 2021 14:37:15 -0800 (PST)
MIME-Version: 1.0
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 10 Mar 2021 14:37:03 -0800
Message-ID: <CAKwvOdmAEKQmi-Hy4Gi33t4nb3mCuKUd_qmbEdwrkRwezAWpiA@mail.gmail.com>
Subject: commit <sha> upstream. vs git cherry-pick -x
To:     "# 3.4.x" <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello stable maintainers,
While working on some backports I'm about to send hopefully today or
tomorrow, I was curious why the convention seems to be for folks to
use "commit <sha> upstream." in commit messages?  I know that's what's
in https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html#option-3,
but I was curious whether the format from `git cherry-pick -xs <sha>`
is not acceptable? I assume there's context as to why not?  It is nice
to have that info uniformly near the top, but I find myself having to
cherry-pick then amend a lot.  Or is there an option in git to
automate the stable kernel's preferred style?

-- 
Thanks,
~Nick Desaulniers
