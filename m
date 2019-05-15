Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA4081F811
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 17:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfEOP7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 11:59:51 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:39764 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfEOP7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 11:59:51 -0400
Received: by mail-ot1-f65.google.com with SMTP id r7so491107otn.6;
        Wed, 15 May 2019 08:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pICf1yleOUpGFfb18d9g2TaD5K8vKoYdhQ5w7nhK0ZU=;
        b=qrDCGHUbt+5hZNmYDg2TElKa6N4bBQ4+efk3EKy4gOaIAvX21oM45U+Ht35cZz9y37
         ND9dHWT9kRzFSrsizIGLUzbbMkJvzPDrtcEHfVSUjB4GtgBl6DnuYpRukulzL8LkpYCo
         nT56ED9MnBc6psKWfWUp+GSABcjVU6/laKBuYN3NSzM3DOY/9F0/lmTiXTBGW3xzzaYB
         vkMek+bOLv/Mp+dfognu0kJ6Tueq0iewrS33ssaaD2yvBD7Mp9zP7uohzLXS/K8BwJYV
         T3NSDR23SZNSH6LSzWzIsLO0jaoSyv67HBuaEufRBTsgi8D1MTF865vNnIG0skhQz+6A
         RUbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pICf1yleOUpGFfb18d9g2TaD5K8vKoYdhQ5w7nhK0ZU=;
        b=C5MxiHXfKGMOqUXI6YLXmzwIFlPyyHhR3qx1t2bK0Y+mJRsIefQw20ug67yo1jDlKk
         qz/uv8B3hGWNr1bn6LAq+4jdZNz2e+nHzMdduke/O0MPsgPbqWRXQzlFl/rPioT3MHD3
         0bIGViIZmVbyp1s/6rVuvWSn8i4bbsDzsSdFKhCqA/GTf8+vvWW4WfuZMWA4QMDU1CHf
         1ZbIKdf0tTScvkxFH4FKvt6iGtFAf9YtsS0vNpcAUxhpwds505GHqsDDWDNh7Q3A5vfU
         qVSbAEbkBHbwbJiQ+IS0Ehogdzc0fox/LmRsA4PyFwoswD5oXGCZE/p3WJa+pM62MBv7
         +s/A==
X-Gm-Message-State: APjAAAXChmHU1MYiR5Rn/aN7zqwmKmGhcStnCGdXMyitDRF8KV7fGYRi
        Fydulh1wk8M4KgYOSYS9S6ImiVOONG36vMbimLjpDv4U
X-Google-Smtp-Source: APXvYqwKB75kRwOHmWxJxqKWIFMMchTSZjke/iYT7O3xJV2NArz1pKvfZn2JWFf89LGEjTO+0ePh6Id4mDFZBNRwcpo=
X-Received: by 2002:a9d:7154:: with SMTP id y20mr1839474otj.369.1557935990684;
 Wed, 15 May 2019 08:59:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190515090659.123121100@linuxfoundation.org> <20190515090704.367472403@linuxfoundation.org>
In-Reply-To: <20190515090704.367472403@linuxfoundation.org>
From:   Jinpu Wang <jinpuwang@gmail.com>
Date:   Wed, 15 May 2019 17:59:38 +0200
Message-ID: <CAD9gYJ+zOgwe5mxns=0m=Lpz0Dthn0f1_YkyR+n0w7JaAswL1w@mail.gmail.com>
Subject: Re: [PATCH 4.14 067/115] crypto: testmgr - add AES-CFB tests
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "v3.14+, only the raid10 part" <stable@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <alexander.levin@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

This patch causes build failure for me:

In file included from crypto/testmgr.c:54:
crypto/testmgr.h:16081:4: error: 'const struct cipher_testvec' has no
member named 'ptext'
   .ptext = "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
    ^~~~~
crypto/testmgr.h:16089:4: error: 'const struct cipher_testvec' has no
member named 'ctext'
   .ctext = "\x3b\x3f\xd9\x2e\xb7\x2d\xad\x20"
    ^~~~~
crypto/testmgr.h:16097:4: error: 'const struct cipher_testvec' has no
member named 'len'; did you mean 'klen'?
   .len = 64,
    ^~~
    klen
crypto/testmgr.h:16097:10: warning: initialization of 'const char *'
from 'int' makes pointer from integer without a cast
[-Wint-conversion]
   .len = 64,
          ^~
crypto/testmgr.h:16097:10: note: (near initialization for
'aes_cfb_tv_template[0].result')
crypto/testmgr.h:16105:4: error: 'const struct cipher_testvec' has no
member named 'ptext'
   .ptext = "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
    ^~~~~
crypto/testmgr.h:16113:4: error: 'const struct cipher_testvec' has no
member named 'ctext'
   .ctext = "\xcd\xc8\x0d\x6f\xdd\xf1\x8c\xab"
    ^~~~~
crypto/testmgr.h:16121:4: error: 'const struct cipher_testvec' has no
member named 'len'; did you mean 'klen'?
   .len = 64,
    ^~~
    klen
crypto/testmgr.h:16121:10: warning: initialization of 'const char *'
from 'int' makes pointer from integer without a cast
[-Wint-conversion]
   .len = 64,
          ^~
crypto/testmgr.h:16121:10: note: (near initialization for
'aes_cfb_tv_template[1].result')
crypto/testmgr.h:16130:4: error: 'const struct cipher_testvec' has no
member named 'ptext'
   .ptext = "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
    ^~~~~
crypto/testmgr.h:16138:4: error: 'const struct cipher_testvec' has no
member named 'ctext'
   .ctext = "\xdc\x7e\x84\xbf\xda\x79\x16\x4b"
    ^~~~~
crypto/testmgr.h:16146:4: error: 'const struct cipher_testvec' has no
member named 'len'; did you mean 'klen'?
   .len = 64,
    ^~~
    klen
crypto/testmgr.h:16146:10: warning: initialization of 'const char *'
from 'int' makes pointer from integer without a cast
[-Wint-conversion]
   .len = 64,
          ^~
crypto/testmgr.h:16146:10: note: (near initialization for
'aes_cfb_tv_template[2].result')
  CC      drivers/edac/wq.o
crypto/testmgr.c:2353:23: error: 'struct cipher_test_suite' has no
member named 'vecs'; did you mean 'dec'?
 #define __VECS(tv) { .vecs = tv, .count = ARRAY_SIZE(tv) }

Can you drop the patch?

Regards,
Jack
