Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1955D523049
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 12:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbiEKKIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 06:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbiEKKIa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 06:08:30 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69ACC674C0;
        Wed, 11 May 2022 03:08:25 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id n126-20020a1c2784000000b0038e8af3e788so928673wmn.1;
        Wed, 11 May 2022 03:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fInMYLpzAR11LD31uZ0FRmuNzaheHgen5odu58s7U7Y=;
        b=Uq7Wwt/hFa3v/+fsmyp3lIb8BtHWF/XRbkB9RzI8tlpijwJI59P65oPhs8dEh2dmJH
         HZqEIGTdwcoM3qnDCvNVgEBITFgnCxbKXouScechgZYrcrDc7uuQoQvcFFnJh0CAqhuU
         7dWoSaH1xsedBJTvxoYpRWPgWQDREfd15Ak/eyGNNw7MPiPzemMCbIoWQ5e3yod6fH71
         B4Qa57PPLdn7/nPnthXftrxUG8jOw8Mt9W3b8VUtu2hqmOg0pZoDHs3RNpcVUyHetQKJ
         rBtJUfin6v4QXGijjxXSc5QvkWXxAQ62FBYCnP/sbQNFPIvfo5uguFDVd4mSBIhY0uE+
         zF2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fInMYLpzAR11LD31uZ0FRmuNzaheHgen5odu58s7U7Y=;
        b=MQeHkccPlYHH+v2WsMCQG+wo01N1dSurSNbT8P4D7yjDi2jTRvJ9PZbs3jCoaL9ylc
         YpSabajUC5z5kL5kcygvHtSw/kaeV0mhc/4SbMM8++n/f4vg1y1rfT3Y+pyczduMC1aR
         WKk99tfFr/Ofea9kxZTVDP3+10cHBTuOAKZm6tqo1Dr+4ZhKDgnFZv/lzdrTtFP55IvD
         5Oh0d4spPkam/fZcgn5UcX3hsgK7s242KQz1pePXza7xI9HDfPBvgn3ZgBRxTL0gB3W7
         aBRclB52zsI+elhujWH22nUYqsKep29lkXvZsZF/1KG0046wVItAJnmJcOqJ9P5YGZ3s
         ypJA==
X-Gm-Message-State: AOAM530+6t6nseRWSBFvcQWe+cf7AkIGblDclVlXxrEhJC3HDaIYNB8s
        eJXxgdedhjhHcVQjAmnAZhA=
X-Google-Smtp-Source: ABdhPJzk8DaJ2jaAHoCb1L8sAkcT44XA1AJ1MbjW1ja5w0YJApDRuN4L5BSKnpCLn1DNdO0z2uWU+Q==
X-Received: by 2002:a05:600c:4e05:b0:394:8955:839a with SMTP id b5-20020a05600c4e0500b003948955839amr4006468wmq.28.1652263703939;
        Wed, 11 May 2022 03:08:23 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id p8-20020adfe608000000b0020c5253d8e6sm1242878wrm.50.2022.05.11.03.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 03:08:23 -0700 (PDT)
Date:   Wed, 11 May 2022 11:08:21 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/88] 4.19.242-rc1 review
Message-ID: <YnuLFbkvKwCyOkv5@debian>
References: <20220510130733.735278074@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510130733.735278074@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, May 10, 2022 at 03:06:45PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.242 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.

Build test (gcc-11):
mips (gcc version 11.2.1 20220408): 63 configs -> no  failure
arm (gcc version 11.2.1 20220408): 116 configs -> no new failure
arm64 (gcc version 11.2.1 20220408): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220408): 4 configs -> no failure

Build test (gcc-12):
Mips builds are failing. Needs d422c6c0644b ("MIPS: Use address-of operator on section
symbols")

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/1124


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

