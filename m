Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28FB2393266
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 17:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235888AbhE0P1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 11:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235017AbhE0P1L (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 11:27:11 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE444C061574
        for <stable@vger.kernel.org>; Thu, 27 May 2021 08:25:38 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id y202so840477pfc.6
        for <stable@vger.kernel.org>; Thu, 27 May 2021 08:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=hWTSzwjfzvK9r78Jc0BKAqGfhQvOyMWlnIJcqhHnqTs=;
        b=cYd7lPfwcGq0TRoHkfrzvW5Dix41MvESnghpVto3fTkNPGqD6oAy1QzKW/YVGrDaPM
         i8L9XPIh1GC8gzEN/kxTdWAOdwUnkEL+kml/F8yc2F9PhwgLm05NvG99A04RK/wZcil3
         ratMVh5vI7NQapvM/ZPvTBOFIuwLhRIh4q3OROHR2izPRLN7TdT9DeprAynvZEeb675h
         YPGAZ4q/qYW0DYAxJmEKgLbX8vY+pZahMuo5LcLf+/wC6LqJ11wdUDvXPLfXibmr6ikz
         82T52/vUOryfwG7udNrS2Ygf4VelmIqK1oYuUYcvG1rjqbXkw8y/TPJvj5UHUtudLDOB
         Yk9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=hWTSzwjfzvK9r78Jc0BKAqGfhQvOyMWlnIJcqhHnqTs=;
        b=H+OmYJ91Z6yEjoB4+bmTwvxMNhhWYeDRWPjEYtM6legpN3X/63THNwuzT51x4wdp72
         hUxWzWlZCiipuDJZ3dVPfs3VAWmlcFhzqeiYf8/zSIm4/r7vG4yBikkpEP1pMxND6aXT
         xuaPqItDg4wNFOlkgN6+pOoeg6nrLd+nUbcoQm2KIau+37OgyPg5xtCBpi8ONyU/GyEs
         JU+7KjN89h02yaYIe/ydnauI5C1X/QXxmJ6Hv2MFk4toMOXSJOYtkDT+/3niEp6uomW/
         jxgbMp0YzJVU2YG8gBTR96KEsnl1XwQKLCK/KL6zyrkhsgxvlmSu5X3QZ4rB0Obk037H
         VWLQ==
X-Gm-Message-State: AOAM530rESsNkSdTSYSKAclHeEZ0QS9jdSw6/dGYNHc5gf3crl0PXsR0
        ZMGolIa9anYBtcgn4bgB2XoCJA==
X-Google-Smtp-Source: ABdhPJyC3Afb91ppmA57gaadCtg0WwcU9xVeUTSm0GT6J185uZPKBl+rLNlyDZ8yyd9y+83mfnwJXw==
X-Received: by 2002:a63:4145:: with SMTP id o66mr4225300pga.4.1622129138170;
        Thu, 27 May 2021 08:25:38 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id y66sm2082841pgb.14.2021.05.27.08.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 08:25:37 -0700 (PDT)
Date:   Thu, 27 May 2021 15:25:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jack Wang <jack.wang.usish@gmail.com>, wanpengli@tencent.com,
        tglx@linutronix.de, stable <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] KVM: x86: Defer vtime accounting 'til
 after IRQ handling" failed to apply to 5.10-stable tree
Message-ID: <YK+57TTRNIhk6xCh@google.com>
References: <1621006676203106@kroah.com>
 <CA+res+S2Jb2_pJFFDRQvizzm2s7yuaKJkqO16WoUT6hM9c0Neg@mail.gmail.com>
 <YK9jzz3vOMNJdAo1@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YK9jzz3vOMNJdAo1@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 27, 2021, Greg Kroah-Hartman wrote:
> On Wed, May 26, 2021 at 08:08:09AM +0200, Jack Wang wrote:
> > <gregkh@linuxfoundation.org> 于2021年5月14日周五 下午9:32写道：
> > >
> > >
> > > The patch below does not apply to the 5.10-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > 
> > If I first apply 866a6dadbb02 ("context_tracking: Move guest exit
> > context tracking to separate helpers")
> > and 88d8220bbf06 ("context_tracking: Move guest exit vtime accounting
> > to separate helpers")
> > 
> > then I can apply this commit cleanly to latest 5.10.y, I suppose it
> > will work for 5.12.

Thanks much!

> That worked, thanks!  Now queued up.

To not mess up in the future, I assume known dependencies should be tagged
"Cc: stable...", even if the dependencies aren't technically bug fixes?
The plan all along was that all three patches would have to be picked up, but
apparently I thought that would happen automagically.
