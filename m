Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B1332795F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 09:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233209AbhCAIgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 03:36:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233238AbhCAIgm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 03:36:42 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A546C061786
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 00:35:53 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id w11so15128853wrr.10
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 00:35:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=MwglKA+DAbrb5Dd59T4Gm1ugHRDlsailixo4MHU+aYY=;
        b=NAwXpCLVa0eAaCzgwLgjOk9ETHzLB7vDQt6SYL/1wNcBooJfV1jHg1iOYOc+O67DCl
         U+4FF5+0T08kv0C5BlrM6/rQvk3u7hc4BV/xYzIArfCHBu8TXOKowLqG4RuPxpBago2O
         J0WO3iSxPbMZei2jYDw67wtq2i7r1tx8e5hKwKed/d6tflq2EnJQQh+URKTjgCp5LyJ3
         UC3c0iOFr0svpM6ynXDKodf8tVaCfvIwhrzE8gIp/qMEsngHrtpgoCMDe1ixGjzn7Oea
         Dr2VmJh9fO1FwTU3yCLFzxOa2Sdx0nh2TpjZkXITsM6I8P0fQHeMgD0WUmopigMj1Iya
         K0xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=MwglKA+DAbrb5Dd59T4Gm1ugHRDlsailixo4MHU+aYY=;
        b=kh0a+LUqevVma6xTpQ3OVaULxnAD0pZbhYVoGSpru2587AibRYv6n05tYKn+OIvHBJ
         pPSTH8zVf/gBHa2NMKpQ7P/YDZg/X8hvL8R3VNwigmepMgplMkYNA+2ZneTc3Rdyg2m1
         paoZOqpYycw6tlEz4LV0XbQ60QD0OaM5Pq4RufzoKkovmeQkobDNm+sxVAT1Eochdo2K
         cPBoOdT2M/66F0Ja6H19K4e2vHI/a3i6af3QSu5a+aB/cd7LEnF0pC4RrTHrpOyBN6IQ
         u8T9RzTwRhzzvSL+Au99fHhZ6UY0X9u+LXcifKtiaHIzIYaeJIf2f0jVzD7cUJZROx4z
         caHQ==
X-Gm-Message-State: AOAM533RQJRzlWkQKmh2jP3OcWHzBPPk0j5QadOCDUafGch7mQlXZl9l
        wURl0/2dl7Hbt5YdYs7Cc2qdmQ==
X-Google-Smtp-Source: ABdhPJzq93XcPB1i8ObGsKFy2YyhwhQnHoCqsU4xGsysGl607gMtts2xwZZplJoHiLO2eDUUoikwIw==
X-Received: by 2002:adf:fb49:: with SMTP id c9mr15813316wrs.72.1614587751771;
        Mon, 01 Mar 2021 00:35:51 -0800 (PST)
Received: from dell ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id r18sm24814864wro.7.2021.03.01.00.35.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 00:35:51 -0800 (PST)
Date:   Mon, 1 Mar 2021 08:35:49 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable@vger.kernel.org,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>, lwn@lwn.net,
        jslaby@suse.cz
Subject: Re: futex breakage in 4.9 stable branch
Message-ID: <20210301083549.GF641347@dell>
References: <161408880177110@kroah.com>
 <66826ac72356b00814f51487dd1008298e52ed9b.camel@decadent.org.uk>
 <YDygp3WYafzcgt+s@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YDygp3WYafzcgt+s@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 01 Mar 2021, Greg Kroah-Hartman wrote:

> On Mon, Mar 01, 2021 at 01:13:08AM +0100, Ben Hutchings wrote:
> > On Tue, 2021-02-23 at 15:00 +0100, Greg Kroah-Hartman wrote:
> > > I'm announcing the release of the 4.9.258 kernel.
> > > 
> > > All users of the 4.9 kernel series must upgrade.
> > > 
> > > The updated 4.9.y git tree can be found at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
> > > and can be browsed at the normal kernel.org git web browser:
> > >         
> > 
> > The backported futex fixes are still incomplete/broken in this version.
> > If I enable lockdep and run the futex self-tests (from 5.10):
> > 
> > - on 4.9.246, they pass with no lockdep output
> > - on 4.9.257 and 4.9.258, they pass but futex_requeue_pi trigers a
> >   lockdep splat
> > 
> > I have a local branch that essentially updates futex and rtmutex in
> > 4.9-stable to match 4.14-stable.  With this, the tests pass and lockdep
> > is happy.
> > 
> > Unfortunately, that branch has about another 60 commits.  Further, the
> > more we change futex in 4.9, the more difficult it is going to be to
> > update the 4.9-rt branch.  But I don't see any better option available
> > at the moment.
> > 
> > Thoughts?
> 
> There were some posted futex fixes for 4.9 (and 4.4) on the stable list
> that I have not gotten to yet.
> 
> Hopefully after these are merged (this week), these issues will be
> resolved.
> 
> If not, then yes, they need to be fixed and any help you can provide
> would be appreciated.
> 
> As for "difficulty", yes, it's rough, but the changes backported were
> required, for obvious reasons :(

Apologies for the fuss.

The back-port become more complex the further back it was taken..

Had I known about the self-tests, I would have ensured those were
passing too, as well as the the build/boot/auto-builder tests
actually carried out.

Let me know if there's anything further I can do to help.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
