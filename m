Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3E61C1E5F
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 22:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgEAUYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 16:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726468AbgEAUYC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 16:24:02 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9B9C061A0C;
        Fri,  1 May 2020 13:24:02 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id r2so5521832ilo.6;
        Fri, 01 May 2020 13:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=LK4KRJWWAJrsktLuXoC6PRNRtrhqTlN6TNIUc7GGM/o=;
        b=vB5TlFep8hgJKi6dS0MaRhAYk2yzL72ajlDlz11NSbzdkDifbr0AgDdV1oqx5ZFLWm
         IQsTJaTMreta1RUpBD0fCEr5P7otKkgBIll5VEI8S7FZfxUTwFlYLI7ZDNLGC0yfMTiD
         sWFQ+oY0qaPsIBlwsJ1PZmmJ9zeMAK9fZc7DX46qVbJ+MdNO9msxDgRLcEC9HePJb7Df
         buDSxgXUu32FaaQmnoVRjTm5FkYVOQ7OYgbfcCRn4XhG80mOq1Dbt1IREumE/eJlcVk4
         hz2GzJuxJdfDvSWMEvxdcjsc1BfN8fbeQB+5yUOZcR9f0AXGCK3bnA1wo2W6DSZWsUfU
         3+nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=LK4KRJWWAJrsktLuXoC6PRNRtrhqTlN6TNIUc7GGM/o=;
        b=k4ZcmuckDCB6Zfqn8uyb4SLVoo9PMRkT9zBn2dLYPkBv1JJ33MoSFT+EMo5QhLP4HD
         utHqZM5LHQ0h2yXkbfcvGkUSL6AWIHLlPTS/Gr7HlML3WWE4Bo1YqBXvltYA5j4nbSqp
         5a2WPA7bglIQfofOjWD1i767GBp2LTcpAK0/uEH2+Ydb7LfKuoFBk+30V7/zM+oz2dj7
         iAdQCjBEHutw+Tcw4VsL6zhJ7oPMXqVsMzZxwhQXmbYhCkXSXMup4wbu6wHklzFfy1Zt
         AtW8Xu3NdtyzXTlFCIhjBF3SKD+3gWba3yJ7VUtiHvMnB8Dk5x9Z8iDfYGHpD6cP7dJt
         P4gw==
X-Gm-Message-State: AGi0Pub5AjSnDgvrMe2irWmQVqoZt0jkA7pLpJo6FdaXiz5BZlxSnu+w
        vjk6QhtAoKngMp//vlYX5eJ70/UguqjAxGk+HHO+iuWrOwQ=
X-Google-Smtp-Source: APiQypJ2pdDkfmWz0mP7qJIHbl7TMEqa6cSc3EXEKoYfD9MoFsVPs7bguN2tGQtnp7XHH+jiQFaOd132E/pKzjm7FGE=
X-Received: by 2002:a92:c80d:: with SMTP id v13mr5327570iln.285.1588364640499;
 Fri, 01 May 2020 13:24:00 -0700 (PDT)
MIME-Version: 1.0
From:   Miguel Borges de Freitas <miguelborgesdefreitas@gmail.com>
Date:   Fri, 1 May 2020 21:23:49 +0100
Message-ID: <CAC4G8N75VkqDug9AmhvMQnXr8bOvC9cu_jUwZVUKwpvWr6pO5A@mail.gmail.com>
Subject: [Patch include request] ARM: dts: imx6qdl-sr-som-ti: indicate
 powering off wifi is safe
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, rmk+kernel@armlinux.org.uk
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear all,

This is a request to backport b7dc7205b2ae6b6c9d9cfc3e47d6f08da8647b10
(Arm: dts:  imx6qdl-sr-som-ti: indicate powering off wifi is safe),
already in Linus tree
(https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/arch/arm/boot/dts/imx6qdl-sr-som-ti.dtsi?h=v5.7-rc3&id=b7dc7205b2ae6b6c9d9cfc3e47d6f08da8647b10)
to LTS kernel 5.4 and to stable 5.6.8.

Reasoning:

Changes to the wlcore driver during Kernel 5.x development, made the
Cubox-i with the IMX SOM v1.5 (which includes.a TI Wilink 8 wifi
chipset) not power the wireless interface on boot leaving it
completely unusable. This happens since at least kernel 5.3 (older one
I tested) and affects the current stable and LTS latest kernels. The
linked commit, already in linux mainline, restores the wifi
functionality.

Thanks in advance,

Miguel B Freitas
