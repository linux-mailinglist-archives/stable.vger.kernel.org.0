Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 418D7276250
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 22:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgIWUmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 16:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgIWUmK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Sep 2020 16:42:10 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F2BC0613CE;
        Wed, 23 Sep 2020 13:42:10 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id f18so373338pfa.10;
        Wed, 23 Sep 2020 13:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YTqMKJ2r9lJvoz5eaRhmClYptdjVPN0cfBkpHCFpZIY=;
        b=q4GZzSi+KRrJZowwN18dJwrui7xW5qEWqe4+gnz8T95t47d9fUojDy3a6MRidGtPVJ
         bhehuf04pA6jWBSCmeJR0Gbs52BMbpnOt4PjVXPN5KGXvRNE87BcANbwIa9l9prfEiYW
         vQmGbf2fzIgLbnOxNNDugHu9KSbpzTu46lzagCg0Ta+ccTSpDl7jL90BIoXMYrmbOM0e
         dmxe3w9FzlE9KkircotdV/F0bs9MQpUjSsieo67VYpWISr0Lcg65eZyoJTZmPHmWPSJp
         dQHD9xsYVIRRHBybQeUUu2S9aziJaLxaRk6Z4jJlHU3Ub0C5m0rvUibvhAOFO+rcpF5Z
         SbCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YTqMKJ2r9lJvoz5eaRhmClYptdjVPN0cfBkpHCFpZIY=;
        b=uVRpxTn2ppTs7NjuwP7xT5jLrO3ByrB4L39j8/6E/EOPXS5wYBOVnwftcLXKX8fXkh
         7QzUUY2baFJveif8QmavWZbLMkHD8yeRBO/VXaJCNVE9/P1wS7Py6X+bgHC/I3clPA+J
         SFjYWMrbQ7Dq+ZSgmB+loZzKSovz6TtACxSO+gu1MzFMea+VhGHxD9Pk+zza+zZSK0o/
         rWRQ0k/WB0+MP5rNlkKE5i+WwM7B1LRYiOEwHGEQ4SLPX70dPgj9MeA5zM6c9dYtG0an
         38Vf1FZzALNezH+rwkM/syjwpz+vFkiMN0ETzRcBPvXfFUZDGJXCi/WOAjev/AAhQWaT
         mgLg==
X-Gm-Message-State: AOAM532+9qZw7MZyoF951JtPCT0b7eZoyvekvk5LZqPOZdlVxwxZggJg
        zDUdmHORh7p91j+eUDyhbqQ=
X-Google-Smtp-Source: ABdhPJylVlBnSEBRjtVUI/3ECfLXMd7+wI/L2Scyeh9x+sImzwiYpOS7niZGC5P1GAkPH+SzRA95fA==
X-Received: by 2002:a63:457:: with SMTP id 84mr1253837pge.191.1600893729932;
        Wed, 23 Sep 2020 13:42:09 -0700 (PDT)
Received: from dtor-ws ([2620:15c:202:201:a6ae:11ff:fe11:fcc3])
        by smtp.gmail.com with ESMTPSA id e10sm693437pgb.45.2020.09.23.13.42.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 13:42:08 -0700 (PDT)
Date:   Wed, 23 Sep 2020 13:42:06 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vincent Huang <vincent.huang@tw.synaptics.com>
Subject: Re: [PATCH 4.19 43/49] Input: trackpoint - add new trackpoint
 variant IDs
Message-ID: <20200923204206.GN1681290@dtor-ws>
References: <20200921162034.660953761@linuxfoundation.org>
 <20200921162036.567357303@linuxfoundation.org>
 <20200922153957.GB18907@duo.ucw.cz>
 <20200922161642.GA2283857@kroah.com>
 <20200922202403.GA10773@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922202403.GA10773@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 22, 2020 at 10:24:03PM +0200, Pavel Machek wrote:
> On Tue 2020-09-22 18:16:42, Greg Kroah-Hartman wrote:
> > On Tue, Sep 22, 2020 at 05:39:57PM +0200, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > From: Vincent Huang <vincent.huang@tw.synaptics.com>
> > > > 
> > > > commit 6c77545af100a72bf5e28142b510ba042a17648d upstream.
> > > > 
> > > > Add trackpoint variant IDs to allow supported control on Synaptics
> > > > trackpoints.
> > > 
> > > This just adds unused definitions. I don't think it is needed in
> > > stable.
> > 
> > It add support for a new device.
> 
> No, it does not. Maybe in mainline there's followup patch that adds
> such support, but that's not in 4.19.

es, indeed, there is a chunk missing, so this patch is incomplete. It
will not cause any issues if applied, so I'll leave it to Greg to decide
what to do with this.

Vincent, there needs to be a change in trackpoint_start_protocol() to
mark these new IDs as valid. Was it s3ent in a separate patch and I
missed it?

Thanks.

-- 
Dmitry
