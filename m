Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9593B71BF
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 14:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233152AbhF2MI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 08:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233141AbhF2MI0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 08:08:26 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1454C061760;
        Tue, 29 Jun 2021 05:05:58 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id u11so25471784wrw.11;
        Tue, 29 Jun 2021 05:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZwIbVY3ptEtNpb22rcbQnSOWt2ow/tmLYWCDFy/3Iz0=;
        b=RQkZIPgvq1iS040WwRb0k8ogk8bTE/CA0W+7DQhZ8x5UqN++TftOTvF3f8mSRlyoKa
         lj7qaX2Rw5x0sJCNNlJOWIdC1TFfkLnCyTCtdVPP/w2QRqw3TmG9BIRZpqxUYFWMI1y9
         UHm7OC6FVy+p7jVqBIOlssFqNrjQTHslNiyJya5D6vjWRIUTaU2ho/CsLKeditqYt1+6
         J/OaojI+QdbgHsvgFlO4hRvLX73M2m4o/W5S8gz+U/yQBUgLA8C1YIK+w2NK2ilUSViO
         sW7M9eb187PmmQdtusasIojKH2IyvUnVZoxHJn27h2t470iIn1uIc4ugCPdl3DcQrLVs
         zSVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZwIbVY3ptEtNpb22rcbQnSOWt2ow/tmLYWCDFy/3Iz0=;
        b=ZzOs6+NWmIVfgf9SBZQz4xdmk6z8b8cl0et2e/tjeHit5YVYl/hL6l4Dhyh58FxjUt
         RgV13KPiHvz7pNRAQvIuGBpkO7VKiHzJ/oD4hD8ORMcUIFp7lu5Nqsp4+EhmFFl86jJo
         2dgS5l11x+nkG8+Q0QjCt5J0YiW6JP9y+2rDfx7yJM9drIvnmmnEGZvplwZ8PJWtknKO
         dKijkJqLweEoeDiAibmISAan2x9evzQ6RYL+GJfFRn1Ppd1Inilvvo5rdB1jbZVWPmYT
         5oSasleQ4B1kM6TrEWjjie/s5Of6TgSc7Ay0nyC+NFij9jZi0UmPBcPizOrASdLkbAPG
         d79g==
X-Gm-Message-State: AOAM532xrwPEeDlh0gozuB0Z4M89x7IF6r/eRVLDtamcpraHfWmvbMn+
        4RzCu7yAJzd/xKXBZLkHGs4=
X-Google-Smtp-Source: ABdhPJxhgDSSIFaN/G5+3sTWvUpyzwYWXxmsIqiQ2zWgJ61EXcYSBaDFiN7WPYlYbxivyFtKwiIdTA==
X-Received: by 2002:a5d:6547:: with SMTP id z7mr5054177wrv.27.1624968357425;
        Tue, 29 Jun 2021 05:05:57 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id r10sm18070759wrq.17.2021.06.29.05.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 05:05:57 -0700 (PDT)
Date:   Tue, 29 Jun 2021 13:05:55 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH 5.4 00/71] 5.4.129-rc1 review
Message-ID: <YNsMo7UOBZrL5Dht@debian>
References: <20210628143004.32596-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628143004.32596-1-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Mon, Jun 28, 2021 at 10:28:53AM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.4.129 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 30 Jun 2021 02:29:43 PM UTC.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210615): 65 configs -> no failure
arm (gcc version 11.1.1 20210615): 107 configs -> no new failure
arm64 (gcc version 11.1.1 20210615): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>


--
Regards
Sudip

