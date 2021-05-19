Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECBC389226
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 17:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348610AbhESPDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 11:03:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242412AbhESPDH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 May 2021 11:03:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4041660234;
        Wed, 19 May 2021 15:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621436507;
        bh=Q5eIlg5LSx2STi4YVXQI/A2oVrFJFwFi3xVlXGqvZuE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y779r6qv8Zx073LLqKKMr6QX15CwVKqVP4yKYKE+Rb++aFcAr0I2euNTJ6+Csu4q7
         gEtMQ4qB6rSUfiRJdYHL3DkPUYLoiRfnTMS3VJ0ZRaLMAjPmcto6FO66XM2EzXvGNi
         sniuoLpXtcqw21etFwNUsGG2NK5v7lC3HrIQQCxaMh+VsjlG5+MkySQLh5ZsPD1FVk
         X4MVlJQkGOXl5WHeQIRTizu4WtEHmdJJ/p8giSow1oovUIzZqaGwH5cmShQ+VFQiw8
         QbjgD79lkQAPmzIaBQirdpNq2v2Hc5zFfpeJ7cs45tr2k2cYXWT9sFzhidrY6f0bEe
         eYZXZn/JAiw2A==
Date:   Wed, 19 May 2021 11:01:46 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: please pick d6d43a921720 to 5.4.y and 4.19.y
Message-ID: <YKUoWlj66VtqO6aM@sashalap>
References: <CAKwvOd=iaL8_e4gxBPAzZbgCHtMy=gLi1YT9ja5Q_9+dE-L==w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKwvOd=iaL8_e4gxBPAzZbgCHtMy=gLi1YT9ja5Q_9+dE-L==w@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 18, 2021 at 02:13:56PM -0700, Nick Desaulniers wrote:
>Dear stable kernel maintainers,
>Please consider cherry picking
>commit d6d43a921720 ("pinctrl: ingenic: Improve unreachable code generation")
>to linux-5.4.y and linux-4.19.y.  It first landed in v5.7-rc1.
>
>It fixes an warning from objtool reported by 0day bot in:
>https://groups.google.com/g/clang-built-linux/c/bSNh_MA6MFU
>and applies cleanly to both branches.

I'll grab it, thanks!

-- 
Thanks,
Sasha
