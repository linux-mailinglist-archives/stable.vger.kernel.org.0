Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593F52D43A6
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 15:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbgLIN5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 08:57:14 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36980 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbgLIN5N (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 08:57:13 -0500
Received: by mail-lf1-f65.google.com with SMTP id o17so289597lfg.4;
        Wed, 09 Dec 2020 05:56:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nKMw5RYGFYod1XmnmmfSFaCVF49QburHqLYV97RSZZ4=;
        b=HylMic9rY2mLUt102TfKMYFWtAuJCNHQxjzeFF2MOPzQGD3kJoiOaB8ZpXofsTM1+a
         F/EI9RsdlsR4OLSRo8zGa/4YAq7Oa6z7Cl9PWcTIy9s4tNcLGX3zHZPDoF2LWkqXziPF
         toqD7pPLdbp3JTZArTju7pY+FxbErVSWIbE36EPKbPgC+JnD+J+IFpowc2XgO+QY7ueZ
         u4ptMwwshzkeaABCuil2M9AagA79pyeo8vrJdFU/PhGDkKCIgO7POG5mn8Z+xtEfq8Tj
         DSPE2jdOJY8VoTbaeywS9rpYte6xnPKNiEVEb5EJs93LKgjiDdjgcIfVq5QT74nmB66A
         XYcQ==
X-Gm-Message-State: AOAM533QMTKgomnwoyZlVcnnbHnyZCVsDnCr21z9/riR4zct4ySFXYiN
        rQt15fDiIYiLpcT6GrZBV1Q=
X-Google-Smtp-Source: ABdhPJzZmFUWWSiHN3jGJf3IX2WPPnsr6qp9wtv4DCM5pXBEpkLsY/qfaF+vaN8EgaE4msboDTITyA==
X-Received: by 2002:a19:cb05:: with SMTP id b5mr962752lfg.61.1607522191324;
        Wed, 09 Dec 2020 05:56:31 -0800 (PST)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id t2sm180909lfd.59.2020.12.09.05.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 05:56:30 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kmzxu-0004r5-PM; Wed, 09 Dec 2020 14:57:11 +0100
Date:   Wed, 9 Dec 2020 14:57:10 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+8881b478dad0a7971f79@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] USB: serial: option: add interface-number sanity check
 to flag handling
Message-ID: <X9DXttJjg2aNqIZ8@localhost>
References: <0000000000004c471e05b60312f9@google.com>
 <20201209104221.13223-1-johan@kernel.org>
 <X9CsfckIiLGSrK/o@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9CsfckIiLGSrK/o@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 09, 2020 at 11:52:45AM +0100, Greg Kroah-Hartman wrote:
> On Wed, Dec 09, 2020 at 11:42:21AM +0100, Johan Hovold wrote:
> > Add an interface-number sanity check before testing the device flags to
> > avoid relying on undefined behaviour when left shifting in case a device
> > uses an interface number greater than or equal to BITS_PER_LONG (i.e. 64
> > or 32).
> > 
> > Reported-by: syzbot+8881b478dad0a7971f79@syzkaller.appspotmail.com
> > Fixes: c3a65808f04a ("USB: serial: option: reimplement interface masking")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> 
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks for reviewing. Now applied.

Johan
