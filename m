Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4826341AF30
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 14:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240725AbhI1MoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 08:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240745AbhI1MoO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 08:44:14 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FD5C061575
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 05:42:35 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id m21so21017784pgu.13
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 05:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KrkBhOCAHDLrXlCJGYdW7dNSKw0SJG9MSoAFEH4IRhM=;
        b=V3HnIKh9EBOuvvF6mNGhT0Ru4vFPSZOsbxmvLe24EqZnjfggFqYa95coyrVbCFyWai
         PhFyRqaL6GLJMN1ez7Xdl/zu1/9PzfWXBereA7KvMCWcnvhQbZKiDu3AIdo+Bp+pEDwG
         oYusH6ow2v/Qzt58vQOlhRpbXrWWkKsahCFxo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KrkBhOCAHDLrXlCJGYdW7dNSKw0SJG9MSoAFEH4IRhM=;
        b=PcABq/Ot7/SCZ183uYsXfg91rQOMqXYjD1DsH2YCjiUlf0GqXfO8z7bif1TFojCC9C
         yHVGS43AQ/A6x+XbS7XFA7S4+vecYHQuc3DN2HU311dcVJ8pAVDzOv2bENRacW1MNJMX
         vvptXBOW82jReaw0HqG4QxO8K1p5ZMvW6qRg70LqYJEcl80q/15qyv4hbY9c2TNr2w4+
         s+hnQc50K0HvnBygcQIoHoUGf5Tgeft5dSWNARucQQEmUKf9BHdZ1OPiND8j9MTwJeu0
         DlmVO43Ugx27WyNqd9uFGyhq859yThEdqTFHEuLouEHlDvYgL8gU4rzq+/9okU5tLhGJ
         83Ug==
X-Gm-Message-State: AOAM530xCW6LCMfivm8aUuhxRlcnbE9Ymvfn4VgYc6XslEODlCU0CfmP
        Tf+ioadn7BeUGM4JSedV+vLm4Q==
X-Google-Smtp-Source: ABdhPJztuO9y0JJxQl3fjPtbES/ZsYEsZ3QZBTftThZwr9boSo2ZHAwM94JQ3QFpg9M9db83/rbZYg==
X-Received: by 2002:a63:534f:: with SMTP id t15mr4468932pgl.392.1632832954904;
        Tue, 28 Sep 2021 05:42:34 -0700 (PDT)
Received: from 235a98196aae (194-193-55-226.tpgi.com.au. [194.193.55.226])
        by smtp.gmail.com with ESMTPSA id t9sm2597559pjq.20.2021.09.28.05.42.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 Sep 2021 05:42:34 -0700 (PDT)
Date:   Tue, 28 Sep 2021 22:42:27 +1000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 000/161] 5.14.9-rc2 review
Message-ID: <20210928124222.GA7@235a98196aae>
References: <20210928071739.782455217@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928071739.782455217@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 28, 2021 at 09:19:04AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.9 release.
> There are 161 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Sep 2021 07:17:13 +0000.
> Anything received after that time might be too late.

Hi Greg,

the following patch causes IGC not to build as PTP_1588_CLOCK_OPTIONAL
is not included in the 5.14.9-rc2 patch.

igc: fix build errors for PTP
[ Upstream commit 87758511075ec961486fe78d7548dd709b524433 ]

the config is only found in 5.15rc on this commit:
https://github.com/torvalds/linux/commit/e5f31552674e88bff3a4e3ca3e5357668b5f2973

diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index 82744a7501c7..c11d974a62d8 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -335,6 +335,7 @@ config IGC
 	tristate "Intel(R) Ethernet Controller I225-LM/I225-V support"
 	default n
 	depends on PCI
+	depends on PTP_1588_CLOCK_OPTIONAL
 	help
 	  This driver supports Intel(R) Ethernet Controller I225-LM/I225-V
 	  family of adapters.
