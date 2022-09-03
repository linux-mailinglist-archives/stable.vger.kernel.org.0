Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13BB05ABBE9
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 02:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiICAo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 20:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiICAo1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 20:44:27 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15285F7F;
        Fri,  2 Sep 2022 17:44:23 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-11e7e0a63e2so8815387fac.4;
        Fri, 02 Sep 2022 17:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=jEzcKz6FKmdXeF28nUatQbqM8KhBDWatkvEgSRjOY/I=;
        b=o/YuoRjVc6z+7Y3M/g5dhJduek8Wh5+hETo7wPipy9hmDuMbHs+QP19GUdcmkUgatY
         ppEhzykxz63Mz6TKTzQ8R70ZlCdJLZQW5kUH8dbuomVXfLvk0nmbAcQUmGYHoHYilDH+
         73dYBLSNS90MrFdTioGt7qGthWVIJGMKrnjZh60+tqlLMZkx5fG8XVndmPRBHTzoNFUo
         1BZL4y0R3W3Tt4S7T8AjJXa9fYFXdHSPbmre2TsAx6b78D1VDkTg2aprKR5OPRLnoE55
         cp2LIouYCOEmHKh1U+4yMecgJ+yaKnsvfsne5gFfcjx176aqMyME/o4IgWpo2QzZ+nov
         +Ajg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=jEzcKz6FKmdXeF28nUatQbqM8KhBDWatkvEgSRjOY/I=;
        b=Bd4jnKOixchS7IkjMBEDkpdGl0ymHucpgE35Y6Po2eG21DssRMprKZiyZWLeSEhkC9
         vcTfJPhMTvlbPm/qxfuSivXQn16gle1Olmg44FxB6igs8hGxxEcwyH0Au25ogob0IKMD
         2Mjm1sSWie/E7Myj67Uj53d5XC2YrlXxL/M5MHP/2XfzWy9g1lm+3FAGFMDrCKJLX2Xq
         ZIhW97oFnqO3GqlZUqQawId4/bZmVvcn0O2Jqabc2XrARnud5NHP+GkLpPvn6CmLbF3i
         m7bTDZ268KmC8bgihSxrFmkr2JEsJ/Xk5o0Us50nMcAgFwOkEUTz+erJvX6O9A3q8fW2
         r29w==
X-Gm-Message-State: ACgBeo3hs+9kXDhwJMbiezZkerwRZfalUu4ESOz6wPd/s7C2pHBAea56
        Rf5kWcpPrP3y7v8VPQXkKlXakAngbnSrrg==
X-Google-Smtp-Source: AA6agR4afCAT0SW/SvmJecwsIz03DcjSZYYUY7myGaqdf9pPIohN4Mgqr3XJ1ke6OUSr7DCMXu5S8w==
X-Received: by 2002:a17:90a:d685:b0:1fb:2d31:84fa with SMTP id x5-20020a17090ad68500b001fb2d3184famr7605198pju.51.1662165319527;
        Fri, 02 Sep 2022 17:35:19 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d16-20020a170902ced000b00174f7d10a03sm2255065plg.86.2022.09.02.17.35.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 17:35:18 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 2 Sep 2022 17:35:18 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/56] 4.19.257-rc1 review
Message-ID: <20220903003518.GC847372@roeck-us.net>
References: <20220902121400.219861128@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902121400.219861128@linuxfoundation.org>
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

On Fri, Sep 02, 2022 at 02:18:20PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.257 release.
> There are 56 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 422 pass: 422 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
