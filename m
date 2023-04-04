Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD996D6EEA
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 23:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236344AbjDDV0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 17:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236263AbjDDVZ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 17:25:57 -0400
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBC04EE8;
        Tue,  4 Apr 2023 14:25:56 -0700 (PDT)
Received: by mail-oo1-xc36.google.com with SMTP id o15-20020a4ae58f000000b00538c0ec9567so5392048oov.1;
        Tue, 04 Apr 2023 14:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680643555;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w1lfgA3bo+QelVS2EazQZQzLteoqL38Cav9tndwQCfM=;
        b=nAlxyVLbkQXwHFIM57BOXPlt9TpceyMPPanWsGKJI0dbdywIzN6xu2oexvuHDTvMCQ
         +98UnockFsNGIg8eBMTGtVBrgMuXjjupXa8IlrCyl2dANDCC8RcsFXVn/CdCu8PZ8dNB
         tbkSWf5cBo3LQdsJ/Isw7icz3j+YCewk6+hnW0kOHZvtW9j5ly6geaC7v72VN+VJdWko
         dv9fVllJ15yBqsoqBksYydvBaVxSkq5D8CM5Q4o0CTTKTKGxz89g9g2SAq+jS1GVLegI
         35kKlihybIMzWs8XQc5ApZPnzBhdcCrxaEU8XAj3i/odpdQjmQctDl2MN23/5gSSguW+
         IIMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680643555;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w1lfgA3bo+QelVS2EazQZQzLteoqL38Cav9tndwQCfM=;
        b=Jy7Mz0y5Jm91uVWQgc1LWvGoZO3qYElm+bd9aLAsCrxPEdVdWM54zlLdxkfCNH2BwN
         X2AsXiIjWM4SZTsnDkJaBDo3Wu7yJBrAe1QOOAFSVuO409+FD5H8CvlcZKDpOI7fgwIj
         C8Cnk3ySdr9c67j+I6AzHR8eBShL5yjmECZBrUz8Bwnl+1BUpf/rMpO1JSoguYn7UaLA
         EjXVEESWhMHWpd8aDyNiZVtqnShXQC4h7LS816PPYNQ7eNijLXrq6uuMasX3cr7dPd+9
         Q/O70kytJUculz/RCs3sEzhLpHZeYfQIPD2q++DKWZqFYuQu0hpQRFMV0NqpdTKbUsZw
         wTaQ==
X-Gm-Message-State: AAQBX9dN2AZ9ffi/6yEzcT7ATYlrnXVD2cEjV5r8ClQ57aFxV7XC2kqy
        FhN/hrRWX1rYGXFgIDOOEoA=
X-Google-Smtp-Source: AKy350YTueH5Ppmo8uC84BaYI61cBu7zxdcAhyRZ6wqPqI5Vc3Yd0F0LeEbBlZnUdYPx8CDdSC1zew==
X-Received: by 2002:a4a:4950:0:b0:53b:691c:43f9 with SMTP id z77-20020a4a4950000000b0053b691c43f9mr2739635ooa.2.1680643555548;
        Tue, 04 Apr 2023 14:25:55 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y70-20020a4a4549000000b0053e56135a1esm5940726ooa.45.2023.04.04.14.25.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 14:25:55 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 4 Apr 2023 14:25:54 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/104] 5.4.240-rc1 review
Message-ID: <a61e0858-cda2-42c1-89a8-e8c4112bfe86@roeck-us.net>
References: <20230403140403.549815164@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 03, 2023 at 04:07:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.240 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
