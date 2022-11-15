Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8474628E10
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 01:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbiKOAOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 19:14:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbiKOAOK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 19:14:10 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA62D2F6;
        Mon, 14 Nov 2022 16:14:10 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id z26so12612878pff.1;
        Mon, 14 Nov 2022 16:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6Q3v3HamMScBwI5sDpzI/Cdggi988OXHbtRrNXBM20s=;
        b=ejY2POYIaZBk3kj2JzfRlhKSMNJotjV5Rr098betGxENf6ExOG++P6KmrNcIF4HN2m
         JD01fJU62ZAKQyToi/N/R9kFpiWfvlwc04dfz4+5PEduqORPrtOnSd0PnohHc+gYhPN9
         rdaHm3sQHONA33RlEhNbQYKaAIJj3s4/OLXMcD2FsuJvZ+lAl3xnZ1pjEONqQUY8XUzs
         LlV67xDQ9dd2oo2JJSVzr3BWZxaxpQlsq5hxYUCffy9Aext2oiknJ7g7oXFsv5pnv8ru
         0tiZR7hdEfvUBP6s/z+GGVt3/xYCmlrSte0Q1jzmtJiyfI7NdX3GIqkhdvqzehw9uWu3
         7qQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6Q3v3HamMScBwI5sDpzI/Cdggi988OXHbtRrNXBM20s=;
        b=4R8NozcuX77vCv8hMljWOurMqUGVlF8+IlpBS1BUjMSlsnbFX0DhBbmA0q9ULlLmB/
         iTfdPmGzzGduKQaMkKSdBSR6IsOmVqUgs5wbENaMnVLnbcmg/eU6QI8qH0qGCVQnlvfE
         nEcMVmSpXr0rd28A0De2Bmyr/QqZ+1VsB2fPYeNWuKAx8Np25iSlEwVHDKOQLarj5orS
         QxhFBARjXxfKouPlc6hY4Z8iaX5nk5J37sAcAYkOlSjAv9sRCHEyZr83aI7xxuLKiBXV
         nmE69zdObULLyB5tukaVvxnde1q1nO3DHYPXAa19fX9JJMbMAS0m3lYLDo8kNnS0xotc
         tq7A==
X-Gm-Message-State: ANoB5pml+xmOE7hs0Ex4FCdtzNjywfLOQY5lRGrPtsFNUH7bxK0J8MFU
        nlyDn52t0bM1KIQQVPucotI=
X-Google-Smtp-Source: AA0mqf7RlvCVShvY+/vX196gc9JTDExaP+Umf/qdVyDp+mIDnyOx1UQKlAF7tFfJtvATH8aLH4+1Aw==
X-Received: by 2002:a63:ef04:0:b0:46f:188c:3312 with SMTP id u4-20020a63ef04000000b0046f188c3312mr13349350pgh.562.1668471249691;
        Mon, 14 Nov 2022 16:14:09 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i7-20020a1709026ac700b00176c0e055f8sm8149696plt.64.2022.11.14.16.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 16:14:08 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 14 Nov 2022 16:14:07 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/131] 5.15.79-rc1 review
Message-ID: <20221115001407.GB2291336@roeck-us.net>
References: <20221114124448.729235104@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 14, 2022 at 01:44:29PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.79 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 152 fail: 2
Failed builds:
	arm:allmodconfig
	arm64:allmodconfig
Qemu test results:
	total: 489 pass: 489 fail: 0

Build errors as already reported.

Building arm64:allmodconfig ... failed
--------------
Error log:
drivers/net/ethernet/mediatek/mtk_star_emac.c: In function 'mtk_star_enable':
drivers/net/ethernet/mediatek/mtk_star_emac.c:980:29: error: 'struct mtk_star_priv' has no member named 'rx_napi'; did you mean 'napi'?
  980 |         napi_disable(&priv->rx_napi);
      |                             ^~~~~~~
      |                             napi
drivers/net/ethernet/mediatek/mtk_star_emac.c:981:29: error: 'struct mtk_star_priv' has no member named 'tx_napi'; did you mean 'napi'?
  981 |         napi_disable(&priv->tx_napi);
      |                             ^~~~~~~
      |                             napi

Guenter
