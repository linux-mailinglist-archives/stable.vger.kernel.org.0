Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5D5E611FCB
	for <lists+stable@lfdr.de>; Sat, 29 Oct 2022 05:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiJ2DfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 23:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiJ2DfN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 23:35:13 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444FA4507C;
        Fri, 28 Oct 2022 20:35:11 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id n18so5291355qvt.11;
        Fri, 28 Oct 2022 20:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FjBmGgtBccJtbskrXHQtFtqOZzyo3pagS1tNLq877uw=;
        b=dQBZDvvbTJRIocCcNKYFpRAG8f3FPqmW5xlTZxu1b1Kt9QdigSmudrY0mJ3NpZ2YAy
         3hyYjA/IHZZN/RNZ2YI3MnwULFdNLRGYDRag+DTiKSZVTQ+KIMxdogdFt9kOSCIEu479
         f2G4YLwnoR0qnFYuMMThybaRPRmmuJNJv0qnEmNHmTYsG7wGHNtNi8QvkDM7+9moNSBp
         hc7+CfhU8MhhzPgE9X2AWlNpvQeThqIYCvgGjwjjx9t3iwJ3xbvoGAIrpV4rnbZIbeJV
         NmkYu8maHTe2tXes4Hwrak3+S5t/KTu6zu6b6WTNIgVLNMjpm9NMrr8N4/alEuV2vcpl
         MYww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FjBmGgtBccJtbskrXHQtFtqOZzyo3pagS1tNLq877uw=;
        b=uaaRUSeBvKq9nSqLr5nzKgBzKkWr1In47a2f2ha391+Hdau1/hcauGOMb8oa2SNXk0
         bczGex4La5rSBov2wf/UrUqstXh7pYQmN9dcpxeQKh7TCeKvWPmNl5I6SLKgVqnIiyKo
         WqHQGschn6WjDG4MlgUqKXbXZknjyeGUT5Gb6bHmujK9Z9Bh/JUkByZfPBK/4zvVANUP
         i7eFRxkflKtBoyelIJ7ySkA9zpHiZkS0sG2EL2jOBYqnlBLVDiA5RW+DgBdkJinJaCkE
         yvaoL+GajldLo9sX0As6i7gyUs5cTBy/jZPvZkW4SxehbQm91kJTtDkeohjbVb0jbUSH
         1rEA==
X-Gm-Message-State: ACrzQf3HE5YN7tSdeUfyng2iO9Zot8XhY7QrNqnu/2Zp2RrUhmH2eZSG
        gkO4Kve22/dO2GtD0uX1Fd4=
X-Google-Smtp-Source: AMsMyM6hiqPMyvNX1PGGZvvo9BhKay4u62k2qFEnjNwZmC1ICRsjYvvgqJFWDs6c94vJgmkePhBt4Q==
X-Received: by 2002:a0c:dd13:0:b0:4bb:664c:5aaa with SMTP id u19-20020a0cdd13000000b004bb664c5aaamr2344167qvk.121.1667014510427;
        Fri, 28 Oct 2022 20:35:10 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q20-20020a05620a0d9400b006ec771d8f89sm309238qkl.112.2022.10.28.20.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 20:35:09 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 28 Oct 2022 20:35:08 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.10 00/73] 5.10.152-rc1 review
Message-ID: <20221029033508.GB53002@roeck-us.net>
References: <20221028120232.344548477@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
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

On Fri, Oct 28, 2022 at 02:02:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.152 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 30 Oct 2022 12:02:13 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
