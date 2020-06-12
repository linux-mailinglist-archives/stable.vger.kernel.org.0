Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD6C1F75F5
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 11:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgFLJ3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jun 2020 05:29:46 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:36352 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgFLJ3q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jun 2020 05:29:46 -0400
Received: by mail-ed1-f66.google.com with SMTP id y6so670641edi.3;
        Fri, 12 Jun 2020 02:29:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ULB+5Eic/UpB9LwZ16CsVWwd9UTnUABnWsy4r1SRht8=;
        b=RKAwMtOxB0WjJ3L2xBrc3uN/J23ab0/1qgcz82buo9JUdv9wSuTHUxGcZNbXZdZ4sf
         VW6YDHPHk0w8RH4qzVLhGO6LJ9/eoZBYc5rLFsNAYZXOAGWp4xxF1VUk6vneyzR7gIei
         DQ6gwJ3cJ2DaMreO1hs1b+tlM35PRORyFgVdWh3piZk8bbNbkI059y9qzx9brxATRzKt
         y/4xp/W2mFIV6GN8Oq8aijnOQcTfmD/uccMDfJRDC9pkbcUxQsyiuMUSd38r53srF2+3
         TGlI18ejytPh6mBP55UYSZTxo1zIx7gR5fEKy88VTDFZNZqx8hjs3MgtmCQDlxZoBCjI
         A+IA==
X-Gm-Message-State: AOAM532vkP3O/WJlDcU9bVU4zeQx9mHj/4a+87iWbl42Le10AFL0OegD
        TJA8PXPJnGug4kEUTgSR4yc=
X-Google-Smtp-Source: ABdhPJwMP+GFoBzoOi50JTnAJ2Za87KnSv0JbQ7xeD1nBi+czQydI34qF9r34jzHKwJE5BzeOwXU6w==
X-Received: by 2002:a50:b065:: with SMTP id i92mr11435029edd.112.1591954183850;
        Fri, 12 Jun 2020 02:29:43 -0700 (PDT)
Received: from pi3 ([194.230.155.184])
        by smtp.googlemail.com with ESMTPSA id l16sm3335817ejx.19.2020.06.12.02.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2020 02:29:43 -0700 (PDT)
Date:   Fri, 12 Jun 2020 11:29:41 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Wolfram Sang <wsa@kernel.org>
Cc:     Oleksij Rempel <linux@rempel-privat.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Gao Pan <b54642@freescale.com>,
        Fugang Duan <B38611@freescale.com>, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] i2c: imx: Fix external abort on early interrupt
Message-ID: <20200612092941.GA25990@pi3>
References: <1591796802-23504-1-git-send-email-krzk@kernel.org>
 <20200612090517.GA3030@ninjato>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200612090517.GA3030@ninjato>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 12, 2020 at 11:05:17AM +0200, Wolfram Sang wrote:
> On Wed, Jun 10, 2020 at 03:46:42PM +0200, Krzysztof Kozlowski wrote:
> > If interrupt comes early (could be triggered with CONFIG_DEBUG_SHIRQ),
> 
> That code is disabled since 2011 (6d83f94db95c ("genirq: Disable the
> SHIRQ_DEBUG call in request_threaded_irq for now"))? So, you had this
> without fake injection, I assume?

No, I observed it only after enabling DEBUG_SHIRQ (to a kernel with
some debugging options already).

Best regards,
Krzysztof

