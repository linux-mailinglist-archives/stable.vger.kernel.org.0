Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB31C31D3BB
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 02:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhBQBUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 20:20:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbhBQBUL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Feb 2021 20:20:11 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E96C061574;
        Tue, 16 Feb 2021 17:19:30 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id e2so2765632ilu.0;
        Tue, 16 Feb 2021 17:19:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=a4x+djdWvyY/y18wtVmluNe/i6nnmv2klaecD6O1IpY=;
        b=rDw0MoKsuIX0ccVjTchBPxzUhKDdWjadd68GwBwFkaCobYwoqdr4aALfiR9PTtwgBe
         Y4Z8BJY2CTVy2jnw7Hz3RCAkwjvSqVm4P1YXI4Rx+2mw/gS18A6vb3qtcSN2ssEOelFE
         qfjzcq+9YX6z+s1vww3+qSjvkBXQNb95fVwiSqUCvtJtuiYrHKiy7hR8r1KGsky43njJ
         Qmlj+nnSzMuCqcqsbadVUJGQHtOl3VrHIFoMHzSEOqMDHrD1O3CuAqEsI9Sln/gFSjkU
         GjK9bo1gOsHS796rI1nNbYyVmGRnFmEj5ElkWQhrVidHzSn5+7pg+Bl2ZV/0G+VqbH8f
         QcYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=a4x+djdWvyY/y18wtVmluNe/i6nnmv2klaecD6O1IpY=;
        b=sR8bUyhN43P6yfUpknPEiSAhwTSZ2bmQnX3V9KY2AVT2II5gSerzfxItHlb629NFX6
         SvTo4lDlmLh13xfK9kGFjjaiMhrji80TsIDDa0zR2dXgknt4P6WBlJi0H5xhs1/vlfpW
         z4/UiiKH9/gUZpjTW0RXvg9ruWZEZApj00CxsyqJaMTXahtEzTMv7f/mLqsdKUUG1QCd
         y3mjhENoAsiXI0qQH/wpKcmTZcmGKJL0gslI6LtwQIs7R1gxrTvW2yfzvEjDS0E74eYX
         hWw2jYRU1mzZIihIbzYBA4RfSnBneY41rMYfX1cRtADbxqG8VoT83/hbxjn7gRlTkGJE
         od/g==
X-Gm-Message-State: AOAM531QGHg/ExWwVpExS+YPASQGyzGGd5KbW704gidsyMj9tpJF9Q3B
        e9q3UiB3tZ8gk/gikVgYhkJhpzWnF9znkw==
X-Google-Smtp-Source: ABdhPJzQ1+zBNZDJEwXFq4rdDJ1ul/EtXVts2a08c3XQ2yCtZqMgX9vyWVq76RBKczOnLlAW2c5d2Q==
X-Received: by 2002:a92:c7c7:: with SMTP id g7mr20701071ilk.304.1613524770363;
        Tue, 16 Feb 2021 17:19:30 -0800 (PST)
Received: from book ([2601:445:8200:6c90::4121])
        by smtp.gmail.com with ESMTPSA id n7sm160428ili.79.2021.02.16.17.19.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 17:19:30 -0800 (PST)
Date:   Tue, 16 Feb 2021 19:19:28 -0600
From:   Ross Schmidt <ross.schm.dev@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/104] 5.10.17-rc1 review
Message-ID: <20210217011928.GA4901@book>
References: <20210215152719.459796636@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 15, 2021 at 04:26:13PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.17 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>

Compiled and booted with no regressions on x86_64.

Tested-by: Ross Schmidt <ross.schm.dev@gmail.com>


thanks,

Ross
