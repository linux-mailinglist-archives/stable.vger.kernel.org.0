Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D170201DF0
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 00:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbgFSWUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 18:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729164AbgFSWUO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 18:20:14 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFE9C06174E;
        Fri, 19 Jun 2020 15:20:13 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id t9so13091616ioj.13;
        Fri, 19 Jun 2020 15:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to:cc;
        bh=BX/baSCar8qPXAnSBMLiAyEtm57FdruojaEfI7fsHsg=;
        b=cnqJS5A4oRljA0CO0wTW5qxXyvJMFAJU1/mXnqydbi3RzGzCSYuoCV1FOsrcEhg0eR
         rLdDoPHN8E7Kp19cUu3W3v5ElwI2E1qcciFn3r0JZQeWYUxitrA0mPVwjvF3V3oB36rv
         V34U+7eyX/VxIYqxppRFbuTWJJs6UEsknLsrEqjd1ZRv9sZ4AyB98Ci3CWyNkqTrohiv
         H68gtY+xF530MycArWrNgkozblTlUaLW9kGH7x/9T6YceUWU4DJ12UIWBtXm90FwbcSV
         DYr744IYbP6s1yudy9RxZ6wB4MZt8T+ZVV8QayPIN0BUWepotRb+bMlIe9wAOaybFU9R
         GEpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:cc;
        bh=BX/baSCar8qPXAnSBMLiAyEtm57FdruojaEfI7fsHsg=;
        b=PBBpTWR5exFl9zXfHNcwUBuNEO6cUnxq6BpVnWpGiF9Nbad6rxejwl4Y+l16Wos1I4
         Pqe+p5x1Q1uXc5us5am01NE2afBm7MME37jsNw/nDuUc7HSBlwVvGghSFBhc65gaMTnm
         oPo7ZHOsPjtLGd5qqFYQoMKo3gDRLv6Ss8fWz5GXtq+nNzfc5p1Bab7fWk1KYCIJ9JwD
         3QzA9Rp2CvdFp0u+HFm/5lB9D+c2n51Yk7jDXxFn0SnSMWRhFgh1OE3JOqhLT66sNaiS
         WleXhJo9kCbcQkkpJuWzOuL5+sqHfWmVCZzjVw+RwxItDt/7AK8tuDsLbIjOILZPUTGe
         zIyA==
X-Gm-Message-State: AOAM530VtH33E5aFWigeCEotDy9rdNxj0XjsegXbYsHZMUKn7Rs0sWu6
        CR56LsdoGKNmFfQAwZ909lGY/ScNf5m65QWsLh4=
X-Google-Smtp-Source: ABdhPJy7cdbbvW6JA90NgdpQnN7LCRZyV0/+leIzYSlEKiXgoPHYDeBgLDU4hEO93QzP/C/dQH3PsOj7CX55oe73VZc=
X-Received: by 2002:a6b:780d:: with SMTP id j13mr6838044iom.66.1592605212376;
 Fri, 19 Jun 2020 15:20:12 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Sat, 20 Jun 2020 00:20:01 +0200
Message-ID: <CA+icZUUcP4ms4e-42YoY6usYSNR=Rz8ARiDLt4Fm=FDH9_4toQ@mail.gmail.com>
Subject: [PATCH 5.7 000/376] 5.7.5-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

works fine here on Debian/testing AMD64...
...with some additional patches to use Clang's Integrated Assembly
with llvm-toolchain-11.

# cat /proc/version
Linux version 5.7.5-rc1-1-amd64-clang (sedat.dilek@gmail.com@iniza)
(clang version 11.0.0 (https://github.com/llvm/llvm-project
8da5b9083691b557f50f72ab099598bb291aec5f), LLD 11.0.0
(https://github.com/llvm/llvm-project
8da5b9083691b557f50f72ab099598bb291aec5f)) #1~bullseye+dileks1 SMP
2020-06-19

Thanks.

Regards,
- Sedat -
