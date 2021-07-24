Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F613D43F2
	for <lists+stable@lfdr.de>; Sat, 24 Jul 2021 02:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233337AbhGWXr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 19:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232724AbhGWXr2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 19:47:28 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A20CC061575;
        Fri, 23 Jul 2021 17:28:00 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id h10so2837360qth.5;
        Fri, 23 Jul 2021 17:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yUR9vJJVBZ++4KfjLkcZVAYSvkA3ayEGS4PyGfLalPM=;
        b=fEg7jmTITwuBlSObLCFYUgVdaZDKJo3E9aqB9Xs8g8wePAAwzjlXTfYPChZoE60gPy
         GxArM5zAYk22cjsHQiobsf4uDInsfcVjl6o5Uj7n/h3qAGesmatZS+tPp790DXpEsMCo
         Nw37ZtOfkWZiO+ROkp4UIZv3Yp69+x1iVegf1OsXbwvthf4sq/9icxsp+2UN6hE3ZMin
         YMmX6/Y0B8g+L6g0PSwp1SnwnkNTW41BYPWka4qE7h+0JpF9CzBwnomLzuopBGS0boXg
         EeNTihTE+EgswZv1sREROSkd4cCdE/PkKX4lrZ91gzjsgttwNV/D5Z9wfDsra7CxBEMW
         aMpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=yUR9vJJVBZ++4KfjLkcZVAYSvkA3ayEGS4PyGfLalPM=;
        b=SuZrmE/Kw6G4EPsE/vj9Mvn+Y8+c1hmUyZ1dsRiLPY9TGr1pDxKFcPr1mWRwwUgLr7
         SjM2aC/A8xFdYIYdOa7Mnstoi2amRfotyzlqh+BHvAFl6hdYojmxCZpPbwwBkXlzv2Fo
         7AdiRhoXRLr2ZZRcGjig2QKpOo+41LnkgPWPKWvx2734P0N2rfbvXMBxnCa45+PzX3d2
         d67n6k9JrMHdeV+EtoqZczms+H4TaM3LlyikEWZPqpB1kzrUw8GtbdCBgG5pca6plJ2W
         cbvdVso5B90ouNtXiROERVOPm53lCu5pCAJLvvYjXbt+Puhb9L/Kw8Te0hkAon87vzzf
         OQZg==
X-Gm-Message-State: AOAM530d4jnEae7G7MBikHQGVplEqfVxcC6sI/neNk9TDXWjGLLazZy+
        Qva8iaNz72siVoWyQviJaCE=
X-Google-Smtp-Source: ABdhPJwrxhDAQ7ceVK5GvlpstNHsjFggcc2RjjEe4hnZLSCi08MSUUiNXVpC2HZ/36bcBUz5JS1Hhw==
X-Received: by 2002:ac8:584e:: with SMTP id h14mr6051271qth.339.1627086479562;
        Fri, 23 Jul 2021 17:27:59 -0700 (PDT)
Received: from fedora ([130.44.160.152])
        by smtp.gmail.com with ESMTPSA id bl41sm4445922qkb.17.2021.07.23.17.27.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 17:27:58 -0700 (PDT)
Sender: Konrad Rzeszutek Wilk <konrad.r.wilk@gmail.com>
Date:   Fri, 23 Jul 2021 20:27:56 -0400
From:   Konrad Rzeszutek Wilk <konrad@darnok.org>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Vasily Gorbik <gor@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Heiko Carstens <hca@linux.ibm.com>, stable@vger.kernel.org,
        Claire Chang <tientzu@chromium.org>,
        Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v2 1/1] s390/pv: fix the forcing of the swiotlb
Message-ID: <YPtejB62iu+iNrM+@fedora>
References: <20210723231746.3964989-1-pasic@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210723231746.3964989-1-pasic@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 24, 2021 at 01:17:46AM +0200, Halil Pasic wrote:
> Since commit 903cd0f315fe ("swiotlb: Use is_swiotlb_force_bounce for
> swiotlb data bouncing") if code sets swiotlb_force it needs to do so
> before the swiotlb is initialised. Otherwise
> io_tlb_default_mem->force_bounce will not get set to true, and devices
> that use (the default) swiotlb will not bounce despite switolb_force
> having the value of SWIOTLB_FORCE.
> 
> Let us restore swiotlb functionality for PV by fulfilling this new
> requirement.
> 
> This change addresses what turned out to be a fragility in
> commit 64e1f0c531d1 ("s390/mm: force swiotlb for protected
> virtualization"), which ain't exactly broken in its original context,
> but could give us some more headache if people backport the broken
> change and forget this fix.
> 
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Fixes: 903cd0f315fe ("swiotlb: Use is_swiotlb_force_bounce for swiotlb data bouncing")
> Fixes: 64e1f0c531d1 ("s390/mm: force swiotlb for protected virtualization")
> Cc: stable@vger.kernel.org #5.3+
> 
> ---

Picked it up and stuck it in linux-next with the other set of patches (Will's fixes).
