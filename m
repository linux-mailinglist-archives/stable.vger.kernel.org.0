Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 554C46A15D7
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 05:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbjBXE2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 23:28:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjBXE2I (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 23:28:08 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54405240;
        Thu, 23 Feb 2023 20:27:53 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id 4so2292710ilz.6;
        Thu, 23 Feb 2023 20:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=risT/+NFrNokW9okfKt9oEpJJBiMyGhaOyPCfJWl8Fo=;
        b=YL/E3YhhslYmqMR2rs8uxQILTQWm77SfoAKJy2P1D1agRcQ2lQAsRJNuxz9ZOioi33
         NiLfTWI1OtoolRcLypxBsbDYOkhB40xhwsQxknOpYmdz+ccc7ttxonLrhNihLdG+3AW0
         hVyLArJJIGMj+VxQllCKt6l8SDZt6XTzjTj1fOqnZ2JS2DiPjxVBI5GD9Kymm05KaXCQ
         KonPqq9Yo8fntEEL3xgvEqec2Wwmul5E4ef/O2hJvYKCmhBMyMF4OTllrg73Ls+Fjbl5
         kfS3v5J+9VoX4ehbl5SFd7rInAHxAtatg5sWhu4RoIX33F+knqhGjX8GJTSyAYns6YMD
         nW8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=risT/+NFrNokW9okfKt9oEpJJBiMyGhaOyPCfJWl8Fo=;
        b=1pqyjyIRFJC9Cmdx9f4bWHjpMrie30jPhopR52ks+i7bEPzO1FjOCnMV2mxICG/Pky
         eUegAzikMKnjJkyDOdd3wuMeR9+asD0qmYlgSl644xfzSokN8Dr1lkUMDK3sDCmoypFq
         kGwSHQE3ZUWK529UzpfzZ+lROEkNeXhvnERVjBId6ATqJ2Twcn77NvzbpKu/o2AACrPr
         u6dO5NAy8QI9aGOWzSLfvtlXKMHKnAfJOUutotQuCznCls/T/md7EffhZBp3kCYDtBsg
         pu5H+rF4ZclE65BtBDTpFDTgOGy7FdLin5eOalLbBCOeXOXfS6+UYuPj3ws0PtLdWKBW
         LM1A==
X-Gm-Message-State: AO0yUKUEfFrZUWH/P1mGC1WWW06jb0djatIKInaZarmbV0MDFiY6Pvce
        YHNLce7ow4nXIUTNhEskF5E=
X-Google-Smtp-Source: AK7set9I4i9PTulcrnitqIM1/8bjmoNAOfnMLI4JRwl9pjBP86zab7XPyO07E5rQq3O7om9HeV4Hcg==
X-Received: by 2002:a92:7510:0:b0:316:e941:24e3 with SMTP id q16-20020a927510000000b00316e94124e3mr4829083ilc.24.1677212873010;
        Thu, 23 Feb 2023 20:27:53 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u14-20020a02aa8e000000b0037477c3d04asm2588456jai.130.2023.02.23.20.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 20:27:52 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 23 Feb 2023 20:27:51 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/12] 4.19.274-rc2 review
Message-ID: <20230224042751.GA1354431@roeck-us.net>
References: <20230223141538.102388120@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223141538.102388120@linuxfoundation.org>
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

On Thu, Feb 23, 2023 at 03:15:58PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.274 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 426 pass: 426 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
