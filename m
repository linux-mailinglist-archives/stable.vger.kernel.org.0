Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD70C1998FA
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 16:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730153AbgCaOxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 10:53:39 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45184 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730149AbgCaOxi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 10:53:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585666418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nDs6T+KryTBsmRrAElzm+mnqqyDifHGjX0HWIx3qyik=;
        b=HXPQs9tF+OJ+gaQdMskQsywqT9S7y9yckCn9cAIqxIIwH2dSzr6DzKKSNFv1nRrULMAB7X
        0ogXm8JzFqMGLb9v5xRKYJ/DlWz9vtaqBCHQ63HPt/vYuZ6pZTeomiDgb5fJfh5zbo96vl
        pwzTIug7gAtPihk9g+ugtsXh6wEecdk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-127-hpUKDwKsMFGSk8FPm3Jkhg-1; Tue, 31 Mar 2020 10:53:30 -0400
X-MC-Unique: hpUKDwKsMFGSk8FPm3Jkhg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB7251005509;
        Tue, 31 Mar 2020 14:53:28 +0000 (UTC)
Received: from sirius.home.kraxel.org (ovpn-112-49.ams2.redhat.com [10.36.112.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E4BC41001B2B;
        Tue, 31 Mar 2020 14:53:26 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id F1E3D31F24; Tue, 31 Mar 2020 16:53:25 +0200 (CEST)
Date:   Tue, 31 Mar 2020 16:53:25 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Dave Airlie <airlied@redhat.com>,
        virtualization@lists.linux-foundation.org,
        spice-devel@lists.freedesktop.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH Resend] drm/qxl: Use correct notify port address when
 creating cursor ring
Message-ID: <20200331145325.f6j2jjczlz33xuyi@sirius.home.kraxel.org>
References: <1585635488-17507-1-git-send-email-chenhc@lemote.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585635488-17507-1-git-send-email-chenhc@lemote.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 31, 2020 at 02:18:08PM +0800, Huacai Chen wrote:
> The command ring and cursor ring use different notify port addresses
> definition: QXL_IO_NOTIFY_CMD and QXL_IO_NOTIFY_CURSOR. However, in
> qxl_device_init() we use QXL_IO_NOTIFY_CMD to create both command ring
> and cursor ring. This doesn't cause any problems now, because QEMU's
> behaviors on QXL_IO_NOTIFY_CMD and QXL_IO_NOTIFY_CURSOR are the same.
> However, QEMU's behavior may be change in future, so let's fix it.
> 
> P.S.: In the X.org QXL driver, the notify port address of cursor ring
>       is correct.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Huacai Chen <chenhc@lemote.com>

Pushed to drm-misc-next.

thanks,
  Gerd

