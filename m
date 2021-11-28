Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD6946057D
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 10:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357021AbhK1Jva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 04:51:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240660AbhK1Jta (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 04:49:30 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F116C061574;
        Sun, 28 Nov 2021 01:46:14 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id t9so12626225wrx.7;
        Sun, 28 Nov 2021 01:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=MyxG4fZuu+tZlzqJDqxR4dVlSnGITUq8koTwfVub/a8=;
        b=QrZMkCn+j6+bK+NlmSrz5Um0jgoGm9qle6SWq2Tr9wdHc1gKAvd72yGwox4NzdGUdH
         8zWrlp6UIDmukQ0FI5gy9YRXsHKdYFi9KpgCGbvJJTcY5wao7OUV206nTIlz7ZqzmtNU
         pog+IwHDCKn4aQbBpDkpoSmgzcN2o06KrLge23CH7XLfyziuYBUFs5qK0S2fTa9epa8o
         aN89tcTJ7s6JzB2w+tqVg0V1uR4DiGcMFQD9kSGRb7ueqN+gBe/IyrbjfBb+Ukvi/Gmz
         LShk8EpMolVVdatVNfdId1RQ1ESrgxiaEPX8XqKTdIQ7ytvBlPo9lwRU3azYSIDPFbUn
         ZqRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=MyxG4fZuu+tZlzqJDqxR4dVlSnGITUq8koTwfVub/a8=;
        b=Jsy5vjJ2tMKxAkC0dwHTHiwDTBkGhlCz68KY+Y0Ek6KknYWGik/bzy0sl9DwXBXIV7
         reAaFerDFip5XvqBlTcEo/8q+TxyGI7XF4j8644bwYhnctexYQ3MqM07NwlGmaEjWc4P
         9j/TqfqIC9/tAOkUCJ/U9tCgA2/PysrPwmYi22LS8QLaB7MWc3B2iMrcKFvzghzfKlqU
         Jfmsf8AIfM5HAKnd5jYU3KITrocoa1htMrXtJIo0cvnTbPwaX/GsvCdSvTE7Z8jZsArX
         pMW0tCKujtQHD4A7SMcvAalhRZfuyJYSe0uVtbiUrULGslKDY2IGS5oSeb97TQg7hilE
         efNg==
X-Gm-Message-State: AOAM533GO5ohNovfq6ZUakq36gA2RKmyBLhlesGKJhJaAkI6xBP1qwA+
        HZ05jIFNVdB7VGh2zeFJyt3hA3ocMdb8Fg==
X-Google-Smtp-Source: ABdhPJxTTa6uZl+HmYtxgDzC9p7fkNcCeg2eRP9jtICua0t9IkNrWJw7UEJpmoyrTKvJKtV8vb8Y1Q==
X-Received: by 2002:a5d:69ce:: with SMTP id s14mr26150329wrw.25.1638092773102;
        Sun, 28 Nov 2021 01:46:13 -0800 (PST)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id x4sm15567607wmi.3.2021.11.28.01.46.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 01:46:12 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Sun, 28 Nov 2021 10:46:11 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 088/323] locking/lockdep: Avoid RCU-induced noinstr
 fail
Message-ID: <YaNP46ypf6xcTcJH@eldamar.lan>
References: <20211124115718.822024889@linuxfoundation.org>
 <20211124115721.937655496@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211124115721.937655496@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Wed, Nov 24, 2021 at 12:54:38PM +0100, Greg Kroah-Hartman wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> [ Upstream commit ce0b9c805dd66d5e49fd53ec5415ae398f4c56e6 ]
> 
> vmlinux.o: warning: objtool: look_up_lock_class()+0xc7: call to rcu_read_lock_any_held() leaves .noinstr.text section

For 4.19.218 at least this commit seems to cause a build failure for
cpupower, if warnings are treated as errors, I have not seen the same
for the 5.10.80 build:

gcc -g -O2 -fstack-protector-strong -Wformat -Werror=format-security -DVERSION=\"4.19\" -DPACKAGE=\"cpupower\" -DPACKAGE_BUGREPORT=\"Debian\ \(reportbug\ linux-cpupower\)\" -D_GNU_SOURCE -pipe -DNLS -Wall -Wchar-subscripts -Wpointer-arith
 -Wsign-compare -Wno-pointer-sign -Wdeclaration-after-statement -Wshadow -Os -fomit-frame-pointer -fPIC -o /home/build/linux-4.19.218/debian/build/build-tools/tools/power/cpupower/lib/cpupower.o -c lib/cpupower.c
In file included from lockdep.c:28:
../../../kernel/locking/lockdep.c: In function ‘look_up_lock_class’:
../../../kernel/locking/lockdep.c:694:2: error: implicit declaration of function ‘hlist_for_each_entry_rcu_notrace’; did you mean ‘hlist_for_each_entry_continue’? [-Werror=implicit-function-declaration]
  hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  hlist_for_each_entry_continue
../../../kernel/locking/lockdep.c:694:53: error: ‘hash_entry’ undeclared (first use in this function); did you mean ‘hash_ptr’?
  hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
                                                     ^~~~~~~~~~
                                                     hash_ptr
../../../kernel/locking/lockdep.c:694:53: note: each undeclared identifier is reported only once for each function it appears in
../../../kernel/locking/lockdep.c:694:64: error: expected ‘;’ before ‘{’ token
  hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
                                                                ^~
                                                                ;
../../../kernel/locking/lockdep.c:706:1: warning: control reaches end of non-void function [-Wreturn-type]
 }
 ^
cc1: some warnings being treated as errors
make[5]: *** [/home/build/linux-4.19.218/tools/build/Makefile.build:97: /home/build/linux-4.19.218/debian/build/build-tools/tools/lib/lockdep/lockdep.o] Error 1
make[4]: *** [Makefile:121: /home/build/linux-4.19.218/debian/build/build-tools/tools/lib/lockdep/liblockdep-in.o] Error 2
make[4]: Leaving directory '/home/build/linux-4.19.218/tools/lib/lockdep'
make[3]: *** [/home/build/linux-4.19.218/debian/rules.d/tools/lib/lockdep/Makefile:16: all] Error 2
make[3]: Leaving directory '/home/build/linux-4.19.218/debian/build/build-tools/tools/lib/lockdep'
make[2]: *** [debian/rules.real:795: build-liblockdep] Error 2
make[2]: *** Waiting for unfinished jobs....

I was not yet able to look further on it.

Regards,
Salvatore
