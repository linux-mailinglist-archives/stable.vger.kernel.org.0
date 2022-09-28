Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBD705ED286
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 03:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbiI1BNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 21:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiI1BNw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 21:13:52 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175381166C5;
        Tue, 27 Sep 2022 18:13:52 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id u92so1708770pjh.3;
        Tue, 27 Sep 2022 18:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=bCIaETrrrN22j2T5jAJrY5RZV/xwx1tEjHpaSPF0Rvk=;
        b=EYjTLcQj2WfRhglPuN2o4FDmKcGVOg3MXS67abQWW8BRw0z4hZ7kI/DmfMy5duVbnW
         08sKZUNh0I3ug5drTKcHGEGxuxhI9ihjzjvmPy7Eu1Y/QBsKVhZrFYZX39iG+OUgnFF+
         ELIY3kQ1zUemvXe40138GlLKEUj65KTZOoOd8AqD8fAbfhqdliHG3E2XW9iBgR8zTG2y
         naOqew6BLk+sKJnfIpOU4jp2L6vXqVwXdrtXriGbO3jk5cG2JwCNqwRRtNy64OJ0Y0/E
         8H+qgUkvcCK6qUSp2rlgwRVXwA3/Ac1zLXktVTd8HnfqIQ8g7POq2bFmlWRnfgdp2iI7
         sREw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=bCIaETrrrN22j2T5jAJrY5RZV/xwx1tEjHpaSPF0Rvk=;
        b=DP2FbZZulzUCGszIdrM7/AWO2qQ5y5aSIQVp3dvB6KQA1ElRVR3jmCoWG+lpmf2LSt
         f+S1m9OfwfSxbWvJhGHAUW1VpSSaJFgqvimFIU4+8FE3GZkA2rfX92o5eP7Vl0UsRUB4
         yktMWRq1HZFN6NH4I4iCf6uLgPZSzd+HXTVZKdsDwMPChHxOnS98eOwLdupMYD1IPNQj
         vhWGkVkQsxGzJS9ZnD5w/Pkj4/ZbPvUJRZ/ydweyI1evDE/EAygykgxKVO9y/wMERkMi
         2fv9X1FAoFnAGlbAdnVGqPSx9JeAl8rBrS27sCrndu7Sh0gMa/x1txRuLBZrldKSCoqi
         RKUQ==
X-Gm-Message-State: ACrzQf2qLvS5xTBnexl96TZBSHo2lZTIOqbp0hi06mNwBeC1ZIQTn4qX
        7+xnG6VL2hA8686PVDv2FJo=
X-Google-Smtp-Source: AMsMyM5dJkxsX55anIza88VmPJhMJ8GdQ3Vv+zrp3J5CgUrCj8FGiGkaZwVF3fxAohsFdvYgRE6nCw==
X-Received: by 2002:a17:90b:4a0b:b0:202:8568:4163 with SMTP id kk11-20020a17090b4a0b00b0020285684163mr7554075pjb.217.1664327631577;
        Tue, 27 Sep 2022 18:13:51 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m10-20020a62a20a000000b0053ebafa7c42sm2485094pff.79.2022.09.27.18.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 18:13:50 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 27 Sep 2022 18:13:49 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.14 00/38] 4.14.295-rc2 review
Message-ID: <20220928011349.GB1700196@roeck-us.net>
References: <20220926163535.997144838@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926163535.997144838@linuxfoundation.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 26, 2022 at 06:36:37PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.295 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Sep 2022 16:35:25 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 422 pass: 422 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
