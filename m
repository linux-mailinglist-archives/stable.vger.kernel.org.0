Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B54D3030A2
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 00:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732072AbhAYXzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 18:55:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732084AbhAYXzb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 18:55:31 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6A0C061573
        for <stable@vger.kernel.org>; Mon, 25 Jan 2021 15:54:51 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id e206so2789180ybh.13
        for <stable@vger.kernel.org>; Mon, 25 Jan 2021 15:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Aq4jx6ZJmmJrk4vcQ+XOoF5zsi6P3HFOE3fFsbhbQZk=;
        b=UxhpO19ZFbPLPmMQlGF62AcWhw5CfgPb42mVAx8iWKzu1Jm6xT3FALo7OBkA8Vr98O
         3UxSoK/tX7Jgepn0HFfpR8DZ+YAim+s7MyzBtC0wXneRzUpnh6g/37K6Pn3I9+wINJmj
         nJItTzKcgkE1GaunE/q7zYitsV+b/l/RGe6hZ0Sk3IU7wVyAVNAtov/xqtM0UcdIsxVk
         VQ75SjvG3pdwyqILbGLcpHk66X6jc9Ha1r0Z0l8uDEOsBTtoL7rQG0dIrz5X2s/v8ItA
         W+zpAgrwcJZXQbkJoy7teec5yfUZiaUCK7neSwTdSgVbu5bADjKJwwZFUG63Uyb/J5fj
         7XtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Aq4jx6ZJmmJrk4vcQ+XOoF5zsi6P3HFOE3fFsbhbQZk=;
        b=eFRHGJChYGlz44bct34ytkSguS7w6Fi4xBZe8c0rgz7g7phKktQ6hw/XXS4L1wt48O
         bjVoKXS5lcVpPgNv43Vp9CZrlYz8NgehzglrzLOcYu6gRWe7cH79yCxScUuhJPk2j9GO
         QlvDvnT0+KVpeEZhXVm7arq74YG4pt+GJLnBmGwnW6qYTx9Bjdr8jRYlUQ655hm6SCUW
         mEPBr4qXrnm+f3hn5UhS3iCny8F/mVRUrUa3ogfoY9TSWGyTaaEYLjzpaZuVJeUz+PqE
         zXW31RxObLXL3oBoQycy/ba+WOvsby7Ii0OMDbQvncW0vrx1cVyIzEPmyJU8q18FWrQ2
         9nmA==
X-Gm-Message-State: AOAM532Yf11kn0abT7eSyTzxb64VVQs5lI/lnggZgcsu3/I21VRNGm0P
        Ih68voiNgWWRM2hy1adKFI9C5CC6KvbYkZ+vBKBWgLV3QnmnBg==
X-Google-Smtp-Source: ABdhPJzEyy2ZxPlQ2MU+C0j6RmpEM+SOTRNkPBbpEfF9yIp1V1UpCx9xf9ztYf+mZ+/ka6gIEO9UGy6FDCt+KSof6ng=
X-Received: by 2002:a25:2802:: with SMTP id o2mr4178708ybo.351.1611618890069;
 Mon, 25 Jan 2021 15:54:50 -0800 (PST)
MIME-Version: 1.0
From:   Alistair Delva <adelva@google.com>
Date:   Mon, 25 Jan 2021 15:54:39 -0800
Message-ID: <CANDihLGoyJcOc6svbBJg+Esg44waexk6Jjn0HzLZqs7XYoEYGQ@mail.gmail.com>
Subject: c8a950d0d3b9 to 5.10, 5.4 and 4.19
To:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        jean-philippe@linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear stable maintainers,

Please consider cherry-picking c8a950d0d3b9 ("tools: Factor HOSTCC,
HOSTLD, HOSTAR definitions") to 5.10, 5.4 and 4.19. It fixes a problem
where the host tools set by the user could be ignored for
'prepare-objtool', and is needed on x86 to enable the ORC unwinder,
dynamic ftrace, etc. with LLVM=1 and a 'hermetic' toolchain
environment.

On 5.10.10 it cherry-picks cleanly. On 5.4.92 and 4.19.170 it
cherry-picks cleanly, besides 'tools/bpf/resolve_btfids/Makefile'
which was introduced after 5.8-rc2. (This file can be ignored.)

Thanks!
