Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1D416E010F
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 23:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjDLVia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 17:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbjDLVi3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 17:38:29 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738CC4493;
        Wed, 12 Apr 2023 14:38:27 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id 98e67ed59e1d1-2470271d9f9so145180a91.2;
        Wed, 12 Apr 2023 14:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681335507; x=1683927507;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zryaPgAYMlVR+T3G4KOAsz+hbudinum/d++UX2e4pk0=;
        b=Gj6a4c7rP48bKypuGbXyKnkj3i7jYX1EW//9af3ssw9LgkQPtVn7ZhI6alSuhOweS7
         O6KQ4XJu6td5/GE7AZFiOoQk72fWKiiV/6zzUV9kTKYJESgYtddVSh+qDZ2lzm6R6dW4
         SRdxEiVSaqzENvuNWG5IzDKrRVlfk81Wc6yjqzc85yFo6MofTY67IaNwxtont0vA0C0Q
         YzAHm7tf+CGAfOzD9Q7pV52BNo/1hVJfKU2QlKdYRLhAK1+XQdRpCwKSgetEo7tJBTix
         QLq37xIYTZ0Z7TXWpU0mHN/zejVN6evyPqaGmez6WpCVfgsXDvxF+HtRr4Z2QBk594LG
         oAGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681335507; x=1683927507;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zryaPgAYMlVR+T3G4KOAsz+hbudinum/d++UX2e4pk0=;
        b=SrENHlF72u4CvIpx9bsQHfPp/7wz3flzvserwnXoc1Ecz8r8RArF6ROFx4XmgTvJbw
         Qp2lw5N4/2d3UyCclZk9dBiTSyAXLycs4D/+sSel/OnUyLAnusH1p34NCvY3FYp4CKlG
         7nHbuE7eaqvd//RTJZc+GyzZBlo1T5Graf3DrovchqE5EsXMllAk1EbfD1Qqa4Eer+SC
         eXrI0/p0ZOiTH/YbbnELELchYUtQNXjrqM8BxxIARW0W10UBl9iy9mI8uXI977YvepEH
         ciGKkEY7uE0jqYinhhMjtP6G6bzaqd4VuuYTj+QoyKFNhhQH456a6L037dzAm7qNPNsW
         vOkg==
X-Gm-Message-State: AAQBX9eT5u1oy2DL8NPpdv7N8uC8x3w0u8JtnoNJB5GNv4WGlPJJtZBN
        19qMAyCpIjfnMXFo1udm/tk=
X-Google-Smtp-Source: AKy350ayLRuWTQHmaXMx17Sh5poDoJ9CEU6/hCpz0PPGekzJrdBt9TWO8taS2nRnD4He/5JUfAQpXA==
X-Received: by 2002:a05:6a00:1a43:b0:627:e69c:8488 with SMTP id h3-20020a056a001a4300b00627e69c8488mr339839pfv.14.1681335506700;
        Wed, 12 Apr 2023 14:38:26 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c11-20020aa78c0b000000b0063afb08afeesm2406261pfd.67.2023.04.12.14.38.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 14:38:25 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 12 Apr 2023 14:38:24 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/164] 6.1.24-rc1 review
Message-ID: <10bdb21e-31d0-4d86-bfa8-1902f32f2760@roeck-us.net>
References: <20230412082836.695875037@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
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

On Wed, Apr 12, 2023 at 10:32:02AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.24 release.
> There are 164 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 Apr 2023 08:28:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 519 pass: 519 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
