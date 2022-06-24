Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B38395596AF
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 11:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbiFXJZl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 05:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231938AbiFXJZj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 05:25:39 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8FB6F4AE;
        Fri, 24 Jun 2022 02:25:36 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id p3-20020a17090a428300b001ec865eb4a2so5191569pjg.3;
        Fri, 24 Jun 2022 02:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eODU9lFhn8L26gItrHbuboDP7iIqtpsyCSr6djIp9gI=;
        b=RJWCxgga3TaFrqa74Xh7hYyFB2PpEF3Z9kmuaoY+NV/+TY4lryrt3peJyz64LSjEeL
         JxG5304m5YeMqPsiBu4jldgeMOtgY/vSSglkifJpMAELmy7bmBEHJcK5yIgIDsVCjvjr
         iMR+cZ8dQarbzTslDvydZeG8g57GKIETfF6LBOHGYCg3EpPUS+AuZ5N2/ml1FKfJ3j6y
         as0I0fUO9ENd5VMOHflzkBpidmWLVz+MRIhf1JgAQkj3MYp2DTxoqpVBCiUXAuLGdbYa
         IuHYLdcFy8u3CfrR5usLQe9pQi4WmR230IBtW7k0AXqJ5CsyjiBZB6cOBqnM6zEVYlCw
         NgzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eODU9lFhn8L26gItrHbuboDP7iIqtpsyCSr6djIp9gI=;
        b=fPKHvCxnCRu+DLT40qV5CExw1zT3xe4TGQHCMVoDG0Gi62QEYlqRTdV6aDk9n0a7KV
         /O8aHPYR9hjkHD9Krvzpr9TINVkCJNqZeJz4HzmDoCK11KKvJ4u5uJiElIJlaQ0N3xvH
         O8oznJf3ZyJFsmZvWalP/g+vG89kcvSZopkT1XF877jXG9Y7tDaawSFPa8XCcI9vFq1O
         oxT9qToTiGfKUpOjo9nX8MWMElBQRbCWvD6pKBTnm2vz2evUUIeHVUrsrWj3etJ09+v5
         3iacNa/OXYL4/pz9ShAewUlMBo6Mg/nIWQD1NOMeVqAlewKpNOHMk2py1wdfynH1JkzE
         twCw==
X-Gm-Message-State: AJIora/K7ufwyAtISoj6UZo+ijlLEiBcxMD6fJz020xNCjshWLF5nT+r
        A2ze/o509IFf0AvHfEs2xx0=
X-Google-Smtp-Source: AGRyM1vpZAnswca8oxJp33Lq2W07brpgiYFDAyYyYXzCit3X5n0aKPdqdtqKGX6eAICJO/UkqLWIKA==
X-Received: by 2002:a17:902:76c1:b0:167:6ef7:dab4 with SMTP id j1-20020a17090276c100b001676ef7dab4mr42239836plt.146.1656062735708;
        Fri, 24 Jun 2022 02:25:35 -0700 (PDT)
Received: from debian.me (subs28-116-206-12-59.three.co.id. [116.206.12.59])
        by smtp.gmail.com with ESMTPSA id n8-20020a17090a394800b001e85f38bc79sm3499368pjf.41.2022.06.24.02.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 02:25:35 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 004E71038E1; Fri, 24 Jun 2022 16:25:28 +0700 (WIB)
Date:   Fri, 24 Jun 2022 16:25:27 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 00/11] 5.18.7-rc1 review
Message-ID: <YrWDB6ryTJ6iv6f8@debian.me>
References: <20220623164322.315085512@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220623164322.315085512@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 23, 2022 at 06:45:12PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.7 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm (multi_v7_defconfig, GCC 12.1.0,
armv7 with neon FPU) and arm64 (bcm2711_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
