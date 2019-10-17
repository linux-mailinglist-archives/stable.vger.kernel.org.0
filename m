Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFC48DB2CA
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 18:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503042AbfJQQuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 12:50:55 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:36518 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394336AbfJQQuz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Oct 2019 12:50:55 -0400
Received: by mail-il1-f194.google.com with SMTP id z2so2731126ilb.3
        for <stable@vger.kernel.org>; Thu, 17 Oct 2019 09:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tBLNQqGbXkMMNFqwqmoHYpYR0omjyH2DGrqLk8lOHRU=;
        b=MvI8fZNQWqbbSWHSvnZ/YilFT8r4cXVjXFQLbWKFHwMU8rmnUzL7K0U7z5JH/0eobW
         tbUj8KjJpd9z05VN5jN3ZzXxr8yawzv+YjV/j/bJdAAWZMxY4CF+Mn4J3g8EbucRK0HU
         ocyC0XJjnK9HgOO3KDcSz/Q2uRNI1vIBMro+XbyDI5y7q72LPb93CBqPwRsp5244gISA
         mCRHf/ofo4mbZL+TotrdbLWcutWnrPd3oEYetBwlcx97bIfKJdbH5dYcoimf1YyvuaJ2
         j+a1Ymg/cLrIUhAfHFlH7TCAjLWLLrq+PSotmrhtIsIaitOcf84U8EHheu9nDsOTE2qw
         MKBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tBLNQqGbXkMMNFqwqmoHYpYR0omjyH2DGrqLk8lOHRU=;
        b=YCOlQiN0DGbXNocys8IHsEfmbOfBvhVeTtCXO2XEYXFeWs5xHFEKRD9XU31BGcOv/2
         XxT4l9mv9ZZnvUiPKkxz7xzfTUh4NpqbB4KhL4ksWLMtJ+ZuVxx/7Nh+eGfVRs3vR+OM
         Q+GwUaEhmcxckpYiL8Qc+l+g++DchSGPJzPeoEb2Qh+sIIoQEOwjvW9affE8NdpuWwwF
         01TxV3a8KyCeaCKQjwlzXopLRRTQoBuB8m8zr51yCs7wmVZNFkMj+/+emU+aQG9Uf35E
         Cjb0tUy+zdhlCM/f+7sr/AvHZa1EszdERLFLbLXt+j2RajPPqxmDTmhhIaz6PBFId608
         R3Bw==
X-Gm-Message-State: APjAAAXtgCh/lr6CdMvMzC0tcQ98u/0nv0EAcJunv/X0umWX76nRpyYM
        4qCbbtzlK9Rlx7GcvzmpdFIKo58IehNqxK0INgPCCw==
X-Google-Smtp-Source: APXvYqzaJqnOh8u1ffkHjbOR8474PuKjMUFOrqsL8xsQWJAm4wh9nEWyJeiQKud1Q6f+SzNL5TC5NIZfvS6/nl1YvvE=
X-Received: by 2002:a92:40c4:: with SMTP id d65mr4939938ill.50.1571331054413;
 Thu, 17 Oct 2019 09:50:54 -0700 (PDT)
MIME-Version: 1.0
References: <20191015065937.23169-1-mathieu.poirier@linaro.org> <20191016183121.GD801860@kroah.com>
In-Reply-To: <20191016183121.GD801860@kroah.com>
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
Date:   Thu, 17 Oct 2019 10:50:43 -0600
Message-ID: <CANLsYkzg2kwxTG=+RZr4CNqQxNSttcyp_bbmO2u=Vq=HJ5_xtA@mail.gmail.com>
Subject: Re: [stable 4.19][PATCH 1/4] ARM: dts: am4372: Set memory bandwidth
 limit for DISPC
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "# 4 . 7" <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 16 Oct 2019 at 12:31, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Oct 15, 2019 at 12:59:34AM -0600, Mathieu Poirier wrote:
> > From: Peter Ujfalusi <peter.ujfalusi@ti.com>
> >
> > commit f90ec6cdf674248dcad85bf9af6e064bf472b841 upstream
> >
> > Set memory bandwidth limit to filter out resolutions above 720p@60Hz to
> > avoid underflow errors due to the bandwidth needs of higher resolutions.
> >
> > am43xx can not provide enough bandwidth to DISPC to correctly handle
> > 'high' resolutions.
> >
> > Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> > Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> > Signed-off-by: Tony Lindgren <tony@atomide.com>
> > Cc: stable <stable@vger.kernel.org> # 4.19
> > Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> > ---
> >  arch/arm/boot/dts/am4372.dtsi | 2 ++
> >  1 file changed, 2 insertions(+)
>
> What about 5.3?  Is this ok there?
>

Yes - all the patches in this series are also applicable (and apply) to 5.3.y

Thanks,
Mathieu

> thanks,
>
> greg k-h
