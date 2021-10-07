Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0796F425519
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 16:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241956AbhJGOPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 10:15:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241679AbhJGOPv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Oct 2021 10:15:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10919610C7;
        Thu,  7 Oct 2021 14:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633616037;
        bh=pMU2+RK50Qv/4VNm4oFS8R4BonkUuJ2i0rz98X7NWhE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DpSjcM3QK3X61FROl/1mDyDtqYJ3tBxzr2t3/u4eL4dLAwK8fzYVVUi+bcaPC4Nq3
         T2u6n4P9JuB6Ehj0uaAeWHAULDpzB3OCDpfLWtaTIdxDUN12Wkt48OuytqvhvdnvKN
         HRoNCa2byULpYDcco/VmyD97jPLn77nshV3EVF2Q=
Date:   Thu, 7 Oct 2021 16:13:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Corentin =?iso-8859-1?Q?No=EBl?= <corentin.noel@collabora.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-stable <stable@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        regressions@lists.linux.dev, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: Re: virtio-net: kernel panic in virtio_net.c
Message-ID: <YV8Ao5W4/z5sB5b9@kroah.com>
References: <5edaa2b7c2fe4abd0347b8454b2ac032b6694e2c.camel@collabora.com>
 <20211007090601-mutt-send-email-mst@kernel.org>
 <CANn89i+-P_mS-0jOM7SD4f291+Jbc9PORYJx2+gfQbebiX3z_A@mail.gmail.com>
 <b517d143c6ec0960eedcbf8f6917776bc67c5fd4.camel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b517d143c6ec0960eedcbf8f6917776bc67c5fd4.camel@collabora.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 07, 2021 at 04:02:10PM +0200, Corentin Noël wrote:
> Le jeudi 07 octobre 2021 à 06:51 -0700, Eric Dumazet a écrit :
> > On Thu, Oct 7, 2021 at 6:11 AM Michael S. Tsirkin <mst@redhat.com>
> > wrote:
> > > On Thu, Oct 07, 2021 at 02:04:22PM +0200, Corentin Noël wrote:
> > > > I've been experiencing crashes with 5.14-rc1 and above that do
> > > > not
> > > > occur with 5.13,
> > 
> > What about 5.14 ?
> > 
> > 5.14-rc1 has many bugs we do not want to spend time rediscovering
> > them...
> > 
> 
> I've tested on 5.14, 5.15-rc4 and 5.15-rc4 with latest netdev and could
> reproduce the crash on them all.

Great, any chance you can use 'git bisect' to find the offending commit?

thanks,

greg k-h
