Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF75351D75
	for <lists+stable@lfdr.de>; Thu,  1 Apr 2021 20:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236535AbhDAS2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 14:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239510AbhDASQe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Apr 2021 14:16:34 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 177FEC08EC6E
        for <stable@vger.kernel.org>; Thu,  1 Apr 2021 06:48:16 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id o19so1032895qvu.0
        for <stable@vger.kernel.org>; Thu, 01 Apr 2021 06:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Yv0SD7azmXsvMEplVTG/OMlC1mfamMg+J+KP7hU2E4I=;
        b=gJpFHp8bORZJ159TQvGWDVPWsqfhrWaEKkWnC67F/5gAcANjTJCuJYuSBI2/iQ6TCz
         /9BfV+GVhUSbLYskIhUFmupnlF8Sy6e+1w6ADgpd0NF+A1EDcFJsew8WgZmYrOHTEA2V
         x42c3O/Y725ydSAZARfnzNWgiMC4wNboQiL7zlAu4vJjcId4yEFeNJOaEV+ghSAO5xS7
         Jx4D3fvpP3Akox3rdVaW6u1qhWD2CWs/VWu5YpOCuI0U0PQaV5JULLQxn41UIdsS3OGv
         Bt79bux7mPxIPzeRJ+vB96cWK8HEZwtHoUuQHTA/hHVBNRirI2+OvBMyZbzTHJy9fqMW
         cCEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Yv0SD7azmXsvMEplVTG/OMlC1mfamMg+J+KP7hU2E4I=;
        b=hSCU4ejYNSUNCrX4LKSbnlKCF78kHLA9VT3HzD0QTUxJ6gSGpTgyRsFPnJdCCYbbZu
         4sArKzML2YP3MkNNW0hXYhk4wGR5GQxvnoUK2+rKMGHX5OTL2zJl3hN4pPYOssROXuVo
         JsoYpfAO7fziixLVgDT3EZZ/kCFaNftorFhEbbDGgBus4zOY3FBC33DXKLbAr0YzGA85
         vI3S7eaoYR5bLI3yYlZUjI5TcREIrZc41iwhIl20CYrenx19U7pyeeGjYUTc1mJPil9Q
         BsJgWsm0mWOHnmeR/u5Br99rgiP+xhOA0GuMhr1z4jQp06gtfvjhQYeqQ4Kv9U224eHf
         nl3w==
X-Gm-Message-State: AOAM5324pCzTCAYmAsaOVTNaSMXzJsZwu1e5YG8nBvTD5Hg4oloiOJuY
        XillQxarfuo9ns4+JYDuboW3qQ==
X-Google-Smtp-Source: ABdhPJzLNDtRKWNx/3wroMc9KweKg7ulxyAg21Fo2VAIUu0qMvXSzqs37gsflntsxeCSlNSmt1j2RQ==
X-Received: by 2002:a05:6214:326:: with SMTP id j6mr8327576qvu.13.1617284895294;
        Thu, 01 Apr 2021 06:48:15 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-115-133.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.115.133])
        by smtp.gmail.com with ESMTPSA id g21sm3931941qkk.72.2021.04.01.06.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 06:48:14 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1lRxgE-006lA3-9J; Thu, 01 Apr 2021 10:48:14 -0300
Date:   Thu, 1 Apr 2021 10:48:14 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Wan, Kaike" <kaike.wan@intel.com>
Cc:     Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH for-rc 1/4] IB/hfi1: Call xa_destroy before freeing
 dummy_netdev
Message-ID: <20210401134814.GG2710221@ziepe.ca>
References: <1617025700-31865-1-git-send-email-dennis.dalessandro@cornelisnetworks.com>
 <1617025700-31865-2-git-send-email-dennis.dalessandro@cornelisnetworks.com>
 <20210329140922.GP2710221@ziepe.ca>
 <7da1174e-97a6-3933-ae35-166a9dcbf38e@cornelisnetworks.com>
 <20210401123317.GC2710221@ziepe.ca>
 <DM6PR11MB330637BAEB1AA8D7FDC56225F47B9@DM6PR11MB3306.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB330637BAEB1AA8D7FDC56225F47B9@DM6PR11MB3306.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 01, 2021 at 01:42:57PM +0000, Wan, Kaike wrote:

> Shouldn't xa_destroy() always be called during cleanup, just in case
> that something is left behind?

No.

> Check the following:

Since I didn't write a WARN_ON(!xa_empty()) it means they were not
made empty.

IIRC there is some special stuff there with XA_ZERO_ENTRY that causes
it.

Jason
