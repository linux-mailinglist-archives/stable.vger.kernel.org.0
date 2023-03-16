Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE51E6BDC1B
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 23:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjCPWzf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 18:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbjCPWze (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 18:55:34 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D1187432B;
        Thu, 16 Mar 2023 15:55:33 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id o14so1526977ioa.3;
        Thu, 16 Mar 2023 15:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679007332;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eDoNPNSvCvWDPYoA/srdpUYBFvbU7h2PPJVATdm4bHo=;
        b=c66hNh6wWkpzOJfE/gMO1vvAOmhXLq6K7ldim2HJsFOahRQQQduvRD5Z0RA5GRB2wU
         nAKp7CAc42fE+5fuzbNy4Bj+6ehMPm4DG7DVuxRg5qdiVGfd0UJPeAF7dePLezXwExMY
         zRGxB7DU+IafmgvR1GTFrB6bi3E2PYrMNB7+0PsDyxCBgZHykhU3S7Yci2xKilc7/PdY
         6J3+Czd+1W0YQStLSpracL0NMCQ5WRBYPXjt19NpJsmOA0p9mU2WjZ6MLYT1MKkQ1ymy
         hru/83CtpQTlcM8TY6qakijb2Ce+RKb9X+da+U6NnkZHR0mrOeekUuNgyPFztDVi4Gbr
         qA8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679007332;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eDoNPNSvCvWDPYoA/srdpUYBFvbU7h2PPJVATdm4bHo=;
        b=0XHKGRTALjVz0II1quy+/FiJqYVqNC2RqAhana8SoFP7hAYVBNaqoKm0ju+9we1tQq
         0fPX5DsGzQ9hZfEYVjuUVvslaa0HpvPsbPQwb/GB11UXfZV/b5WvsatGfRp9/sv6M8o0
         QHPyeoQfubJn/f8mDCD1XHnE1JRhvXUS6VSiODAsRaAS3zA6utXA3LK+vTRdIBOof6IC
         Frmdx23NgBeFAnnR3L2oB+BR6eVCGEn/dj3GoMjn/ViGa1G3W8ryAoW2uhno8KNBWwsz
         Kct+wcQKj75fqv9ohjqfwbz9Vain1BrD4+gs87ggNZE3bDy9YPxcNe2HuaDkXQe/FdKC
         eOvg==
X-Gm-Message-State: AO0yUKXHd/oe4GwOpst0N+R0EqejETVW2LRhqUrDjYVD1yxcHsuDR/Da
        Ulm0MAfDfHYHN39iKr8pb28=
X-Google-Smtp-Source: AK7set9x0A+WMA2AqHiC4ywrzlKilO5aU96FNpktqHHI9t+4QNvfUJT56hDhnbP8ss+bFE2rkN/FRA==
X-Received: by 2002:a5e:8407:0:b0:74c:8f71:dde7 with SMTP id h7-20020a5e8407000000b0074c8f71dde7mr361001ioj.19.1679007332423;
        Thu, 16 Mar 2023 15:55:32 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q54-20020a056638347600b003c41434babdsm170708jav.92.2023.03.16.15.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 15:55:32 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 16 Mar 2023 15:55:30 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/137] 6.2.7-rc2 review
Message-ID: <eef22eab-ea45-4987-8efd-ac084aa8b594@roeck-us.net>
References: <20230316083443.733397152@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316083443.733397152@linuxfoundation.org>
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

On Thu, Mar 16, 2023 at 09:50:31AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.7 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 517 pass: 517 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
