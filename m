Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FAE13368AA
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 01:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhCKAau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 19:30:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbhCKAa3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 19:30:29 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DCBCC061574
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 16:30:28 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id o1so56064qta.13
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 16:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Mmc0RuUOlCFvulxidW/k2Ie5WhinDkDwZmLnUv3DwVg=;
        b=K0TTKTAUf0dPXP7nNJPS8qIcDoLTv9HQdRbLC+7/Z+r2605f+QGmAlJn2t2I8oopeX
         OtiBwgihuy2tjV3b/2DIBXC1x2SygPnjSJXMAWUl8yDCJMXpZwv21X1KcsKplLRkalKF
         +ioL1l1XxeQvA7ntGR/s0XSTA2XdQQjXnaOChWHNZWYRU94RW6c+ze8qDOjTp4D5+u96
         Kblc1Aonn001vYVB8/11jA2OGx7n99poT2/P0iQZmENXZ1IvGZUt61y9MJY6atQxWY1Y
         kMye4b4xWX9qfFf+pFW4vgokxZKm3MrFzdRkFu5E+MdBepzIHVakZ4GAsfB0jfkkSSqF
         wavw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Mmc0RuUOlCFvulxidW/k2Ie5WhinDkDwZmLnUv3DwVg=;
        b=PBjwT5tylkfHmAxMG54eh709stqehUaWKg1TdGI9tMDcYtLpMtlW2hu7/dj2IO37pq
         9OghpBrz3mz6CE7t/xLlxXjjbRot5KxhbRZlv3cJwXssB9U4++rNYrx1YGDTXygzl8ih
         cgsyuiJAbgxnZtXadLRZur5nA/yvKZUkLcxjE2V7X9tXUKohZ9UEmy9CdZaE9/oExRQZ
         RvukkZEckojifRz6s0+2HYn9ovGoG4nbD1TmV+bymhiuBfFKhJUyWkeaGY2PWvzgO1fr
         AYhgNRdDfZQavLSDpQ+tI3shDCUZ2MDdoGwvNGhsvUa3g2fohjrmMZSqk5GqQ80mK1eT
         8Lcw==
X-Gm-Message-State: AOAM533w3ZYcmULY9dd4cWTlKEpg/ogs7plSCShYJtkUoyYHwtE0Jbt/
        1YE5iqOhvgKZSCMvsTV3GGm9lQ==
X-Google-Smtp-Source: ABdhPJy/HscA2IVpxWWAjD5lhf70Ts/MUuwJKSD65SIfCEGU3adAV+25h6xuHbsrx6TTpui9/qcQxA==
X-Received: by 2002:ac8:5a15:: with SMTP id n21mr5278107qta.85.1615422627496;
        Wed, 10 Mar 2021 16:30:27 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-115-133.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.115.133])
        by smtp.gmail.com with ESMTPSA id j2sm707607qkk.96.2021.03.10.16.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 16:30:27 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1lK9De-00Ayzo-Kd; Wed, 10 Mar 2021 20:30:26 -0400
Date:   Wed, 10 Mar 2021 20:30:26 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     akpm@linux-foundation.org
Cc:     aarcange@redhat.com, bgardon@google.com, dimitri.sivanich@hpe.com,
        hannes@cmpxchg.org, jglisse@redhat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, rientjes@google.com, seanjc@google.com,
        stable@vger.kernel.org
Subject: Re: +
 mm-oom_kill-ensure-mmu-notifier-range_end-is-paired-with-range_start.patch
 added to -mm tree
Message-ID: <20210311003026.GR444867@ziepe.ca>
References: <20210311000616.GIEHU6C1Q%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311000616.GIEHU6C1Q%akpm@linux-foundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On Wed, Mar 10, 2021 at 04:06:16PM -0800, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: mm/oom_kill: ensure MMU notifier range_end() is paired with range_start()
> has been added to the -mm tree.  Its filename is
>      mm-oom_kill-ensure-mmu-notifier-range_end-is-paired-with-range_start.patch

Let's please wait till the discussion settles, to my mind this patch is not
an improvement.

Thanks,
Jason
