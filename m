Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABB419D367
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 11:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgDCJVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 05:21:38 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54474 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727774AbgDCJVh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 05:21:37 -0400
Received: by mail-wm1-f68.google.com with SMTP id c81so6402021wmd.4
        for <stable@vger.kernel.org>; Fri, 03 Apr 2020 02:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=jHuT6DAScL4tMtP+YdP4mAw8JHh9m0HacngFD8L3u9c=;
        b=BCzo3L+Wx7J8K+wLJfeBZ2xJD+Y1pdha1oXincBCoP81qa8aNUQ2k7I50nHl/QF32U
         LEmaerv0SztTiRe84+ezxM5ktefDA6azMSVmTfXDnlatGX6UO16D/vOy7NtnMgzeC2YJ
         Ak+UmUtOTxC9w8GNhcaTQ9zL5W2ILaneyD6UgNzpQLrD24EixXFX6nwtzkKsCHdi1Ay9
         L4L6i9eWSUy3rHOauysQNLnEJ76jljv/lkbxd+RMasSJXS3PSrHA0bGAhNmhfsRezw8C
         1Cy3UfRVXou73jiqFI5NVFQ26Z5dGrQgbuiX/Y82l/iP0fzmijbCo2VbOJjjeG0w7U1c
         x3uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=jHuT6DAScL4tMtP+YdP4mAw8JHh9m0HacngFD8L3u9c=;
        b=do3a5nNQEe6xBwFQ1kyLva3S0qtpqMCsWSKEZQrG9GPCWAigbiQi3oRFNBX5wQzEmJ
         +zWFwRR2fCCnPSfNRRpfeR4iItf7uJ/yre7HMt/E1eOPir+i9Dgm7NjdC43KvPpgSTwv
         CwiyYAMQxVLKRcpbHSilX2nUY6kR8jbMedAEx9r5K1ChLEzdZg9wkEhoQyUxoZMfp44A
         ynrE9FI6BJQpvClxC4aWMf8mzxc/ZLZwCfq2BdpbjQ0MvHfZ7i+xq3AHdyoP/7Oq1RjQ
         bdvZWqY+wAw8ZNICLNvcMZDrB5T37bsJdusiaZuVw7MN/YjCnDtZtbb8jfxC/eTRZeO3
         RVPw==
X-Gm-Message-State: AGi0PuaEm2/RZUKmRrpV9ZxJJNWLYGE1X253wOjKgFLjF0heKOVZpzm7
        l76BpXaINpLslyNB27dsl4A7uIV6dvo=
X-Google-Smtp-Source: APiQypKvK1664jO6UUF/Uo6YTIzUzjk50u89Xviy8XXeoT18E6JIUaDQMCANhKms/CfakVaKfn/z4Q==
X-Received: by 2002:a05:600c:214b:: with SMTP id v11mr7786299wml.104.1585905695763;
        Fri, 03 Apr 2020 02:21:35 -0700 (PDT)
Received: from dell ([2.27.35.179])
        by smtp.gmail.com with ESMTPSA id a2sm11227122wrp.13.2020.04.03.02.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 02:21:35 -0700 (PDT)
Date:   Fri, 3 Apr 2020 10:22:29 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.19 14/14] lib/list_sort: simplify and remove
 MAX_LIST_LENGTH_BITS
Message-ID: <20200403092229.GC30614@dell>
References: <20200402191220.787381-1-lee.jones@linaro.org>
 <20200402191220.787381-14-lee.jones@linaro.org>
 <20200403091337.GB3739689@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200403091337.GB3739689@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 03 Apr 2020, Greg KH wrote:

> On Thu, Apr 02, 2020 at 08:12:20PM +0100, Lee Jones wrote:
> > From: George Spelvin <lkml@sdf.org>
> > 
> > [ Upstream commit 043b3f7b6388fca6be86ca82979f66c5723a0d10 ]
> > 
> > Rather than a fixed-size array of pending sorted runs, use the ->prev
> > links to keep track of things.  This reduces stack usage, eliminates
> > some ugly overflow handling, and reduces the code size.
> > 
> > Also:
> > * merge() no longer needs to handle NULL inputs, so simplify.
> > * The same applies to merge_and_restore_back_links(), which is renamed
> >   to the less ponderous merge_final().  (It's a static helper function,
> >   so we don't need a super-descriptive name; comments will do.)
> > * Document the actual return value requirements on the (*cmp)()
> >   function; some callers are already using this feature.
> > 
> > x86-64 code size 1086 -> 739 bytes (-347)
> > 
> > (Yes, I see checkpatch complaining about no space after comma in
> > "__attribute__((nonnull(2,3,4,5)))".  Checkpatch is wrong.)
> > 
> > Feedback from Rasmus Villemoes, Andy Shevchenko and Geert Uytterhoeven.
> 
> Random patch chosen from the list, why is this needed?  What issue does
> this fix?  Where did it come from?
> 
> Also, you need to cc: all of the people involved in a patch for when you
> submit them to the stable trees, to give them a chance to weigh in and
> say "no, that should not go there."
> 
> Please do that for all of these series, and provide a 00/XX email.  I'm
> dropping them all from my queue for now, thanks.

Will do.  Thanks for the feedback.

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
