Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F2E3881EA
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 23:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241852AbhERVP2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 17:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236093AbhERVP1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 17:15:27 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1895FC061573
        for <stable@vger.kernel.org>; Tue, 18 May 2021 14:14:09 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id e2so6812567ljk.4
        for <stable@vger.kernel.org>; Tue, 18 May 2021 14:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=aORSooZ175z7MA7q67fTcs0pfXV58Nu7HHm+DIUPNrg=;
        b=mL/2cGxqszJ2Rz25wMGpR+/hS7py2OgKf34enET9YiLUTnsZgNEPXE/MoTXv4TlmNy
         YUr1beIV1eot65kcBXbtLRBUt7iXXSEb1MeVxqHEkTTUYTOZCVN1pWyOrV5Ml2Z9OXUZ
         78OnAW5t0FwAZM9M0cfaJl/VhtAE6EoU/KyxSTdNhHeRompSMBh0FBkdXpXGICrNpJhi
         Z+JMoNNymbmJifJhtzY6IOMWqmMN8fOUR65Fsc26nxIkq2xLAtiGfJRHBlmO7mdw4nF7
         znvrrwCfUTI8bjlW9gmlhJVjIGD66kNQDON3/Srf1htTKqM8YBQwcCaqw/7FgusCCKBa
         Nrjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=aORSooZ175z7MA7q67fTcs0pfXV58Nu7HHm+DIUPNrg=;
        b=drUflzQ+xveB81jVCcD1UtTBIB23I17a+A2Mbv44G7QSNXq0v5rmigmea3F3YPO3EG
         C2Cdt7rH87pUe4cwVkSElfwZbPeyTNwYbKg1XpUqlai6d1ScOh5hClxR5Q5/8DCPm2a0
         DTTjvCYs5cu9hbTCS7W2IdIddSZrVIG+xKa9WZ8sO0AN5fJdTRLsbZNDQGLwUh9nn7Wl
         tasZUqvxTPefQkDx4lt0qUYb+BkJMUutfQSCwaTKfOW4P1/3ACmE2fD9qXxuFWBxsB5n
         DEmpp0Zn7xWumXyPhFHj7xu1xF6cN6KpVCcKhg2gUt7tdMaTHxktCyIFeZZM/mCrx+l9
         y1sw==
X-Gm-Message-State: AOAM531tSWR//HWdJJ/XQmh7u57QEWZWfFfnRvTSSfDq8zk+6RobybpX
        40tKrfHtBSkMdner/zvMqIkI9N6b2J16QvyiTfx3hY2Z3RzIIg==
X-Google-Smtp-Source: ABdhPJwFaV28Q4EOVNZ0PpKEkJGO2qzeDl2Qh9letWZR/ziCdRdHxTU2MfqgZ0j9SfPbNx/ugc3LlMxa2P3ubj++2eE=
X-Received: by 2002:a05:651c:106f:: with SMTP id y15mr1930311ljm.244.1621372447380;
 Tue, 18 May 2021 14:14:07 -0700 (PDT)
MIME-Version: 1.0
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 18 May 2021 14:13:56 -0700
Message-ID: <CAKwvOd=iaL8_e4gxBPAzZbgCHtMy=gLi1YT9ja5Q_9+dE-L==w@mail.gmail.com>
Subject: please pick d6d43a921720 to 5.4.y and 4.19.y
To:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear stable kernel maintainers,
Please consider cherry picking
commit d6d43a921720 ("pinctrl: ingenic: Improve unreachable code generation")
to linux-5.4.y and linux-4.19.y.  It first landed in v5.7-rc1.

It fixes an warning from objtool reported by 0day bot in:
https://groups.google.com/g/clang-built-linux/c/bSNh_MA6MFU
and applies cleanly to both branches.
-- 
Thanks,
~Nick Desaulniers
