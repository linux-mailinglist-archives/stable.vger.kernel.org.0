Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2121012A3
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 05:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbfKSErG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 23:47:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:56128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726748AbfKSErG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Nov 2019 23:47:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AA23222DD;
        Tue, 19 Nov 2019 04:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574138825;
        bh=ZDGgR81wu4Yd4RDYraq0eHaQhXVp4oDD2gmqGqLN0cc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mWov7ZdrgYqDjH05QstC5trCuQaiY9e3tjOg42AhJ9FSlO0UEF6cqp1Ur0iLBQUw9
         YkcbPzDvFdJ67qg1oMFDPJvigWPh6So4zHvNKNQZJWBT2JWB/56jCd7zgWikkX3o2S
         f/myLuPAyNOq6U6g/KBh7B+0S3UJihCN8ds3vT+8=
Date:   Tue, 19 Nov 2019 05:47:03 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ralph Siemsen <ralph.siemsen@linaro.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+899a33dc0fa0dbaf06a6@syzkaller.appspotmail.com,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Jeremy Cline <jcline@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH 4.9 02/31] Bluetooth: hci_ldisc: Postpone
 HCI_UART_PROTO_READY bit set in hci_uart_set_proto()
Message-ID: <20191119044703.GA1451491@kroah.com>
References: <20191115062009.813108457@linuxfoundation.org>
 <20191115062010.682028342@linuxfoundation.org>
 <20191115161029.GA32365@maple.netwinder.org>
 <20191116075614.GB381281@kroah.com>
 <20191118202712.GA14832@maple.netwinder.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191118202712.GA14832@maple.netwinder.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 18, 2019 at 03:27:12PM -0500, Ralph Siemsen wrote:
> On Sat, Nov 16, 2019 at 03:56:14PM +0800, Greg Kroah-Hartman wrote:
> > > 
> > > BTW, this also seems to be missing from 4.4 branch, although it was merged
> > > for 3.16 (per https://lore.kernel.org/stable/?q=Postpone+HCI).
> > 
> > Odd that it was merged into 3.16, perhaps it was done there because some
> > earlier patch added the problem?
> 
> This patch should really be viewed as a correction to an earlier commit:
> 84cb3df02aea ("Bluetooth: hci_ldisc: Fix null pointer derefence in case of
> early data"). This was merged 2016-Apr-08 into v4.7, and therefore is
> included in 4.9 and higher.
> 
> Only very recently, on 2019-Sep-23, this was backported to 3.16, along with
> the correction. Both appeared in v3.16.74.

Ok, that makes more sense now.  The "fix" didn't apply as it was not a
fix for an old issue, but rather a new one.

> > I say this as I do not think this is
> > relevant for the 4.4.y kernel, do you?  Have you tried to apply this
> > patch there?
> 
> The patch does not apply, but this is mainly due to the earlier commit
> missing. It seems to me like that earlier fix is desirable (and it was put
> into 3.16), along with the followup. So I would think we want it in 4.4 as
> well.

I've queued them both up now, thanks.

> [Aside: I'm really only interested in 4.9 and 4.19, so the 4.4 stuff is just
> a diversion. But figured I might as well mention what I found...]

Other people at your company care about 4.4.y :)

thanks,

greg k-h
