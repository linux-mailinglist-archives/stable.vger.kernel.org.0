Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 909002B29DD
	for <lists+stable@lfdr.de>; Sat, 14 Nov 2020 01:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbgKNA1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Nov 2020 19:27:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbgKNA1O (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Nov 2020 19:27:14 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B153DC0613D1
        for <stable@vger.kernel.org>; Fri, 13 Nov 2020 16:27:14 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id g11so5321149pll.13
        for <stable@vger.kernel.org>; Fri, 13 Nov 2020 16:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=bpBal5S5plQ7QuZR1K9vyQ+ek7VX2xaZ9fotOPPTNFI=;
        b=Z8vA5WHoFs6/tH5r7QqetcLkFNose339Y/YUqrRTfHYCLQWlddo/xYJOhSnpoezxj7
         idz4x5LblTQTYC9V3oFOL+ZFsPvfdiyxFo52GDU7d4nkFID94cXHaJ5BE0Dz/uXCoYzv
         gHYKUO9jB3Irh6r7schK8EDczUiv/9lNaTZ/kXcwJM6QKhlybut4EwfDkoyWTFvqlFor
         mtGhkvCyRgUuc8j13w1XLKwc0Wyr1f2P5i2Cdt18Zl7UX7CFVzIS55gCoymVIxuzG3Ed
         MBnWQ+xPTJriy7ngt8pZfljxTabOu2KRphyj05Lhv1NoN/I47klVZkpgAgmscp+S74uR
         ASMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=bpBal5S5plQ7QuZR1K9vyQ+ek7VX2xaZ9fotOPPTNFI=;
        b=WpsSYaldBLwVQuyXd1uXFKMtB4tfqjl0amIwXBXII1Y+nNlgbSGEgYCgqDpn8etSam
         74H3HBZi2RW6rBCug2l+h8Q7pLE+bOqJVR4KuzA/AlbI0jQ8Rz9rLmBIP/EhQnwmOweo
         s9dz+7B+HltXuGdmRnd8Q8qF9719AC0kbV4YRQV0a5JRWPEihip+Q3u1WzxFX6JJCZoO
         y/w0r8/hEQ6FLjhDrpRf2bDRuHAP8xoCBIgqm4UxDOuDphJxodT9mRqwOp5pfsrjP74A
         RnAV/71ihcEocckezabhjYrPE+8xWqXxvk3tdg1KxCnf9zzTLE+a0mwvIo9XNi/a1LCQ
         947w==
X-Gm-Message-State: AOAM532HSoe3ToUusN6LKl7l5OrGQcVEJsQEyjwX5fKi8fLKWJosTNmd
        mcLFOcHmUpzt5MWJDhq/0MPYCLYIfXcfLgyYA0sGSg==
X-Google-Smtp-Source: ABdhPJzBCGoarKy3ywZsEm2d7tq95Sn9leOBk6rUWKARhok1bwNeQl+FwQtdvNPff5bn5m0FkMDLUZD8MYDg/ayE9iU=
X-Received: by 2002:a17:902:760c:b029:d6:efa5:4cdd with SMTP id
 k12-20020a170902760cb02900d6efa54cddmr4126341pll.56.1605313634036; Fri, 13
 Nov 2020 16:27:14 -0800 (PST)
MIME-Version: 1.0
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 13 Nov 2020 16:27:02 -0800
Message-ID: <CAKwvOd=x+fVo1_mMJUGHYXpmGf8UM5yx+uWD-Ci=y=0oFX2ktg@mail.gmail.com>
Subject: LLVM_IAS=1 ARCH=arm64 4.19 patch
To:     Sasha Levin <sashal@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Jian Cai <jiancai@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Stable Kernel Maintainers,
Please consider cherry picking

commit ed6ed11830a9 ("crypto: arm64/aes-modes - get rid of literal
load of addend vector")

to linux-4.19.y. It first landed in v4.20-rc1 and cherry picks
cleanly.  It will allow us to use LLVM_IAS=1 for ARCH=arm64 on
linux-4.19.y for Android and CrOS.
-- 
Thanks,
~Nick Desaulniers
