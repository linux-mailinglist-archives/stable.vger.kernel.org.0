Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAE5A697549
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 05:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbjBOETf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 23:19:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233265AbjBOETV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 23:19:21 -0500
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717D134330;
        Tue, 14 Feb 2023 20:17:30 -0800 (PST)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-16a7f5b6882so21586654fac.10;
        Tue, 14 Feb 2023 20:17:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xmVeJ55I3Amn4MeSLLrEqjAfEnFaFqqmJFVHznJhXDg=;
        b=f0JQ8yzg+FPR5y3CaNNne8QhAd3lAC+Iilmkc/1qKFQTVBnRvohkiTN/g+NPgq0Xz1
         9D/AruKAIVYyH6eQMAt3KOsjYJDlzJKisFMpwfFA3ZkKBrySd1D6r50TnpU+1DYDQMhU
         HTY/kh7NQ2N99B2VXolM/BaAF5uCePH0rJi5DR4vF3ANxwwnMU0MsrkyeLbZJ9shFQkD
         p+a3x4w9MUXBQdKGtJ+fBOhybW5arybnxQL5cC6MZL4StEjiLu2s4bkg8jB9OteGxdPg
         ANdpvz12ub8F7pCYPMzncSWFQUQe/2u6J+lT534u39ulfGTjd3B5CPSi2rXD1mEzF7IG
         ICFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xmVeJ55I3Amn4MeSLLrEqjAfEnFaFqqmJFVHznJhXDg=;
        b=Z8PSIe1yjBx/OgRApJPiJVJUnh7Gpb2i9ETa5C5UGHxMmVkJMAgOEM2CI7trASUPZV
         px4/HzYdFtzzoLcUp0OtQGXfA0npq/60d35HQukQMt3CfMMZuoh9/rcwWWDgDodC+B31
         lh0bSfVcVSpQ9Fib/IsqAAFIUy2iSK6BRHmfa5iSOzu8+KlCcQi5npcAeyGmf3Utz2cd
         07SMw4Mx8+9elGXBa2oXbn8Xw225umOSu5yU28Eauqfnev+Qz6ZXguzRhQM2L81uK5Zr
         wj7tiVPG/NSSFo5Zj/dalU63paw2+lv+WhqAINOl9H+d5ajpcGAW1PBRUQqIv5XL4Zi6
         dEWA==
X-Gm-Message-State: AO0yUKV0/0s8RRRHan8QAoRB/614BWL5EOAWdH/2lWqd2NCAS/ekaC9w
        2YvapW1mkKKltU+tMbyAGS0cfk0GNK0=
X-Google-Smtp-Source: AK7set9YxmE76VEtlEwSGDhLhrdacS37IAlGfOJedC4/nE6qBvViit+FXiWz6r49rMj3U8quEpIkWw==
X-Received: by 2002:a05:6870:20c:b0:16d:d985:3363 with SMTP id j12-20020a056870020c00b0016dd9853363mr401941oad.36.1676434639838;
        Tue, 14 Feb 2023 20:17:19 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id ds41-20020a0568705b2900b0016db8833b2dsm5181674oab.52.2023.02.14.20.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 20:17:19 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 14 Feb 2023 20:17:17 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/134] 5.10.168-rc2 review
Message-ID: <20230215041717.GA1237270@roeck-us.net>
References: <20230214172549.450713187@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230214172549.450713187@linuxfoundation.org>
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

On Tue, Feb 14, 2023 at 06:41:06PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.168 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Feb 2023 17:25:19 +0000.
> Anything received after that time might be too late.
> 

For v5.10.167-133-gf90240a:

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 478 pass: 478 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
