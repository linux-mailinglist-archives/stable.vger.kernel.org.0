Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 348111E2DB0
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390656AbgEZTX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391528AbgEZTJM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 May 2020 15:09:12 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A59C03E96D
        for <stable@vger.kernel.org>; Tue, 26 May 2020 12:09:11 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 23so10575836pfy.8
        for <stable@vger.kernel.org>; Tue, 26 May 2020 12:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UodxcmBfs60/UJ4+u47LnpLdz/rsUv7B0ToHUyIES5s=;
        b=mHgyeMhJypPRxZudBsh74WCqPTYBBTn7wUawKIavys/q85CbI555vuZfG41ykyC0pe
         dw5CzcH9r1+kEdRWYCK1PGe+31hYKSm+DyTqpR/Ffpp1uoLGf1ROEEWuiGaxOuI7ty3Y
         5CRkL6fVc+/MSZnJ4bSa79f/VNJj+QStPiUM6qPIxSpwyu3C7GLiyv666ioPniH+TfvN
         m+daXerqSGcOHFw5sGuae7RXX6C+EHS9jHQa2+lp9RqLKbe1EUhJooQOEAlBMMNHAj1O
         TPBWjiGNPdoSYiloR4Tk6WFIKypuXGlC/PloJNc3z0+1Xixdoc+DOT7HUSZe7dZmqwIW
         haXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UodxcmBfs60/UJ4+u47LnpLdz/rsUv7B0ToHUyIES5s=;
        b=MKEnu4F1/WUVdAtDcw6yK/28IRThPGFhrtAJKe+QkL3PVZNYijl3pKkGO6wum9EhKM
         hmpNQikgKNjq2yHWVxb3rsdQ4fueDw7aG5cvq5C5QtQRT5FelTamyYSC1nkDR8C0Wws5
         xQZpDJddxsYE1Pkf6WlDJumGzG/rHkEYMETUcISD6Es5N0V1unLXEiWgqHgdKKNQCkEK
         sxPCB7iy4kkD0xmDAL0XtS4/EFQvgjBQHHQ0z2GusV7eCczAo73uJd6lqDecg7nSB/+w
         nymfyj+TrDGlb3D0TQ5fpbgttpOcepzR53hhNi6+T+Iq53EDD+s2dIlJQou4afK/BnI1
         X9LQ==
X-Gm-Message-State: AOAM533XvRtuOmymTIkmIWhND94Sia/KTaUGe/F68U/iseWKes/ZpieE
        VkN0V/CW0YW/+NKg12BXRj04Xw==
X-Google-Smtp-Source: ABdhPJzNf2v+WYf0TWZ+/HizdUzn57c6ARUWaL65N3rFv8707Z/t7Wu6BVDU2qaPDO90RHlo7rKegA==
X-Received: by 2002:a63:e04a:: with SMTP id n10mr330150pgj.157.1590520151233;
        Tue, 26 May 2020 12:09:11 -0700 (PDT)
Received: from google.com ([2620:15c:201:0:4e3a:fe5d:27e5:c203])
        by smtp.gmail.com with ESMTPSA id bu7sm211425pjb.41.2020.05.26.12.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 12:09:10 -0700 (PDT)
Date:   Tue, 26 May 2020 12:09:04 -0700
From:   Eric Biggers <ebiggers@google.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable-commits@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Patch "ppp: mppe: Revert "ppp: mppe: Add softdep to arc4"" has
 been added to the 4.4-stable tree
Message-ID: <20200526190904.GA165275@google.com>
References: <20200524135255.8821820776@mail.kernel.org>
 <20200524171105.GA56504@google.com>
 <20200525024316.GY33628@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525024316.GY33628@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 24, 2020 at 10:43:16PM -0400, Sasha Levin wrote:
> > 
> > Hard for "anyone else" to object to it when you didn't Cc any real mailing lists
> > (stable-commits doesn't count) and just sent this to me.  Lucky I saw this.
> 
> This is just the "added to the queue" mail, you would see another mail
> when this release goes to -rc1. No reason for too much spam...
> 

So that second email would have gone to the real mailing lists that would need
to review this patch (linux-crypto and netdev)?  I don't think that's what
happens, hence my concern...

- Eric
