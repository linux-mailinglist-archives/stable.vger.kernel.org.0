Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096063A0C96
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 08:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236812AbhFIGmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 02:42:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232644AbhFIGmH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 02:42:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C77B61181;
        Wed,  9 Jun 2021 06:40:11 +0000 (UTC)
Date:   Wed, 9 Jun 2021 08:40:08 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrea Righi <andrea.righi@canonical.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        regressions@lists.linux.dev
Subject: Re: [PATCH] proc: Track /proc/$pid/attr/ opener mm_struct
Message-ID: <20210609064008.liz2gvpjtyqwx6qr@wittgenstein>
References: <20210608171221.276899-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210608171221.276899-1-keescook@chromium.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 08, 2021 at 10:12:21AM -0700, Kees Cook wrote:
> Commit bfb819ea20ce ("proc: Check /proc/$pid/attr/ writes against file opener")
> tried to make sure that there could not be a confusion between the opener of
> a /proc/$pid/attr/ file and the writer. It used struct cred to make sure
> the privileges didn't change. However, there were existing cases where a more
> privileged thread was passing the opened fd to a differently privileged thread
> (during container setup). Instead, use mm_struct to track whether the opener
> and writer are still the same process. (This is what several other proc files
> already do, though for different reasons.)
> 
> Reported-by: Christian Brauner <christian.brauner@ubuntu.com>
> Reported-by: Andrea Righi <andrea.righi@canonical.com>
> Tested-by: Andrea Righi <andrea.righi@canonical.com>
> Fixes: bfb819ea20ce ("proc: Check /proc/$pid/attr/ writes against file opener")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---

Thanks!
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
