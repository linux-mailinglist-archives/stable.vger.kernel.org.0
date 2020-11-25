Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A53A2C3B53
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 09:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgKYIsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 03:48:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbgKYIsy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Nov 2020 03:48:54 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EED7C0613D4;
        Wed, 25 Nov 2020 00:48:54 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id b17so1402940ljf.12;
        Wed, 25 Nov 2020 00:48:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1CiFGI+zAQ3sbdgy5ohjyQFrwpN9S9lbEbuqLPPcRrc=;
        b=sIrmXlu/HrT1IFeUrE7K8dvjEY9Vg8JWaKtNuINQr9xIkrznrBM18y1b/G16+7tfMC
         l5ohUg1QLDXZ6662jBthgmh0G2P80PPAybSD+5pSyXIAsAOoAQgzGrbWipN9NFtG6DXe
         3iNnfkXxhGRP73zAV2pze1QWRnvEj+DdFCNVu6THWm2adx5nXO11IvU/FlerplW17Hme
         8jioAfOhiJUl5kTW8QaYw0mDzcyIX2TrSAg7VIxMi2QZ4fWd9KDj0Ifmw4XV+fuOCB3p
         drwAhQ69R39cwa1pgwLITw9wJt3iSwg+KW6+alm3UNQF88ZNyo9ql5Nz9JmgXbnJfJNn
         LA2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=1CiFGI+zAQ3sbdgy5ohjyQFrwpN9S9lbEbuqLPPcRrc=;
        b=eDnCcYdr2/ZmuzAs6HMpoTO4lIwdZvPjoupNvMJHNVZ/Qvsci+Rjdi5WLBMDDPYDVk
         1uwBy28d6cOswhuuEXl1eD/eBMHzcPWyq3GnpbaQwIXNmmkkCWQeGmJfOxQ+GOJFX2FC
         TWPGX4pzjZBL68F+gBDGOZEzTuuniD0GCruIxLWvb8wufd6ESU1vwGna5ivvkfOM6Jc0
         6//mXArBWbtKGU6VN/xLqlyTWHNAk6VIfboVQzxWU4V2syzJMEnBTCfSKY2KrkTdXQcM
         vre3avw6dkWr7tR9lYfPJ8y2IHJxkR9kuRCecysvO051R8GElJ4djmxrILaYCQqpc6sZ
         yOTw==
X-Gm-Message-State: AOAM531ZS2Ah+eStaShtIZuv5YSjy9HgT2aQE3jJMiznrCd0esD5qqVX
        K/opVviYtgCoJDCoaBBY9SrA6k6niRYwJQ==
X-Google-Smtp-Source: ABdhPJyDbFwMZisczcuSAtsoZd69soFXx8+zX1JJzEiv9GMl2dMM3pPPJgz2gyrDGK5V/tjzTDtukw==
X-Received: by 2002:a2e:7203:: with SMTP id n3mr959896ljc.86.1606294132804;
        Wed, 25 Nov 2020 00:48:52 -0800 (PST)
Received: from ?IPv6:2a00:1fa0:4212:944b:4041:d4db:b733:f39e? ([2a00:1fa0:4212:944b:4041:d4db:b733:f39e])
        by smtp.gmail.com with ESMTPSA id r80sm176066lff.77.2020.11.25.00.48.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2020 00:48:52 -0800 (PST)
Subject: Re: [PATCH 1/5] memory: renesas-rpc-if: Return correct value to the
 caller of rpcif_manual_xfer()
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Jiri Kosina <trivial@kernel.org>,
        Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Prabhakar <prabhakar.csengg@gmail.com>, stable@vger.kernel.org
References: <20201124112552.26377-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20201124112552.26377-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <26fc2f22-eae4-86bc-1c39-e8498b77e1cd@gmail.com>
Date:   Wed, 25 Nov 2020 11:48:42 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201124112552.26377-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 24.11.2020 14:25, Lad Prabhakar wrote:

> In the error path of rpcif_manual_xfer() the value of ret is overwritten
> by value returned by reset_control_reset() function and thus returning
> incorrect value to the caller.
> 
> This patch makes sure the correct value is returned to the caller of
> rpcif_manual_xfer() by dropping the overwrite of ret in error path.
> Also now we ignore the value returned by reset_control_reset() in the
> error path and instead print a error message when it fails.
> 
> Fixes: ca7d8b980b67f ("memory: add Renesas RPC-IF driver")
> Reported-by: Pavel Machek <pavel@denx.de>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>

MBR, Sergei
