Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 413635FF841
	for <lists+stable@lfdr.de>; Sat, 15 Oct 2022 05:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiJODai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 23:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiJODag (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 23:30:36 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 591E93AE43
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 20:30:32 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id e129so5896572pgc.9
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 20:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ER8adTwAOMdLu2nq11yXwvX5UbvtwH5jkW2p7zfk5Rg=;
        b=Ys6Os6lFMtFxXLfPMhUKVze/ZWQwXxeCGxwKPSU5Sqk3m1S3nS4/VnVqu5qUW90dqy
         zBzXvd3bfdCKr9IxDSK8Yz7wwAja858gaPkxuXoRTWqlSDB3biWXMSMQeeGwHLTYgJj5
         UxdC2UE0ot970e7cV4mfIZb6WqAqqOvm3uwSs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ER8adTwAOMdLu2nq11yXwvX5UbvtwH5jkW2p7zfk5Rg=;
        b=sEKdP25Q16M3+YM++gX54F6KUakB3wkFNnrMP/lbqPgF8GwUYgPLWflrQafaSBxSdD
         00V4ZBHa04FOjqih0yCxmqpn/w2usJnajOmdCTsujgURfvpekI6N02gQwgy6D3LvLlUO
         se3cJWywg3RCMn4mwkKFTz/U+xW/ex633HV/xt97w2nSIwIBTgu05FQs9KVsIANNXvlC
         JQa/WK3ENYO6c2K0CR2NL2V1rJMh6lvS0GuuabfCvSjF84klTnCmnFoqlAEu8whj9qu8
         Xo6VlwLGmo2focF4jVj3d2UEUrxmWDEnXTqPkzcaN0KuH7VosL6wOe12uK28Sbb05Cn+
         97kA==
X-Gm-Message-State: ACrzQf0lxDf+99CtRGyeluLwOVosbdcsvKvUUL4Fd4Tz2o4/RRGdN5ue
        y+URt46A1N95SaZ7s+lf83RCUA==
X-Google-Smtp-Source: AMsMyM61fO7n/3/pxtyjZ17fc6DpQrxi2g8Fs8LAopSZ1XYE6Yo3eZGcXJTx+pMqlLTLfEuuQTAvMA==
X-Received: by 2002:a65:6b81:0:b0:461:4049:7df7 with SMTP id d1-20020a656b81000000b0046140497df7mr945115pgw.593.1665804631835;
        Fri, 14 Oct 2022 20:30:31 -0700 (PDT)
Received: from 90cf639d7f59 ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id m3-20020a62a203000000b0053e38ac0ff4sm2427921pff.115.2022.10.14.20.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 20:30:30 -0700 (PDT)
Date:   Sat, 15 Oct 2022 03:30:23 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.10 00/54] 5.10.148-rc1 review
Message-ID: <20221015033023.GA1744407@90cf639d7f59>
References: <20221013175147.337501757@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013175147.337501757@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 13, 2022 at 07:51:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.148 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.10.148-rc1 tested.

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
