Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 377A93703CB
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 00:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbhD3Wze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 18:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbhD3Wze (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Apr 2021 18:55:34 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956C9C06174A
        for <stable@vger.kernel.org>; Fri, 30 Apr 2021 15:54:45 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id l14so2364058wrx.5
        for <stable@vger.kernel.org>; Fri, 30 Apr 2021 15:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=u8f/+WkpiXL7vqYkxYCAZAgYWE52z9YaOdWRbFIQdCk=;
        b=K7Qu2s/+VfFxz9PoMYrbGWRqvgmQTVkwcd3Si44mPC4CLPa06BLf1bs/geSamJotsq
         cYZGdiLvs6mSAimLeoXduvgxqIE51Jf5w1KU9deKj82X7XHi/JlRqhVgrh+dKPPzb/V1
         ltizpJhm3RnlA4qdMZIoDAAUVC1vxdFKJo2xUatfKkhlr7Jh4Y1594qMpVknGpuknH7j
         971w2l1boUpJSJesm7VJW0aHo6lc8RUemCsliYP1bSFoIErLS5u9eoWYVNKwpqTRfOU0
         j9NHkKiwMQoeIUn8okhTezh13/zy9qB5/XDmftFVS65tOlINjN2FfbcAQQxaJyonK1Pb
         33ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=u8f/+WkpiXL7vqYkxYCAZAgYWE52z9YaOdWRbFIQdCk=;
        b=eumSRoUgH5PxuOvygkSQz5+yPyFP/IHLaw9LKtvCBJxuFdIGW4mOyKB9bBEwypoyy/
         RpcObNXXUQnXbiuGUVw+vVQC1rofMjBkW3kqfzhUxDucrX5+qkl1C1M9pgWH1ReveT2F
         X3z0Yi7qTwe5orBeXypYHokj2DE3a+wjh0xJC+VJBEdH1QWpYDQZiciN4fIJVjlWE71h
         oEoasqKsP7eRH2vjcB1AuwbAVO0UUBTuc+hdM55eICPAUmg/y367cvwpWGwy+vNeiW6E
         +7INBbDMgHTUFWr3pQ7z+rQNc6ihJfYXdxVjxkHLSWiALotwQQFR1KyOgf7jAw5bZyY5
         2XZw==
X-Gm-Message-State: AOAM532LG+ZxvLeqXRv3zr+sqHYl4zjbcT2j7t2e4mBhpN+fz3d1qkpc
        YZLqrmlAmdcnlAgYNmJMNls=
X-Google-Smtp-Source: ABdhPJwieJaYXHjWOHoBzSsHq5jWaWNfzst5iqzjPZwpxYi3X9GPyTvSSODk7vIjOn/eT2NGyN6j3g==
X-Received: by 2002:adf:d1e1:: with SMTP id g1mr10171664wrd.401.1619823284415;
        Fri, 30 Apr 2021 15:54:44 -0700 (PDT)
Received: from debian (host-84-13-30-150.opaltelecom.net. [84.13.30.150])
        by smtp.gmail.com with ESMTPSA id s16sm14073634wmh.11.2021.04.30.15.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 15:54:44 -0700 (PDT)
Date:   Fri, 30 Apr 2021 23:54:42 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, sashal@kernel.org
Cc:     stable@vger.kernel.org, Romain Naour <romain.naour@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: request for 4.14-stable to 5.12-stable: 1d7ba0165d82 ("mips: Do not
 include hi and lo in clobber list for R6")
Message-ID: <YIyKsnjERure9/UG@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Sasha,

The config malta_qemu_32r6_defconfig for mips fails to build for gcc-10+.
Please apply 1d7ba0165d82 ("mips: Do not include hi and lo in clobber list for R6")
to 4.14-stable to 5.12-stable branches.
It will apply cleanly to 5.9-stable to 5.12-stable. I will send the backport
for 4.14-stable, 4.19-stable and 5.4-stable.


--
Regards
Sudip
