Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE504BA6AE
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 18:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239758AbiBQRGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 12:06:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232955AbiBQRGM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 12:06:12 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE122B357C
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 09:05:53 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id k1so10156468wrd.8
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 09:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ONgUBPfeZrmGu37DzgGQPWatmRVCLiTPCmawUJX/zto=;
        b=v3PNb8UdGz0UDBKOigYVnr993LU1L/RX3wbCjWY5pSD4lo0r24wtSELmy0fttm66aB
         z5WUT4fHPFk4irdD747x4utvKGEY6gTggBIs8kKOR0sJ5ZIppbe18sCz37xvyANqn5JA
         kQIyGt6zBgIWb6uQry5zIAKnIF1Gajk3c6fU5jmrwyZGlr8IgnPPgLGX7vanHNtzXYE5
         OqoHgQPUBLKaQ4nediXKiLnZsdNMZYwhQnOUqf7v5L2DtnFfuuRg9lYORAPm5BDKBqZ4
         qSXcRqKHJWek8kaGR7yicJ0t0aRAzuINRtdnnaHfjhYT6z4S8vy4NwyCJ+tcGWjQTCqm
         OYog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ONgUBPfeZrmGu37DzgGQPWatmRVCLiTPCmawUJX/zto=;
        b=iEuAUMvKVx73dAown92phMx0ERcYTBDmnKr8vkN+mxzBrC6lYUKcc4ldV5FeyK5AFK
         kJ0/1eiDsNtyI9uOq9So9y6DXxfG+DK2nRqilOB5ZbvxJZUODgN+QWweOpqL0aP6z15O
         uvkyTlepMXtyxt/wVcG1kz0rCxIjDVzf1xNBOi0EIwPlFiW2ZZrOLyAmGrj0z9B6I1pR
         8IWqnLxMkMWx7YP+W/TgXjcBukBLknTJoOveZgXZWeHWo5HWlMGvFH/EHvaloT9H0i2N
         O2++kvn0rgk8Bs/gMT8+p2kOUpGE5tXsjI3A51UZsxkXRyE1vNG2cNiCKi2HUYsFOdXX
         G9qg==
X-Gm-Message-State: AOAM530Yq/acgv+3NgXTB38MZPE0di4cI6Qrw8pXO/ul5lGho56XyWNx
        83haenjbA29aY2kH8hT/pLaC3Q==
X-Google-Smtp-Source: ABdhPJwkmv4rUEAp6tW7MAuS8zWUBGjH7XX+5l5CGcPXLTeuYFRV6IofNejP7+YuPIhl3RZsT9aWSg==
X-Received: by 2002:adf:fc86:0:b0:1e4:a7b6:6ba with SMTP id g6-20020adffc86000000b001e4a7b606bamr2987012wrr.93.1645117551911;
        Thu, 17 Feb 2022 09:05:51 -0800 (PST)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id p15sm2133750wma.27.2022.02.17.09.05.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 09:05:51 -0800 (PST)
Date:   Thu, 17 Feb 2022 17:05:49 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     daniel@iogearbox.net, andrii@kernel.org, ast@kernel.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] bpf: Fix toctou on read-only map's
 constant scalar tracking" failed to apply to 5.4-stable tree
Message-ID: <Yg6AbfbFgDqbhq0e@google.com>
References: <163757721744154@kroah.com>
 <Yg5wY5FKj0ikiq+A@google.com>
 <Yg51IuzfMnU8Uo6v@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yg51IuzfMnU8Uo6v@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 17 Feb 2022, Greg KH wrote:

> On Thu, Feb 17, 2022 at 03:57:23PM +0000, Lee Jones wrote:
> > Good afternoon Daniel,
> > 
> > On Mon, 22 Nov 2021, gregkh@linuxfoundation.org wrote:
> > > 
> > > The patch below does not apply to the 5.4-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > 
> > We are in receipt of a bug report which cites this patch as the fix.
> 
> Does the bug report really say that this issue is present in the 5.4
> kernel tree?  Anything older?

Not specifically, but the commit referenced in the Fixes tag landed in
v5.5. and was successfully back-ported to v5.4.144.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
