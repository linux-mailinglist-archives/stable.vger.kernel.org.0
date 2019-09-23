Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F155BAFB4
	for <lists+stable@lfdr.de>; Mon, 23 Sep 2019 10:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406495AbfIWIfj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Sep 2019 04:35:39 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37073 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406140AbfIWIfj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Sep 2019 04:35:39 -0400
Received: by mail-wr1-f65.google.com with SMTP id i1so12882929wro.4
        for <stable@vger.kernel.org>; Mon, 23 Sep 2019 01:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=DonLaU+ALkUO4XcKRBTGh6tkB6YDwuQS1LIpYKsRKI0=;
        b=iweD1MXsqfvUS94mRK6CuoKUGcj8JkfPP+1CofV6Ctqi9Zgrez1OViiWsNU4+5c9b3
         1v+Wlc6urwR5u48jExvDWPNV+b3xTmp577z0x9kdXFBVyFQUebSuMf8E1et5vWygC0wh
         BGMI+Q+gK2RunsyXNXM/I2ECIP6ap5PQQ7tlDaI6PWhk+9y+/59I2ld9Hl5Ce53t0s5n
         WMnZyjd6MyeGecXc+z8N8DfSowIX3WoHhi+euxfLNBkWSNJdv+aX7jtMW49/86y3zCOg
         XrPPRlfpPeHWL/GRo/wLm827Cc9vJJJ0CxfzJN1eBxB8tUI1uGbW6TfE5JcNWgejWrbv
         JIUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=DonLaU+ALkUO4XcKRBTGh6tkB6YDwuQS1LIpYKsRKI0=;
        b=SExYUIgsEm+qIcLcRc3sqNMJgjMVmI5wMxwyN+B+BK98QUCihNccBY6xQn728j/Lw2
         0LYUPNa5223VNhyaHkZb7UjkTK9RXTZx2h7l/dOgIUrq2Z/WEMMJ3MKvvlxxoTM7WUyP
         7LvsaPXkGPGKGxQ5bcW9M1IyrfWnB+84ljcTxbX/oqZ+z5EUYRHPp5cTIkyk5K4zzE6y
         lFkK47umMNaKPSiPPoUPoKRnAFVD/sAQmTv2F+5uduXBjXa9SIR2hfjuhbbngfn0LsvB
         fo+J3LoK2ejS1P2bVj3jwcQ4yZtY8KChSBJTFjuOwkjOIYpZCf590v2LZMxLIad9Wd8c
         YM2g==
X-Gm-Message-State: APjAAAUJpoLouP9yVdBhYVLHdnpYwAXec+GavUUADGtMexKDK4oXLWdr
        CDp0+N1cFXrsm5MYSoiQYTQxqSqEECIbHw==
X-Google-Smtp-Source: APXvYqxJcD4Iva8LjauXdRv7MdXdwAKMDkOV0VwKKJWiJJiS8vUfgnWZhmg47YeFRhHeSnOuDhR7JQ==
X-Received: by 2002:adf:fac3:: with SMTP id a3mr20173795wrs.24.1569227737278;
        Mon, 23 Sep 2019 01:35:37 -0700 (PDT)
Received: from localhost (lmontsouris-657-1-212-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id r6sm9279229wmh.38.2019.09.23.01.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2019 01:35:36 -0700 (PDT)
From:   Jerome Brunet <jbrunet@baylibre.com>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-amlogic@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.3 034/203] ASoC: meson: g12a-tohdmitx: override codec2codec params
In-Reply-To: <20190922184350.30563-34-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org> <20190922184350.30563-34-sashal@kernel.org>
Date:   Mon, 23 Sep 2019 10:35:35 +0200
Message-ID: <1j7e5ztnoo.fsf@starbuckisacylon.baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun 22 Sep 2019 at 14:41, Sasha Levin <sashal@kernel.org> wrote:

> From: Jerome Brunet <jbrunet@baylibre.com>
>
> [ Upstream commit 2c4956bc1e9062e5e3c5ea7612294f24e6d4fbdd ]
>
> So far, forwarding the hw_params of the input to output relied on the
> .hw_params() callback of the cpu side of the codec2codec link to be called
> first. This is a bit weak.
>
> Instead, override the stream params of the codec2codec to link to set it up
> correctly.

Hi Sasha

This change depends on the following series in ASoC:
https://lore.kernel.org/r/20190725165949.29699-1-jbrunet@baylibre.com
which has also been merged in this merge window.

With this change, things are done (IMO) in a better way but there was no
known issue before that.

I don't think it is worth backporting the mentioned ASoC series to
5.3. I would suggest to just drop this change from stable.

Regards
Jerome

>
> Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
> Link: https://lore.kernel.org/r/20190729080139.32068-1-jbrunet@baylibre.com
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
