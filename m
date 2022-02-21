Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57BA54BE963
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355770AbiBULMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 06:12:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355419AbiBULMM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 06:12:12 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59AC324BFF
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 02:44:39 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id e3so26332891wra.0
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 02:44:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=5Qz7wK6li8P/fiukKFPzdBLxnK/7sm/mLgvbY1F8kaI=;
        b=dZQm/LjpsC157kkJOIL2aDidnjKU2Idrq0tb0EqLdKn0iQlNdBtno31kputse8Q0xe
         bK1mXa4W7FV3AW5E7hrJdoNz8y9Hl/QaGmnw7Z2T7Cnh8oKdYviWHnmKrCGlkAc1jm5I
         LPsU8LGpYZkAnnXLdY7BpkqD3UCjPl0odaIK1nS+LBqRp0+vWdaSXITKT9ed/J8e5vxL
         z3/Yu/NBFdcYtXx6o/KXU0EeAYHWc6K9z42SSWv9yB7lubb9cTV48oPDwoerf/2f34br
         TDS0QQ/Mi4h6LP4r5QjusSDdhuvqYl8En5lHeFJvvw82BgmW7zMkSmJzyoURyHV3kQCD
         sezg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=5Qz7wK6li8P/fiukKFPzdBLxnK/7sm/mLgvbY1F8kaI=;
        b=0oiYw775nZWJeGziWBGcVW1+rbzJPeq2RmlWt3IbvRiP9Rv7pd1pHh4fZ83HRS0Pxx
         TdSZIi0AILsorV8d5R3sTlYFAfgssSEg14vF3iasd9BB9Xw+o8P2JDSajs5BvDlc7QmJ
         xRNIyNgfFmIrmFVaIpU24esUlUCLG9Y9YGaWOiLud3yICqy1cfi7zp6HfE+wXUNuy3rU
         Rm2G4A+THG8GmCAMVfyz6MaL5pgmu3AOZjO+TR4i2Kp9z4dvE0JAKPYN/W/K2E6NgwnJ
         tPjL8wt8D2bFdr/Q5XLOK80bF0kli0voO+L1ziX0u5vxmh+2D1XkFmziHtY0rEnxpDSI
         2cGg==
X-Gm-Message-State: AOAM533u+K2IfRT5NjywQjUbdeLeiuqeJwhfCUdVWVcvK2OULneNwnbJ
        dC2RQTge9mi4+4cIa/X5JpEJ1A==
X-Google-Smtp-Source: ABdhPJyjP2brHJSi14Rvypw/usC1rea4FCRME/3nG5blkzYsT0UGiOgjet2cyne9OQbbpfaIKQ+J2w==
X-Received: by 2002:a05:6000:c:b0:1e3:24e8:ab97 with SMTP id h12-20020a056000000c00b001e324e8ab97mr15565960wrx.593.1645440277872;
        Mon, 21 Feb 2022 02:44:37 -0800 (PST)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id y6sm30161680wrd.30.2022.02.21.02.44.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 02:44:37 -0800 (PST)
Date:   Mon, 21 Feb 2022 10:44:35 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     daniel@iogearbox.net
Cc:     andrii@kernel.org, ast@kernel.org, stable@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: FAILED: patch "[PATCH] bpf: Fix toctou on read-only map's
 constant scalar tracking" failed to apply to 5.4-stable tree
Message-ID: <YhNtE/sIdv5OkBQT@google.com>
References: <163757721744154@kroah.com>
 <Yg5wY5FKj0ikiq+A@google.com>
 <Yg51IuzfMnU8Uo6v@kroah.com>
 <Yg6AbfbFgDqbhq0e@google.com>
 <YhNg4uM1gIN89B7U@google.com>
 <YhNoZy415MYPH+GR@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YhNoZy415MYPH+GR@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Feb 2022, Greg KH wrote:

> On Mon, Feb 21, 2022 at 09:52:34AM +0000, Lee Jones wrote:
> > On Thu, 17 Feb 2022, Lee Jones wrote:
> > 
> > > On Thu, 17 Feb 2022, Greg KH wrote:
> > > 
> > > > On Thu, Feb 17, 2022 at 03:57:23PM +0000, Lee Jones wrote:
> > > > > Good afternoon Daniel,
> > > > > 
> > > > > On Mon, 22 Nov 2021, gregkh@linuxfoundation.org wrote:
> > > > > > 
> > > > > > The patch below does not apply to the 5.4-stable tree.
> > > > > > If someone wants it applied there, or to any other stable or longterm
> > > > > > tree, then please email the backport, including the original git commit
> > > > > > id to <stable@vger.kernel.org>.
> > > > > 
> > > > > We are in receipt of a bug report which cites this patch as the fix.
> > > > 
> > > > Does the bug report really say that this issue is present in the 5.4
> > > > kernel tree?  Anything older?
> > > 
> > > Not specifically, but the commit referenced in the Fixes tag landed in
> > > v5.5. and was successfully back-ported to v5.4.144.
> > 
> > Another potential avenue might to be revert the back-ported commit
> > which caused the issue from v5.4.y.
> 
> Unless that was fixing a different issue?  I have no idea at this point
> what commit you are talking about, sorry :(

The bad-commit mentioned in "the Fixes tag":

Fixes: a23740ec43ba ("bpf: Track contents of read-only maps as scalars")

Which as you say, could well have been fixing another issue.

In fact, yes it was:

https://lore.kernel.org/stable/20210821203108.215937-2-rafaeldtinoco@gmail.com/

Daniel, what do you suggest please?

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
