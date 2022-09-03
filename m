Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1F645ABBD7
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 02:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiICAeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 20:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiICAea (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 20:34:30 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28557A1A3;
        Fri,  2 Sep 2022 17:34:29 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id l3so3332962plb.10;
        Fri, 02 Sep 2022 17:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=A+rdY+/HIFxMsYQnafcVE64D86S78IFqsd6Y1LJws4I=;
        b=f/mBEYrJ0VOnRQm4h6VkA+dewTUyIo2gSoqe1kyvow1s+wxA2KI86r5b2OqSUMcX5y
         /1n8Jcs/vknDB/GcIQ0+ihB4+y16j/aXTbwatbBrJAjqihRhRFMRTgqn2RkUcdXaPNli
         ppi6eKeLKkl19i5cT6eJthEuqk2FSh3WgcQ+FeDZkN9SEcIuFgRSDC5Ym9jWwX3Y6UWp
         7yyQkIDofz7TISTfIDhzHzf5wFn12Q++c0pghBjAb9g/CeqB9N1Bc3DpgwIsjSAVIPB3
         09rmSGCzqvXZ7jjmAVu92EArEJWITeP+grdbQfjeeo061k7A6hwU3smYrVmzc5KwB21K
         tEZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=A+rdY+/HIFxMsYQnafcVE64D86S78IFqsd6Y1LJws4I=;
        b=nKaP7MnDQE8WhA6D3Om1HYW6eUoCs3J9jmxBXJU9U5Sgmb0ZCzG4cKc7oqbC6fFk9x
         M8NKxH4j6d2BMsRKEtxOzuTkY7l9K8N9mIn/HpG/OhaYdlLFtcAFbhEIl1mBJBrSYKM2
         zgBgBlPqlu2v5HDJWJjuxsjiNZ0/MvR0ctkiCEzjUqMAD0MZsXRM6DHONTXtsatr9qeS
         65WL31sMh4ydTE6gvhy7KfKU3PjqVVPGaIdutlCVFSRLwL2M9LuOG/xZ7Fj/FHizlgga
         LAvt0upVpBNKbC3DhwqsIL8bsXwzYRNi3ftN6M2MSDR0h7aGuBYpWglDx9jFyFZjq3T5
         DS9A==
X-Gm-Message-State: ACgBeo3QFDPOEAhOwrBzlZx1PKqK/0b3FTqaU0JPMK5paUrNRPyCkY1n
        5TfFjTGGhPHpRhu0t/BEZTu/m47WEJW5sw==
X-Google-Smtp-Source: AA6agR4h3q/CejZAoKRvYPs3Oa+t53Prmaa+H6qSA/JgoZDStn0CV4Az0IcaMQZSVNyhIHXlFp/kyw==
X-Received: by 2002:a17:902:7803:b0:172:c13a:fd9b with SMTP id p3-20020a170902780300b00172c13afd9bmr37788695pll.86.1662165268576;
        Fri, 02 Sep 2022 17:34:28 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h3-20020a170902680300b001714fa07b74sm2273390plk.108.2022.09.02.17.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 17:34:27 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 2 Sep 2022 17:34:26 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 00/31] 4.9.327-rc1 review
Message-ID: <20220903003426.GA847372@roeck-us.net>
References: <20220902121356.732130937@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902121356.732130937@linuxfoundation.org>
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

On Fri, Sep 02, 2022 at 02:18:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.327 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 164 pass: 164 fail: 0
Qemu test results:
	total: 394 pass: 394 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
