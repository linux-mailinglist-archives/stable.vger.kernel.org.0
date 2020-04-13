Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A723D1A68AC
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 17:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729907AbgDMPXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 11:23:49 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46617 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729910AbgDMPXt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 11:23:49 -0400
Received: by mail-pg1-f196.google.com with SMTP id k191so4565114pgc.13
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 08:23:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kjNfu8hiKSxzOF2IxzYB3Owq9P0kd7GHIEss4nAoykA=;
        b=BBCnPSzHLgSCZkEZcvBKSNsJ8cdNGQdhiaIes4MecciV1POdmOnzezEXfvmcYTyDS5
         LKG3iS09ZaXWp4JOlRVb2Fd9MAf7FjFQvOv1FwjJSce1q2p/rZprQsYFfnCCTQFq3Q/J
         W71l5r7pWKGKtXh9iVeSfZyhQ3CRvDwPGzddNgdMiXW13dr15y//42YVhHnkIAEo6N/e
         lgi28zCmN+iuaB2XHMQCLkIIMeaBgjY0ztEvoXmOHU7SuTw19kOc1MNFzadyqPvsY4Yu
         gfU3unQ6RVG7mgg95jiClxZs//NSgzGs3w0TujJBaIXGipm4qNQgd1XlCaXpwWEroOes
         bcVw==
X-Gm-Message-State: AGi0PuZbwqdSvGL7S5EIrQkgmwMeGChCNtsQpmS2D2EELgQfylZkOOBq
        eGp97CY4PHlOWKnJUYtpvWKh2oDM
X-Google-Smtp-Source: APiQypKL6ugWr+mdyUQfdEnL4UWeFVlIDsklbhw/w66dmlLZhJWf7mRYjkcpnhpEp9mNH/ctz4ye+A==
X-Received: by 2002:a62:fccf:: with SMTP id e198mr15482606pfh.9.1586791428721;
        Mon, 13 Apr 2020 08:23:48 -0700 (PDT)
Received: from sultan-box.localdomain (static-198-54-129-52.cust.tzulo.com. [198.54.129.52])
        by smtp.gmail.com with ESMTPSA id w8sm8921970pfi.103.2020.04.13.08.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 08:23:47 -0700 (PDT)
Date:   Mon, 13 Apr 2020 08:23:44 -0700
From:   Sultan Alsawaf <sultan@kerneltoast.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2] drm/i915/gt: Schedule request retirement when
 timeline idles
Message-ID: <20200413152344.GA2300@sultan-box.localdomain>
References: <20200407202856.GA2026@sultan-box.localdomain>
 <20200407204345.3498-1-sultan@kerneltoast.com>
 <20200412074851.GA2703@sultan-book.localdomain>
 <20200412075607.GA2709076@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200412075607.GA2709076@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 12, 2020 at 09:56:07AM +0200, Greg KH wrote:
> On Sun, Apr 12, 2020 at 12:48:51AM -0700, Sultan Alsawaf wrote:
> > Hi Greg,
> > 
> > Could you queue this one up as well?
> 
> What is the git commit id of this in Linus's tree?

Sorry, I botched the commit message formatting. I'll send a patch with the
correct message formatting now.

Sultan
