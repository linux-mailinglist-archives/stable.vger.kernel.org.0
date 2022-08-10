Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6115158ED62
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 15:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbiHJNeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 09:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232974AbiHJNd1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 09:33:27 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809D55E305;
        Wed, 10 Aug 2022 06:33:09 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id ha11so14763424pjb.2;
        Wed, 10 Aug 2022 06:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=rLS4XzXigq7zr1Uoykzx35o3H3YZFNnNxYLLWVPCvRY=;
        b=dncOnmyn31oXo530KASjPuIYSYkt8+yDqS1S6Ahmc7JaFQVlJtwXOGO1ajbVitk4q9
         Rgi3w0rSDSFX2XbkKm7lARaOXgxvSZhQOda+9DeeiCU5dBATQ6451S3XPoSGQS7WHUV8
         u+EtIvPu2Opebu8WJanY3FkW/+Nf2m5avWYEqIuVUJim6hilY4Ufa/V20Q4DthFYkv30
         7P7xdSYx00Xdsfr07q1Ok+iNB+o6aqTSvVRsFCSG5d513j49cXDjvCluMkTFiy7AJnbI
         8oeSyNil/g6wyKj8UFhcbGKYVamu/ZAkBngYJfpBrR2pCezKG0HvuKHmmwiBFv28ehnB
         IKZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=rLS4XzXigq7zr1Uoykzx35o3H3YZFNnNxYLLWVPCvRY=;
        b=1qELsAZLfTqrl1rpSYD4zaGu9WQri9HeHLocSznVp0lR2sgrt90pJ1ktfgTAg958Mj
         Cw/1kZBacPImbkBczequb2lUSwrdnrOTimgLOS7JKcRFzucEg/YxO5iIOVv44iGAS0kJ
         9gqe73DkpULkX/E1xowAMXRePIbtxg95Axz/zfCWH+s2rxz3lJ8/cVuj1FQIGeApJTy/
         CRUaJl+wIQmZ/dj+76cQeK/e6b52f2rHO4iKyWzpD8qQoXMWIk3/re7kmIObwTXjv/4W
         oh+S8F6y21R4237w9z0UcF6EI5HTjjh153Z0snwvfq2Q8cHfrm3v2pIq2am078ZEUTpc
         YsYA==
X-Gm-Message-State: ACgBeo0PUygx5mMt9C4Q9bDQUNQrJUdPMqSfAwSy1dpYGUqty/HdYVIe
        lM/7dm896/oyHTiJgCWiDOM=
X-Google-Smtp-Source: AA6agR6ULGuU4adBm5Wh/ms1WQIevkPBZdoS8KKpu9lutSOcZUqYE4v4kDfYdWczDCuhuNvIJquvcQ==
X-Received: by 2002:a17:902:ef96:b0:170:d01d:df13 with SMTP id iz22-20020a170902ef9600b00170d01ddf13mr10831153plb.53.1660138388951;
        Wed, 10 Aug 2022 06:33:08 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f14-20020a170902684e00b0016da9128169sm13004353pln.130.2022.08.10.06.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 06:33:07 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 10 Aug 2022 06:33:06 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 00/35] 5.18.17-rc1 review
Message-ID: <20220810133306.GG274220@roeck-us.net>
References: <20220809175515.046484486@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809175515.046484486@linuxfoundation.org>
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

On Tue, Aug 09, 2022 at 08:00:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.17 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
