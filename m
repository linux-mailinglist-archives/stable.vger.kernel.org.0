Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E621D1336
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 14:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732573AbgEMMvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 08:51:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731779AbgEMMvw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 08:51:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C33F6206B7;
        Wed, 13 May 2020 12:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589374312;
        bh=1SBdssmchS7etFt8Hcpk8fQ7VCPg4FYqBUt6sF72B5g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OhEM8JhEn/lJos7yaxYu6g2ZU9D8JyDCADcM+2ZZ+L7kaoQ5Kqjgr6WE63xVWYNm3
         PUttciyF4c3ojFT2P7SWDpwh9M+5487VZWdWYsKiwzfT2RiIbNvQTFc1NPVbEwcaxQ
         ybwWLmTXc9XexFxejMYj2YDLQq5vGFBcBi5e8Nk8=
Date:   Wed, 13 May 2020 14:51:50 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Guillaume Tucker <guillaume.tucker@collabora.com>
Cc:     kernelci@groups.io, kernel-build-reports@lists.linaro.org,
        automated-testing@lists.yoctoproject.org,
        linux-next@vger.kernel.org, stable@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>, agross@kernel.org,
        qcomlt-patches@lists.linaro.org,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, ulf.hansson@linaro.org,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>, linux-pm@vger.kernel.org,
        vireshk@kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        kernel@collabora.com, kernelci@baylibre.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: kernelci.org transitioning to functional testing
Message-ID: <20200513125150.GA1084253@kroah.com>
References: <66aae710-1ee9-fb67-1a1b-997eeb70dc04@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66aae710-1ee9-fb67-1a1b-997eeb70dc04@collabora.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 13, 2020 at 12:13:24PM +0100, Guillaume Tucker wrote:
> As kernelci.org is expanding its functional testing
> capabilities, the concept of boot testing is now being
> deprecated.
> 
> Next Monday 18th May, the web dashboard on https://kernelci.org
> will be updated to primarily show functional test results
> rather than boot results.  The Boots tab will still be
> available until 5th June to ease the transition.
> 
> The new equivalent to boot testing is the *baseline* test suite
> which also runs sanity checks using dmesg and bootrr[1].
> 
> Boot email reports will eventually be replaced with baseline
> reports.  For those of you already familiar with the test email
> reports, they will be simplified to only show regressions with
> links to the dashboard for all the details.
> 
> Some functional tests are already being run by kernelci.org,
> results have only been shared by email so far but they will
> become visible on the web dashboard next week.  In particular:
> v4l2-compliance, i-g-t for DRM/KMS and Panfrost,
> suspend/resume...
> 
> And of course, a lot of functional test suites are in the
> process of being added: kselftest, KUnit, LTP, xfstests,
> extended i-g-t coverage and many more.
> 
> The detailed schedule is available on a GitHub issue[2].

Very cool stuff, thanks so much to everyone involved for making this
happen, it's really helpful.

greg k-h
