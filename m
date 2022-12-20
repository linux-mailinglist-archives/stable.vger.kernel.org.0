Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A31146523B0
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 16:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbiLTPdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 10:33:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiLTPdF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 10:33:05 -0500
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF6DB489;
        Tue, 20 Dec 2022 07:33:04 -0800 (PST)
Received: by mail-oo1-xc35.google.com with SMTP id z20-20020a4a4914000000b004b026afa844so929652ooa.13;
        Tue, 20 Dec 2022 07:33:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=suyFY8xw9UxN+N9G3efEmh94rT9pPwpzgTHk6VM1Dqc=;
        b=CIleh4Apr8LRwfvI+A+BsYTd8i+SO+iVA99bQOSI4JQAHRn00el5BF74vki3nnnQWY
         banuUqWAjPRDPdL8dzb4s3OqgCEKOyXs818a0XC83NfMZuGCbPaFOPpEAMHFqLwUP8qV
         Tpet8LXYFdPAdlsTNpNOWnJR96Nz/xQep1lubNOKqVFu8YhDdllvDH9mAFVZWQJZzh8R
         cRcduHW6iXhNpJtqbljF+TlwS6TCJjVHC8GfR+bI6rmI22Qubs997URFoo+5G8Qv2A3A
         UXdTuHKLUo5fTvGtBEupnxRaTN2W4HzSEPlAVO2ZNpsnCGsZ+vAWIXMhNKJ69+13h5o7
         4dcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=suyFY8xw9UxN+N9G3efEmh94rT9pPwpzgTHk6VM1Dqc=;
        b=PM8Tqzqps/r+cUDl3XFRWSAx3LGyT2V1RVKDxFJD09L+VRP8T68jlGkHuEv7q5az3+
         57yZASA6PRSmk2xEDCeKKX+/VxS5yCewtTfIsmuZ677A4zRgJivChMsvO1DWMvKmepzY
         lohD+kS4ndEMmieMivvSsLrRLpFBkUQe700SJYac0IJ0OMwaV9jMXPJkFQz2WWym/9/F
         hk2WPTYBRnwFXKvPffZwanqVhLbBZo7ghagJt8DLBHV/Ilij7ktX0ZfB0dtAQ0BpS1mS
         GZDdtLTNH8320MA0wYq4LWME7F8thNBiO2PD+S6WZ7WkA+i0IO4K/TlCRzS5ALYmkQoB
         70AA==
X-Gm-Message-State: ANoB5pk6yIDNczT1cq+OLblc+3WwoT/+rmLbUY/Y43mNhGdLKhJEebUG
        wlXuvOLo4XrtskiPGbxF6Z0=
X-Google-Smtp-Source: AA0mqf6A884VIUJ2aHIMNtCymsgMVLg/Y+NGc14jOkcXUYSbZVFFvdSEPHpAYHEIkM7ElnSyrNgM5A==
X-Received: by 2002:a4a:d12e:0:b0:4a4:9a57:8eb2 with SMTP id n14-20020a4ad12e000000b004a49a578eb2mr12778900oor.1.1671550383589;
        Tue, 20 Dec 2022 07:33:03 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n14-20020a4a344e000000b004a5811080dfsm5156134oof.40.2022.12.20.07.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 07:33:03 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 20 Dec 2022 07:33:02 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 00/28] 6.0.15-rc1 review
Message-ID: <20221220153302.GA907923@roeck-us.net>
References: <20221219182944.179389009@linuxfoundation.org>
 <20221220144900.GD3748047@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220144900.GD3748047@roeck-us.net>
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

On Tue, Dec 20, 2022 at 06:49:02AM -0800, Guenter Roeck wrote:
> On Mon, Dec 19, 2022 at 08:22:47PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.0.15 release.
> > There are 28 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 155 pass: 155 fail: 0
> Qemu test results:
> 	total: 500 pass: 500 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>
> 

Wrong results, sorry. I'll resend once I have real ones. 

Guenter
