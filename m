Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAF354A2F1
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 01:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236672AbiFMX5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 19:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiFMX5B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 19:57:01 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C7926547;
        Mon, 13 Jun 2022 16:57:01 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id 187so7119396pfu.9;
        Mon, 13 Jun 2022 16:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AC8FPQTqGpkpuneSEms7RKD3OH3vEQROFI38UBpbbGw=;
        b=OwPoy2yxCgZVPumyCm1qqyOshj8+MgmMfbfT/3ZXzSYgUUBgTVaS9Ga1DZXRRw7AdL
         3GbTYTEtdb74KP+0W7lz8GdTPzfxS3kATh4DYO/al+yMJF5N/FFabFV7SUgpslXX/kLH
         /je7JYJbWYAh9hQQgF4CA7HKxpAtnwH7N4lBQXNj3atQFnD0EjRgMncUgfpDB354G6jp
         rohihzJX95qFNyJDEQNCdNpxQ1i9ZQVuJXVqPenzW3VtnPaUcdmJCU0kBajor+y8GX6P
         RqYyIzC1Z23UMJV1VE4Upliyf76IzmnEwe4Go8gSVGLAfknM5yDq2VLZEOjv67KAcGBr
         tLnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=AC8FPQTqGpkpuneSEms7RKD3OH3vEQROFI38UBpbbGw=;
        b=PTqz/w/q+ELlEoGtBL+0wzmq7F09GyncSrz4Xz1LttVS62bBZ1Shupo6PoFBxnFNAj
         vmmTmrQzbljIqmcd93yWi0g6IXffyZ8ub517TaejwqnnwXsnTPjVyt+puMnuK/5iPI0x
         GDz+EK7gGnzuqtX79yLA7o854ubQwzbRFyFmaCPsHk3L+2VxsSyLXMoqdS9TVDvxJB1l
         mtuxKrCFDtX0ddHjo6GBywtJgqhVcjVAum0OvJPzdvFHWvBouBZHKa9O6IjF7vNmb3oq
         cViVsMX7Pi7vAf0A4tnUsDnDM4QdebHcGVI7PAlcES4CvSFE5XaZi0cDPo7q2iw9WQnw
         y63g==
X-Gm-Message-State: AOAM532tNRbpZ/La5k0frzg1VPU1Vxa0x8K6qrLU7KiBDcCbCCPi/nBJ
        jRweVihQaL3CUhzJraJfbxE=
X-Google-Smtp-Source: ABdhPJwLX/bdClNZEdud+8pvDyLjQkxrXsKEHvnbRVQ/sV2YLTD77EiNebkBh3i19G0Kc9olUEaz7A==
X-Received: by 2002:a05:6a00:1a91:b0:51c:2fab:7340 with SMTP id e17-20020a056a001a9100b0051c2fab7340mr1845880pfv.74.1655164620791;
        Mon, 13 Jun 2022 16:57:00 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g12-20020a056a00078c00b005190eea6c37sm5957381pfu.157.2022.06.13.16.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 16:57:00 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 13 Jun 2022 16:56:59 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.14 000/218] 4.14.283-rc1 review
Message-ID: <20220613235659.GB1666524@roeck-us.net>
References: <20220613094908.257446132@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
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

On Mon, Jun 13, 2022 at 12:07:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.283 release.
> There are 218 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 09:47:08 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
