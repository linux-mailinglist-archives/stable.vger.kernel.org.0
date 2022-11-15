Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73B56628E13
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 01:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbiKOAOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 19:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236661AbiKOAOn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 19:14:43 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D229D2F6;
        Mon, 14 Nov 2022 16:14:42 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id k15so12618995pfg.2;
        Mon, 14 Nov 2022 16:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0PUgakfIb3B+WPgvAwfy7fwsocSPx2wCqEn/4/3wPns=;
        b=JOBUc794LxPvDMrzGKaD5a5K55kIAW+6brQoFjJLTZ+FMCx7uKUfKgz7JsEqFofro4
         7ochCrTt5ZXIbqkSI4AjF+KaorwoF9JmPtDLz+zcIvsZDdohdIV9eaC6RMdTcYlnPils
         eH8+hZz4jKNOBOnccNba7D1ag8wG/W4jZ61v/xG+hyI+/iv8Kegzpb4I+6S3Elsc43+V
         xRLJ82tdrhy69F7Z3QZf9Apnysi7EgN0SmEWDUv+EYwTfZdZrK7XGLw6Qn2CkKT28QKc
         JdSxIwgpRbJ+rJ/TU3R5WOO9eCXPi/gW/uhJSbtOo5IQiyn5lPY0vdMVRbmG55ZOWryZ
         dZYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0PUgakfIb3B+WPgvAwfy7fwsocSPx2wCqEn/4/3wPns=;
        b=5ZPUwfYuykrAW7SJSKx2K9MVym4nSuigpgfNSIvIpgq5ZUjlE+rulyvPpEdDFhUH7J
         Bxx2mFAJ+AyvRf6PqSqgKF7YwTloxfQ3el13tQAXvEKpcWD0nGkm3ujps9DMwh5r5bXI
         SMmHWvGqq5cT2oUBLb/yJRQ3tBZkB67hguoW9U3AQAcTGOn98LmhbR1/aOjOGpMe/4yr
         8BzdQ208pcHs7qN1iMgtGHuPfpIxQjMgapRmLKUtUCF+q7zCqdHoI3COYLJAoaxnv+fW
         yjstj4iHwIBa5Q6R7sylDq7H3ySkP9JPCxmXOVu7BEh8Z3kKJUX8m8CnROVVoG9NJ9AU
         QVTQ==
X-Gm-Message-State: ANoB5pnaE6SdxhVsXEKlEIZtxkFlCNYeSaCeUNnD0LwRgRh0v2wGAhiF
        N35QgHlK+qn98S7qloD75I0=
X-Google-Smtp-Source: AA0mqf62gToNtfuLSSzYaP98r/OvEYkU56JLLSCIkEu4DiQuEPHf5zvmjD0O12y75crS3Li59EiODQ==
X-Received: by 2002:a63:f658:0:b0:474:bbb:6523 with SMTP id u24-20020a63f658000000b004740bbb6523mr13727218pgj.476.1668471282126;
        Mon, 14 Nov 2022 16:14:42 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id mu4-20020a17090b388400b00206023cbcc7sm10427386pjb.15.2022.11.14.16.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 16:14:41 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 14 Nov 2022 16:14:40 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/190] 6.0.9-rc1 review
Message-ID: <20221115001440.GC2291336@roeck-us.net>
References: <20221114124458.806324402@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
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

On Mon, Nov 14, 2022 at 01:43:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.9 release.
> There are 190 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 152 pass: 152 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
