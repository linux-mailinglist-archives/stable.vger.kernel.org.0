Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C32C40103A
	for <lists+stable@lfdr.de>; Sun,  5 Sep 2021 16:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233366AbhIEOcK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 10:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231341AbhIEOcJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Sep 2021 10:32:09 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95506C061575
        for <stable@vger.kernel.org>; Sun,  5 Sep 2021 07:31:06 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id q3so5708423edt.5
        for <stable@vger.kernel.org>; Sun, 05 Sep 2021 07:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=7/1jDOGzfp3PXRcY9mA9mIPbXo8eoYQIufcyNrSrdxM=;
        b=ysj6gmVcqNHadgXS9+bDPwQsbxGxVvOIR/E3NWp852m68iBMAwhSXd6/07o+6DMJsr
         k/DirnKmIctct/dhSj0twwPKBli9JeeYmVrj2/Mk2Ofq3CAdniV5ae5/0qnSjgf2wkBo
         daX+WtqPeBMJtXhF/7jezOqmmRlTt3GmPO7OrZV4zlRK0JhF6BOxJSNexqT2eYkOaG/3
         424dfGfyKbBB5BkXMHhB/7g8OAV9gVN4b0O87tF8TzoHzy2yH/EEDqxS+iP0vRM0GOLv
         eqFjRtXTuuo44PGn8M2KWjqkNkgN89PWGai9S2WsFUBybPbZAZHCQm3/5Qbtcsa805gr
         ZoAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=7/1jDOGzfp3PXRcY9mA9mIPbXo8eoYQIufcyNrSrdxM=;
        b=hST8OdN3Si8i0lKY9Xiaq/V6g9H+FwR4/lpYDPmskRTP8K2wzbPz/six/tvpeOnYsv
         jVyhXL4EPUAzkX4YlACv3vlf6kSruWgF99yvM29U9duMpaZO6lLl89wC1kZ+f8Z75/4q
         BUb2fuRDe8/0oAn8clntqdArX7LCLl4WVYbi5T5JugZGqqK2ripzH4e9SjpZ2QlzUJ3r
         0SL+35Uau9eXoXYTDnhw/vjhaRgZSpS7sqgRZVJI0TGI4wB1jSc5k3G3wlAwY96VsVdG
         H50XlLqRiEy73aAEDc1ScujJ2TRHAiS3A9fO1HGfAEwLAw/Vru/0X9JYQoHavVgBuRK7
         R0HA==
X-Gm-Message-State: AOAM531Bd0cu0c1D7JRr3Ogl7Ws8CKljs8eeEmy/Sqq4gfLw0Wm0RH50
        Ef9AVoprnGQCi+p9IbZaaeXXjSp57IpcOWZzyiMeJw==
X-Google-Smtp-Source: ABdhPJxLkulszZ+5R2hFoQFt48ejGYp+MiYE+Yd64kvqwhDDt0F7dgJCJoOQl5S+PU2dcz0yxakLb94XV64LLw5bpuQ=
X-Received: by 2002:aa7:d3c7:: with SMTP id o7mr8971267edr.288.1630852265055;
 Sun, 05 Sep 2021 07:31:05 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 5 Sep 2021 20:00:54 +0530
Message-ID: <CA+G9fYsNttv1A+iWdaaabZCfbo+miw9LDTzOjrSuuEoKOqVvDA@mail.gmail.com>
Subject: proc-pid-vm.c:214:19: warning: 'str_vsyscall' defined but not used
To:     "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>
Cc:     Shuah Khan <shuah@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Following build warnings noticed while building stable-rc Linux 5.14.1-rc1
with gcc-11 for arm64 architecture.

aarch64-linux-gnu-gcc -Wall -O2 -Wno-unused-function -D_GNU_SOURCE
proc-pid-vm.c  -o kselftest/proc/proc-pid-vm
proc-pid-vm.c:214:19: warning: 'str_vsyscall' defined but not used
[-Wunused-const-variable=]
  214 | static const char str_vsyscall[] =
      |                   ^~~~~~~~~~~~
proc-pid-vm.c:212:13: warning: 'g_vsyscall' defined but not used
[-Wunused-variable]
  212 | static bool g_vsyscall = false;
      |             ^~~~~~~~~~


Build config:
https://builds.tuxbuild.com/1xXcUtI2INra8KaHjOXXQMOyAD0/config

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

meta data:
-----------
    git_describe: v5.14-rc6-389-g95dc72bb9c03,
    git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc,
    git_sha: 95dc72bb9c032093e79e628a98c927b3db73a6c3,
    git_short_log: 95dc72bb9c03 (\Linux 5.14.1-rc1\),
    kconfig: [
        defconfig,
        https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/lkft.config,
        https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/lkft-crypto.config,
        https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/distro-overrides.config,
        https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/systemd.config,
        https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/virtio.config,
        CONFIG_ARM64_MODULE_PLTS=y
    ],
    kernel_version: 5.14.1-rc1,
    target_arch: arm64,
    targets: [
        dtbs,
        dtbs-legacy,
        headers,
        kernel,
        kselftest,
        kselftest-merge,
        modules
    ],
    toolchain: gcc-11,

steps to reproduce:
https://builds.tuxbuild.com/1xXcUtI2INra8KaHjOXXQMOyAD0/tuxmake_reproducer.sh

--
Linaro LKFT
https://lkft.linaro.org
