Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3340A45A5C4
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 15:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236113AbhKWOj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 09:39:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238223AbhKWOj6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 09:39:58 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE67C061574
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 06:36:50 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id x10so28217454ioj.9
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 06:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5s+PTaOidkzwPxizEEm3X1Q+YXlkNEJeP8EdC5QP65A=;
        b=d5gMZDfxtH8H7JOXvQiwU2AeOrRq+I28WAjPvAmVEC4Y5abDufD52+Fb5sXMcFaRWB
         bKMuQJ4x92eP5Vo1ytq97ZKTQbCybtsnDST6w7uEgsbOu1TI3NQhZr5eQai/dA5OHYTh
         Zjj1ZewN0/PCSKMgStPWEEpjbpcezWw7jIQ38=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5s+PTaOidkzwPxizEEm3X1Q+YXlkNEJeP8EdC5QP65A=;
        b=o5Ja/+qRCwKH2CYhrlLo7dF8AiscmyOlPfv1oY2G4b33n78gOqR2oLaPS1HENGU+6S
         5htiZdiv9DDPgA7B6bvBKiJFDcWqGCllr78BKZh3eDVf/382r0oISmg6vuLbWHi9FBvD
         kziQqwEiEYso+LUhHW+i3oYkkogzXzupShoUtpyBwqEYas/c/oVNR3hjiroN2znQR4Jf
         5CigUA2nzAXKFrCT9W3yY+zxtN3UKh51+l29VL2EaXE/A7a7zog0AoTqPTznk/QpM1lk
         zKIYYi8zDfebIGJX/Bt3UwJy+GbYGHUBSRJ71PP/1hotFXy+ErrQzkvNEQNtbsPQOwkc
         Dolw==
X-Gm-Message-State: AOAM533mRfqSgAbric7ZLzbnwB7I5ZYKXzcKwDEnAQx8fKfhyBuJE51v
        huNa4yZce56W14txWD3JaIP4wA==
X-Google-Smtp-Source: ABdhPJxKMNzk2ruDNOvnXz6TD3uBqEDYSYgT93HsWkxB5ZtOLPAon6dCOG262yLD8r7xPm4YS/Wluw==
X-Received: by 2002:a6b:f715:: with SMTP id k21mr6698606iog.96.1637678209678;
        Tue, 23 Nov 2021 06:36:49 -0800 (PST)
Received: from meerkat.local (bras-base-mtrlpq5031w-grc-32-216-209-220-181.dsl.bell.ca. [216.209.220.181])
        by smtp.gmail.com with ESMTPSA id q8sm3331761iow.47.2021.11.23.06.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 06:36:49 -0800 (PST)
Date:   Tue, 23 Nov 2021 09:36:47 -0500
From:   Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To:     "Fernandes, Francois" <Francois.Fernandes@conduent.com>
Cc:     "webmaster@kernel.org" <webmaster@kernel.org>,
        stable@vger.kernel.org
Subject: Re: EOL Kernels versions
Message-ID: <20211123143647.zcnrlsnlmfl5yhhu@meerkat.local>
References: <BN8PR20MB26744F4622B7219F22A2DA64F8609@BN8PR20MB2674.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BN8PR20MB26744F4622B7219F22A2DA64F8609@BN8PR20MB2674.namprd20.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 23, 2021 at 10:05:20AM +0000, Fernandes, Francois wrote:
> Hi,
> 
> First of all thanks for your very interesting website.
> We contact you today because we are looking for an information regarding the Kernels versions.

> We are using the following version : Kernel V5.4V20
> 
> Regarding your table hereunder, we understand that this version will be EOL in December 2025.
> 
> [cid:image004.jpg@01D7E05A.07F76050]
> 
> Could you please advise :
> - What will happened in January 2026 ?

Two things:

1. most likely: a final 5.4.x version will be released and no new 5.4.x
   versions will be provided after that (meaning no new security or bug fixes),
   or
2. less likely: someone else will step up to maintain the 5.4 series instead
   of the current stable kernel team, in which case the EOL deadline will be
   extended further

> - Is the evolution to a newer version imperative ?

Yes. It is never a good idea to run a kernel version that is no longer
receiving security updates -- unless your devices run completely offline with
no external input of any kind.

Note, that you don't have to wait for the 5.4.x to reach EOL before you plan
your switch to a newer LTS tree. You should prepare for it well in advance.

> - Is this evolution a difficult operation ?

There is no simple answer to this question. It greatly depends on how you use
the kernel for your project. If you maintain many custom kernel modules, then
porting them to a newer version of the kernel can require some effort. If you
are using a vanilla kernel version running on common hardware, then switching
to a newer kernel tree could be very easy. In any case, you should plan out
proper development and testing resources.

> Thanks in advance for your help on this subject.

I have cc'd the stable list, where you can get further help for questions you
may have.

-K
