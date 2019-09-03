Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1F4A70A4
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731349AbfICQju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:39:50 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:43355 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730403AbfICQjt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 12:39:49 -0400
Received: by mail-io1-f67.google.com with SMTP id u185so33569100iod.10
        for <stable@vger.kernel.org>; Tue, 03 Sep 2019 09:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N4ZEq7vH4LyybBLltNPsggnz+MnaF8ltq7+1mV3M7z8=;
        b=jkuHlxpeTffQzyKV7i+2JpBXYeno5qGkifyuRpdFr9yRwi+/bp2jvkxx9lYBVPAkpc
         QoZrOZWkcUWulrSc1aWcPUCpSqIXq3wwat3oMQyk/b84xNgzpclPZvcP0kSIs7YfB7i6
         CBNOVJronTNdu4mWyF/x5DwEr0QXKAykO90Ug=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N4ZEq7vH4LyybBLltNPsggnz+MnaF8ltq7+1mV3M7z8=;
        b=pTRz05yOJ42+F4Xa1wjEhB/sz6gKSlnQtSNkb80eGBPOsM41OgZlcGi3ZehDMLfS36
         QqDsZwanqXqeQ6IZ6B0CzkXpLJ+BXAME3yL/+lhLuElsHSFT6eN6b/OFdacNXMVeHdVJ
         LaoPuIICCd+ABnE8LxwUXXpMQNEsL5Gl4FxW73aKQGqEgCocLQaTmT2+FLFUeAlvfTqk
         9elRNydCiAji6V5sDV6/S2a2WtWG5uVwxpzbX8TNWpWS7P7/JWBUsTxav4A4Sg2MBy0h
         +5s8LgybrNFwDQHPbCRiG5+o4FU+YEhW/p5lgHtMv/yg+dnnsJCZXv3QXBhHx3pvbeGE
         yepw==
X-Gm-Message-State: APjAAAWaXswO4qbMCWbNzw49xONbZNA3F+TxpidOzfh6tMiLnKkPfjqC
        ilVtJV5CFzqzzoW59CKxyeqYFaEKOMA=
X-Google-Smtp-Source: APXvYqynPw+B5WmxpHIRCfQ9eqWiuaA/U65MURxsN8dBeJD7Wyn4zOCEsyltvKnpanyrqE4y4fttfQ==
X-Received: by 2002:a02:16c5:: with SMTP id a188mr304199jaa.106.1567528788745;
        Tue, 03 Sep 2019 09:39:48 -0700 (PDT)
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com. [209.85.166.52])
        by smtp.gmail.com with ESMTPSA id n15sm2511124ioa.70.2019.09.03.09.39.48
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Sep 2019 09:39:48 -0700 (PDT)
Received: by mail-io1-f52.google.com with SMTP id f12so19906615iog.12
        for <stable@vger.kernel.org>; Tue, 03 Sep 2019 09:39:48 -0700 (PDT)
X-Received: by 2002:a02:a703:: with SMTP id k3mr26897198jam.12.1567528787667;
 Tue, 03 Sep 2019 09:39:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190903162519.7136-1-sashal@kernel.org> <20190903162519.7136-126-sashal@kernel.org>
In-Reply-To: <20190903162519.7136-126-sashal@kernel.org>
From:   Doug Anderson <dianders@chromium.org>
Date:   Tue, 3 Sep 2019 09:39:38 -0700
X-Gmail-Original-Message-ID: <CAD=FV=W0YodeoOCiCv9zmv+-gswuU8U_XgrBnesE=wynTbDBiA@mail.gmail.com>
Message-ID: <CAD=FV=W0YodeoOCiCv9zmv+-gswuU8U_XgrBnesE=wynTbDBiA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.19 126/167] tpm: Fix TPM 1.2 Shutdown sequence
 to prevent future TPM operations
To:     Sasha Levin <sashal@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>,
        Vadim Sukhomlinov <sukhomlinov@google.com>,
        linux-integrity@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Tue, Sep 3, 2019 at 9:28 AM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Vadim Sukhomlinov <sukhomlinov@google.com>
>
> [ Upstream commit db4d8cb9c9f2af71c4d087817160d866ed572cc9 ]
>
> TPM 2.0 Shutdown involve sending TPM2_Shutdown to TPM chip and disabling
> future TPM operations. TPM 1.2 behavior was different, future TPM
> operations weren't disabled, causing rare issues. This patch ensures
> that future TPM operations are disabled.
>
> Fixes: d1bd4a792d39 ("tpm: Issue a TPM2_Shutdown for TPM2 devices.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Vadim Sukhomlinov <sukhomlinov@google.com>
> [dianders: resolved merge conflicts with mainline]
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/char/tpm/tpm-chip.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Jarkko: did you deal with the issues that came up in response to my
post?  Are you happy with this going into 4.19 stable at this point?
I notice this has your Signed-off-by so maybe?

-Doug
