Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74F3F187B27
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 09:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgCQI06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 04:26:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43946 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbgCQI05 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 04:26:57 -0400
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jE7Yt-0005u6-E9; Tue, 17 Mar 2020 08:26:55 +0000
Date:   Tue, 17 Mar 2020 09:26:54 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux- stable <stable@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Todd Kjos <tkjos@google.com>, Shuah Khan <shuah@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>, tkjos@android.com,
        ardb@kernel.org, Kees Cook <keescook@chromium.org>,
        lkft-triage@lists.linaro.org, Basil Eljuse <Basil.Eljuse@arm.com>,
        YongQin Liu <yongqin.liu@linaro.org>
Subject: Re: [stable-rc-5.4 and 5.5 ] WARNING: CPU: 3 PID: 2548 at
 /usr/src/kernel/lib/refcount.c:28 refcount_warn_saturate
Message-ID: <20200317082654.zl6piqg6kbc43ivm@wittgenstein>
References: <CA+G9fYu06RPexAK-4huCSwYC4=FkuH2QduVpxOgG43ojX2jyBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+G9fYu06RPexAK-4huCSwYC4=FkuH2QduVpxOgG43ojX2jyBA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 17, 2020 at 01:15:40PM +0530, Naresh Kamboju wrote:
> While running selftests binderfs_test on stable rc 5.4 and 5.5
> branches the following
> warning on arm64, arm, x86_64 and i386.
> 
> This warning was noticed on Linus's tree and reported [1] and then
> Christian Brauner investigated this problem.

I've sent a fix (You should've been Cced on.) which has made it into
Greg's tree so should land in mainline soon. I've also made sure to Cc
stable meaning it should land in all relevant kernels soon after. Please
see:
https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/commit/?h=char-misc-linus&id=211b64e4b5b6bd5fdc19cd525c2cc9a90e6b0ec9

Thanks!
Christian
