Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1D625B2C
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 02:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfEVAcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 20:32:23 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36516 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbfEVAcX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 May 2019 20:32:23 -0400
Received: by mail-pl1-f195.google.com with SMTP id d21so162541plr.3;
        Tue, 21 May 2019 17:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=VGIvfzaOgeWFcIXYZN/wl5CoVxGOnE9T7onHlmNH6wQ=;
        b=irs3SrhUMnEuURqj4z1l/qbrI/tSUIj4JARNCqEv2ZDuEphpUHEn66u0jq75y0Pr/G
         IX/3C+VcFXcn2ztVs9QciOLvrsfQq5WKLoiAWMeOw1dtFiaIcd+T5n6CikV2PkQyLPDY
         TBqkUP0vfXVuOozFIT4NQwmsylCIlVR0+500jLAfmbYzE4w2hG0oTZ0I1ByPVaucZ45w
         4TXNyp5809Mcg8YsovW2CXgmQOD56nnHsVojyCmNHVBJm0yzADH+W2kMbqTyYKqVsJ9M
         G92nJzXaOYx65NOtGVSu+cevDD3bo7Me+/xqeRHCs9PjWDaUmFmZ2cE3V6VDM+nvvRAY
         iCGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=VGIvfzaOgeWFcIXYZN/wl5CoVxGOnE9T7onHlmNH6wQ=;
        b=UqbfMMgb+R5k2X/RrOsLuPO7dRjp3PaANN33xiDods9ej3XoYXqdf5LPhug5gKqFdY
         jpSNFltYUvgALwQYIHps+aW0xyHLI8PAfFAAfr2FqadNvhoBVtCc0re1qg1jEdIz1ZBz
         scPwkNJR9raGmwH2i+ZqNRNn1DAvrpnD560g+bP/oSrT5/MLQCkHGhXkTRXNv2T1Gahc
         FG5LjJTzQz4u2IIJe1SXzEhVE4oSTKOuLUltN71mqkhIZRRf5EWhA9dVWwpNTZv46wvD
         3NN9lAiLwKW5zpy+FCkcrs6BzzB+9qwHAFrAVC4IN5lEPoAMc/BMb0jjNKVqe2HDEXPF
         MfXQ==
X-Gm-Message-State: APjAAAX8KaljwItbKE2jpFHnaBfnJUwO6vauqCpymY6Mb+9/hYh6ziVo
        dtw39w0A5upAvKbqoAYHpN68RjF7
X-Google-Smtp-Source: APXvYqxlAWK6Bw1UuJ99F3bEAK9UPQdnN9Ry/S6IfVRHFvOTn3CddATKf0VN7dD2QMZ8hdkTz846ow==
X-Received: by 2002:a17:902:6b:: with SMTP id 98mr86611463pla.271.1558485142252;
        Tue, 21 May 2019 17:32:22 -0700 (PDT)
Received: from [172.30.90.239] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id 14sm26253668pfx.13.2019.05.21.17.32.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 17:32:20 -0700 (PDT)
Subject: Re: [PATCH v7 2/5] gpu: ipu-v3: ipu-ic: Fully describe colorspace
 conversions
To:     Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20190406230903.16488-3-slongerbeam@gmail.com>
 <20190408145233.7F26F214C6@mail.kernel.org>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <c49da0a6-1165-b283-a4f2-ba02b73af5b5@gmail.com>
Date:   Tue, 21 May 2019 17:32:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190408145233.7F26F214C6@mail.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On 4/8/19 7:52 AM, Sasha Levin wrote:
> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 1aa8ea0d2bd5 gpu: ipu-v3: Add Image Converter unit.
>
> The bot has tested the following trees: v5.0.7, v4.19.34, v4.14.111, v4.9.168, v4.4.178, v3.18.138.
>
> v5.0.7: Failed to apply! Possible dependencies:
>      5a89b98a172c ("gpu: ipu-v3: ipu-ic: Fix saturation bit offset in TPMEM")
>
> v4.19.34: Failed to apply! Possible dependencies:
>      5a89b98a172c ("gpu: ipu-v3: ipu-ic: Fix saturation bit offset in TPMEM")
>      70b9b6b3bcb2 ("gpu: ipu-v3: image-convert: calculate per-tile resize coefficients")
>      d0cbc93a0110 ("gpu: ipu-v3: ipu-ic: allow to manually set resize coefficients")
>      dd65d2a93b0c ("gpu: ipu-v3: image-convert: prepare for per-tile configuration")
>
> v4.14.111: Failed to apply! Possible dependencies:
>      5a89b98a172c ("gpu: ipu-v3: ipu-ic: Fix saturation bit offset in TPMEM")
>      70b9b6b3bcb2 ("gpu: ipu-v3: image-convert: calculate per-tile resize coefficients")
>      d0cbc93a0110 ("gpu: ipu-v3: ipu-ic: allow to manually set resize coefficients")
>      dd65d2a93b0c ("gpu: ipu-v3: image-convert: prepare for per-tile configuration")
>
> v4.9.168: Failed to apply! Possible dependencies:
>      30310c835f3e ("gpu: ipu-v3: don't depend on DRM being enabled")
>      4a34ec8e470c ("[media] media: imx: Add CSI subdev driver")
>      5a89b98a172c ("gpu: ipu-v3: ipu-ic: Fix saturation bit offset in TPMEM")
>      64b5a49df486 ("[media] media: imx: Add Capture Device Interface")
>      70b9b6b3bcb2 ("gpu: ipu-v3: image-convert: calculate per-tile resize coefficients")
>      8d67ae25a9ea ("[media] media: v4l2-ctrls: Reserve controls for MAX217X")
>      92681fe7e98e ("gpu: ipu-v3: hook up PRG unit")
>      93dae31149bf ("[media] media: imx: Add VDIC subdev driver")
>      d0cbc93a0110 ("gpu: ipu-v3: ipu-ic: allow to manually set resize coefficients")
>      d2a34232580a ("gpu: ipu-v3: add driver for Prefetch Resolve Engine")
>      dd65d2a93b0c ("gpu: ipu-v3: image-convert: prepare for per-tile configuration")
>      e130291212df ("[media] media: Add i.MX media core driver")
>      ea9c260514c1 ("gpu: ipu-v3: add driver for Prefetch Resolve Gasket")
>      f0d9c8924e2c ("[media] media: imx: Add IC subdev drivers")
>
> v4.4.178: Failed to apply! Possible dependencies:
>      2d2ead453077 ("gpu: ipu-v3: Add Video Deinterlacer unit")
>      30310c835f3e ("gpu: ipu-v3: don't depend on DRM being enabled")
>      4a34ec8e470c ("[media] media: imx: Add CSI subdev driver")
>      572a7615aedd ("gpu: ipu-v3: Add ipu_get_num()")
>      5a89b98a172c ("gpu: ipu-v3: ipu-ic: Fix saturation bit offset in TPMEM")
>      64b5a49df486 ("[media] media: imx: Add Capture Device Interface")
>      70b9b6b3bcb2 ("gpu: ipu-v3: image-convert: calculate per-tile resize coefficients")
>      8d67ae25a9ea ("[media] media: v4l2-ctrls: Reserve controls for MAX217X")
>      92681fe7e98e ("gpu: ipu-v3: hook up PRG unit")
>      93dae31149bf ("[media] media: imx: Add VDIC subdev driver")
>      cd98e85a6b78 ("gpu: ipu-v3: Add queued image conversion support")
>      d0cbc93a0110 ("gpu: ipu-v3: ipu-ic: allow to manually set resize coefficients")
>      d2a34232580a ("gpu: ipu-v3: add driver for Prefetch Resolve Engine")
>      dd65d2a93b0c ("gpu: ipu-v3: image-convert: prepare for per-tile configuration")
>      e130291212df ("[media] media: Add i.MX media core driver")
>      ea9c260514c1 ("gpu: ipu-v3: add driver for Prefetch Resolve Gasket")
>      f0d9c8924e2c ("[media] media: imx: Add IC subdev drivers")
>
> v3.18.138: Failed to apply! Possible dependencies:
>      029d61779189 ("[media] adv7180: Cleanup register define naming")
>      08b717c2ae8b ("[media] adv7180: Add fast switch support")
>      2d2ead453077 ("gpu: ipu-v3: Add Video Deinterlacer unit")
>      30310c835f3e ("gpu: ipu-v3: don't depend on DRM being enabled")
>      3999e5d01da7 ("[media] adv7180: Do implicit register paging")
>      3e35e33c086c ("[media] adv7180: Consolidate video mode setting")
>      417d2e507edc ("[media] media: platform: add VPFE capture driver support for AM437X")
>      572a7615aedd ("gpu: ipu-v3: Add ipu_get_num()")
>      5a89b98a172c ("gpu: ipu-v3: ipu-ic: Fix saturation bit offset in TPMEM")
>      70b9b6b3bcb2 ("gpu: ipu-v3: image-convert: calculate per-tile resize coefficients")
>      8d67ae25a9ea ("[media] media: v4l2-ctrls: Reserve controls for MAX217X")
>      92681fe7e98e ("gpu: ipu-v3: hook up PRG unit")
>      b37135e395c3 ("[media] adv7180: Add support for the adv7280-m/adv7281-m/adv7281-ma/adv7282-m")
>      c18818e99067 ("[media] adv7180: Reset the device before initialization")
>      c4c0283ab3cd ("[media] media: i2c: add support for omnivision's ov2659 sensor")
>      cd98e85a6b78 ("gpu: ipu-v3: Add queued image conversion support")
>      d0cbc93a0110 ("gpu: ipu-v3: ipu-ic: allow to manually set resize coefficients")
>      d2a34232580a ("gpu: ipu-v3: add driver for Prefetch Resolve Engine")
>      d32d98642de6 ("[media] Driver for Toshiba TC358743 HDMI to CSI-2 bridge")
>      dd65d2a93b0c ("gpu: ipu-v3: image-convert: prepare for per-tile configuration")
>      e130291212df ("[media] media: Add i.MX media core driver")
>      ea9c260514c1 ("gpu: ipu-v3: add driver for Prefetch Resolve Gasket")
>      f0d9c8924e2c ("[media] media: imx: Add IC subdev drivers")
>      f5dde49b8f36 ("[media] adv7180: Prepare for multi-chip support")
>
>
> How should we proceed with this patch?

It will be too difficult to backport this patch to stable trees, so the 
Fixes: tag should just be removed. I will resubmit this series without it.

Steve

