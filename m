Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12B46C4BA9
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 14:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbjCVNZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 09:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbjCVNZF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 09:25:05 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA503FBA2;
        Wed, 22 Mar 2023 06:24:59 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id t19so8408436qta.12;
        Wed, 22 Mar 2023 06:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679491498;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ktOzcvKmmhLIzoXczCp5MfAlx870gRd58nh3sh76UaA=;
        b=iHFgprdTUOe5MtVRqVMc3gdMI5qKcs2hivdULK2xESoLn+RZeMqW2uvicUwEm+0Zlp
         KVcY/mbPTBn9pEHHLXsuQr1ELJWC6wR26loeRvrABTP4ZMctpndFDvSmpGW65mrbbllc
         wGc+XbydSChrs46l5WpnqYJMW8hW1Ym4N27zflZClsmxUFii4AGUMV+g0NHP9dEk1Ufb
         knXYLaxlE1oT/W+3FL/ulr1FHVaueLgDLXV3rVhu5qSpLCdv+pdCD1AhSRbTkXXjm1nf
         tzshia7tIu2M00PwpG+bVXj8OhdCI2M+3EgwYedYXaV6USXa06QBTpsCWxghFXRZRjE2
         PIJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679491498;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ktOzcvKmmhLIzoXczCp5MfAlx870gRd58nh3sh76UaA=;
        b=z08JXUPuHUm3QK+MQcQmYQuEd9VQ+UPpCZp+HtB7H1zArTbSn0cikRNp4tOdbwf9la
         PLkygC5nR+brjoCi9cizCq8sUmEN8E90EG/by+P8wjykT+5ulOx91fcucq1bbUHeQubL
         ur7yZ7ID40trX294QNTfoxIgwb3VApv2g4BMYB0k4LBpFA3Ih63X1qE+Cc4cavpqzwhi
         9/CuQ+RMLoJn6vWYv7a7EuBs58CsGXAfjId+YR7W19Nr2yY1+h72CRNWKwQv/52WzQ2G
         MvboJ1RG2z2E8Li4oBYRWEJHQ4C3d9U9g2IwEEERazFu/Nz747xLyuMuRwDve9cNhZCH
         tE9Q==
X-Gm-Message-State: AO0yUKWa1T4nxAu86X3HfrIP5XqhobKkfQuNzF+WSYVI8fFCsw6fuf7m
        Jp3Fcve6DjGDuykixzgUdbw=
X-Google-Smtp-Source: AK7set8atlErkr+308KUlHlMjqaGKyuDTrinp8qCUhCK5mYVwIZ4EK/FM5hkwurWeUPUrR0WhEuqvQ==
X-Received: by 2002:a05:622a:1055:b0:3b9:2c3:675a with SMTP id f21-20020a05622a105500b003b902c3675amr4951678qte.62.1679491498576;
        Wed, 22 Mar 2023 06:24:58 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bl28-20020a05620a1a9c00b007339c5114a9sm11330311qkb.103.2023.03.22.06.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 06:24:58 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 22 Mar 2023 06:24:56 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/27] 4.19.278-rc3 review
Message-ID: <d08b2e27-32e0-4cf8-ab15-74deb887f64d@roeck-us.net>
References: <20230316094129.846802350@linuxfoundation.org>
 <ZBQ/rhv9nP+i8Pyc@debian>
 <ZBRjTid0Hc4V7bwB@kroah.com>
 <CADVatmOU9nJQDo7OGDNGppU8eci98yqsJzxYLjT=NPXqv8BbDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADVatmOU9nJQDo7OGDNGppU8eci98yqsJzxYLjT=NPXqv8BbDg@mail.gmail.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 17, 2023 at 01:21:03PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Fri, 17 Mar 2023 at 12:55, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Fri, Mar 17, 2023 at 10:23:42AM +0000, Sudip Mukherjee wrote:
> > > Hi Greg,
> > >
> > > On Thu, Mar 16, 2023 at 10:42:14AM +0100, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 4.19.278 release.
> > > > There are 27 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Sat, 18 Mar 2023 09:41:20 +0000.
> > > > Anything received after that time might be too late.
> > >
> > > Build test (gcc version 11.3.1 20230311):
> > > mips: 63 configs -> no  failure
> > > arm: 115 configs -> no failure
> > > arm64: 2 configs -> no failure
> > > x86_64: 4 configs -> no failure
> > > alpha allmodconfig -> no failure
> > > powerpc allmodconfig -> no failure
> > > riscv allmodconfig -> no failure
> > > s390 allmodconfig -> no failure
> > > xtensa allmodconfig -> no failure
> > >
> > > Boot test:
> > > x86_64: Booted on qemu. No regression. [1]
> > >
> > > Boot Regression on test laptop:
> > > Only black screen but ssh worked, so from the dmesg it seems i915 failed.
> >
> > Can you bisect this?
> 
> There was no need to bisect. Only one i915 related commit was there
> and reverting that has fixed it for me.
> 
> 9a0789a26289 ("drm/i915: Don't use BAR mappings for ring buffers with LLC")
> commit 85636167e3206c3fbd52254fc432991cc4e90194 upstream.
> 

Unfortunately, the bad patch made it into v4.19.278 anyway, breaking that
release for all affected users (i915 with LLC support). That has been fixed
in v4.19.279, but it is still unfortunate that the patch made it into the
release even though it was reported that it is problematic.

I don't know what went wrong here, but it would be great if that kind of
problem could be avoided in the future.

Guenter
