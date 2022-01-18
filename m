Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812E3491F93
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 07:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241421AbiARG4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 01:56:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51935 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240184AbiARG4e (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 01:56:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642488994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AmJlqI3V1Qshx6eMkpy4chv7mvxWHrVFABtLYD/f+QU=;
        b=Ro+t2Mz/8SoHOAl1RluiSyiUV4bJkJU1qBsJFvbulZ6MiMIm0ZoQG0/sgMIRTTsAPtl8wP
        PnJ98Se337kyZxoegUCV8cSUaE9ajrAVdtVCmg344rmHdrW27IV0oepus/3QWhXCX1DbUk
        EaUovu79x4KcEvtQRO8T5i1uHT2LOZk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-280-spQxhNexNYmXEy-j9274sw-1; Tue, 18 Jan 2022 01:56:28 -0500
X-MC-Unique: spQxhNexNYmXEy-j9274sw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 391F580ED84;
        Tue, 18 Jan 2022 06:56:27 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.49])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9DB2C79455;
        Tue, 18 Jan 2022 06:56:26 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id D1F3E18000A6; Tue, 18 Jan 2022 07:56:24 +0100 (CET)
Date:   Tue, 18 Jan 2022 07:56:24 +0100
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     airlied@linux.ie, daniel@ffwll.ch, dri-devel@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+e9072e90624a31dfa85f@syzkaller.appspotmail.com
Subject: Re: [PATCH] drm/virtio: Ensure that objs is not NULL in
 virtio_gpu_array_put_free()
Message-ID: <20220118065624.uw76mxi2ij3ho4r4@sirius.home.kraxel.org>
References: <20211213183122.838119-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213183122.838119-1-roberto.sassu@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 13, 2021 at 07:31:22PM +0100, Roberto Sassu wrote:
> If virtio_gpu_object_shmem_init() fails (e.g. due to fault injection, as it
> happened in the bug report by syzbot), virtio_gpu_array_put_free() could be
> called with objs equal to NULL.
> 
> Ensure that objs is not NULL in virtio_gpu_array_put_free(), or otherwise
> return from the function.
> 
> Cc: stable@vger.kernel.org # 5.13.x
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> Reported-by: syzbot+e9072e90624a31dfa85f@syzkaller.appspotmail.com
> Fixes: 377f8331d0565 ("drm/virtio: fix possible leak/unlock virtio_gpu_object_array")

Pushed to drm-misc-next.

thanks,
  Gerd

