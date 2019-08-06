Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFD582B0B
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 07:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730055AbfHFFee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 01:34:34 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44785 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbfHFFee (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 01:34:34 -0400
Received: by mail-pf1-f196.google.com with SMTP id t16so40821628pfe.11
        for <stable@vger.kernel.org>; Mon, 05 Aug 2019 22:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=eng.ucsd.edu; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ITZzXk4hkchefAa/C9vch93mRZp0Y9hrzcYHt1CxoXA=;
        b=XtIPgb4wZqOrKmW/tyl/QqxOYFVvbKKuvd9MA51RVQmTlFCPH2GcLl2+Yms2/Avcg9
         EZTxoWpQQUenC6fwYQ+VTBb7m34eiUsH2fGBy0sdch+TGCxAIZOZSk/oxFFOplsuZa9e
         V6E1ChrlnDWbp8GoKFGKqvTacAXBLXp3rbiVE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ITZzXk4hkchefAa/C9vch93mRZp0Y9hrzcYHt1CxoXA=;
        b=ru4c84ZZmRnzuD/SBs9BSd/nMO4QgoY/mSm1U61llU90YwswlprDT4rlIytYENQK5d
         ZVKY/rgVwo5SpXR05NO1q9p/sHp0y/xGGK2GCM1oT+AzCMD+J1xkbh1sqZl/tiL1/MvW
         pKY3/DXoVU8au8Cr1sZxZdQpTbueEx3orjEGWL2hQDSB2doUXmpvNGDeauu+S0Pjfk2V
         3r7BLsvQDWiRhhporP1F5Pxw4oUKbeTEvOnau/RblYoNaZsgdLciwx+tfOmXxL4XtFDC
         dnj2px6U+c6kkl6pl+9YEE7+Q3ruDOcyMNRkwvPm9Eq26VLZmiVuvYZ2P+8tjwjxMxVF
         +mMQ==
X-Gm-Message-State: APjAAAWtVRwzn97r2kijI94djHAF/5S00lt5d6iorokgjgmW6+Wl1CHc
        Fq58Jez52YmNQ4xe6diw3038xw==
X-Google-Smtp-Source: APXvYqzH8Z0Hn489Zyo573sDGL6BycECAxRLofQeib0NEkjpsn4FwKtl3QVZuhTS8CTnrpt5DYMuQQ==
X-Received: by 2002:a62:5883:: with SMTP id m125mr1817575pfb.248.1565069673515;
        Mon, 05 Aug 2019 22:34:33 -0700 (PDT)
Received: from luke-XPS-13 (114-198-81-189.dyn.iinet.net.au. [114.198.81.189])
        by smtp.gmail.com with ESMTPSA id 143sm131382923pgc.6.2019.08.05.22.34.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 22:34:32 -0700 (PDT)
Date:   Mon, 5 Aug 2019 22:34:26 -0700
From:   Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
To:     Joe Perches <joe@perches.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        syzbot+a4387f5b6b799f6becbf@syzkaller.appspotmail.com
Subject: Re: [PATCH 5.2 10/20] media: radio-raremono: change devm_k*alloc to
 k*alloc
Message-ID: <20190806053426.GA7108@luke-XPS-13>
References: <20190802092055.131876977@linuxfoundation.org>
 <20190802092100.285432717@linuxfoundation.org>
 <9403fd1e250bb4dd8e1bcf0536e6d224be7c889c.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9403fd1e250bb4dd8e1bcf0536e6d224be7c889c.camel@perches.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi there, 

On Fri, Aug 02, 2019 at 03:04:25AM -0700, Joe Perches wrote:
> On Fri, 2019-08-02 at 11:40 +0200, Greg Kroah-Hartman wrote:
> > From: Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
> > 
> > commit c666355e60ddb4748ead3bdd983e3f7f2224aaf0 upstream.
> > 
> > Change devm_k*alloc to k*alloc to manually allocate memory
> > 
> > The manual allocation and freeing of memory is necessary because when
> > the USB radio is disconnected, the memory associated with devm_k*alloc
> > is freed. Meaning if we still have unresolved references to the radio
> > device, then we get use-after-free errors.
> > 
> > This patch fixes this by manually allocating memory, and freeing it in
> > the v4l2.release callback that gets called when the last radio device
> > exits.
> 
> This really should be commented in the code
> and not just in the commit changelog as some
> unsuspecting person will likely undo this in
> the future without one.

You reckon I should submit a patch with the necessary parts commented? 

Thanks, 
- Luke
