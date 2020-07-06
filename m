Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D0B2155EC
	for <lists+stable@lfdr.de>; Mon,  6 Jul 2020 12:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbgGFKz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 06:55:56 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38027 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728606AbgGFKzx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jul 2020 06:55:53 -0400
Received: by mail-wm1-f66.google.com with SMTP id f18so41433293wml.3;
        Mon, 06 Jul 2020 03:55:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=biFGacWJgPGBoPEjc+gEhsuak0pUoudIvrL6jPqp5rY=;
        b=QYj6UVyQYvLTFsB1bwGKIXJebSW7oFYH8r2SQ2+/gvLdkISzoTlBzqhLVZqlPiHqI4
         tGJPrZb3MElQbOAFSIpzWURZbnQdT6MFF9pxd0pKF7uqM+zKsD4kYigqw+oaCVVcenYM
         bhGL0ciTWiqQGCktIxdG+n6/6Le0YBJHVSvCV2jURX5U0hSgOs1n1yy53H3CXgUpgN65
         ohTVVfJ6OZr3htooPVrnvtw4jR0gexwnzUlmeSQPrAZ9DPxE6RoGwiVJmunTuhx7B5za
         63KsFv2hkrE5xeoxXraj7/H8yaatlKfpVpwXpEa8lO/5xsxvVkpmzLlsdLLS3oy5bPsE
         fjww==
X-Gm-Message-State: AOAM531m7Fg9uv1a7K5R8CShZCSMHj8Wv73MVlLihKQ0Dem0FYBYYOlq
        GdCm0n6hiS/VID+xIJo9wDI=
X-Google-Smtp-Source: ABdhPJxvL4DLGcSfAF1wuY/syeA0ZaxjaTza+5lAGocr9nlRFiFYDsr+n/IOkkgWYU/KED1nKdhRdg==
X-Received: by 2002:a1c:2109:: with SMTP id h9mr5668923wmh.174.1594032950905;
        Mon, 06 Jul 2020 03:55:50 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id w13sm23182400wrr.67.2020.07.06.03.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 03:55:50 -0700 (PDT)
Date:   Mon, 6 Jul 2020 10:55:49 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Joseph Salisbury <joseph.salisbury@microsoft.com>,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH][v2] Drivers: hv: Change flag to write log level in panic
 msg to false
Message-ID: <20200706105549.xum3y7hmviatil2w@liuwe-devbox-debian-v2>
References: <1593210497-114310-1-git-send-email-joseph.salisbury@microsoft.com>
 <20200701193326.12D69214DB@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701193326.12D69214DB@mail.kernel.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 01, 2020 at 07:33:25PM +0000, Sasha Levin wrote:
> Hi
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v5.7.6, v5.4.49, v4.19.130, v4.14.186, v4.9.228, v4.4.228.
> 
> v5.7.6: Build OK!
> v5.4.49: Failed to apply! Possible dependencies:
>     53edce00ceb74 ("Drivers: hv: vmbus: Remove dependencies on guest page size")

Unrelated, shouldn't be backported.

> 
> v4.19.130: Failed to apply! Possible dependencies:
>     53edce00ceb74 ("Drivers: hv: vmbus: Remove dependencies on guest page size")
> 

Unrelated, shouldn't be backported.

> v4.14.186: Failed to apply! Possible dependencies:
>     4a5f3cde4d51c ("Drivers: hv: vmbus: Remove x86-isms from arch independent drivers")
>     53edce00ceb74 ("Drivers: hv: vmbus: Remove dependencies on guest page size")
>     7ed4325a44ea5 ("Drivers: hv: vmbus: Make panic reporting to be more useful")
>     81b18bce48af3 ("Drivers: HV: Send one page worth of kmsg dump over Hyper-V during panic")
>     8afc06dd75c06 ("Drivers: hv: vmbus: Fix the issue with freeing up hv_ctl_table_hdr")
>     ddcaf3ca4c3c8 ("Drivers: hv: vmus: Fix the check for return value from kmsg get dump buffer")
> 
> v4.9.228: Failed to apply! Possible dependencies:
>     4a5f3cde4d51c ("Drivers: hv: vmbus: Remove x86-isms from arch independent drivers")
>     6ab42a66d2cc1 ("Drivers: hv: vmbus: Move Hypercall invocation code out of common code")
>     73638cddaad86 ("Drivers: hv: vmbus: Move the check for hypercall page setup")
>     76d36ab798204 ("hv: switch to cpuhp state machine for synic init/cleanup")
>     81b18bce48af3 ("Drivers: HV: Send one page worth of kmsg dump over Hyper-V during panic")
>     8730046c1498e ("Drivers: hv vmbus: Move Hypercall page setup out of common code")
>     d058fa7e98ff0 ("Drivers: hv: vmbus: Move the crash notification function")
> 
> v4.4.228: Failed to apply! Possible dependencies:
>     4a5f3cde4d51c ("Drivers: hv: vmbus: Remove x86-isms from arch independent drivers")
>     619848bd07434 ("drivers:hv: Export a function that maps Linux CPU num onto Hyper-V proc num")
>     6ab42a66d2cc1 ("Drivers: hv: vmbus: Move Hypercall invocation code out of common code")
>     73638cddaad86 ("Drivers: hv: vmbus: Move the check for hypercall page setup")
>     75ff3a8a9168d ("Drivers: hv: vmbus: avoid wait_for_completion() on crash")
>     76d36ab798204 ("hv: switch to cpuhp state machine for synic init/cleanup")
>     81b18bce48af3 ("Drivers: HV: Send one page worth of kmsg dump over Hyper-V during panic")
>     8730046c1498e ("Drivers: hv vmbus: Move Hypercall page setup out of common code")
>     a108393dbf764 ("drivers:hv: Export the API to invoke a hypercall on Hyper-V")
>     d058fa7e98ff0 ("Drivers: hv: vmbus: Move the crash notification function")

Just from reading the subject lines it seems to me a lot of the possible
dependencies aren't really related to this patch functionally. It could
be that they are touching the same area of code which create some
contextual dependencies. Some of the listed dependencies should
definitively _not_ be backported.

Michael and Joseph, how far do you want this to be backported? It may be
easier for us to provide bespoke versions of this patch to the stable
trees we care about?

Wei.

> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?
> 
> -- 
> Thanks
> Sasha
