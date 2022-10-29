Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9941611FC9
	for <lists+stable@lfdr.de>; Sat, 29 Oct 2022 05:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbiJ2Dex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 23:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiJ2Dew (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 23:34:52 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F29B2D;
        Fri, 28 Oct 2022 20:34:48 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id e15so748466qts.1;
        Fri, 28 Oct 2022 20:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=547toOe5v9+fyrx4uLzHLZTvaSA7cu9z5ChcHjNwlSY=;
        b=jKVeYVgA+JBAy0TADQTmkNxoKi/QFxOjs/ZUstcbr7p3KMeIXT34FE7Wu6so6pRwra
         SBH4yQOM+lZ9e6zZmK3bqzc/LEDxHYOKvr+vVZCB6prrqd1ZmVoaeQN9b3JNREPCpmMi
         RMBU3OXLlvtVRJH/peOEs+DJ/gKZBTKIVTakvxmXM9FF0pD5DJJUowVjjAlY72rHaotV
         v+YwseRH27h0MT0QuFAW9mOGmVTbrKt0EAE0DN15KEF8QNepI/lM1bkiGNbj8AvtoiXz
         ryB5JbhSUUzNv851WnAT5dpsH7z+31pW3iG4aG55HFmQq9Ikcvntp4ZXZKXB0LafbsGg
         x9gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=547toOe5v9+fyrx4uLzHLZTvaSA7cu9z5ChcHjNwlSY=;
        b=Q9xXcfL8q3Gfa+e+W26RsZtAQDEND1YckNro3ZQrl1lqaqjAp0KolXR6IK3H45lCeP
         cB+8/c+Hl21NFw3gRoYplxqx+7H5P7p7mauJq926XgwPJsUhqWttXvuRtYHzymk8i11g
         xQXrjZh8QvFV/gvHREgSBwFspOuyn1FjMu7+HqS0pj4t1+g/CK7Jqhi0/857Rsalutdc
         VD/U9wi+IegyivWh2BllSPvAzde1kyZlFzOCSOB4D93UNrJW116TahMWKysQDcbOzaGN
         39L/H9cRtnle5BXhR0E47QgJyQanEalC8xo/Xh43kKOW4OVzMKdKo/hTRgddGKiX68iP
         W7wA==
X-Gm-Message-State: ACrzQf0W9agLFG1OxjXr2Ji7vADsbMBYsAC07mn2AX6eBVAxllXIkCD5
        FSrBTioz5rmWpPhx/9d/9aQ=
X-Google-Smtp-Source: AMsMyM72zL+lXJJBJaSilPjg6GPgKF+FiTC1Oeos7yOJR3Cwe8S1cCxZHoCL3cFFwr97FA+TwyErpQ==
X-Received: by 2002:ac8:5c07:0:b0:39c:de84:64ad with SMTP id i7-20020ac85c07000000b0039cde8464admr2255306qti.336.1667014487137;
        Fri, 28 Oct 2022 20:34:47 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f11-20020a05620a280b00b006f8665f483fsm323213qkp.85.2022.10.28.20.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 20:34:46 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 28 Oct 2022 20:34:43 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.15 00/78] 5.15.76-rc2 review
Message-ID: <20221029033443.GA53002@roeck-us.net>
References: <20221028120302.594918388@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028120302.594918388@linuxfoundation.org>
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

On Fri, Oct 28, 2022 at 02:04:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.76 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 30 Oct 2022 12:02:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
