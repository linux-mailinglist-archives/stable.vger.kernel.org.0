Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3AAD10B159
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 15:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfK0ObG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 09:31:06 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56036 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726655AbfK0ObG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 09:31:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574865064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1qcF+crjPekI2g8F6yg4/QAlr2yre5tEiiDaK0bT3vQ=;
        b=AoUKvLspMc6+5MLytUtLBNtUs4WgroBWNptXSl489L9XdjPFvCNNB7aG2lA5eGEeajLhEY
        x200MUGzQQuTKQbboDnsX3xhug8GpYQMCN6WmSc43OdHImkOD/Roz5o6BFabzfDhF2+5Cl
        2mWV3x7YJsurMFR35GasOXwraA92h2Q=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-A_rtIJtNOgOlyn3MyVsQNQ-1; Wed, 27 Nov 2019 09:31:01 -0500
Received: by mail-qt1-f200.google.com with SMTP id t20so2689549qtr.3
        for <stable@vger.kernel.org>; Wed, 27 Nov 2019 06:31:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6Y6VVgVGk8pMJiR+6qRJ22Q71fs5rouFL3QXyb1XcZA=;
        b=sgkHq7dgB3aqT+U8zkZXc7+BfIASMp+sMSoLgRiD7nqanTpLzQAlM++iE+GmsFYLcu
         spC4pMLASKeA5qpAq9Q292EZSFaf4hpI8J1LS/vLp+Ir2RCFa6PMRvW2Mne/sgco65iJ
         pW7B5S5qeaQ4fluHrxk7YJ7r8Bu3cQrGLVoCiqihgsvfUvxpMb2j2kLtT0fQYS4Vjuwf
         rpKkd8w1Vit3eRAFgl5Dpey2LuXy0s7tpOIJt1TaoZf0F/OE2lnPt81fkYE0P5ZJ9shE
         PD0j6Hop/lS0dSdvAHdMeq8gbuMUunO+q8tyD8MXJTlsQObMFEVhApTK74pnnnWiW6HL
         Q4dg==
X-Gm-Message-State: APjAAAV5rW5xU4UTSIlr+CP8TgTJS3uIHmy0nD2qwSdARBT6V8VrkMkQ
        QRBz6LrGeMYE3YFKYYrcTGHKq87S9uaQeegAPLeZpxdg7t+86wsrfUOCshSlWARwoG4SmMMYYLN
        jJP/tmaN2L8Poa+lB
X-Received: by 2002:ac8:2a42:: with SMTP id l2mr24949300qtl.64.1574865060881;
        Wed, 27 Nov 2019 06:31:00 -0800 (PST)
X-Google-Smtp-Source: APXvYqzotu2JM6pl4rL4YgxrQP8qwI9A8WEBjCBQXNtBehs13skLo0LF9qkmUReZy+2xgD1SYBaxsg==
X-Received: by 2002:ac8:2a42:: with SMTP id l2mr24949284qtl.64.1574865060713;
        Wed, 27 Nov 2019 06:31:00 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id g25sm7792944qtc.90.2019.11.27.06.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 06:30:59 -0800 (PST)
Date:   Wed, 27 Nov 2019 09:30:55 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     gregkh@linuxfoundation.org, wei.w.wang@intel.com, david@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] virtio_balloon: fix shrinker count"
 failed to apply to 4.19-stable tree
Message-ID: <20191127093031-mutt-send-email-mst@kernel.org>
References: <1574703882140153@kroah.com>
 <20191127022359.GN5861@sasha-vm>
MIME-Version: 1.0
In-Reply-To: <20191127022359.GN5861@sasha-vm>
X-MC-Unique: A_rtIJtNOgOlyn3MyVsQNQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 26, 2019 at 09:23:59PM -0500, Sasha Levin wrote:
> On Mon, Nov 25, 2019 at 06:44:42PM +0100, gregkh@linuxfoundation.org wrot=
e:
> >=20
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> >=20
> > thanks,
> >=20
> > greg k-h
> >=20
> > ------------------ original commit in Linus's tree ------------------
> >=20
> > From c9a6820fc0da2603be3054ee7590eb9f350508a7 Mon Sep 17 00:00:00 2001
> > From: Wei Wang <wei.w.wang@intel.com>
> > Date: Tue, 19 Nov 2019 05:02:33 -0500
> > Subject: [PATCH] virtio_balloon: fix shrinker count
> >=20
> > Instead of multiplying by page order, virtio balloon divided by page
> > order. The result is that it can return 0 if there are a bit less
> > than MAX_ORDER - 1 pages in use, and then shrinker scan won't be called=
.
> >=20
> > Cc: stable@vger.kernel.org
> > Fixes: 71994620bb25 ("virtio_balloon: replace oom notifier with shrinke=
r")
> > Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > Reviewed-by: David Hildenbrand <david@redhat.com>
>=20
> I think that the fixes tag should be pointing to 86a559787e6f
> ("virtio-balloon: VIRTIO_BALLOON_F_FREE_PAGE_HINT"), and this commit
> isn't needed on 4.19.

I believe you are right but don't see a way to fix that as the patch is
upstream.

> --=20
> Thanks,
> Sasha

