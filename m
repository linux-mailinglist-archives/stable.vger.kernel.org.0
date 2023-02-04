Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E34BC68A7AD
	for <lists+stable@lfdr.de>; Sat,  4 Feb 2023 02:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbjBDBv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 20:51:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233172AbjBDBvZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 20:51:25 -0500
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8F51A963;
        Fri,  3 Feb 2023 17:51:24 -0800 (PST)
Received: by mail-oo1-xc2d.google.com with SMTP id k15-20020a4adfaf000000b00517450f9bd7so675778ook.8;
        Fri, 03 Feb 2023 17:51:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e1hnwrQg/7TrlKiWRJR4hcEttZPGMMEcTVNIQ+LbzmA=;
        b=eFIFeueLVEjLat1j3tzYef0iCRSXaYNriZQFGtlW5SMwAGBBHnmvjHGan6KeqNyyKR
         5EnDF8KnCrdM/FVW9nHbwovNqXAXyBlbCxTnVpPM+BifQdUMcpHSE3lxDBs+LOaeiS9Q
         lNhSisOSgGwJaU4lZSoZ5ujkMcBO0OGWSE9FHJcxiG5VKKebG0p2AyckxFdoie8dmwRx
         2gsR/gLbG5GGzj5VhQZsdD6tQOa0ID4a4eBDSTmtgPw6ZuUxq8dVkRHIjcNS5zhpnyvn
         qvVNtqkTXOw9WQbuedSiUSHMm75Dy4Yn7s3krr4DLIT8+EskXQDfLmwSMkQmzIncOmbe
         b4Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e1hnwrQg/7TrlKiWRJR4hcEttZPGMMEcTVNIQ+LbzmA=;
        b=wkVIsn2n0B7k5GQCTm3psOuTEx3iJmSMMVCnhXnEpJIog1DTI7l6rSMnsJU+ch1Cxi
         2/QdjIo9tF4wgsNAe5VpZtBZhx+ryW9JWPGYLZCsMQG08GFNAcXKVO1NVu2xK0ZUrND5
         TOnvWhh2UjfAJC+RWXoKg2OVTLGhHEz/XqEBAkbPx0m3e30z/3aNJSnbEsnf/8SgDpWz
         f4nfNJy9r8mCgrRRNwVz1Rbf9Fw3dd0D2P5cuf6IBZ1AA2k/GRMDGDs3FsQbhRG8prS9
         SY7qAPyS6yqPA9vUoalyviFA6ib0zZL2SFdDpxwvK6JXRAloKuBXHskfSnwpKoo0Crlh
         ejXw==
X-Gm-Message-State: AO0yUKUcGF6Pr1hrvkHMAsMHCoV00mAHR1cNChW/IvgGJEqTBi3ZnRPm
        amP1J0FDFpBSdhsMiNzDW6rcjIwzB9A=
X-Google-Smtp-Source: AK7set/p2A8FdtXyfiQ00tDpRUMXqwb2TTooDavd11tdWB5qJQv1lo7zQ55/9bEQ692IyMch8SriyA==
X-Received: by 2002:a4a:e38c:0:b0:517:afee:a386 with SMTP id l12-20020a4ae38c000000b00517afeea386mr5626564oov.2.1675475483713;
        Fri, 03 Feb 2023 17:51:23 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h13-20020a4aa28d000000b004fd878ef510sm1616569ool.21.2023.02.03.17.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 17:51:23 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 3 Feb 2023 17:51:22 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/28] 6.1.10-rc1 review
Message-ID: <20230204015122.GF3089769@roeck-us.net>
References: <20230203101009.946745030@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
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

On Fri, Feb 03, 2023 at 11:12:48AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.10 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 503 pass: 503 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
