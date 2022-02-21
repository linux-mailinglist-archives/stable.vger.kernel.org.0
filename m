Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC874BEC60
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 22:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234540AbiBUVRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 16:17:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234531AbiBUVRj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 16:17:39 -0500
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED891129;
        Mon, 21 Feb 2022 13:17:11 -0800 (PST)
Received: by mail-qv1-xf29.google.com with SMTP id x3so35247115qvd.8;
        Mon, 21 Feb 2022 13:17:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7T91lURFivsZ1nZTW+xC3qOfVcL6XCDPXIe4eVgPcG8=;
        b=BvzRHyQZsiiVIUfQttVkmneV2DvItNxTycH4G22UZWNEyb0weK/iPcBKHGn9PZpVc2
         TyCRufR9AS0CmHq5FwqqkLfrWAHLPl3MZVr4RC7CCEaHR9RjH5TP+IpF/sIoq0K+xY/F
         +h3+HRuL9PN2/wa1W3J/j5TnPOeOwkGkGBiUKxAceARnAVqonAcqrGLnqeXqwrLNMOsL
         oeKWDIWf3Dvw6IR8zfhHD3FJQ7FQQhKQk01EtGooMbuHrTldWQReqRnBuFYUvlrjDmj4
         zL4irtRCvpoYuoy7Ssrb23naMF/g3WwwUvZnJJYgHvMVcwG7D6v9bLTo31/+JRHHLp9a
         2baw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=7T91lURFivsZ1nZTW+xC3qOfVcL6XCDPXIe4eVgPcG8=;
        b=gmvsSb87H6PEXtakGjdE1sZKwfplUknpswrsTPRBy8o7O2aMDZf4ZlUcQ7UXZWb8us
         YIt7JUaJiGHhtfwWaGRUrDHnJr3NUAFyEZ5zJ5dskTwH9f1foSGswiUvp7xy2+ttQet7
         ELG5Kad3DTnvdcD5pYEPScy0JoK2JrY/G4zfU6UA+PCTqMLcitaJd0hJO62orMC8UG3l
         sxBxwtQ1GlQ2Lu9gDLhjm7RSiJ+I6dL7vh0AgthwS2O++5cR7KRbvhXwbowNUdITBn0/
         3zK4tWTqf7LhW+g8y+blO2bALpdy1LWk441fuKCO/ttanP/uLg5g0w81SNb003+vwXF6
         kwlA==
X-Gm-Message-State: AOAM533sgM3TZ4/yTPOIAoq94gBrrWshYf10DZllzgiMV8BzUncIfT3m
        y1TZkJ0wUoJ+oZPTVhDVYWc=
X-Google-Smtp-Source: ABdhPJxocCnJt2nZO9a8kQTvUigkGm42BczPF/n1ND2hxhw0Kbowj0RcRiZzIsNaH07NXbx0DYlv0g==
X-Received: by 2002:a05:622a:15d0:b0:2de:7a3:ccb8 with SMTP id d16-20020a05622a15d000b002de07a3ccb8mr7161164qty.521.1645478230611;
        Mon, 21 Feb 2022 13:17:10 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y20sm30903069qtw.28.2022.02.21.13.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 13:17:10 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 21 Feb 2022 13:17:08 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 00/33] 4.9.303-rc1 review
Message-ID: <20220221211708.GA42906@roeck-us.net>
References: <20220221084908.568970525@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221084908.568970525@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 21, 2022 at 09:48:53AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.303 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 397 pass: 397 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
