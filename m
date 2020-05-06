Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195DC1C6D22
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 11:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729089AbgEFJkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 05:40:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25043 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729048AbgEFJkD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 May 2020 05:40:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588758002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kJ4kEjO/bwheMovYORrIfy7ArmLVCRzD0yejl3ZmrDY=;
        b=XD+HdxkjPRi5aoYZtsT0NGoAKDp15lWqrzc1KcyAe0zUaZPpD0Dcw1/04+fxVgQhUfNlbf
        Y3qEiynKov6o+UJ6mJnsrwYhEuXND3pgDj4SWNzrbhzBEFqZhgGCY/u5klXTxwS8NlUOgT
        DyiJtSuuhFFgs33u9a80mChV5qtUa3E=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-yYetJbp9MpaM0zoT6QE7YA-1; Wed, 06 May 2020 05:40:00 -0400
X-MC-Unique: yYetJbp9MpaM0zoT6QE7YA-1
Received: by mail-wr1-f70.google.com with SMTP id s11so1023958wru.6
        for <stable@vger.kernel.org>; Wed, 06 May 2020 02:40:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kJ4kEjO/bwheMovYORrIfy7ArmLVCRzD0yejl3ZmrDY=;
        b=Tm0jIwmeIP5wpo5yGFpGSArm33rsihbdRIvBsBuXypYQKarmtKGSZlaVgN5v0/9gbk
         XZQrccHzA4+/Urk3dPHqo/4SqRMIzRo6P9/m4NW9+xaMCm9Y10AmhGo4QubuUAk5Dqap
         Y5WAcQdnr+lKLpsmVPembNaSwGHY1nm/QATbdy6qxOFYxdmZt7KWoDZkagvd0XtRks5b
         S3dbeN19A4GCN8XEmS3BJn2f0+LaZKCcIEp42LqJWFw0FeXIxfea782N6hRVuBPu5QZc
         AVEbTmZ2MnGYNKfeElbiTazzYfjxy/jTvTHSED3bOKaTZ34iX8PZP7S43XxTgweuvMWf
         ctaQ==
X-Gm-Message-State: AGi0PuapUUwluzpialYGuEm1cuVCwvciHlOwQR402uDD0TKMjR+llmSx
        Xb5TSUDYHfXo//aotTQuAQN+W6q2IQlWoK1bbffEOnubhfShYd2Cg4YGo9wvTDW2XqOVSEa6oDk
        BRKiUASB06vE58Uy+
X-Received: by 2002:a5d:4c4b:: with SMTP id n11mr8949399wrt.139.1588757999144;
        Wed, 06 May 2020 02:39:59 -0700 (PDT)
X-Google-Smtp-Source: APiQypK13X0Zo4jMSTyL7ujAS9WuUrdxRvvZsqJbiGw8vpveKPhCdyH4OKPB+Frf82bNzjKr1/MqGg==
X-Received: by 2002:a5d:4c4b:: with SMTP id n11mr8949372wrt.139.1588757998970;
        Wed, 06 May 2020 02:39:58 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id m4sm1993050wrb.42.2020.05.06.02.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 02:39:58 -0700 (PDT)
Date:   Wed, 6 May 2020 05:39:55 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Justin He <Justin.He@arm.com>,
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
Message-ID: <20200506053948-mutt-send-email-mst@kernel.org>
References: <20200504081540-mutt-send-email-mst@kernel.org>
 <AM6PR08MB40696EFF8BE389C134AC04F6F7A40@AM6PR08MB4069.eurprd08.prod.outlook.com>
 <20200506031918-mutt-send-email-mst@kernel.org>
 <20200506092546.o6prnn4d66tavmjl@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506092546.o6prnn4d66tavmjl@steredhat>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 06, 2020 at 11:25:46AM +0200, Stefano Garzarella wrote:
> On Wed, May 06, 2020 at 03:19:55AM -0400, Michael S. Tsirkin wrote:
> > On Wed, May 06, 2020 at 03:28:47AM +0000, Justin He wrote:
> > > Hi Michael
> > > 
> > > > -----Original Message-----
> > > > From: Michael S. Tsirkin <mst@redhat.com>
> > > > Sent: Monday, May 4, 2020 8:16 PM
> > > > To: Linus Torvalds <torvalds@linux-foundation.org>
> > > > Cc: kvm@vger.kernel.org; virtualization@lists.linux-foundation.org;
> > > > netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Justin He
> > > > <Justin.He@arm.com>; ldigby@redhat.com; mst@redhat.com; n.b@live.com;
> > > > stefanha@redhat.com
> > > > Subject: [GIT PULL] vhost: fixes
> > > >
> > > > The following changes since commit
> > > > 6a8b55ed4056ea5559ebe4f6a4b247f627870d4c:
> > > >
> > > >   Linux 5.7-rc3 (2020-04-26 13:51:02 -0700)
> > > >
> > > > are available in the Git repository at:
> > > >
> > > >   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
> > > >
> > > > for you to fetch changes up to
> > > > 0b841030625cde5f784dd62aec72d6a766faae70:
> > > >
> > > >   vhost: vsock: kick send_pkt worker once device is started (2020-05-02
> > > > 10:28:21 -0400)
> > > >
> > > > ----------------------------------------------------------------
> > > > virtio: fixes
> > > >
> > > > A couple of bug fixes.
> > > >
> > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > >
> > > > ----------------------------------------------------------------
> > > > Jia He (1):
> > > >       vhost: vsock: kick send_pkt worker once device is started
> > > 
> > > Should this fix also be CC-ed to stable? Sorry I forgot to cc it to stable.
> > > 
> > > --
> > > Cheers,
> > > Justin (Jia He)
> > 
> > 
> > Go ahead, though recently just including Fixes seems to be enough.
> > 
> 
> The following patch Justin refers to does not contain the "Fixes:" tag:
> 
> 0b841030625c vhost: vsock: kick send_pkt worker once device is started
> 
> 
> I think we should merge it on stable branches, so if needed, I can backport
> and send it.
> 
> Stefano

Go ahead.

-- 
MST

