Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8C11C6CCF
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 11:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729075AbgEFJZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 05:25:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31519 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728885AbgEFJZz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 May 2020 05:25:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588757154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Bim1c8eCjYcLbuTSswn0dpCBvXNi8zOQ0N1tlPafZn4=;
        b=a/WX2MvpVfdLwgMlWsGaXFmhPJcEm7GcakNQf4XqzojKV3Faq0mIzyu3iSox1aInkgs6G2
        3kXdS1nfFOMklUg4HOCBZHDgQMasoFz6YVizWYfuT7YcnmF96jDMbwGqbTZaYEkyJMCYHv
        uyows5NyV74pEW5pv34t7DNBcGNFeTI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-JI3ktFf5NEqmwrP31mTT0Q-1; Wed, 06 May 2020 05:25:50 -0400
X-MC-Unique: JI3ktFf5NEqmwrP31mTT0Q-1
Received: by mail-wm1-f72.google.com with SMTP id v23so598026wmj.0
        for <stable@vger.kernel.org>; Wed, 06 May 2020 02:25:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Bim1c8eCjYcLbuTSswn0dpCBvXNi8zOQ0N1tlPafZn4=;
        b=aHXynAIUBYiDxj9qmbu1GVnij3P4F9AWBZtxt8LMrYVShJSSt1AcP6/4Dh5ssForgC
         QfhE1e4DuHs60qn2hMKLDRd167UM17GWmLl1lFmoOt86SYKqhHArcS3G2jBWpqLT/QyM
         qLmDbLv1gnxi7DshM4ERV3GOUQ7qGHQcA9Dde+vUH0GMIHsDtWN+FloooLE1g+pmElpx
         mJsYrtKNnHHuTXX6G76uIMhK9acsKQpwJdl7Ad/20gKK6hVYRI3dv5Kg/ET9okopnmiE
         eBUXQ2PJSVl99nMz6BV02SObNy2EjjOJJt88R4Yg6vV0SjhdhKJVVxhxsihxPusi4U7T
         1J/g==
X-Gm-Message-State: AGi0PuarYv88FuIlZHwYCJFBgijlAFnWlIIJlgF7bEKkgXezTsGfw+/J
        Z9bw7rFCf6QqV1Bkv+ppzRFvmhdOYSHCMbtbwSl/tw5Wcg/xYH+D3K46SiZnFigvf2YybMYeqJD
        c1i0X7n4nf4T50RCn
X-Received: by 2002:adf:dfcd:: with SMTP id q13mr7131688wrn.22.1588757149678;
        Wed, 06 May 2020 02:25:49 -0700 (PDT)
X-Google-Smtp-Source: APiQypKDcQLCEb81yrXyKaZpg3LwlEaXE+I6k94/3G8d4AwC2GS8U1KX5Fn5b7fyFPoR8Cv9PqLECw==
X-Received: by 2002:adf:dfcd:: with SMTP id q13mr7131657wrn.22.1588757149453;
        Wed, 06 May 2020 02:25:49 -0700 (PDT)
Received: from steredhat (host108-207-dynamic.49-79-r.retail.telecomitalia.it. [79.49.207.108])
        by smtp.gmail.com with ESMTPSA id c25sm2030281wmb.44.2020.05.06.02.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 02:25:48 -0700 (PDT)
Date:   Wed, 6 May 2020 11:25:46 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     Justin He <Justin.He@arm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ldigby@redhat.com" <ldigby@redhat.com>,
        "n.b@live.com" <n.b@live.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] vhost: fixes
Message-ID: <20200506092546.o6prnn4d66tavmjl@steredhat>
References: <20200504081540-mutt-send-email-mst@kernel.org>
 <AM6PR08MB40696EFF8BE389C134AC04F6F7A40@AM6PR08MB4069.eurprd08.prod.outlook.com>
 <20200506031918-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506031918-mutt-send-email-mst@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 06, 2020 at 03:19:55AM -0400, Michael S. Tsirkin wrote:
> On Wed, May 06, 2020 at 03:28:47AM +0000, Justin He wrote:
> > Hi Michael
> > 
> > > -----Original Message-----
> > > From: Michael S. Tsirkin <mst@redhat.com>
> > > Sent: Monday, May 4, 2020 8:16 PM
> > > To: Linus Torvalds <torvalds@linux-foundation.org>
> > > Cc: kvm@vger.kernel.org; virtualization@lists.linux-foundation.org;
> > > netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Justin He
> > > <Justin.He@arm.com>; ldigby@redhat.com; mst@redhat.com; n.b@live.com;
> > > stefanha@redhat.com
> > > Subject: [GIT PULL] vhost: fixes
> > >
> > > The following changes since commit
> > > 6a8b55ed4056ea5559ebe4f6a4b247f627870d4c:
> > >
> > >   Linux 5.7-rc3 (2020-04-26 13:51:02 -0700)
> > >
> > > are available in the Git repository at:
> > >
> > >   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
> > >
> > > for you to fetch changes up to
> > > 0b841030625cde5f784dd62aec72d6a766faae70:
> > >
> > >   vhost: vsock: kick send_pkt worker once device is started (2020-05-02
> > > 10:28:21 -0400)
> > >
> > > ----------------------------------------------------------------
> > > virtio: fixes
> > >
> > > A couple of bug fixes.
> > >
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > >
> > > ----------------------------------------------------------------
> > > Jia He (1):
> > >       vhost: vsock: kick send_pkt worker once device is started
> > 
> > Should this fix also be CC-ed to stable? Sorry I forgot to cc it to stable.
> > 
> > --
> > Cheers,
> > Justin (Jia He)
> 
> 
> Go ahead, though recently just including Fixes seems to be enough.
> 

The following patch Justin refers to does not contain the "Fixes:" tag:

0b841030625c vhost: vsock: kick send_pkt worker once device is started


I think we should merge it on stable branches, so if needed, I can backport
and send it.

Stefano

