Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6005A6227B6
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 10:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiKIJ41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 04:56:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiKIJ40 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 04:56:26 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083FF18E09
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 01:56:24 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id d13-20020a17090a3b0d00b00213519dfe4aso1419532pjc.2
        for <stable@vger.kernel.org>; Wed, 09 Nov 2022 01:56:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8OrF8dH4eiZS9L3s0WZftm0o/EO5zf8rOLBRrHL6Sgk=;
        b=UfQdVdb9j523nu0DU9BEjD0S3rH/cUK+pofD3d0h9hFKs3F/K4EXQUmtY8f7+WETW9
         gequo3sOKgP+CBEUrvC+X3MWGADLF51b7Y/4Yc4lho8Fp8itkrBGXFjV99s0eK5UelIL
         rzgdgQo6K2dE/RUl8WKEl5VnArr+cfVSZVylY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8OrF8dH4eiZS9L3s0WZftm0o/EO5zf8rOLBRrHL6Sgk=;
        b=nokO0nB1CEZKP8gfzWJBy/dgfTmqSFubWBF73F8FbQFpGdUNhz0CkopTkT70SwAH+p
         vfHIlMamBROU7Ht8URuNoMtEavKq9q8XgNs8QH5a89Ye916fKBDOHzS/pcp4OqhekeQQ
         AKmPXEz2MYT3B5EiEuXaNkRd7mUysAyb9qWw1CgCHUqu0K93ZaSbrp2TAgNNWhQI91pA
         4H59bc26oaPus1tQY0USOhbrHGa3eLT/gv40jRSBGvEsv3OuPw7Jl+kD+4wqy7dRWxz7
         poeuBI2uvASVXnew/4R4Lrx0pf8AIOruI3tLWRo+FgltklgGuPxP8gwCg8Yw1c9Q/kna
         Ar+w==
X-Gm-Message-State: ANoB5pm/CCJtoKbtjDsxKyzRZBppefSbkW+K6xoxM3FcBoWrn+DFEtma
        mw2pC7rW5fjZ4VZ26l2JEZo5UQ==
X-Google-Smtp-Source: AA0mqf6PiYdLhpF666M7VNwWUnrYO42eGbuAHrm0em6JnnekdoRCAbfsdilmDvZDDSmatRzbcqDUbA==
X-Received: by 2002:a17:902:9f98:b0:188:6593:17fb with SMTP id g24-20020a1709029f9800b00188659317fbmr28111548plq.173.1667987783369;
        Wed, 09 Nov 2022 01:56:23 -0800 (PST)
Received: from b0ad8707f47a ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id a9-20020a1709027e4900b001783f964fe3sm8582947pln.113.2022.11.09.01.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 01:56:22 -0800 (PST)
Date:   Wed, 9 Nov 2022 09:56:15 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.10 000/117] 5.10.154-rc2 review
Message-ID: <20221109095615.GA947857@b0ad8707f47a>
References: <20221109082223.141145957@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109082223.141145957@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 09, 2022 at 09:26:53AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.154 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Nov 2022 08:21:58 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.10.154-rc2 tested.

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
