Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9FF23EEBF5
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 13:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237001AbhHQLzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 07:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236693AbhHQLzK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Aug 2021 07:55:10 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F8CC061764;
        Tue, 17 Aug 2021 04:54:37 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id u16so11069794wrn.5;
        Tue, 17 Aug 2021 04:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=11FxlL3j/rWuw0tksvOEdo8fLSly46c2epzOXUItwu4=;
        b=pxwFPA8HIE8pmORyqrvMDxSLCyh7t7R24WEcjKWaqcQfkqe3QaGPGgtiWmc9khcLCn
         2o/iG6t+2HqvCBYNMSTbHeeUxelXJQKi662bnnCTeYt9r5//TzBcF+WGxqIka8l7qJkg
         w31+VUKANQvt9BD+bXVIxpbEnceQugTwmEyZ1/5XB2nGTgl0l1AQk6YYgfF9iuyMoeyY
         FMz/tnnNnvNTQViPM3JxfEkm5OAeGIuzjiCMZxYZ9Q0CyF3E50bYVBr4jKG0jZyiWO5S
         rjeXJOXz3MFcLw0HGolckzZrm+uhlKC/+Mb7x1YFStzf6iomtpmfUvWtKIZkVzXh7XzX
         8Eiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=11FxlL3j/rWuw0tksvOEdo8fLSly46c2epzOXUItwu4=;
        b=pFvN5kfS8JoVZffkr/By7YPzxLBnhBVPH6sOZ6xku5CT7ltBhX6w3/LnoZngf1o2kY
         Q5k0UHrG4Zr6/OfKslN8nRqK+8QkHdW+vt3DTYEtMqL3tvqqo8zl3dFgYN1JVw0/yJNa
         qJLaYf3zyJwTLHovcfiqr/hcmC5xoTHAnxcJlZ0hZzjOWN8SD59mmy8wbgdRj8qGRl/Q
         R/qTL/tXEn8+mWWjH0GkLLEItmOv/hksVnuZv6Cg9H4q/7RIO8g7sSmWKQumYdw4Fs2v
         Fvv9YySFcVnOxmlzZ3Jc0pLKHimsOqS//6m36selrv+uiGOmDA1d9SoWUvKMmIfZ6PRA
         sHhg==
X-Gm-Message-State: AOAM531l3tUJT8HzyEvl2zgRPWG7t0eUGvxgI2oItFWQ33U1+aKup6ev
        CRhVLW68FpPS+wDlyNMFFl4=
X-Google-Smtp-Source: ABdhPJwagcpnR2KmHvVpqne+IJm706Uv1++3Tz/t098Oh2icvVPKFsJxqdAGXp8cFfuyhrJnSyj7RQ==
X-Received: by 2002:a5d:5085:: with SMTP id a5mr3774428wrt.62.1629201275030;
        Tue, 17 Aug 2021 04:54:35 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id l38sm1794482wmp.15.2021.08.17.04.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 04:54:34 -0700 (PDT)
Date:   Tue, 17 Aug 2021 12:54:32 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     "Maciej W. Rozycki" <macro@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paulburton@kernel.org>,
        James Hogan <jhogan@kernel.org>
Cc:     linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: build failure of mips decstation_r4k_defconfig with binutils-2_37
Message-ID: <YRujeISiIjKF5eAi@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi All,

While I was testing v5.4.142-rc2 I noticed mips build of
decstation_r4k_defconfig fails with binutils-2_37. The error is:

arch/mips/dec/prom/locore.S: Assembler messages:
arch/mips/dec/prom/locore.S:29: Error: opcode not supported on this
processor: r4600 (mips3) `rfe'

I have also reported this at https://sourceware.org/bugzilla/show_bug.cgi?id=28241

--
Regards
Sudip
