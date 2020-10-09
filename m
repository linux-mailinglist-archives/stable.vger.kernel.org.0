Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370C8288811
	for <lists+stable@lfdr.de>; Fri,  9 Oct 2020 13:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732520AbgJILuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 07:50:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56783 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732480AbgJILuX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Oct 2020 07:50:23 -0400
Received: from ip5f5af0a0.dynamic.kabel-deutschland.de ([95.90.240.160] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1kQquc-000710-Sn; Fri, 09 Oct 2020 11:50:14 +0000
Date:   Fri, 9 Oct 2020 13:50:14 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Aleksa Sarai <cyphar@cyphar.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Shuah Khan <shuah@kernel.org>,
        containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] openat2: reject RESOLVE_BENEATH|RESOLVE_IN_ROOT
Message-ID: <20201009115014.ft7kjyejhqvommnv@wittgenstein>
References: <20201007103608.17349-1-cyphar@cyphar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201007103608.17349-1-cyphar@cyphar.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 07, 2020 at 09:36:08PM +1100, Aleksa Sarai wrote:
> This was an oversight in the original implementation, as it makes no
> sense to specify both scoping flags to the same openat2(2) invocation
> (before this patch, the result of such an invocation was equivalent to
> RESOLVE_IN_ROOT being ignored).
> 
> This is a userspace-visible ABI change, but the only user of openat2(2)
> at the moment is LXC which doesn't specify both flags and so no
> userspace programs will break as a result.

Indeed!

> 
> Fixes: fddb5d430ad9 ("open: introduce openat2(2) syscall")
> Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
> Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
> Cc: <stable@vger.kernel.org> # v5.6+
> ---

Thanks! This is a good fix imho.
Christian
