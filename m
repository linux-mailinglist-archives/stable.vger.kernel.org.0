Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61102345217
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 22:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhCVVxq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 17:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbhCVVxO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 17:53:14 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77279C061574;
        Mon, 22 Mar 2021 14:53:13 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id w21-20020a9d63950000b02901ce7b8c45b4so17500563otk.5;
        Mon, 22 Mar 2021 14:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+Q22Ap9F18SO11+JwtdTXhevNoahi5Ij4mqfiXUk5rU=;
        b=uhi+lFuyjo32/1ZODviw0ylLz3JTPpBJPfnvUjRkqEFeQL7osQJKCfH+tqu537Ge3g
         hFYskjcHRzT/61gn+VwHZ0fiP2AogS6UewHgeA+DKGU3DifsjOetCkC80efRaT300Tzp
         dMfKMw/DajMBBjnfrqNLlERohuogmrcIrCkiDyiEVaR0v3wmjphOTBN/5scpyNIEMzkp
         uOdxwShezayVWQs3Qgs+M0yFsR1/bUHbOhmMC1omGGRvAEtF1KF2ZASuVsrPjppctmsi
         FU7VDsIVs4ylzMgFW57N9tlfIwojKtcTp9yOA2yfjEmExa7h2BVhEuUvKuFvdf7B7dtH
         BRwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=+Q22Ap9F18SO11+JwtdTXhevNoahi5Ij4mqfiXUk5rU=;
        b=n+IwCJ8SDOqLXbrjK1TtQUzZ6Nmrp8XExfKPLWgaaQY99lem94FKYbAUlRHO71G/3B
         o5QJzuw07NwhcOv9XrDotUPyAtwkmsBzgQjDW/AL84Xnlj9/9STLcNEz5Sj9lVlrKC7J
         CZTj3mwoWZX/zxO2bqYBuFkvLIP9qfJ8eJ8c5LB2dtl6HENXsIb77SOUY7CbsaCd7sFk
         2rg/6PV5yBe+bhROxcH5s1yKNL4m4uhzjUrQG7MU+/bCdV1iyE8VQ8DAJghg+y8GrlTn
         WL8E8dBe5QScZPXUNOneXK3cE3J7ZB+VgZRFc41U8rgGM1TaqizOdRUE2cW5jhYZLazL
         6P5g==
X-Gm-Message-State: AOAM533jUg3CtjB1Md+qaJla8AR9jqgSVSlsAJfibLzfOLKmoQTAsB2q
        EfE72HxEu9xdvnW2crwBiyQ=
X-Google-Smtp-Source: ABdhPJyvU1SRrFT0+n0/FpvpOE5XrN7ZHq/RGwcBDm4Cgoo/WhvZhr9rbcTd+3SC6LkDBX10URs3qQ==
X-Received: by 2002:a05:6830:120b:: with SMTP id r11mr1533576otp.82.1616449992866;
        Mon, 22 Mar 2021 14:53:12 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e4sm3395798oie.23.2021.03.22.14.53.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Mar 2021 14:53:12 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 22 Mar 2021 14:53:11 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/60] 5.4.108-rc1 review
Message-ID: <20210322215311.GC51597@roeck-us.net>
References: <20210322121922.372583154@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322121922.372583154@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 22, 2021 at 01:27:48PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.108 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Mar 2021 12:19:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
