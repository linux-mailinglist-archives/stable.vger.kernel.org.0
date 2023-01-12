Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 805556667F2
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 01:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235707AbjALAkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 19:40:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236151AbjALAkW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 19:40:22 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA55479F1;
        Wed, 11 Jan 2023 16:39:31 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id e205so14110769oif.11;
        Wed, 11 Jan 2023 16:39:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uw3RvlkKhUSjn7U3F/k7IOc1Tg1nh4Rqs+vIJtAUYKA=;
        b=cYangVCx1U7zVgFlFhhsN7JCHIowhA+tge8oP+Ym/boTZSUqk7eiF8lBiPvVrn32K6
         6pjI9HB+TGOnDBUKBTlyZsHFHP1PdTIE1X72gB/GVPX9I3Vz3eBZrH/5g8gUkdYPaCpB
         i+7tMd6Drty6QOMz7B2egSDX946Ka52UsJkK+yX1YOkSOY2ASuYvxD2EcaxMvq+09BcN
         /Dan6XkeM/H4ru7vtCQmOdE5U8WCntwIIewzuzehI5Q4w6eDbcY7132BLGUk/K8njCvC
         nTKDUkjwVW/yexogXpoqb1kyGZbxENSOhrf6Mjp96FgKAH2v56TT0BJzi9aXrBC210Z5
         yagg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uw3RvlkKhUSjn7U3F/k7IOc1Tg1nh4Rqs+vIJtAUYKA=;
        b=GsPkPJWU4Iuf2uKKAgOAaue+FBDdc/WyFJXl+hY3h/4eJqZJBHcyDv61B4i+x79Cp9
         bkh0EyjmT8zteffSasbd3G8xsTNhr23R1AZ1X2bZHeiwx8IZqCF1p+2PA92qVXDIVX/v
         KMfQcMaRO6H4yOH3P4mvNC6Op4LN/h068vpTsBhWmhe/a5jl5fmWRWTIVaEu56mYGpBM
         nUSVO3pYASFDdp11T/k/Pj0SXE8yCqzD/915sbzTm15fyiHswGJClRYVxxviXM3jPeZh
         MSJApBm34WWtvfGR+GEUrMhJjyhZR6Ta9vyLMjAuXri9baPTfzLodgx6GcY09pDUNdVE
         zu1Q==
X-Gm-Message-State: AFqh2kpdHjufzlU9T9V17Zdp39mvqvR9WQHUL+kgtGSG/t9fkd84pAaN
        1/eNJN11qedEZSAYWuTdPpfOGsyFBOw=
X-Google-Smtp-Source: AMrXdXviHuvmM5cC7C+C2BQTX9qM0pGn1HpXy6yzaarspSxgC7qprJlollUgHOYeLp1U68EFW8kP+g==
X-Received: by 2002:aca:1c13:0:b0:364:7618:8d1e with SMTP id c19-20020aca1c13000000b0036476188d1emr1770185oic.34.1673483970636;
        Wed, 11 Jan 2023 16:39:30 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r16-20020a0568080ab000b0035bce2a39c7sm7278029oij.21.2023.01.11.16.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 16:39:29 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 11 Jan 2023 16:39:28 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/290] 5.15.87-rc1 review
Message-ID: <20230112003928.GA1991532@roeck-us.net>
References: <20230110180031.620810905@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 10, 2023 at 07:01:32PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.87 release.
> There are 290 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
