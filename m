Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048C15689EB
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 15:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbiGFNpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 09:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiGFNpa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 09:45:30 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06186DEF2;
        Wed,  6 Jul 2022 06:45:30 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id y18so5681726plb.2;
        Wed, 06 Jul 2022 06:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WGK72/7vTRIwJjdJ6LotEDrq9vkC4rTRXJEC2hraLP4=;
        b=CS4WoZUm4U/XQ5RNSzueixz7iZe2c314g+4XWXUrGcN6KX0DxBNbB6y0vGUUHtGrD0
         48o9I/gbjCzmYJH4Ah0I/XTm7LhijEzgCz86jviuDkjDcbZs2NOlDlRhbhdHr0aal3oA
         I1OJZ1xOwWjUYyIOXauE7THr8puBD9Vw3H+9/fHe/d32YGzSZEfe7FaUYDpToeVwAky1
         oCq5s2xTCf9SWT9nYLJI5n1WOW2J1R5J4vh/zHOPCMMKOriB/A7pxXEmLgQXfBPFWn6f
         rP9Fah2jFx2D4a2yUDj5HPqbdxyOXtyZMMf0ACgOFJhlWnpDo1UD1OuDZga2blLbbvCr
         ByAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=WGK72/7vTRIwJjdJ6LotEDrq9vkC4rTRXJEC2hraLP4=;
        b=I+mfyB+p8J+xgXYI0bembtdCOOAOux1EJQtRyKvcTIJi0q46r0+iNQEEivbsLBGvx6
         4BBdjttLRm1TzLYyT/mlER1sqj4tneMHh5L9dUpZ5braO+iKB+2F47CBV6f/KNLYYU2w
         pc//FT5fJDX9h3lvw+bvksDrQBJbgwY5ic2Dio+6e3Q+3xsuO4iMWIJ4uLcR1WdIruIx
         F+ORJcYm4/RuVqxclp+RhRNZ/634lqappdKcHr4O2q+jhzP+LdOUCjTm4bcOTSTvp5VU
         Mal5+4QnJlDsZNYFQf7V3Wv2foUpF4kpQmI1ZfHHom1923tis41Cpc6FasLSylj0yhUh
         MydA==
X-Gm-Message-State: AJIora/aVOnlZ9tN/UUFW5/vbnp9mmLaYmmgUMaOVs2GtrqPDdb79k6P
        RCQLPZVgkBv+tV4hCRqvQ7E=
X-Google-Smtp-Source: AGRyM1sO4XUsCPhbyifU9JkP52tlZ2ZJK9eNyJ5xWoG96A+0VOMC4YO7FgnOrZy9AeUqSI+64g8bGw==
X-Received: by 2002:a17:902:aa05:b0:16a:5113:229d with SMTP id be5-20020a170902aa0500b0016a5113229dmr47184746plb.111.1657115129554;
        Wed, 06 Jul 2022 06:45:29 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id be9-20020a056a001f0900b005251fff13dfsm24622020pfb.155.2022.07.06.06.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 06:45:29 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 6 Jul 2022 06:45:28 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 000/102] 5.18.10-rc1 review
Message-ID: <20220706134528.GG769692@roeck-us.net>
References: <20220705115618.410217782@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
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

On Tue, Jul 05, 2022 at 01:57:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.10 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
