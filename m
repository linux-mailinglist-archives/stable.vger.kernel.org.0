Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF0B11BCCE
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 20:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfLKTYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 14:24:17 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:57031 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726487AbfLKTYQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 14:24:16 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id ed70bf81;
        Wed, 11 Dec 2019 18:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=gip64HzuPsRga8Ne1H0spaLLqWk=; b=RcGYxF
        oM4SIcha9hDO2hJ7XxaC2cX6SQzfwcyFknujl2JF3V9Qw40sAbueZOosBY7OTgj7
        jWjMpdmyOeZcm8WGFMxXiCgLh5crvnxZzaJDp6yPXIg7jGtFRyfWcOaWUoSQNU3m
        m84uawJNz8NrMX+tUSqBM/EJMr3f7ceVyJ1HovVULPTAhEjIXxppsTTQwNrPKkh7
        XuwuINx9LnXRfXQmxOXGmt+BA2wqIvDMy60CI5fOprD6SYvJR0EsDB6LioZXHIDo
        bCEVQ0xsMH5lwhtXj4Wy8QxY5FmqJvg8bHYA6mWk6vAdfIozfXHzf7xej53guSop
        ZpmQsrq/I/Ej+lFQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f9fd5fd7 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Wed, 11 Dec 2019 18:28:31 +0000 (UTC)
Received: by mail-ot1-f50.google.com with SMTP id r27so898388otc.8;
        Wed, 11 Dec 2019 11:24:13 -0800 (PST)
X-Gm-Message-State: APjAAAXxAR0ihLrT+omEE1A/S+M0MJa2lTLI9SVvH49PwSEGIKMgFIvQ
        HZJZt/Xi/8Ur7ozsM8E7b1a+hBTHALo1tifXI6M=
X-Google-Smtp-Source: APXvYqwe23otDtpvnVTakdxZ1Y+wYxXtFKXiUijpXUYbq80PPqi8E4wy4+tu7boWmi7rJ0yN5+O+RztE2/gENDnebrY=
X-Received: by 2002:a9d:674f:: with SMTP id w15mr3591941otm.243.1576092252458;
 Wed, 11 Dec 2019 11:24:12 -0800 (PST)
MIME-Version: 1.0
References: <20191203205716.1228-1-Jason@zx2c4.com> <20191211163646.13A212073D@mail.kernel.org>
In-Reply-To: <20191211163646.13A212073D@mail.kernel.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 11 Dec 2019 20:24:01 +0100
X-Gmail-Original-Message-ID: <CAHmME9p6o3__NL_KMrreS+MtWJ6Uu2sxzHy5ZOf2Mkw9MWpzFA@mail.gmail.com>
Message-ID: <CAHmME9p6o3__NL_KMrreS+MtWJ6Uu2sxzHy5ZOf2Mkw9MWpzFA@mail.gmail.com>
Subject: Re: [PATCH] x86/quirks: disable HPET on Intel Coffee Lake Refresh platforms
To:     Sasha Levin <sashal@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Wed, Dec 11, 2019 at 6:36 PM Sasha Levin <sashal@kernel.org> wrote:
>
> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v5.4.2, v5.3.15, v4.19.88, v4.14.158, v4.9.206, v4.4.206.
>
> v5.4.2: Build OK!
> v5.3.15: Build OK!
> v4.19.88: Failed to apply! Possible dependencies:
>     fc5db58539b4 ("x86/quirks: Disable HPET on Intel Coffe Lake platforms")
>
> v4.14.158: Failed to apply! Possible dependencies:
>     fc5db58539b4 ("x86/quirks: Disable HPET on Intel Coffe Lake platforms")
>
> v4.9.206: Failed to apply! Possible dependencies:
>     fc5db58539b4 ("x86/quirks: Disable HPET on Intel Coffe Lake platforms")
>
> v4.4.206: Failed to apply! Possible dependencies:
>     fc5db58539b4 ("x86/quirks: Disable HPET on Intel Coffe Lake platforms")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?

It probably makes sense to backport the dependency commit mentioned.

Jason
