Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86221C858A
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 11:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgEGJRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 05:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgEGJRS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 05:17:18 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2C4C061A10;
        Thu,  7 May 2020 02:17:17 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mq3so2388153pjb.1;
        Thu, 07 May 2020 02:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NsGXZKVjnwITEukQUNn3zovirkspDit08UiRlVwi+Ws=;
        b=jDHCH5FQQr0KoofiUFOeWYHKKJAeXwT3pQX8hLU0Lszpou/L3/+IBV/zzSSMQD+dhD
         4Apc7r1egT7m7ecFPi5MIW5sqmdHr22BdFiXc8aj+SN7/jzjVOPPQLA+Txf+vH3ZJ4fB
         OtMb1jteey3yweQFrutrlOEWvGdXFzFBUSaGN8PKvHzM72xRgMv1Rfv6hSyBwBG0FZ9Y
         ERKWrNB3ouNH59JfVF0yW6FzBW+kzGG9mtCyRllg36CvFf41mdvy3lSjobtNnIT1X2CE
         pgdX+Qprf/1X5wuI+vnzx1kCyU72XSZ7szpUogc9NUyepgJPPDNUvQtc89KmqkTB36r3
         sLkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NsGXZKVjnwITEukQUNn3zovirkspDit08UiRlVwi+Ws=;
        b=JRMxFaabNCSMlZCDCt+h74YulXi/NNCnA4GOkRuMOdnpcx1cu0zjWezwGvCKbVowdN
         JcP2eT2Cs1y9eDrK+2qPbQFk+RdnOS+eN3696Scua4bNU3oDeCe4g+B5RuZRuMECFD3c
         6kB9QNtkHys0QF4eWEQpvU+q+sUu6kbguXWXB5U89B8yTNOb3EzQCizeDP0b1CPCEIoY
         3Alg7gy/Jj2tfjxCNKU0DDIZNLKusW+aJeotQNmlg2VOb8UPz0uMk8MgPOpr2/4iiuCQ
         5byt9HHMJNU1C0qiN/zkceewSWrvRNn2erpMO0zL75rcKjiCIaEjy5Ubdv3xki9eALRI
         Tvjg==
X-Gm-Message-State: AGi0PuY8m6HMhh4kU17Fz9feImqqN0U/i2JALbqt4T6Vui+H0fHb5Fid
        fdUcxL5AbN124eqyHiDwbYVVzsNaqyNEBBLTAQY=
X-Google-Smtp-Source: APiQypLOUdTI+f4l2KV3JY1Lt4ZdW/0MsjM4ssFnKKFGV3tb4n8P2k+iMW/Z88rbegr5xPN/wZfE9Btqy3C7SRUEE44=
X-Received: by 2002:a17:90a:fa81:: with SMTP id cu1mr14735775pjb.25.1588843037478;
 Thu, 07 May 2020 02:17:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200505174423.199985-1-ndesaulniers@google.com>
 <CAMzpN2idWF2_4wtPebM2B2HVyksknr9hAqK8HJi_vjQ06bgu2g@mail.gmail.com> <60b16c05ca9e4954a7e4fcdd3075e23d@AcuMS.aculab.com>
In-Reply-To: <60b16c05ca9e4954a7e4fcdd3075e23d@AcuMS.aculab.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 7 May 2020 12:17:05 +0300
Message-ID: <CAHp75VceSvk25rbbS-hmJKAgP4Xe+U6tFQDHBEA=9EHnzBH5+g@mail.gmail.com>
Subject: Re: [PATCH] x86: bitops: fix build regression
To:     David Laight <David.Laight@aculab.com>
Cc:     Brian Gerst <brgerst@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        stable <stable@vger.kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "kernelci . org bot" <bot@kernelci.org>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Ilie Halip <ilie.halip@gmail.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Marco Elver <elver@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Daniel Axtens <dja@axtens.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 7, 2020 at 10:50 AM David Laight <David.Laight@aculab.com> wrote:
> From: Brian Gerst
> > Sent: 07 May 2020 07:18

> > I think a better fix would be to make CONST_MASK() return a u8 value
> > rather than have to cast on every use.
>
> Or assign to a local variable - then it doesn't matter how
> the value is actually calculated. So:
>                         u8 mask = CONST_MASK(nr);

Another case with negation won't work like this I believe.
So, I thin kthe patch we have is good enough, no need to seek for an evil.

-- 
With Best Regards,
Andy Shevchenko
