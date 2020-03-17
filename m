Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD1A6187B38
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 09:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgCQI3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 04:29:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbgCQI3O (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 04:29:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA28E205ED;
        Tue, 17 Mar 2020 08:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584433754;
        bh=2WT19PmoSgn1gbaCPBHuh8j2hU+YYvbYMVaBBYTbuJ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DYJdFepvuwK7WXbswP6UaKoHadSVJZYbmVJ+0otsGBM/ur0pKMLC6W6kPMSTGjkYS
         1oHUKMMykE5jQilMICWfonmCux+gBo59njjHpAPBphYqcl8vAa9bx9uQZd8gAw69zV
         yd1XlvJdVeXmGJAcXVHAzDU7xrvgwlTS8DBvMKMY=
Date:   Tue, 17 Mar 2020 09:29:10 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux- stable <stable@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        open list <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Todd Kjos <tkjos@google.com>, Shuah Khan <shuah@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>, tkjos@android.com,
        ardb@kernel.org, Kees Cook <keescook@chromium.org>,
        lkft-triage@lists.linaro.org, Basil Eljuse <Basil.Eljuse@arm.com>,
        YongQin Liu <yongqin.liu@linaro.org>
Subject: Re: [stable-rc-5.4 and 5.5 ] WARNING: CPU: 3 PID: 2548 at
 /usr/src/kernel/lib/refcount.c:28 refcount_warn_saturate
Message-ID: <20200317082910.GB1063543@kroah.com>
References: <CA+G9fYu06RPexAK-4huCSwYC4=FkuH2QduVpxOgG43ojX2jyBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
> 
> FYI, We are running selftests source from stable rc 5.5 branch.

There is a fix in my tree that will go to Linus for this this week.

thanks,

greg k-h
