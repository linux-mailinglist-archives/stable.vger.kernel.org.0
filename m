Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9677E54D42C
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 00:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349805AbiFOWDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 18:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350415AbiFOWDX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 18:03:23 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738C34DF72;
        Wed, 15 Jun 2022 15:03:22 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id q140so12608189pgq.6;
        Wed, 15 Jun 2022 15:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HpXht2vQUs3891kb2gEFNTl2qxZrtdW1HL09+GLamKs=;
        b=b6usFECoIqxszCYBV17tDNHXQanks3Gqhlx0lPraVnKdVYiUPAgCbPQsKkyFddFDU3
         XoURpJtuOka+ZMswQ4As3oRju8l+iyiqUezSDhZ3oEaYZ9VgsPQiKnC2Hs1fd660MFJh
         5675XcPANX8iuvzihuFqv8NaCPLDLWIuTK5DnvGLEBdmUUIenqAufUQqIJ1zdg+XiOUv
         J+Y8TdGTOGk0qDcpub2zovIOxBqvHc8HZ8gULFVRpOTvsK2XFG7gOvEhvVe2k/0XJ+v2
         elrwGaRdOKJsIjTCFtcrqgi6gXw9evIDUJmP9C34NDtdb2hPT5MxJIqvIPG+5NVeQoMq
         eQHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=HpXht2vQUs3891kb2gEFNTl2qxZrtdW1HL09+GLamKs=;
        b=aF2ty18lcWFoNYzRs2UOb1f0jEQGSE1hMUqLbcw7XALRDRZUYQ6Pc9HSsGVOfHxKFl
         RgDgMdFkyqxE7KPjwBsLKnkGDwEa+GjHI/xBewXcFpUWFsl1uRFGR85/RqMFSNGSCj03
         7OvA4YoDbNjTtM1Pg55uNbRM7R2DcLE8/9cyHGQD4WULZCVasUsTZuLtTV1eroBHFPdI
         entegkJPgnttTAMq1YLXYGYEXIot60W7tctMCQm3GAx3DZxe4Un4PtNVtYULtfMTVHhe
         d/VpTmeFWtrWdurnVV5TC4H/o+znys/DkkSoTK3mdHvLPlMRX2nu8c5YkI/WEzx5ZIGo
         IcjA==
X-Gm-Message-State: AJIora+iHiQeBkG5ERHs2hBuhxX8x9iGLhMqoSIgz+JLE3+5QLrmbhY2
        sEOGBRaROvvyZlLYxBR9Lh0=
X-Google-Smtp-Source: AGRyM1vdsXQ4o1KjicGa6bAc9rkjm6fsKjvkmjhbVYHmgfcd8aqt+/v4Au4ZOsU1kBCT9GGFBJmImw==
X-Received: by 2002:a62:7cd2:0:b0:51b:9ba6:a028 with SMTP id x201-20020a627cd2000000b0051b9ba6a028mr1709596pfc.24.1655330601665;
        Wed, 15 Jun 2022 15:03:21 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id fa17-20020a17090af0d100b001eae908b67dsm155940pjb.15.2022.06.15.15.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 15:03:20 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 15 Jun 2022 15:03:19 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/11] 5.10.123-rc1 review
Message-ID: <20220615220319.GE1229939@roeck-us.net>
References: <20220614183719.878453780@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614183719.878453780@linuxfoundation.org>
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

On Tue, Jun 14, 2022 at 08:40:22PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.123 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
