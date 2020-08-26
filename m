Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283E52534E0
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 18:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgHZQ2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 12:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726864AbgHZQ2h (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 12:28:37 -0400
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05754C061574
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 09:28:37 -0700 (PDT)
Received: by mail-wr1-x449.google.com with SMTP id i6so692114wru.23
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 09:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=QZ7W+T4QF0YUCetjd1HtO/LKCNojLSEIhVHn9HwR0a0=;
        b=htX2o67mV8ck0A9HgmM1ua4ytwnzztLRuTCBqYnqrKoNCkkJLQRdC2xavCtwM+HFdy
         M7CEjkg5CzlycXMEoqoAnaExzsa6LEdr/xT2k3q4SNDNjE3UBmq5eBsG6qVYqcpRcj4u
         VX4rkYHxuMCFN2oxWnbgcy18MuO4ZSDcE+E9v3P94grffWa48nAQAoGM5oLEdCs3UVMK
         c1t7jZSCajMS/glJM1lA1OebKemFakV9DNn8xpeKKU6UWwu2lg6PSjGgx6W1pv6WCh8y
         F1NzZa3bhBiKAHENXPS6aN4ZA+PEsMj2JaEya8ly9itWKp1MQczHNjixYULjsxUPx52D
         glcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=QZ7W+T4QF0YUCetjd1HtO/LKCNojLSEIhVHn9HwR0a0=;
        b=oZAS4MzmAe8qjL977J4SMud50qQXCVThy989eomh0IuIfyTai8ODe+g9SfZQd8Dzpf
         wJqhScCsHHwdyQj6Hhv6aNFu4ea3EmJpT0yACkzzEhhofi4QepNMOqdJ0a3v17o/PVZO
         gMPLVHTy/aWMPXOO5Oc0M72c8SzYfGAtVLUQyPADRE9Un0E3PFOMGHc8sChJWEcK6NP8
         TOQhgLYIhkKHHJlWj9AawgqJG78I6Nc5ykklpdJFX0RLfdHvOg8rqwbYvMEHkYAc1UCs
         ka0pfxjpSddCb3S/QgWUPv8mI7v72nrZ4ZdOn/gnTlIg/ioxIHS588N2nQhco7Fgjz8R
         bL+A==
X-Gm-Message-State: AOAM533ZmR2MA/JDOkGWx69hz41UAHNfhc2hHtuIlQmcT0P9ocE4+vY1
        by7DtXv4haWO7P8iyv6qtUDcNkVIkOwqanzIJ0aEwpIaTbqwds2Cg3AADIohcO4jGlcKTblDwMG
        RARRN+l/5KSIc5pde47RH1trL4tYytuPIeFmUfKqgwD8bhfXXKb1Ww+4h21b6MCJENKw=
X-Google-Smtp-Source: ABdhPJyLbrbxxusUnK7wJ8w0zr3FJy5sfTjrcdMecBjH42S9OfHWw/iBVu2dOt3y/w55KxqdxI5lm6jJPSrzdw==
X-Received: from lux.lon.corp.google.com ([2a00:79e0:d:110:7220:84ff:fe09:a3aa])
 (user=maennich job=sendgmr) by 2002:a7b:c74b:: with SMTP id
 w11mr7472090wmk.81.1598459314703; Wed, 26 Aug 2020 09:28:34 -0700 (PDT)
Date:   Wed, 26 Aug 2020 17:28:22 +0100
Message-Id: <20200826162828.3330007-1-maennich@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
Subject: [PATCH v5.4 0/6] Build time improvements
From:   Matthias Maennich <maennich@google.com>
To:     stable@vger.kernel.org
Cc:     kernel-team@android.com, maennich@google.com,
        Denis Efremov <efremov@linux.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

please pick up the following patches for 5.4.

Those are build time optimizations for kernel/gen_kheaders.sh, and - by
removing bashisms - dropping the dependency to /bin/bash.

In addition, this enables build time improvements across the tree by optionally
allowing to use alternative implementations for various compression tools, e.g.
GZIP=pigz.

The documentation-only change is not strictly necessary, but keeps
kernel/gen_kheaders.sh in sync with mainline.

Cheers,
Matthias

Cc: Denis Efremov <efremov@linux.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Denis Efremov (1):
  kbuild: add variables for compression tools

Masahiro Yamada (5):
  kheaders: remove unneeded 'cat' command piped to 'head' / 'tail'
  kheaders: optimize md5sum calculation for in-tree builds
  kheaders: optimize header copy for in-tree builds
  kheaders: remove the last bashism to allow sh to run it
  kheaders: explain why include/config/autoconf.h is excluded from
    md5sum

 Makefile                          | 25 +++++++++++-
 arch/arm/boot/deflate_xip_data.sh |  2 +-
 arch/ia64/Makefile                |  2 +-
 arch/m68k/Makefile                |  8 ++--
 arch/parisc/Makefile              |  2 +-
 kernel/Makefile                   |  2 +-
 kernel/gen_kheaders.sh            | 66 ++++++++++++++++++-------------
 scripts/Makefile.lib              | 12 +++---
 scripts/Makefile.package          |  8 ++--
 scripts/package/buildtar          |  6 +--
 scripts/xz_wrap.sh                |  2 +-
 11 files changed, 83 insertions(+), 52 deletions(-)

-- 
2.28.0.297.g1956fa8f8d-goog

