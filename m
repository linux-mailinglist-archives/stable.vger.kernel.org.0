Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D460355A4EA
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 01:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbiFXXfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 19:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbiFXXfw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 19:35:52 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F028D857B7;
        Fri, 24 Jun 2022 16:35:50 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id cv13so4085389pjb.4;
        Fri, 24 Jun 2022 16:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OE2guk39Iwc6Qn+wIMrx7BPfba1qmkxLP78goDICeU4=;
        b=DYpOpv89o9uorxcC2340OgH+v4Qwiv2LzTsAfu6Bfl0djdjX9E8UwUEz445axPm6nY
         5v+Ba4VqNLg8JD38YvJuKSv0YqlPqOPCFV+yCCM4SP+/hgL1ZuNle+b25QggsYDtpsYS
         Ztw75EL4LyFzGes+Ss6+zjqG39EUCmriB0jcjzJCOdHC6LwTDE2yJV7te5GCxVW1ZZO2
         fgE5nSue6O/Vmen5wXwwrzH1dXJwfPWrGax3Xs33GFLWwBTl7Fh848CudZKmi5byb3lF
         RkgIZx54OvnPSnDP57eMOyxZqZZW4Cwx61x5Nq0VmOxc31EvEIE5sk4DpAtb2cuW8M3S
         qrdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=OE2guk39Iwc6Qn+wIMrx7BPfba1qmkxLP78goDICeU4=;
        b=nCh0MGYptW0HpGWdCoHCI0rdW9FvhOFDxls5lj/Eli01KFBdb35AjeW/Moagn6QWon
         KpeAbEszGDtQgy4aNmXC7pu/YM8IUjSO0jlhya0Y41+gmxqAXlAP+l1ODMCeHp/81R4Y
         YpeYLD3eaa26sFPuKrHfUqzgFR4PNx0200W/U8yx3ZoCdcTJA00a1CVMRVWyotqx0AIW
         ztJtmdOEZaZhKz0/9hfdCl0WaLqNXmx6fOsWl7V6Gd9c0y9kbds+zicqUQPS/IoqU0mJ
         XmLjO0s98wuoIn1wHIunJ9GvLOXhZDiAi2O7p7P83rX33TVzdT1yPGg877ilFris6gH5
         qJBQ==
X-Gm-Message-State: AJIora/0EeTtCizpZjKuQwOIIYPI/Cbk9AtDLb6C1RsLuH00o8Z2CUb1
        o+1N2mErR140lC0vf6oU3lg=
X-Google-Smtp-Source: AGRyM1vD+KSneQVD56CtCbSTDfG/cvo+iRINY/HbFZCG/UtFTdYn3Hdp6Drl/UEzP90OEtabocQziw==
X-Received: by 2002:a17:90b:4acb:b0:1ed:fef:5657 with SMTP id mh11-20020a17090b4acb00b001ed0fef5657mr6577690pjb.142.1656113750475;
        Fri, 24 Jun 2022 16:35:50 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 67-20020a630946000000b00405306de2c2sm2127065pgj.65.2022.06.24.16.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 16:35:49 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 24 Jun 2022 16:35:48 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 0/9] 5.15.50-rc1 review
Message-ID: <20220624233548.GF3341529@roeck-us.net>
References: <20220623164322.288837280@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623164322.288837280@linuxfoundation.org>
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

On Thu, Jun 23, 2022 at 06:44:43PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.50 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
