Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 430641B7156
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 11:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgDXJ6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 05:58:54 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:59623 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726193AbgDXJ6y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 05:58:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587722332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JE79+wofZ/vQi9Js/RC7p80m+SKhfKiuI320PsFcIa4=;
        b=RBQbzOlm9ZwmFvIQ7iEWIC/+LmBDfMeeFRh8Pb997UaL0cBD0G9t8NF2DKOiBEpJBEdkvd
        0NKgAoXu6nvlJRt6xPfM5Uuqw7HsMeTHDIaOYLUnIs4D7ylewikVZjC7ORx8KA6X4QTUNZ
        t2wUB0xGPcjhZ47UwS3sjv3Sb5SJ5qM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-93-TV-a6NB1PyuqHbYkyB7JEA-1; Fri, 24 Apr 2020 05:58:46 -0400
X-MC-Unique: TV-a6NB1PyuqHbYkyB7JEA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C288D107ACF2;
        Fri, 24 Apr 2020 09:58:44 +0000 (UTC)
Received: from sirius.home.kraxel.org (ovpn-113-193.ams2.redhat.com [10.36.113.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4EE445C1D0;
        Fri, 24 Apr 2020 09:58:44 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 4AD0A9D98; Fri, 24 Apr 2020 11:58:43 +0200 (CEST)
Date:   Fri, 24 Apr 2020 11:58:43 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Dave Airlie <airlied@redhat.com>,
        virtualization@lists.linux-foundation.org,
        spice-devel@lists.freedesktop.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH Resend] drm/qxl: Use correct notify port address when
 creating cursor ring
Message-ID: <20200424095843.owgjzaxdfkzr5ahk@sirius.home.kraxel.org>
References: <1585635488-17507-1-git-send-email-chenhc@lemote.com>
 <20200331145325.f6j2jjczlz33xuyi@sirius.home.kraxel.org>
 <CAAhV-H6vpKk=MD3PX8r6ByT7u4fhwfUcBX6c8FGVA-D0yqm28g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAhV-H6vpKk=MD3PX8r6ByT7u4fhwfUcBX6c8FGVA-D0yqm28g@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 24, 2020 at 05:57:37PM +0800, Huacai Chen wrote:
> Hi,  Gerd
> 
> On Tue, Mar 31, 2020 at 10:53 PM Gerd Hoffmann <kraxel@redhat.com> wrote:
> >
> > On Tue, Mar 31, 2020 at 02:18:08PM +0800, Huacai Chen wrote:
> > > The command ring and cursor ring use different notify port addresses
> > > definition: QXL_IO_NOTIFY_CMD and QXL_IO_NOTIFY_CURSOR. However, in
> > > qxl_device_init() we use QXL_IO_NOTIFY_CMD to create both command ring
> > > and cursor ring. This doesn't cause any problems now, because QEMU's
> > > behaviors on QXL_IO_NOTIFY_CMD and QXL_IO_NOTIFY_CURSOR are the same.
> > > However, QEMU's behavior may be change in future, so let's fix it.
> > >
> > > P.S.: In the X.org QXL driver, the notify port address of cursor ring
> > >       is correct.
> > >
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> >
> > Pushed to drm-misc-next.
> It seems that this patch hasn't appear in upstream.

Was probably to late for the 5.7 merge window, should land in 5.8

cheers,
  Gerd

