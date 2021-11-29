Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCDEB461182
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 10:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344527AbhK2KBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 05:01:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31132 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239291AbhK2J7e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 04:59:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638179777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3oo5FehUIDwCCRCGx90qgY5CbZ33PoMSa77Ery2GawQ=;
        b=QEyo+x057Sawm6yk1ee/PHfrQDuEbHr5AmXZ3upT5VQJhUHnb5O02D27mqpMow9QmN0mb2
        2yxyM1h6cf+G5AMbZHk2W1phrqz+AEHzqYY9KH9KML24fP6Pi7sXWhhbeUZRVMyDGQiWms
        WZNe814wb79dALunGeRp3zNBD60lRy0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-600-3lg6I__sPj61GBsJGT-tHg-1; Mon, 29 Nov 2021 04:56:15 -0500
X-MC-Unique: 3lg6I__sPj61GBsJGT-tHg-1
Received: by mail-ed1-f70.google.com with SMTP id m12-20020a056402430c00b003e9f10bbb7dso13198583edc.18
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 01:56:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3oo5FehUIDwCCRCGx90qgY5CbZ33PoMSa77Ery2GawQ=;
        b=4ydHUj7mPRfBNik/wIDfZC5vfMWZ2BKhfYv6TFlLjA27/zsiaK5irUoLXIOgk2+q76
         ZTPDpd2F93M9y4InImkT9Lo500zvORbmDbWeOR5maXcMfnmkQRpnzXr+HEpubQ+4Xtts
         8shXjFNQD+/5JTzWs8nnmIndIuV5PKmK4eDvzh5tRsF48BoJysK4jzUuDgDxjFCyFDv/
         XaTMK6/Cw/SUkwnQMlHyF0Adjy8K732wqRdYV1m/ExyvF0X+XBuVZAUy86KK9i3Kpx3Q
         c3//+xS1OgDuEQBaAZANfLpIlshfwdLq8QZ/u+vtm8js//WJNP6vWHFbYyVnD+qn/vyM
         qrow==
X-Gm-Message-State: AOAM533H/1glSLvDggYXVyypXPGsK9yvoRIkYv5pHDGRo6ZNqxkhhMzA
        HFYN712bBpe/Q3uh9u69fhtuL09OmTeVDJxGfbHXc0iqF6aBWwDA/Gy1AJ5/zO7j7e4H6oCrB84
        NLFfd07Vqz/bLUe1Y
X-Received: by 2002:a05:6402:51cb:: with SMTP id r11mr72726026edd.150.1638179774651;
        Mon, 29 Nov 2021 01:56:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyIoW9wRMsbBv9H3aY2q/90GIi2XH2bUiB+/EDtazNjhoXRSQ52lFmofG2hdYwJSrON/gHONA==
X-Received: by 2002:a05:6402:51cb:: with SMTP id r11mr72726001edd.150.1638179774466;
        Mon, 29 Nov 2021 01:56:14 -0800 (PST)
Received: from steredhat (host-79-46-195-175.retail.telecomitalia.it. [79.46.195.175])
        by smtp.gmail.com with ESMTPSA id t3sm8798190edr.63.2021.11.29.01.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 01:56:14 -0800 (PST)
Date:   Mon, 29 Nov 2021 10:56:12 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     gregkh@linuxfoundation.org
Cc:     jasowang@redhat.com, mst@redhat.com, pasic@linux.ibm.com,
        stefanha@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] vhost/vsock: fix incorrect used length
 reported to the guest" failed to apply to 4.9-stable tree
Message-ID: <20211129095612.2t6fal6f7d2tuh56@steredhat>
References: <163817018318163@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <163817018318163@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 29, 2021 at 08:16:23AM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.9-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.

I'll send the backport for 4.9-stable.

Thanks,
Stefano

