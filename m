Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB47654A2F5
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 01:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239465AbiFMX55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 19:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235709AbiFMX55 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 19:57:57 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADCF52B184;
        Mon, 13 Jun 2022 16:57:56 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id y6so1487273pfr.13;
        Mon, 13 Jun 2022 16:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hh1+Iero0NV2sb1lbTAO85Oc3RXgllfmc8Fg8jSSfLU=;
        b=Qw/I5GRWJ2eGD7WIMYuFxxPEOAu1/Xi7cFDfuc8+Ro+6fRVnBWaErB33D6ew5mEWGX
         Dt6liRgDp809+uUzvzh8C1aNBY9Qnm6ZhxBUDMNADMgev48dngm4pPvrg0WkC6/y2tj8
         odkezTAhwF3e1wBTb2gDXU/DoiYKDe153qpvYmWm3fX+fB/wPric70sfmSa55+kfk/Ac
         W7U3nRL2TpjehqLjUml/XtAqVhP27bfd2OiWjDa7w5h+pU2zG583vlkOxRMdfLT+1w1M
         9rsJGTM6RctVNBLj7T9cUb3PFVPYz7GFd6E0b6ZTAnRZbY/7sgHG0OHqxs9kG63xmZ3/
         9NVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=hh1+Iero0NV2sb1lbTAO85Oc3RXgllfmc8Fg8jSSfLU=;
        b=r+QrCrVEiFiT8P++1EFKNzyArxcXAbBBZsophMCUvME5i51QfDAElC0daI0LQOQXCp
         gKF/+4V7luFX0M9JEbayJgW4nCOQdWHpIoz8xfgi0gkkO3sEZIL39ag130EQNxyr/AVc
         rcjCk9x626oxpNe2UtH6wbabIH90D4ytGp/TV6SP0xR0W3mfWRz/OGL4zBsN508C8oJ6
         fFXLk6KE2bILHMYv5hFwptgzBVXsbm8MfNQ4DOARVbDL3p+G1zPkPQFKGbVBOhsP9doM
         gc2hDhhTaDfe82aPiSWx5cr4Nm5q59NYrgG2lORijMnBTK0k9E2Vt8qtGmWErGJwg0NF
         oC9A==
X-Gm-Message-State: AOAM533oblgFB2voCaAmC23T3UkNIZmJoeacriMdzOXwutwIvIZh111W
        UnEwBzzDBVpygas3RDmed7w=
X-Google-Smtp-Source: ABdhPJxoVzp+IaX+4F5acV0fodV2i47w6O42oSMZKMkX75w277jwaN/9j1zRrnXPRXsG9eHv05B3HA==
X-Received: by 2002:a05:6a00:b8c:b0:51c:2d3d:4595 with SMTP id g12-20020a056a000b8c00b0051c2d3d4595mr1712485pfj.80.1655164676213;
        Mon, 13 Jun 2022 16:57:56 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a27-20020a637f1b000000b0040898e7e30csm1510100pgd.94.2022.06.13.16.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 16:57:55 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 13 Jun 2022 16:57:54 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 000/411] 5.4.198-rc1 review
Message-ID: <20220613235754.GD1666524@roeck-us.net>
References: <20220613094928.482772422@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
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

On Mon, Jun 13, 2022 at 12:04:33PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.198 release.
> There are 411 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 09:47:08 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
