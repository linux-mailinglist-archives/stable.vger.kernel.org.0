Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30551E9688
	for <lists+stable@lfdr.de>; Sun, 31 May 2020 11:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgEaJV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 May 2020 05:21:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39514 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725813AbgEaJV4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 May 2020 05:21:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590916914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ywTf4qZlZwxY3+4hdzNIdEQ5uHrIZLnoqwJn0ChNVtk=;
        b=R1SC8nxEzgEfwCHaP6E1Z8jpGn/UWlPmOPjyfFFji4u6MvrhFEp4aKCvNvhIjantnSWe5q
        FytfNonb67U587I3M6Ba+SsoD2J7eOUDMEEingoQHSS+uRthJU8a9E98YmFZeXNKrTWM6F
        9wopIf18zIfOs13tuYtnl7Kitw0Eyw0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-5KPoL2BJMM278XKT1hgOYQ-1; Sun, 31 May 2020 05:21:53 -0400
X-MC-Unique: 5KPoL2BJMM278XKT1hgOYQ-1
Received: by mail-wr1-f70.google.com with SMTP id h92so3239626wrh.23
        for <stable@vger.kernel.org>; Sun, 31 May 2020 02:21:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ywTf4qZlZwxY3+4hdzNIdEQ5uHrIZLnoqwJn0ChNVtk=;
        b=kRUJhh7lmk8rPqpgxW/TGacmQTUiBu4tN/Y88Cb0G1xPscH9Hzz2xSekHJy9WSlatg
         KeTjt6jaRzV5IvAKGHkw61wYiUMNUWT4ploLfzgIWbVpI8bWD0Yhr744ADUNfrrjb8lr
         a+Gw/W/khjxytVcCxCIr2IH3P/5/kdzoxy71EhbAdDSgkq13tYQDQYb2FH+/Zceynq9v
         qYMvFHD+SarSq8IaX3lRPBJuJmdZCB3FdFySLz5PukhLjGMin9bo0NAMOjdEtzMlHNeT
         PJD+R72eJITHF/rjEUMGjomZYf+FK1Gl9xzi8z/ZKZjPsqA9/+sP1ag5EZDRM3qeikvg
         xmTA==
X-Gm-Message-State: AOAM531zlbrjJw5WJXI78tKlLHVtZMx2RTYs20BMc2LKycmDzRJJmbVY
        e++OmcI3T3ljVNJontdeko9QGRFTPcmxYBKzdw1moV3x/AB02Y724OQiDJyFo2Tbmt4xhJlMPZN
        V78wVSlo/Qyj6ZVUk
X-Received: by 2002:a1c:230a:: with SMTP id j10mr16369531wmj.124.1590916911666;
        Sun, 31 May 2020 02:21:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzzcgV6CUih1OZuVP6HyzHPhx3Qo76tys5xO9OetvdQfwhqn22ihHvFUhLx7Ow9OvlukxlV9g==
X-Received: by 2002:a1c:230a:: with SMTP id j10mr16369518wmj.124.1590916911412;
        Sun, 31 May 2020 02:21:51 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id 23sm7468291wmo.18.2020.05.31.02.21.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 02:21:50 -0700 (PDT)
Date:   Sun, 31 May 2020 05:21:48 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     "Longpeng(Mike)" <longpeng2@huawei.com>,
        linux-crypto@vger.kernel.org, Gonglei <arei.gonglei@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Markus Elfring <Markus.Elfring@web.de>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] crypto: virtio: Fix use-after-free in
 virtio_crypto_skcipher_finalize_req()
Message-ID: <20200531052126-mutt-send-email-mst@kernel.org>
References: <20200526031956.1897-3-longpeng2@huawei.com>
 <20200526141138.8410D207FB@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526141138.8410D207FB@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 26, 2020 at 02:11:37PM +0000, Sasha Levin wrote:
> <20200123101000.GB24255@Red>
> References: <20200526031956.1897-3-longpeng2@huawei.com>
> <20200123101000.GB24255@Red>
> 
> Hi
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag
> fixing commit: dbaf0624ffa5 ("crypto: add virtio-crypto driver").
> 
> The bot has tested the following trees: v5.6.14, v5.4.42, v4.19.124, v4.14.181.
> 
> v5.6.14: Build OK!
> v5.4.42: Failed to apply! Possible dependencies:
>     eee1d6fca0a0 ("crypto: virtio - switch to skcipher API")
> 
> v4.19.124: Failed to apply! Possible dependencies:
>     eee1d6fca0a0 ("crypto: virtio - switch to skcipher API")
> 
> v4.14.181: Failed to apply! Possible dependencies:
>     500e6807ce93 ("crypto: virtio - implement missing support for output IVs")
>     67189375bb3a ("crypto: virtio - convert to new crypto engine API")
>     d0d859bb87ac ("crypto: virtio - Register an algo only if it's supported")
>     e02b8b43f55a ("crypto: virtio - pr_err() strings should end with newlines")
>     eee1d6fca0a0 ("crypto: virtio - switch to skcipher API")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

Mike could you comment on backporting?

> -- 
> Thanks
> Sasha

