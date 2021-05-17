Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD763822B7
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 04:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbhEQC2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 22:28:23 -0400
Received: from mail-ot1-f54.google.com ([209.85.210.54]:47079 "EHLO
        mail-ot1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbhEQC2W (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 May 2021 22:28:22 -0400
Received: by mail-ot1-f54.google.com with SMTP id d3-20020a9d29030000b029027e8019067fso4290310otb.13;
        Sun, 16 May 2021 19:27:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=HRhSOtyoD2H3bChxJeYA1Zs7pI2B7TRFxhzN1OhDfh4=;
        b=KoOZlUWmkII1GPyB4a+hwWnGpSnH0PBtYVVDkUWH1w6+HFM8RuYLxjVpAiRV61wlhF
         fcJKoYKj8x+oAd1exoZrStvKehXEzUMe2ojfwk8GY+J+nI1zGQJG+1NBeetrkXUonz4M
         bTd/MAk2A5pusIA/nzO1yvYzMrrmUpS+KHgo2kWz/vh3U6xuq6A1K92NTjwryC0nHSO5
         WxAJ4G2KClUncvcC/Cv6E5ckUnjBfwHKxCFC0z0Bk2JCXrdd1zpjs582s8cbgusqaRIM
         1cTH5G2CgOAKkL4aljfw4A9s3mOyEIrN2tpwu9tj1qDG6NF6ro3JLufmWcfgaOwfM+6V
         QNsQ==
X-Gm-Message-State: AOAM530Bb6QF2QuFfELQqwG5GuoHg94Xuy4ngmNHCj8qxcjNEE27L4ei
        z4hxYV2xPtI6CKuZq+t2GA==
X-Google-Smtp-Source: ABdhPJzhJHWi3K/TD/sTbfPKhPEBkUKNywRBCOlgjhmr72tuU/7ZTn/bwbLuP4Y5rhUd6NEwR6M8oQ==
X-Received: by 2002:a9d:6d88:: with SMTP id x8mr32737152otp.35.1621218426415;
        Sun, 16 May 2021 19:27:06 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id y13sm2799202oon.32.2021.05.16.19.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 May 2021 19:27:05 -0700 (PDT)
Received: (nullmailer pid 1315831 invoked by uid 1000);
        Mon, 17 May 2021 02:27:03 -0000
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?b?TWljaGFsIFZva8OhxI0=?= <michal.vokac@ysoft.com>
Cc:     NXP Linux Team <linux-imx@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>, linux-leds@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>, devicetree@vger.kernel.org,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>
In-Reply-To: <1621003477-11250-2-git-send-email-michal.vokac@ysoft.com>
References: <1621003477-11250-1-git-send-email-michal.vokac@ysoft.com> <1621003477-11250-2-git-send-email-michal.vokac@ysoft.com>
Subject: Re: [RFC 1/2] dt-bindings: leds: Add color as a required property for lp55xx controller
Date:   Sun, 16 May 2021 21:27:03 -0500
Message-Id: <1621218423.803658.1315830.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 14 May 2021 16:44:36 +0200, Michal Vokáč wrote:
> Since addition of the multicolor LED framework in commit 92a81562e695
> ("leds: lp55xx: Add multicolor framework support to lp55xx") the color
> property becomes required even if the multicolor framework is not enabled
> and used.
> 
> Fix the binding documentation to reflect the real state.
> 
> Fixes: 92a81562e695 ("leds: lp55xx: Add multicolor framework support to lp55xx")
> Cc: <stable@vger.kernel.org>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Jacek Anaszewski <jacek.anaszewski@gmail.com>
> Cc: linux-leds@vger.kernel.org
> Signed-off-by: Michal Vokáč <michal.vokac@ysoft.com>
> ---
>  Documentation/devicetree/bindings/leds/leds-lp55xx.yaml | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/leds/leds-lp55xx.example.dt.yaml: led-controller@32: 'color' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/leds/leds-lp55xx.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/leds/leds-lp55xx.example.dt.yaml: led-controller@33: 'color' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/leds/leds-lp55xx.yaml

See https://patchwork.ozlabs.org/patch/1478502

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

