Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2876BFCF
	for <lists+stable@lfdr.de>; Wed, 17 Jul 2019 18:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbfGQQrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 12:47:21 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:33656 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729160AbfGQQrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jul 2019 12:47:21 -0400
Received: by mail-lj1-f193.google.com with SMTP id h10so24335374ljg.0;
        Wed, 17 Jul 2019 09:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bs/QITWbhqAZxDhjSjDJdcwaHkIW+GS9/ueefoQtdFc=;
        b=jHfgK6HWw2DZSrGHtZx8q+g4s8uAJoOkBI1je+U1ttvkHW0Mdrp6NZXQuH1aruQFSx
         twKkQDDxOqu/Q4/dMSRAqdLHO/X0cO/85YFm15xb13DcnBDKOpx+XwUeXe6FWRzhStPO
         sbk8DyKpQRpE46tK3V8ZMUj0tCr0DNHzarWAbNUVVPz6H05hTdxahwmuspn/lKyuyqkZ
         4uKuARsDBm+5KUUAd58FdMaIJqUQEMqrMIB61DSbb9ErMSD/6+I2PnUQPQUiVmQ9UPQp
         z9LkKuDveVOm2f86NQK388zbUHEI0gV5v6r6uzFbVwD76WqHy0y+b7U1AJCboFSwFSWP
         nRCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bs/QITWbhqAZxDhjSjDJdcwaHkIW+GS9/ueefoQtdFc=;
        b=nWCk6s3tadNdwy/Cj0KnjgkZwuW0aYH0wlsDz08eyHN3vncLiJLwRdmW8stLI2g5hW
         AcBsm4emfddpzxXoIiXTP7BhOdj1/tUcyNHjx3OnMCGLB3Sm0F169+SRZ1m1n40n91VY
         JiETrjRot8okn/p8FGPPGp1lYZOFerBAMx2p11BKSG+xAPhHcOmn8RPDIVFnijIDtd5l
         JNniqk0juWoQQ4RHbioedu8xsRn+hDrX6Y2ccFI9t9AQ8Zw8lDigd/3oZZtP0r/qcx1N
         yn8ugaDHYKQ+3HcceRPW5hMKoNxw6DAsjxZCl6QGLeqHUfLVP2hUVwLCouyj5unLydn/
         YkNg==
X-Gm-Message-State: APjAAAUsIxTH/fiX5wdbBj54ZsWT13OWiNtnNROgUr81ggP3A39mCieF
        SRTKeRvoa0xzR0vDvJ8kImPvJk11xkiRKwMC474=
X-Google-Smtp-Source: APXvYqy+aNYb7anJn+W+Rf+NmIpi47qfolURZwZXuLoTi8QKxjWASrknRWjcO23N0nDwwtBGM6WVUZr4teTmVEJi7B4=
X-Received: by 2002:a2e:a311:: with SMTP id l17mr20833447lje.214.1563382039201;
 Wed, 17 Jul 2019 09:47:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190717163014.429-1-oleksandr.suvorov@toradex.com> <20190717163014.429-2-oleksandr.suvorov@toradex.com>
In-Reply-To: <20190717163014.429-2-oleksandr.suvorov@toradex.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Wed, 17 Jul 2019 13:47:08 -0300
Message-ID: <CAOMZO5C=gYAZ4F2XOaTgCTRVyZdNSa5CEHsiVv7SsSgo5VfZ9A@mail.gmail.com>
Subject: Re: [PATCH v4 1/6] ASoC: Define a set of DAPM pre/post-up events
To:     Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Igor Opaniuk <igor.opaniuk@toradex.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Mark Brown <broonie@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 17, 2019 at 1:30 PM Oleksandr Suvorov
<oleksandr.suvorov@toradex.com> wrote:
>
> Prepare to use SND_SOC_DAPM_PRE_POST_PMU definition to
> reduce coming code size and make it more readable.
>
> Signed-off-by: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
> Reviewed-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
> Reviewed-by: Igor Opaniuk <igor.opaniuk@toradex.com>

Reviewed-by: Fabio Estevam <festevam@gmail.com>
