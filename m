Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C8321C4FB
	for <lists+stable@lfdr.de>; Sat, 11 Jul 2020 18:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbgGKQB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jul 2020 12:01:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54025 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728412AbgGKQB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jul 2020 12:01:56 -0400
Received: from ip5f5af08c.dynamic.kabel-deutschland.de ([95.90.240.140] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1juHwn-00008h-RL; Sat, 11 Jul 2020 16:01:53 +0000
Date:   Sat, 11 Jul 2020 18:01:53 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Will Deacon <will@kernel.org>, stable@vger.kernel.org,
        Tycho Andersen <tycho@tycho.ws>, Shuah Khan <shuah@kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-next/seccomp v2 2/2] selftests/seccomp: Set NNP for
 TSYNC ESRCH flag test
Message-ID: <20200711160153.33bypdolunefsdlw@wittgenstein>
References: <20200710230107.2528890-1-keescook@chromium.org>
 <20200710230107.2528890-3-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200710230107.2528890-3-keescook@chromium.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 10, 2020 at 04:01:07PM -0700, Kees Cook wrote:
> The TSYNC ESRCH flag test will fail for regular users because NNP was
> not set yet. Add NNP setting.
> 
> Fixes: 51891498f2da ("seccomp: allow TSYNC and USER_NOTIF together")
> Cc: stable@vger.kernel.org
> Reviewed-by: Tycho Andersen <tycho@tycho.ws>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---

Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
