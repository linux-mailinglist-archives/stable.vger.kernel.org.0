Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68044595AEC
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 13:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233380AbiHPLzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 07:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234875AbiHPLzA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 07:55:00 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D550233E24;
        Tue, 16 Aug 2022 04:34:09 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id h28so9081316pfq.11;
        Tue, 16 Aug 2022 04:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=hOaorKIBjJgqQCTYy4uwngH9aexUVaWig1LTjcqZICE=;
        b=jgi3MlyGRuZU0sGKK67DR+ftEmeqdLT017xvKjrTgWcDC44lWgbkwpPCE0CAwm7hFh
         lDlcoo3GuOMyt5y4nAzsfDx/0Lt9vrHQSbnsuiKLAfKbvCyrfOE6imrTJld1pfSqC1BJ
         uwr6FahbmRyeaC5jokmFRQFJ7MV7qtm0/lXZomIlul78Xm/+NgPxmPjSBkKCJ2dnrTVz
         vSy2/vaGRt++ppwZBuYw7bJlXcYBKy5I3r4fku6fee5z8HHFgWIC+bLE2/iu00eQL/uD
         egXY6VmTrZOz1dx64VMlrQJV3WaCW1s7927q5J4GXsymGszJoKD/v6x16nta7GQXisDG
         dyGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=hOaorKIBjJgqQCTYy4uwngH9aexUVaWig1LTjcqZICE=;
        b=RBToTnWMz0aP3HLZ3XZBYyY+MW571ybOpbAyn2qd4osorDjX3ozgeP7xnJUzONkm8N
         q/hHLAB6X5dKOAr7SQItQIJIsMkIXO1OGqEK5/6fgyDBYaYnNb7DvxW/vSLKVAqnYABJ
         04dVTb2SiMclbixOiUhu2UlY3JyJJ4uS3hyvU33Py24FtYxFiGQCDFWH4adF8JwQkRkl
         oupaSqYj9/5G+Fs9Gpa5PTbLurlDLkJIpVvm6DSY0m8xkePzaIdfUdYywtqZYf6hUUHK
         QeBzO5YAdut34481pFFCPErPh+Fm5a1Wv+vsU/zu9nnWy5UpDdhEiUGKy9WyWqQgrAcW
         ivJg==
X-Gm-Message-State: ACgBeo3DwgzWufV0MUKIYI9Wtr2E6vBVBWEtlzfe0Egfkpvmkmo5grdu
        DVB+/LBDLUfDrnzAuJegvyc=
X-Google-Smtp-Source: AA6agR44EcjSp1Z2nU/bfFkaSdYaV9nSLPoWvXPvyVGF+6/JAbvgpVfZQFY6QUKttAk7UnLTN9dEUA==
X-Received: by 2002:a63:e109:0:b0:419:c3bc:b89 with SMTP id z9-20020a63e109000000b00419c3bc0b89mr17435298pgh.176.1660649649368;
        Tue, 16 Aug 2022 04:34:09 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a15-20020a1709027e4f00b0016d72804664sm8776994pln.205.2022.08.16.04.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 04:34:08 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 16 Aug 2022 04:34:07 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/779] 5.15.61-rc1 review
Message-ID: <20220816113407.GA1809610@roeck-us.net>
References: <20220815180337.130757997@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
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

On Mon, Aug 15, 2022 at 07:54:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.61 release.
> There are 779 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Aug 2022 18:01:29 +0000.
> Anything received after that time might be too late.
> 

Building powerpc:ppc32_allmodconfig ... failed
Building powerpc:ppc6xx_defconfig ... failed
--------------
Error log:
arch/powerpc/sysdev/fsl_pci.c: In function 'fsl_add_bridge':
arch/powerpc/sysdev/fsl_pci.c:601:39: error: 'PCI_CLASS_BRIDGE_PCI_NORMAL' undeclared

This affects v5.15.y and earlier branches. Several patches
would be needded to make this work. In mainline:

0c551abfa004 powerpc/fsl-pci: Fix Class Code of PCIe Root Port
113fe88eed53 powerpc: Don't include asm/setup.h in asm/machdep.h
e6f6390ab7b9 powerpc: Add missing headers
904b10fb189c PCI: Add defines for normal and subtractive PCI bridges

There may be others since the patches touch several files, and it seems
quite unlikely that they all apply to older kernels. It may be easier
to define PCI_CLASS_BRIDGE_PCI_NORMAL locally.

Guenter
