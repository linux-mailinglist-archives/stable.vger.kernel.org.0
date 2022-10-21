Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE3C6606CE0
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 03:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiJUBL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 21:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiJUBLZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 21:11:25 -0400
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 297B822C81D;
        Thu, 20 Oct 2022 18:11:25 -0700 (PDT)
Received: by mail-oi1-f173.google.com with SMTP id g130so1553502oia.13;
        Thu, 20 Oct 2022 18:11:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lq/2f5Qjta2IeYsuNeBBwS2JijLfeJeS9crwH8APXzw=;
        b=Z1Mgwxr8+mhE7S0ZrP7Xz8qIoLxgE2oW+qMlnAOUES9TUyLB4aT59mBGYDxgBOeCrm
         VmEFdvq6cJGLY0+DWEZZ+V+zH2sIEzfAAEHE5DGe8YYIuYhZPn9Ewc1l/N68zNihAXfN
         MJOiOmISc0QuzwEV4073VD3tfOnNKMqrJghzVAThWqpap4uqgbY/c7ZdftMJtcbUhBrB
         6pDvPCGyAQUDMAfP3Gw/1/6SBhPQjjnt30vyjDlP0R0DrI3XR/xB8hUAfP2i1dxknWXW
         qvw2RUXQLcRPbkfNNmL4/zCxpz/0zztor8XOK7fzKg31g9wxvbrjOWxMOttVwTcgp3dJ
         z2TQ==
X-Gm-Message-State: ACrzQf19y3pMaWCVR9BQR/AxdiYniu0ou1ySolrUpLXrYf4izWei5I4L
        gtAR3aDF8CZrlnkukyxAyg==
X-Google-Smtp-Source: AMsMyM7ufduaJ4RrO5rQF62MQyAxwcMCb1wyId7oqmw2ywn9Lwx9e+UFcDNaI+UfDBT16P/XXm2RAA==
X-Received: by 2002:a05:6808:bcb:b0:355:219c:3cf1 with SMTP id o11-20020a0568080bcb00b00355219c3cf1mr8984755oik.121.1666314684389;
        Thu, 20 Oct 2022 18:11:24 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id m8-20020a056870a10800b00127a6357bd5sm9507965oae.49.2022.10.20.18.11.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 18:11:23 -0700 (PDT)
Received: (nullmailer pid 2108245 invoked by uid 1000);
        Fri, 21 Oct 2022 01:11:25 -0000
Date:   Thu, 20 Oct 2022 20:11:25 -0500
From:   Rob Herring <robh@kernel.org>
To:     Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        saikrishna12468@gmail.com, git@amd.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] Revert "dt-bindings: pinctrl-zynqmp: Add
 output-enable configuration"
Message-ID: <20221021011125.GA2104528-robh@kernel.org>
References: <20221017130303.21746-1-sai.krishna.potthuri@amd.com>
 <20221017130303.21746-3-sai.krishna.potthuri@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221017130303.21746-3-sai.krishna.potthuri@amd.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 17, 2022 at 06:33:03PM +0530, Sai Krishna Potthuri wrote:
> This reverts commit 133ad0d9af99bdca90705dadd8d31c20bfc9919f.
> 
> On systems with older PMUFW (Xilinx ZynqMP Platform Management Firmware)
> using these pinctrl properties can cause system hang because there is
> missing feature autodetection.
> When this feature is implemented, support for these two properties should
> bring back.

So I'm going to get to review the revert of the revert at some point? 
Why do the properties need to be removed from the binding? They work on 
'not older' firmware, right? Isn't just removing the driver support or 
removing from .dts files enough?

Rob

