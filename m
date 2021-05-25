Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 919133908F5
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 20:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbhEYSaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 14:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbhEYSaK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 14:30:10 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 277B5C061574;
        Tue, 25 May 2021 11:28:39 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id r26-20020a056830121ab02902a5ff1c9b81so29507975otp.11;
        Tue, 25 May 2021 11:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/B1xMKpahCW1rM78bCwuGnyS5E8o5+3n70D1vLfmFDM=;
        b=dZyk8M5tGN7zD3cHAECnS3WF9HKSgHRFz8PgDbK0JYkKfmwGu6FzDj2rAOHy360nwN
         9tkNh1nhIu0wO2LEt9P29OfSrzLhr/HNn8KtyEpIlh83Vu0lyrKJ9A2SJ1P0rVkAwOrW
         CiLGAw5VcGIaBkpYOJIcdk17W7VkFf+RHe1pGq4BbIXn3u943xeFeL09C0CXKq/4Idpl
         duJ44JniNtOl4K8LBG8mfYDhMtAVP64LIgqbHX1n/wD38W2WbFwDzpDS+5//q8yZhYSO
         GF/Zgh1+ngaKhP83EI8eMSwhIN4VXQ1mNUBrlfi55vTtkldFsBzClUYtnLM5xfFeaNol
         /LQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=/B1xMKpahCW1rM78bCwuGnyS5E8o5+3n70D1vLfmFDM=;
        b=L0n7LkCnfKEG9wxuBgwz9h1BaVMC1LdUQUPyrF1AU44A5DcjD/5kY+u91VXSjVxiuJ
         BMkh2E8RFERV2pcPjTJb6TayE+8CAT4R4SSLASg1tfO/GJDTW0WRiUyTVyjVXSh2fv1E
         Zw2zyRMqgV4emliiIw9EfLhH+PCWt8+uFphCR5lbb+NXntfsoQpBjPl18LBxmjThoxD4
         fOnd8hLL9By/wBOKLMC8x8YKMAIBzSFCYSQx+HlgaZweqrDZ1k6VKnhJxS9FrrTudyv0
         5D+McHPaovlsBMJVtDQpCDpOJEEsNCsrrp/yCgPyWmrg/lYV4U6wSBefD9W8jZa1TCjH
         YO1w==
X-Gm-Message-State: AOAM532QgnpRami+0Knacr91I/e80Dv4S9pJ02bMNTauMMSGMluUGvVI
        NWkOa715SM2NNpED+UqXMHf6YJm1wKI=
X-Google-Smtp-Source: ABdhPJx4YkzUXdcAkfpKRxKYmLPuBOxHopuBOqCdd7ThGMulGDjR/QBHayFYC2n8r7llsm3sjOAZ4A==
X-Received: by 2002:a9d:2276:: with SMTP id o109mr22400060ota.33.1621967318374;
        Tue, 25 May 2021 11:28:38 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u1sm4066533otj.43.2021.05.25.11.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 11:28:37 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 25 May 2021 11:28:36 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/71] 5.4.122-rc1 review
Message-ID: <20210525182836.GA236211@roeck-us.net>
References: <20210524152326.447759938@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210524152326.447759938@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 24, 2021 at 05:25:06PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.122 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.
> 
> greg k-h
> 
> Christoph Hellwig <hch@lst.de>
>     nvme-multipath: fix double initialization of ANA state
> 
This patch was later fixed with commit commit e181811bd04d ("nvmet: use
new ana_log_size instead the old one").

Guenter
