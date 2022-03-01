Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD32E4C940A
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 20:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbiCATOt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 14:14:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232383AbiCATOs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 14:14:48 -0500
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90D35F4EC;
        Tue,  1 Mar 2022 11:14:06 -0800 (PST)
Received: by mail-oo1-xc30.google.com with SMTP id n5-20020a4a9545000000b0031d45a442feso15945643ooi.3;
        Tue, 01 Mar 2022 11:14:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VAOlnVCrC0B/Wyg87h2kzfQClf/5sYgTOIdLOnoGhk0=;
        b=jCXL0QZZDNOlJ86DPp+iFDWOT1BxsZS2peGuxVdfMWbscFbuqvxKUuF9xIKlJ3em51
         y8PxXv1wv2sIbxuYAkbRMG4/0QwG+bXR7pQN+ajwUNA/BwAYlNXlk2tWP+1Fs2xwepeb
         zpGhWhcnee530fb3RiydeSY82mfXVX+jNse89M74svViBQfCBsMscsiF9XiHsdwcYaw3
         +i5dYgEbHaTPxVxR+a8g+yC+v3vUgoPRaPXzybU935Q5t7h5F9PXvjZg7O7xfEySz/wn
         CD/YhI5YMz0qCUH++S547pNHrIHyhQJtti/70JF+zHTeyMXhG2aKPBvlsczEUdJfX+Y6
         GsQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=VAOlnVCrC0B/Wyg87h2kzfQClf/5sYgTOIdLOnoGhk0=;
        b=JTPeVkcWBT7dtKHiDySbvlQbbrOvUGfHPbRDnPBLHvTF575P+vFhjb8hNHXWePm0Xu
         uXRGkdl/a2NtBXEVkTlDolvR/8ojUKoOPUUnbfhJxtWHI2fAeZAot3pw7jBB7ZSX94Lu
         LedMgBAqhsC+KUIRCMsrwe3amy9ISWmCTpaVtDXXJWWUfNwX9pWyyn+apySjxT7jtque
         SAkQCPd2WQ9CvJqLdvca8NE9UH+EApW9g1CFp1gNrcDXt1aOeGyLxzWpb5kLp3MvOsZa
         pMQhrSARDR+nxkOVP0CaCeVeYMUgV8+AuhYumlmOJtCsePCVyWqUCxK+ZKdIcRPs33rK
         K6/Q==
X-Gm-Message-State: AOAM531x9qNr//4XNCjDJ8l7ZZnFG6hpY1FyBPSTpssNyozatIDeVcl1
        o6+wlBNwqTqgxONGsU+0+WE=
X-Google-Smtp-Source: ABdhPJzMobnuYdqNQPYY5hJXLsJZrPe4mumoMnS+ZjH2tTf96Jh4sxlGvCGlZvXDP0qzmIw4aJUn2g==
X-Received: by 2002:a05:6871:430e:b0:d7:649:9bd3 with SMTP id lu14-20020a056871430e00b000d706499bd3mr4918920oab.83.1646162046129;
        Tue, 01 Mar 2022 11:14:06 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 62-20020a4a1d41000000b0031bf4df25a8sm6583529oog.8.2022.03.01.11.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 11:14:05 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 1 Mar 2022 11:14:04 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/80] 5.10.103-rc1 review
Message-ID: <20220301191404.GB607121@roeck-us.net>
References: <20220228172311.789892158@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228172311.789892158@linuxfoundation.org>
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

On Mon, Feb 28, 2022 at 06:23:41PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.103 release.  There
> are 80 patches in this series, all will be posted as a response to this one.
> If anyone has any issues with these being applied, please let me know.
> 
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.  Anything
> received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
