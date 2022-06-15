Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13FF54C248
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 08:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245722AbiFOG7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 02:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243415AbiFOG7E (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 02:59:04 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF97D201A8;
        Tue, 14 Jun 2022 23:59:03 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id t3-20020a17090a510300b001ea87ef9a3dso1162598pjh.4;
        Tue, 14 Jun 2022 23:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RBmiguKlQOVHhlhpHecbbvd+lo03Xw4Rz70AEQGk6+w=;
        b=L4c9huHLocK1dM6bt9+m/dmyNBhJlcWy1/DMtsye9uUiG320uGdiWuSYDWLZ5s7VBB
         3LUgxcVlsF/pOwqOSRxcijy1mUm6aoBb6AsiMjKOeiYE+6DIOSasnhCPyScpx6FjJmr3
         MchLk4cSSoTfDL5/deOH+0OX1JZmrwgJngBZH3jXF564qc0poYgSLHiPnI1SsOPtx5qT
         q2Xk84pusx324m7vVvJiNjxaQtA0l74f+3FmuHlzbb0WjbZgmzQsLolXzgZsER1ZMhQP
         tPv7cFhx0sbTBkWtu2YW/KEuqJSwya3bVFL7ybcGubgJTLFCUv67YdPh3G4u0ofZoBB3
         ha3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RBmiguKlQOVHhlhpHecbbvd+lo03Xw4Rz70AEQGk6+w=;
        b=kHetdDuKS1YePWXutYeef5wGlfxp1L9HtYR4Ma5FDHVvVcERNrBXfp8inz2BpbUGL/
         okpMmrqU+PtqyfkepMH4G5a1Jh68b4eLRRcuwdHkmTX6kXkg9SO2bPe002IYgdywU9Wo
         F3DMLOXIHbS2vGjrKK71IBWlbFYUEhCZgBGe3/v0zFMNmQ1jCdYkkXolrP1QhLt1lU5B
         yMRYseO/J5hk8zp091RklLAx4YfAngTrIPydLUYl1RG6T2he+onFHyc1yH/aIvJVN/iO
         B/JEp8Bf+27qoWUqCDlo4VjhDaC48YHrDhP2TV+7kXEe1qMcJXD31tiXuzPhfg9n6EYF
         EpTA==
X-Gm-Message-State: AJIora+AYHIq7yhuMMWmpc8/iTtEBjwNRKz9kpXZeeez+LDcIQ3QuzWQ
        zGS+IaA+fmn6ocxIKP/LR18Vkcda1Chd+Q==
X-Google-Smtp-Source: ABdhPJzisz0ODI5us82LsjLmcrXqUii3I1Frb0jEbYB5moXtjrNo7r6RbUMu59HWL2rvCHMQZMgjvw==
X-Received: by 2002:a17:902:f815:b0:163:c524:e475 with SMTP id ix21-20020a170902f81500b00163c524e475mr8101980plb.37.1655276343309;
        Tue, 14 Jun 2022 23:59:03 -0700 (PDT)
Received: from localhost (subs03-180-214-233-79.three.co.id. [180.214.233.79])
        by smtp.gmail.com with ESMTPSA id a8-20020a17090a6d8800b001e2ee0a9ac6sm851219pjk.44.2022.06.14.23.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 23:59:02 -0700 (PDT)
Date:   Wed, 15 Jun 2022 13:59:00 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 00/11] 5.18.5-rc1 review
Message-ID: <YqmDNA7RhsCaqdz8@debian.me>
References: <20220614183720.861582392@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220614183720.861582392@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 14, 2022 at 08:40:37PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.5 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Successfully cross-compiled for arm (multi_v7_defconfig, GCC 12.1.0,
ARMv7 with neon FPU) and arm64 (bcm2711_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
