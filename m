Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B462F40ED89
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 00:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241279AbhIPWwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 18:52:02 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:42920 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241276AbhIPWwC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Sep 2021 18:52:02 -0400
Received: by mail-pj1-f47.google.com with SMTP id p12-20020a17090adf8c00b0019c959bc795so314619pjv.1;
        Thu, 16 Sep 2021 15:50:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Vw0j2AmAI+jDWlQA6oI7YirQNYbuAQxGA7HjiEIg9wU=;
        b=TlpsgRjbTTaLG7gck4DqObcsq2MPqAIL1JbGqDqy8VP0PE4zjHLBiRKtXxpQ16dyGY
         VtGJgMoi7pgrp9BirYHVtte9VttgI5w3bPVAzEBVDaegYr5PfssCsaP56JKVjnb4n6Gb
         IMcP2g6oXaVLtWznOAMRo1tX7E+gN6Hi8XOe4y+4EYx1knvq9btjibBtaoT1KmLMlJDL
         IsAC3ZWZO7FULHvUUL/mgpYkMR9xNBVE9JUIiZuyqIVpWHLlEwRGT9H6+tvApkxeLaJo
         KMH/IHHZwZBHpaNYw+P0Jzdsp5JEdowUY5PFQKQdoGoz+b2jC+gb6KFmgU5jJ2/ZXJgo
         lFCA==
X-Gm-Message-State: AOAM531K1jRXDeytKQw9U+8wUK6P1liQFvit5Jz6bdxd4LOifRIEM9aP
        AU/bs7khCZck8vCNKeKAxivicNHrRGA=
X-Google-Smtp-Source: ABdhPJynvLv4SLwrfDof5iB0v728YZPksh5TOzXLr9hIot3CP6nykPOjBkK7REn1gOk5PtFBON/8kQ==
X-Received: by 2002:a17:90a:ab90:: with SMTP id n16mr8561525pjq.157.1631832641003;
        Thu, 16 Sep 2021 15:50:41 -0700 (PDT)
Received: from localhost ([2601:647:5b00:6f70:be34:681b:b1e9:776f])
        by smtp.gmail.com with ESMTPSA id k4sm4354227pga.92.2021.09.16.15.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 15:50:40 -0700 (PDT)
Date:   Thu, 16 Sep 2021 15:50:39 -0700
From:   Moritz Fischer <mdf@kernel.org>
To:     Russ Weight <russell.h.weight@intel.com>
Cc:     Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org,
        trix@redhat.com, lgoncalv@redhat.com, yilun.xu@intel.com,
        hao.wu@intel.com, matthew.gerlach@intel.com, rc@silicom.dk,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/1] fpga: dfl: Avoid reads to AFU CSRs during enumeration
Message-ID: <YUPKPxrgkLaqEZRr@epycbox.lan>
References: <20210916210733.153388-1-russell.h.weight@intel.com>
 <YUPEIDk7jMc/WpAQ@epycbox.lan>
 <e070cf0f-76d4-5bd8-2e7f-67499351e449@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e070cf0f-76d4-5bd8-2e7f-67499351e449@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 16, 2021 at 03:34:39PM -0700, Russ Weight wrote:
> 
> On 9/16/21 3:24 PM, Moritz Fischer wrote:
> > On Thu, Sep 16, 2021 at 02:07:33PM -0700, Russ Weight wrote:
> >> CSR address space for Accelerator Functional Units (AFU) is not available
> >> during the early Device Feature List (DFL) enumeration. Early access
> >> to this space results in invalid data and port errors. This change adds
> >> a condition to prevent an early read from the AFU CSR space.
> >>
> >> Signed-off-by: Russ Weight <russell.h.weight@intel.com>
> >>
> >> Fixes: 23bcda750558 ("fpga: dfl: expose feature revision from struct
> >> dfl_device")
> > Did you mean:
> >
> > Fixes: 1604986c3e6b ("fpga: dfl: expose feature revision from struct dfl_device")
> Oops - I must have been looking at the wrong branch. Yes - you have the
> correct commit ID
> >
> > And for future please don't line break those, or we'll get yelled at :)
> Got it.
> 
> Thanks!
> - Russ
> >
> > I can locally fix it up, no need to resubmit
> >
> > - Moritz
> 
Applied w/changes to fixes,

- Moritz
