Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D9233B252
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 13:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbhCOMMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 08:12:19 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:60427 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230460AbhCOMMF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 08:12:05 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 81FD2A73;
        Mon, 15 Mar 2021 08:12:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 15 Mar 2021 08:12:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=fBzFGXpNRHFQAuoFpt3mgnhFIZl
        zWeWUYreZMDki7ow=; b=gw53q3OjkrFzCu1fp5IWbVA4JpuvJNTGU/Wbgw63OTd
        USFej0wvrXQDL1F/MFZ/clpjoPxkMAKGOx7605gn/yfef1kf9tLQLv2K7uu3wCIz
        qot2o1QJ3q0VvRgqWYCEW3/MBooAqvlsmdsV2qXPZTHntevFGX00BFFLXosR9B8D
        UjbDy3tdBTZH2wor8sJNfXBtdo7mixDUU6K6tmgfyhNMrFzH/BLj53xB0beA/3ct
        j0VtIYySnwGCRIcOFPOxzXqDCmeyaNGbJZDlWaE0JBKNzLiv0jBDzKKV904xS615
        1E7Xg0eXlLOaOTFS0o4aWSjrzoUJnAqi8Qz0GqKv3Bw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=fBzFGX
        pNRHFQAuoFpt3mgnhFIZlzWeWUYreZMDki7ow=; b=OFCs8LhIlnylYNTNYP5yPD
        ur9JBCu7IN1lxBPNCp8kiGAVdHp8MpgpLrKBZxUfNjnFwn0NATS32VA4i1OS0K1k
        d9IRf5/Al1e3UYveBzUbqau2OVWQMrtTRU2tKea1OoedFDIfJm9+sGK2wwOIwQrd
        ZYhVPgsDncp9Hm2fewIw089kMy7sty9oLbN/64hoPxzlpZsG/u+8iFZ9D0Qr2+I4
        sC9j57a9uNELy4VNtfqdkYdTXtdYuW8QXyAvtPyAV28uak1vB4WS0TT+gwyE/w5R
        OH9y0UZxEuw+j2A0IfZxjJ4IO0HTnBhfMpWmDvyuKIWYI8LzglkZ/6ut4lfPVG/g
        ==
X-ME-Sender: <xms:E09PYCdG5-OkCzOg39zOQQvwzTsL8mY6-G2nB-wppeXpa-aq3HGgNg>
    <xme:E09PYMMEapj_93UZsqqRW8Tst2vDy_ZfZssgbk-Esb5_tGuoDSVMHOgZS5N-E8tje
    d1iMdQfw47GYQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvledgfeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:E09PYDiRj5qyIjhLl7L59bwJdsImw6CHAe1mHxw3f11mA_VGf_QCeA>
    <xmx:E09PYP-QHIC1SqvyAyi-KeAF0ew_u_h8lNdWlSzDWZqwo73PTxzgZg>
    <xmx:E09PYOuaxj9vXfqBs_lbET6HycOFYJA2mybEtHubcF1xteunFLAXEw>
    <xmx:FE9PYH76k6gK--epSo85EeaTRuT2r0xZkeIPqXepnM1SegW1vDnX_A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 246EF1080069;
        Mon, 15 Mar 2021 08:12:03 -0400 (EDT)
Date:   Mon, 15 Mar 2021 13:12:00 +0100
From:   Greg KH <greg@kroah.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH v2 stable v4.4+ 1/2] iio: imu: adis16400: release
 allocated memory on failure
Message-ID: <YE9PEKdZWznxnMUo@kroah.com>
References: <20210313172950.6224-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210313172950.6224-1-krzysztof.kozlowski@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 13, 2021 at 06:29:49PM +0100, Krzysztof Kozlowski wrote:
> From: Navid Emamdoost <navid.emamdoost@gmail.com>
> 
> commit ab612b1daf415b62c58e130cb3d0f30b255a14d0 upstream.
> 
> In adis_update_scan_mode, if allocation for adis->buffer fails,
> previously allocated adis->xfer needs to be released.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> 
> ---
> 
> Changes since v1:
> 1. Add also this one for backport: v4.4 - v4.14. Newer should take
> direct cherry pick
> ---
>  drivers/iio/imu/adis_buffer.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Both patches now queued up, thanks for the backports.

greg k-h
