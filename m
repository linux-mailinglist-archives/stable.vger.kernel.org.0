Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3E6C339E52
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 14:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233423AbhCMNhi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 08:37:38 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45819 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230309AbhCMNhG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Mar 2021 08:37:06 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 8DC255C00AC;
        Sat, 13 Mar 2021 08:37:05 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 13 Mar 2021 08:37:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=ZCe7sz1gX/VS/MJ+o0BPscvjdQV
        q6lbwEMdDYWRsERs=; b=smZWWFgf/6754r7Ss86WMFPIsLSI8XjYKaoDSXpgH+K
        y/3Vim50buNJaRwUWUSHsfrGEoWeeGHz4kW1hS8QMwxPJ8fpeCxEFeruu/N+uND/
        JDetLjOp/wLPomMXSPEowGnYT9ajAv0l1BpYOoNqbRLyf0d7rvZ8FZ0qjU6Ctt5N
        JPN9BEN7D+VtWyqHS/Ie3h79Q3ZY3QdrQNExTqRC9JZHO4sZuffkvvXOlPdaBu73
        cNG1xaUOEtD+u6zB1oiGPMeEF3VDk3YsrJ4k0wkOAXvZD7wrw/S5pwzfh0SffzuE
        UMV2/XqwytN2WAPOmtYThoTMdBe9pKO0Ynqj0aw+K6w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ZCe7sz
        1gX/VS/MJ+o0BPscvjdQVq6lbwEMdDYWRsERs=; b=IGoe+76fLLy+s0lc/ny8vE
        EUb9bOeOgSk3oUxi8vGjVfxbwpuXZhjpx7cxN0kaO2znjQ7NxWCVtAnFHg5Zix3I
        7/5aBrr6zQJjH5nRM/EPJ1KTy46lRP4+XCVEmpSK7QhBW9ZdvYKKToiF2BQJBVBK
        lSkLw4lG/RoHrxC0loQ6ypiP9nv86Q9zUOxkmLrWdPyFbfHBUL+HOgS9yI14jLme
        mEKmgtzivQ5L+8VxrFS1uRqhBZgmfZyVhdlrmE7xiX2CzUT5OQACncUEoF4NYsHg
        JBRouv3IvoIGDO53w2DdoRB7q3mCbAOYQfF3Mkz8ZoWXS5MopyMpb5reW+IuWgkQ
        ==
X-ME-Sender: <xms:AMBMYBduUwkJHY3_-L0MiD2yPQ7GNj1tQRe56-GC_bVeq6G8xiiThw>
    <xme:AMBMYPOlmKR83RFljZZgPugqy0uxn_m94N3RM1gGDpdzpjAuhJKlq62HnGB4V3cqo
    0TKvcvoVKM3ag>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvgedgheefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:AMBMYKhSe-eeRTqRbzxYTolZq1sfnuklipp9jb4eSQPBFfGebIYkyQ>
    <xmx:AMBMYK-NiIP5bzBJZDYPLGTW7UgH40d5MCSbojG-Yn6BZptaW6PDbQ>
    <xmx:AMBMYNtRB0wLiOyBSpvkixovOCLSIiPryvU_U9iJ57XpSt2qUafCcw>
    <xmx:AcBMYG6fOu9fW0qPBqJ9-xDDGkavXQv7sJAzB7To6c8aAuJm2z_l2g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 67A451080057;
        Sat, 13 Mar 2021 08:37:04 -0500 (EST)
Date:   Sat, 13 Mar 2021 14:37:02 +0100
From:   Greg KH <greg@kroah.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH stable v4.4] iio: imu: adis16400: fix memory leak
Message-ID: <YEy//r+IqxvR/tbu@kroah.com>
References: <20210312170311.17464-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312170311.17464-1-krzysztof.kozlowski@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 12, 2021 at 06:03:11PM +0100, Krzysztof Kozlowski wrote:
> From: Navid Emamdoost <navid.emamdoost@gmail.com>
> 
> commit 9c0530e898f384c5d279bfcebd8bb17af1105873 upstream.
> 
> In adis_update_scan_mode_burst, if adis->buffer allocation fails release
> the adis->xfer.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> (cherry picked from commit 9c0530e898f384c5d279bfcebd8bb17af1105873)
> [krzk: backport applied to adis16400_buffer.c instead of adis_buffer.c]
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  drivers/iio/imu/adis16400_buffer.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

What about 4.9.y?  Will this backport also work there too?

thanks,

greg k-h
