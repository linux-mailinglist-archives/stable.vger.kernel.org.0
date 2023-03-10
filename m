Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7018B6B527F
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 22:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbjCJVEN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 16:04:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231639AbjCJVD5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 16:03:57 -0500
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A9F1C7EE;
        Fri, 10 Mar 2023 13:03:48 -0800 (PST)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-1755e639b65so7289029fac.3;
        Fri, 10 Mar 2023 13:03:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678482227;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wfmqX3V1ZCMWpCaHCjTnFuP7SeP5Oijt1dgEqyxc0ec=;
        b=Tohs15PHiP3AGywZuBUeePIxJNM6k6cXJPOsRCmia/nnLX8gGJU2hmmAyMktSuwV8z
         G5UPNuWhEE295VA1kW44TBxfRmlmlEvm5W6lQHSGEWSQ6c5JlqQG+/ceZPkLDuAPoC8R
         NFq3MACnCwPYF/RNZhAoIL5yQOC6MI3MGCQEVdJXiA1We8mX2Ym/qvL7BZUEDUZVo7lL
         57ylFP2lYkPau/z7rG2IfCckVfMcW1AvDER+/teP0emAAbpHUeaNkna36OxDwE5pHVYu
         sWuDcY2aXB3O6/sU7X+5VpGONcSwZkIDsuUg6W/gSI/IoLnBqKxDdHNHCt/i22GPt08Y
         fWWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678482227;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wfmqX3V1ZCMWpCaHCjTnFuP7SeP5Oijt1dgEqyxc0ec=;
        b=J7GlZGa5O2jRD9HrrhrN0/FaIBUHZcL6m6SKkj2U9mnOO9ogThrljiwzREhd8PLhJn
         c0GChlgS0zhqeU1HdOzI8ChdzjToXpeD9X05LdM4Za5mmStSdZDiHNuE1q7C2TPKqIER
         sd7liZgiTQZT6BMQjCyM/nTK53zmOFRFicqge0N9WtUXcabpNUHU40eB1et14iTDCIFB
         gRMc5+TlBPnxmnCA/vrOdue5H+K0utBHyfDaGEsan8Ig5kSjcLRX+pm2lQlDI+m2GxnW
         nAP2z0QYs46jHMSR+UKrIObx6MVgZVD2faba5RO7eWqipx9aWv8HdJVoNPMyjZO/m1Ey
         G6Vg==
X-Gm-Message-State: AO0yUKXt+Lx/2DkUty9Vqgm6tA9N3vpcml9Up8Gl3/cxWycIVbrYO0gp
        Bc7i7PjZobQoErAQ8ju6JG8=
X-Google-Smtp-Source: AK7set/1Xb/AfJoR5VcPyo6dEOREDGGhMPrBMiaN+2aTEuBNnWsl1eab75EmL9ehA0wrBF27WH7gyw==
X-Received: by 2002:a05:6870:b619:b0:176:4e22:1b9f with SMTP id cm25-20020a056870b61900b001764e221b9fmr17523813oab.24.1678482227474;
        Fri, 10 Mar 2023 13:03:47 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id ds26-20020a0568705b1a00b0017243edbe5bsm412262oab.58.2023.03.10.13.03.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 13:03:47 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 10 Mar 2023 13:03:46 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 000/193] 4.14.308-rc1 review
Message-ID: <fa9bb069-e298-4984-931d-40e151fab15e@roeck-us.net>
References: <20230310133710.926811681@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
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

On Fri, Mar 10, 2023 at 02:36:22PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.308 release.
> There are 193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
> 

s390:

arch/s390/net/bpf_jit_comp.c: In function 'bpf_jit_insn':
arch/s390/net/bpf_jit_comp.c:1122:7: error: implicit declaration of function 'nospec_uses_trampoline'

arch/s390/net/bpf_jit_comp.c:1127:4: error: implicit declaration of function 'EMIT6_PCREL_RILC'

Guenter
