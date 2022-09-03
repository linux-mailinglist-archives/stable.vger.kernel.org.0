Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A669E5ABBDD
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 02:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbiICAfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 20:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbiICAfr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 20:35:47 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC0B5724D;
        Fri,  2 Sep 2022 17:35:47 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id s206so3304618pgs.3;
        Fri, 02 Sep 2022 17:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=pJHpU+JAyxyZ/u70WTOXCHFhmhx4G3xxzhg3HwNg+oc=;
        b=O57FWJmu2qNX2Z5iRzdW/Y1H8jdPzTd6yYVyaVMipu85X0GSoKEnrVNkbKNYQ5YL9m
         Iu7ff0DPa3kzO+mMgepbqRG0zoCscZ4+TehIXwnsl0R52zleTzn/1CoSQLVyACj57Tx7
         emNKAOjehELWjS3s0WWOhCjNJeZ4Sig86EqfBYwBXXfOYT/z73mTctybeEX9Osk68yQ3
         Urz1/+ApvY8zsjNdo5u07+XI5GUMEqDMXfbGeOwzhD2A+6FWp+sMWd5v4UReGKH/U687
         /J+ga4KEALXJHsNEGvnXYZH6kywBhT1OsBjzciy7RHDxZ7C9n3SbbFJYvbFhBXhYACrO
         bORA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=pJHpU+JAyxyZ/u70WTOXCHFhmhx4G3xxzhg3HwNg+oc=;
        b=ES7VksG/O5/5GGVCaDkAdxVE9dcLXCBPZhk8Ow7jmyiEGTcbGM8DmF8UGJp0eIPqS/
         gJAi5yGLMWmZNGRHY0vCa7nyO/MnMTLMDWyo7HSTNiyK9tzgGCFtIpsoHeSfpR+fim8a
         BOdyZ3B6RifOPS0YEW/FfOjQa0uxxGTU91Cup8G47KiRJ1ykjbzDCTBJnElgNxc/AG0a
         BzmlU5Euyt5yCsslGY+N8yDmT+4ET70yn2hSqLNxVHDGzxBloFqmJXp9hk6gE1GrNsVl
         6BTR7ATlgHJYLNYyGK7A+38Tkk9+PT0x2P3winnFEv4+/c4CTH6KsRTA4OkXHC5XdjJo
         YOEw==
X-Gm-Message-State: ACgBeo1cpJaw8WcXeTwIz02JbxPkIu2UDQXfXnilPjU5UyrZsUSLg/z5
        hTl6vfj6Oiq2dlJ/ert3JTc=
X-Google-Smtp-Source: AA6agR7Z97tJnHLdYy0U4nZFAnIZ5dQAahsmr/z4/ilTP7AtMgOxFWWBgpNTXnTRoxWXyTz3Z/Oo3Q==
X-Received: by 2002:aa7:88c4:0:b0:538:4308:fe99 with SMTP id k4-20020aa788c4000000b005384308fe99mr26849895pff.74.1662165347067;
        Fri, 02 Sep 2022 17:35:47 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h76-20020a62834f000000b005385555e647sm2425777pfe.155.2022.09.02.17.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 17:35:46 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 2 Sep 2022 17:35:45 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/77] 5.4.212-rc1 review
Message-ID: <20220903003545.GD847372@roeck-us.net>
References: <20220902121403.569927325@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902121403.569927325@linuxfoundation.org>
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

On Fri, Sep 02, 2022 at 02:18:09PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.212 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 446 pass: 446 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
