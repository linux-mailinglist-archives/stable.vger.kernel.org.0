Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05E7D5A628C
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 13:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiH3L4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 07:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbiH3L4a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 07:56:30 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E070C6521
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 04:56:28 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so7265849pjq.3
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 04:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=X9CW8YAhOwoOytehiYWVX/AikhedsoBMovFs0QzoOmg=;
        b=TsgU0/0bOWOVRrdyXneVObc3RrxfDqYg5hM1CTRWChk9ZPYjiBBVvd6nZftmt+zE/f
         HQfmmviEyBxCwPXq2vipCAJnwvr3bbugsdplSTxyFXd81f3iljsa8PWNWl9uiP61FJCx
         zn7ttAOb60S0rTbKyXPYxjOEurvgGelyUqluQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=X9CW8YAhOwoOytehiYWVX/AikhedsoBMovFs0QzoOmg=;
        b=Os5MWwqNz0AdM78CHmZSzOubE81scXQGscKcPMMtjq9GrsUHGqhdK6j4WN765AlGB5
         piKSXdXzqsFfCqWfv1FVnP9wmX5o9OGwAPhWTBldRopYRwHThvAcMnUK5dHxQJn3nhDf
         W2QTvc1lttuHAa1P+BJ9vmaJeIqxEM6GhTIvUFbMxBK174tu69ulxKFDtHR2YJROx+2+
         6CdAQGuioukrDSpP4Ia4VqWSNDlI6o2IeYCBoGyEzpI60DLnHBXqE+R0/o8AueRfQWBJ
         wUXobNKZdCBCKzl4RYvno6m7L3Wpp9fSRBGZjQJbmsANlQdI3/V5giy/no8BLlxAqe7M
         uvzA==
X-Gm-Message-State: ACgBeo3KXljp95Rd33zy6vVui+gIoOt55trAur/OqC90YcNsL5XjwyrI
        TVm8x15Mn6MA/52+CSxU1CsJiw==
X-Google-Smtp-Source: AA6agR4xPEavXHEOSuKBU2QTD+CkULAsUVC6EVfzYSgRRYBbSV1tLCOq5B3MjFrpu5jNzjMCbadKOQ==
X-Received: by 2002:a17:902:7689:b0:170:8b17:37f4 with SMTP id m9-20020a170902768900b001708b1737f4mr21179438pll.42.1661860587991;
        Tue, 30 Aug 2022 04:56:27 -0700 (PDT)
Received: from a1173f985c48 ([203.220.223.63])
        by smtp.gmail.com with ESMTPSA id l2-20020a17090af8c200b001f8b3f7cc16sm8601962pjd.57.2022.08.30.04.56.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 04:56:27 -0700 (PDT)
Date:   Tue, 30 Aug 2022 11:56:18 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/86] 5.10.140-rc1 review
Message-ID: <20220830115618.GA1105413@a1173f985c48>
References: <20220829105756.500128871@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 29, 2022 at 12:58:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.140 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Aug 2022 10:57:37 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.10.140-rc1 tested.

Run tested on:
- Intel Skylake x86_64 (nuc6 i5-6260U)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
