Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F266067101C
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 02:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjARBiY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 20:38:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjARBiT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 20:38:19 -0500
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E592751C60;
        Tue, 17 Jan 2023 17:38:15 -0800 (PST)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-15f83e0fc63so540369fac.11;
        Tue, 17 Jan 2023 17:38:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yj95zSMd/dFzEvBANl5CQ2nulIJOTYnoNXUK/SwkuLw=;
        b=N67wc/sdTeD/kWurZ5iOghACMZ/UDON9JEeyhQ4J5nucfOXCEUqHtM1sf1csiY8mWh
         PJ3hDWt1SHPq8VQa0hIAB9getPRUQd72NZwrl6ZtBDJcl1e5zlap2zJonahffO2A82BC
         ZWOqPmBWN3JFDkG5FiMIuVxoU5mDGOtU8MraH/rIEgHiresAt7iz1fvgn6b6/QglRJke
         z9pC3eAGa3s3Xem34y21jvL+o7Tl43111uxu1abrk/f4Yq2ogSLgOX2roOAPNz7U/R9P
         luBz7+QVfcnR5/OFk1DPDSVs6Y0Hl2WVTG3Qot2GmexrDh+nE350ZAoV7Oqlzi0g0T9O
         K7TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yj95zSMd/dFzEvBANl5CQ2nulIJOTYnoNXUK/SwkuLw=;
        b=gYpB8rMjiWGUYVKDWQApHc3N7Ht6IkwOrupEc/tc3/r1qVDYDp5FrwRWUETRWQfIcP
         HtjFfF5VqHyXgGp+2As7/rLeOCFpjRYznJekKGG/H1ooY78OfQ0AxWxZIr/pruW+fR29
         CdM1yOyPXuXauXLMGqZsDFDHDQ7/5q/334K72F+66/C4Izo/Pcz6DXy97zarB6FSDaoM
         wx3aqGsBhZbGn8ThdLPVqHSq6ZC6y0KpRH6yZQ3C6Z4CyHYiStpccVUOk551QSlt0gPF
         c91xfPtKw79p8xmblRDQXRTEZCt2qQ7uk8oGiRPhd7W4viG+iSbEn+ppCB6OQqKRLeeI
         2Fxg==
X-Gm-Message-State: AFqh2kok0gTd4N4yVZnKVP3rWJwhCiSarmDxkjgpXbKALOQt85dDGVmm
        ciBzCZFMSPqWLrRfkW8zOAc=
X-Google-Smtp-Source: AMrXdXt4YJs7IBzCXlfyaG69wyzx6BqNCxCU3/qF6vaEjm3K2gzXk1se84EZBsc90DP9HT40auewDA==
X-Received: by 2002:a05:6870:d98b:b0:15f:a9c:de99 with SMTP id gn11-20020a056870d98b00b0015f0a9cde99mr3074374oab.32.1674005895241;
        Tue, 17 Jan 2023 17:38:15 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y34-20020a05687045a200b00143ae7d4ccesm3770238oao.45.2023.01.17.17.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 17:38:14 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 17 Jan 2023 17:38:13 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 000/477] 4.19.270-rc2 review
Message-ID: <20230118013813.GB1727121@roeck-us.net>
References: <20230117124624.496082438@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117124624.496082438@linuxfoundation.org>
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

On Tue, Jan 17, 2023 at 01:47:51PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.270 release.
> There are 477 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
