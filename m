Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5DB57E967
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 23:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236654AbiGVV7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 17:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236702AbiGVV73 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 17:59:29 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FF4BA4EF;
        Fri, 22 Jul 2022 14:59:25 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id p6-20020a17090a680600b001f2267a1c84so7575221pjj.5;
        Fri, 22 Jul 2022 14:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j9XpNIfh/rfEtFsIaRl4XRMJLXQTaQPky7EjGJ+34us=;
        b=VRcFIbbQoSI2RQ201OvN5e11RFw0zviYPgylt8pDt1nna/czjsne/BrYN0TyvlVaLz
         /K+ajYZeTwEw5KnRVDcUHG3dPy0nnHQNt9KXS53iEbjiHMAO6BkQgVyGblkzLkp2/wl9
         dtiPW0B+mRzTupNIWbib/Gb2OYUTGAiOOcRiyD74jFt2+9D6x9IGQ8ZgVfhDxZ+G6Kpl
         ujLHulPOQrHZrjVrapzaKy4B9Hueiwom3NVVdqvF/3nH8Pf87nfigW4PNNZVXuileaCh
         vpWKxtIA8hficCdUWWVo9n6jkrnDv0LQ+rufeLvs8rTX9ftp8u3eqncC036aoXgVd/p6
         5PvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=j9XpNIfh/rfEtFsIaRl4XRMJLXQTaQPky7EjGJ+34us=;
        b=dtXTs/8kGY1C+Ymh9alJHRlnsy+Gw0rdpT9zv+MydytmCBDw0eyzR92GyfBKEQiEMo
         yC0w8r16Osizl0T6nqGD8dXbQ/I8CIBarNJI+Ug53Ed7AXx73D72mHyDQIz9VkZVCSsH
         jtdSOqMDR1bMWWjN4bgHOy2tdxfypNDF/6poUeTkybeFvEzVf8kr1JQMWMD1jjXSlrzr
         RoFoLkCaBFmLBbJhK4OfBnrz4xohUPNhHOexTABhNkLuK7rS51leh6TfFffYE4FYy4ZK
         joELFEWLIaiEv/H43WtdEu3+xVP7mMQ8e1FlOsEgmfKBP61FqVVk5sCHJH3oH3QyAGtj
         +1ew==
X-Gm-Message-State: AJIora+GCcipWW04Nq3bRAlMvqDD+hPBB8mcaorQF3/7DQd1sjk6zR1W
        tOSD94GT0HapSfgRn4QTWl8=
X-Google-Smtp-Source: AGRyM1uV1zYzpGGN8SJutgt8BTnZEV19YT/gzXXNyNZWAP21NET6D5ggHFvCpPfbSqeJSf6bnkYIjw==
X-Received: by 2002:a17:902:ecca:b0:16c:569:47d8 with SMTP id a10-20020a170902ecca00b0016c056947d8mr1822853plh.97.1658527164725;
        Fri, 22 Jul 2022 14:59:24 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id cp1-20020a170902e78100b0016d2540c098sm4218553plb.231.2022.07.22.14.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 14:59:24 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 22 Jul 2022 14:59:23 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 00/70] 5.18.14-rc1 review
Message-ID: <20220722215923.GB1030798@roeck-us.net>
References: <20220722090650.665513668@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220722090650.665513668@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 22, 2022 at 11:06:55AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.14 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Jul 2022 09:06:00 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
