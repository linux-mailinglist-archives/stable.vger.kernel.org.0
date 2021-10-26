Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A884543B985
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 20:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238288AbhJZS3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 14:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238282AbhJZS3k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 14:29:40 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D9AC061745;
        Tue, 26 Oct 2021 11:27:15 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id e4so20857056wrc.7;
        Tue, 26 Oct 2021 11:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1pL59vjDL5iVhNjSYNHVUm0At7ysQBHo8rmOQiF4OIA=;
        b=K4ALytQBC+tbHBZPMy9Cx5x74X2xYRxSM5QJZEAuJuB0zNlrPKCgNER/yhnZtCo10U
         6yXw2pyJgmguWvhz/MyPY6kwL9T8VoemyFrSL9Sh8SKuSLHGkXuUTggHu0V00NTRbDjD
         twirUCVNf2Ovs6rp2K8rdtgqhE8vjXd3Fpt9Aa6CT0aDGKO84IPxAabixl0Y2s0xHgnD
         jpMYNsBOf8ZpTpccMfnxgdNlJK7QFfQYCvhVcwpsOAt3qzl5BFQ5rxZF1bc/hFOIBn2T
         uS2y2mWC2Hp7gmRri5qIQkYX8Iclu2qmBcZPCBejFuVj5APebdSuOf5Rnv5oiNSPS7Xt
         CK+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1pL59vjDL5iVhNjSYNHVUm0At7ysQBHo8rmOQiF4OIA=;
        b=RCEbm313DGF2P0SIiOy4qs/K4VgYaeL4tCdEBGmDOfMBvUuocAN/ni7cGQJKC/soBx
         F/NniAeMUq77Z7Byg1SgyL6QZH6JbO4hbGUAKez9DAoH8JrcowOFkvfAemjabhYQ996B
         wH0ROdyzRbdlrsKP1ed3oOtMhpLLNjvsParMKoKAkRsaKL+q+ZmM0ZtvMlNOdjhvHK7x
         s2ge1RyiZwl+6kkYPNFistu2jQVrWoF9WGRAp9nbYOVZ7NNIcrdUdtyUb8j9X1V5nxD7
         1a5hVorlVP8uRLG1QkYOZVI+s9vgmLCOrIMCDbP4Tpnmc22JF7UtTzBtH64BJ8QfcxSD
         K7bQ==
X-Gm-Message-State: AOAM533eEwU93HAoiR/6SN+OuaY5GkpacAebtjJB+Lf1PgkvMOGqQoK8
        GDXYhOldprh5PRxX+vusCSE=
X-Google-Smtp-Source: ABdhPJyGZWAgkTAGeB35GybjzeKMCbOOlm0bENH5kRHWbzqG4mDGaSJtwIL95UEqgE2D4d2e+ZTOKw==
X-Received: by 2002:a5d:4a46:: with SMTP id v6mr33241790wrs.262.1635272834387;
        Tue, 26 Oct 2021 11:27:14 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id l9sm714779wms.40.2021.10.26.11.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 11:27:14 -0700 (PDT)
Date:   Tue, 26 Oct 2021 19:27:12 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/95] 5.10.76-rc1 review
Message-ID: <YXhIgFOroRyVkp0g@debian>
References: <20211025190956.374447057@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Oct 25, 2021 at 09:13:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.76 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Oct 2021 19:07:44 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211012): 63 configs -> no new failure
arm (gcc version 11.2.1 20211012): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20211012): 3 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/310
[2]. https://openqa.qa.codethink.co.uk/tests/307


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

