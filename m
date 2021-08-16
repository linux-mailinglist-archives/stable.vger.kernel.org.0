Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645803EDC92
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 19:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbhHPRtl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 13:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbhHPRtl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 13:49:41 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C09C061764
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 10:49:09 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id g21so13869406edw.4
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 10:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=essensium.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=HtanmOCO1xPvA52qQrltU62xtZEo/lHDPX7MThglOdk=;
        b=WofalPP/stphZy+kxJqyOAj0PcuQsQhSMptD2/Ez5dD+AEFvSNPiVkZ8zicqI/Jz4E
         4/SJC/44IvHtWpHGbJF90pGmcxhm/rBofoJglorn46caofXPKJxNNdIFnfRqQqQxHmP0
         Y7cvieVGV85IylubY7ii66s+mO94XWchw8X3dTCsdc07CYN7RcZA5wpR2NFG+oXLrF2k
         Z2/hNaXf8tTpV2XawndFgNJO5JnaTB66cTmy3Fz0F2LSONQr5ebNswNIX46LvM6qxUXT
         BUq2Gjf//Ghp3G4sm437QeQ+lyTwFQGuv2QQfhBf+cR9YG0usLM4wf6xZIeF+PH8j/Wh
         NMFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=HtanmOCO1xPvA52qQrltU62xtZEo/lHDPX7MThglOdk=;
        b=QFUQtp5J8BHpCI/v8ImvD/JpCUF716g7UbJpUHBWw3Sc1In0NMbQy/5gaeH31FHDYQ
         UHM2m6LycnTMjUzr6Ez6JXvLKL5hHM+8SDtobH0XsHxzei6C8dx+Al/mSiL0rHJw4VIZ
         MhBr/qONbUEaDALDihCrC4q+k4oDpc8brWLfDiIlK2rQnReEgonE/ohr/vIAv7wxMyfi
         AE3nj/5piKzrrjqDhWPRnRtX7k3LTAUC0DzCjbhs1ECMFS6gF2qKsO0uUkBTF/hI7SpB
         OPCv0+hsVO/4p8Af5q0nd/evXrov0hwimFp7gN+dKx/NhzwJbhHu8vBxFYTYEcIJSbyr
         V1tw==
X-Gm-Message-State: AOAM5312s+quo59Gc2Jm2eodHJbxfW4aeZlpjQ7NLLkUTh9l1il7N3EY
        U+Or3NlD1h/7GSCqRuufdpnuqg==
X-Google-Smtp-Source: ABdhPJyVBxziI0laVMnqPRfK5ZB3LZYobXgwDwGyZUO3YOWXAbCKunxs9NDtfw4wiiQHQ6odGFNSug==
X-Received: by 2002:aa7:d147:: with SMTP id r7mr21610405edo.148.1629136147925;
        Mon, 16 Aug 2021 10:49:07 -0700 (PDT)
Received: from cephalopod (168.7-181-91.adsl-dyn.isp.belgacom.be. [91.181.7.168])
        by smtp.gmail.com with ESMTPSA id p23sm3962672ejc.19.2021.08.16.10.49.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 10:49:07 -0700 (PDT)
Date:   Mon, 16 Aug 2021 19:49:05 +0200
From:   Ben Hutchings <ben.hutchings@essensium.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 52/96] net: dsa: microchip: ksz8795: Fix VLAN
 filtering
Message-ID: <20210816174905.GD18930@cephalopod>
References: <20210816125434.948010115@linuxfoundation.org>
 <20210816125436.688497376@linuxfoundation.org>
 <20210816132858.GC18930@cephalopod>
 <YRqR7NFWJmhFR9/d@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YRqR7NFWJmhFR9/d@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 16, 2021 at 06:27:24PM +0200, Greg Kroah-Hartman wrote:
> On Mon, Aug 16, 2021 at 03:28:58PM +0200, Ben Hutchings wrote:
> > On Mon, Aug 16, 2021 at 03:02:02PM +0200, Greg Kroah-Hartman wrote:
> > > From: Ben Hutchings <ben.hutchings@mind.be>
> > > 
> > > [ Upstream commit 164844135a3f215d3018ee9d6875336beb942413 ]
> > 
> > This will probably work on its own, but it was tested as part of a
> > series of changes to VLAN handling in the driver.  Since I initially
> > developed and tested that on top of 5.10-stable, I would prefer to
> > send you the complete series to apply together.
> 
> What is the "complete series"?  We have 7 patches for this driver in
> this round of kernel rc reviews.

You have the full series queued up for 5.13, but only 2 of them for
5.10.

> What specific git ids are you referring to?

The fixes missing from the 5.10 queue are:

ef3b02a1d79b691f9a354c4903cf1e6917e315f9
8f4f58f88fe0d9bd591f21f53de7dbd42baeb3fa
af01754f9e3c553a2ee63b4693c79a3956e230ab
9130c2d30c17846287b803a9803106318cbe5266

(I also have another fix just for 5.10 because the issue was fixed by
a refactoring in 5.11 that wouldn't be suitable for stable.)

Ben.

-- 
Ben Hutchings · Senior Embedded Software Engineer, Essensium-Mind · mind.be
