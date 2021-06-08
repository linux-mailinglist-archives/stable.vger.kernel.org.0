Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0613A3A0390
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233827AbhFHTSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236965AbhFHTQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 15:16:43 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91ED0C061787;
        Tue,  8 Jun 2021 12:09:04 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id l18-20020a1ced120000b029014c1adff1edso2692036wmh.4;
        Tue, 08 Jun 2021 12:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZrWe5m2ABiVQaXdjQCYInEiV6od69+L49fxMdPlzQAw=;
        b=ReVX6hhnLKVm2K/lkxRibdfKZS95T5em8ujmOt0nek4RDCKKC/I3bkaG0pvR7gQ3Eh
         QkNTEGIXhtPTEsSrboMGPpmsNMu6cQKCvRf/HgIt+qFm1LmtRLOfgeCq9olF86QtC6gO
         272XyaIvz1q7zcEpxunpPnHGATceh6JWZAbV+0yaAnErvLw/THQJAoBnMs6TfzntaVrh
         FuTom9JfwZmwjsZPpxoGEL53XZ+oadmGrXBCIauti7QRqfSkeeJweRSCaNBeqLiNCU6j
         SPaCvY8VFHapOPZPELtKlj1HSOJUQ9ukDoMUv1jj7mGigALZdFOnREbxAgjo95/WT9Mr
         bNEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZrWe5m2ABiVQaXdjQCYInEiV6od69+L49fxMdPlzQAw=;
        b=gL/5HJs8Qn9rHtYrWcx5XpYoSSYHu4xUjgWq1FDy0jiP6e0+UQHR3++6E6PfJyG88Y
         6O+BFwrSWB5RdwPfr/ui8/dUJitdZ/pADVb1wZ8jBqa577QyT4h4FdoWKI2yo+a6g7VA
         18C3HeL2gF2chPMjfxnxBKaMYNgfA0TaIG5g/d+Dp8AgFaMZaxMtBWvckqCheonf/p8s
         E3b+Q1GEmP4FXsPxTTBAbFckjHrV6zgpMZKDiKj4Cc1udon9a3eULarJOBFVpzTPbiic
         AQRQIkuxmD2DJtmJN+ZfeGn+lRcnxiNM3/LJKE1KLknSu91D/JPN/FmRo/cRq+bpvGWh
         h3gg==
X-Gm-Message-State: AOAM533rqgDfvnLZA/7bzhYnKoTMDVcVOcDb6+QpiTAEeSs3LccIeXk7
        QIdiNc9w9kKnQYOZY78ucAQ=
X-Google-Smtp-Source: ABdhPJx86Y5UJnSwjc3iqHodwJIM1RsOWxuTmpZyMxXPzQ40hh24co4AWHXfss9s2yFEnuzTNbhI2w==
X-Received: by 2002:a1c:770f:: with SMTP id t15mr23112887wmi.182.1623179343160;
        Tue, 08 Jun 2021 12:09:03 -0700 (PDT)
Received: from debian (host-2-98-62-17.as13285.net. [2.98.62.17])
        by smtp.gmail.com with ESMTPSA id u15sm3673592wmq.48.2021.06.08.12.09.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 12:09:02 -0700 (PDT)
Date:   Tue, 8 Jun 2021 20:09:00 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        Ludwig Zenz <lzenz@dh-electronics.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: Re: [PATCH 4.19 28/58] ARM: dts: imx6q-dhcom: Add PU,VDD1P1,VDD2P5
 regulators
Message-ID: <YL/ATP6MBeYlclSx@debian>
References: <20210608175932.263480586@linuxfoundation.org>
 <20210608175933.214613488@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608175933.214613488@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Jun 08, 2021 at 08:27:09PM +0200, Greg Kroah-Hartman wrote:
> From: Marek Vasut <marex@denx.de>
> 
> commit 8967b27a6c1c19251989c7ab33c058d16e4a5f53 upstream.

This is causing build failure with error:

Error: arch/arm/boot/dts/imx6q-dhcom-som.dtsi:414.1-12 Label or path reg_vdd1p1 not found
Error: arch/arm/boot/dts/imx6q-dhcom-som.dtsi:418.1-12 Label or path reg_vdd2p5 not found
FATAL ERROR: Syntax error parsing input tree


--
Regards
Sudip
