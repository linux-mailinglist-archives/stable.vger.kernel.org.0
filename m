Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3851C69F0
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 09:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbgEFHUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 03:20:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21980 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727982AbgEFHUF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 May 2020 03:20:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588749604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=736cry6ayk4bFoTJ6GjBafnY0xYXIZ6Pinl17EvWj60=;
        b=MiKOwhM6zcyrkvsCTDfKmdl7uCxGO4bW2yJEo6U/sGUnOBn5jghX3Mz+Zf4tWpMRwahD4l
        xRn/dW2ZtjWqGGyqV1pu9bN0TzX7N8/rddQ+btHSlqNCf+saGY/Bje4BBqaUNTQchoe/4y
        kFtBatf08TLyXyKRw3hCB4/+DwYlmqQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-25ZvavzpMRm_-RdeIILSYw-1; Wed, 06 May 2020 03:20:00 -0400
X-MC-Unique: 25ZvavzpMRm_-RdeIILSYw-1
Received: by mail-wm1-f72.google.com with SMTP id h22so744972wml.1
        for <stable@vger.kernel.org>; Wed, 06 May 2020 00:19:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=736cry6ayk4bFoTJ6GjBafnY0xYXIZ6Pinl17EvWj60=;
        b=Cvqu1DEAy4s2+hCa7vMUlk6ja08oFyxQcfxf6MbB1/aS+LO6CBIRLdXrC1CqWt0pc/
         KuBLqgtDUvhRaoKmK2BJQb/ezn1xg3I/U+KI42w1Laa5YQEVbCB0OOJoriiULrM87WJo
         WU+f0J0Us7BkO8lS7REwYuwRHnRd4aiO92P9A2QTc8Kup78C0QbVVVsb41al6qS8otPc
         3XKS9H1XIOvNCVxpRMwrsW/rJAsITZKxvOOh7T39GVALnJeU7QBBtHeCvvwc2yWctNA5
         Pp/wKwbpUEFjH32DV8q9wOaVtcNkR/1MCeEZKozzOkxDzHAs26+fR+/hAQB+MzOgwz0m
         1zTw==
X-Gm-Message-State: AGi0PuZ8SwNGfVW6dFdItuPJpUfvBhInSg69h4fN3iInvDXUSym4lcK5
        r/XpCWDjU86V75lq4P0vgUbJTGyehp8t5BXRDX0gj6LWTP8baT8HD+DCXf5xOQg3/zzdMEIygxw
        wpy4zIWNJlS3Nnpce
X-Received: by 2002:a7b:c38e:: with SMTP id s14mr2569988wmj.12.1588749599088;
        Wed, 06 May 2020 00:19:59 -0700 (PDT)
X-Google-Smtp-Source: APiQypIV+r+NtiFQvVY9XndOnisjRoTPFVUYqnvGw+P8xp0StDMwaXBjj0p0abeACiuHrrh2hF04MA==
X-Received: by 2002:a7b:c38e:: with SMTP id s14mr2569971wmj.12.1588749598878;
        Wed, 06 May 2020 00:19:58 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id o129sm1727634wme.16.2020.05.06.00.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 00:19:58 -0700 (PDT)
Date:   Wed, 6 May 2020 03:19:55 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Justin He <Justin.He@arm.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
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
Message-ID: <20200506031918-mutt-send-email-mst@kernel.org>
References: <20200504081540-mutt-send-email-mst@kernel.org>
 <AM6PR08MB40696EFF8BE389C134AC04F6F7A40@AM6PR08MB4069.eurprd08.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR08MB40696EFF8BE389C134AC04F6F7A40@AM6PR08MB4069.eurprd08.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 06, 2020 at 03:28:47AM +0000, Justin He wrote:
> Hi Michael
> 
> > -----Original Message-----
> > From: Michael S. Tsirkin <mst@redhat.com>
> > Sent: Monday, May 4, 2020 8:16 PM
> > To: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: kvm@vger.kernel.org; virtualization@lists.linux-foundation.org;
> > netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Justin He
> > <Justin.He@arm.com>; ldigby@redhat.com; mst@redhat.com; n.b@live.com;
> > stefanha@redhat.com
> > Subject: [GIT PULL] vhost: fixes
> >
> > The following changes since commit
> > 6a8b55ed4056ea5559ebe4f6a4b247f627870d4c:
> >
> >   Linux 5.7-rc3 (2020-04-26 13:51:02 -0700)
> >
> > are available in the Git repository at:
> >
> >   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
> >
> > for you to fetch changes up to
> > 0b841030625cde5f784dd62aec72d6a766faae70:
> >
> >   vhost: vsock: kick send_pkt worker once device is started (2020-05-02
> > 10:28:21 -0400)
> >
> > ----------------------------------------------------------------
> > virtio: fixes
> >
> > A couple of bug fixes.
> >
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >
> > ----------------------------------------------------------------
> > Jia He (1):
> >       vhost: vsock: kick send_pkt worker once device is started
> 
> Should this fix also be CC-ed to stable? Sorry I forgot to cc it to stable.
> 
> --
> Cheers,
> Justin (Jia He)


Go ahead, though recently just including Fixes seems to be enough.


> 
> >
> > Stefan Hajnoczi (1):
> >       virtio-blk: handle block_device_operations callbacks after hot unplug
> >
> >  drivers/block/virtio_blk.c | 86
> > +++++++++++++++++++++++++++++++++++++++++-----
> >  drivers/vhost/vsock.c      |  5 +++
> >  2 files changed, 83 insertions(+), 8 deletions(-)
> 
> IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.

