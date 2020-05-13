Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFCC21D10C9
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 13:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730047AbgEMLNa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 07:13:30 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:47620 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726645AbgEMLNa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 07:13:30 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: gtucker)
        with ESMTPSA id BFAF72711FF
To:     kernelci@groups.io, kernel-build-reports@lists.linaro.org,
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
From:   Guillaume Tucker <guillaume.tucker@collabora.com>
Subject: kernelci.org transitioning to functional testing
Message-ID: <66aae710-1ee9-fb67-1a1b-997eeb70dc04@collabora.com>
Date:   Wed, 13 May 2020 12:13:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As kernelci.org is expanding its functional testing
capabilities, the concept of boot testing is now being
deprecated.

Next Monday 18th May, the web dashboard on https://kernelci.org
will be updated to primarily show functional test results
rather than boot results.  The Boots tab will still be
available until 5th June to ease the transition.

The new equivalent to boot testing is the *baseline* test suite
which also runs sanity checks using dmesg and bootrr[1].

Boot email reports will eventually be replaced with baseline
reports.  For those of you already familiar with the test email
reports, they will be simplified to only show regressions with
links to the dashboard for all the details.

Some functional tests are already being run by kernelci.org,
results have only been shared by email so far but they will
become visible on the web dashboard next week.  In particular:
v4l2-compliance, i-g-t for DRM/KMS and Panfrost,
suspend/resume...

And of course, a lot of functional test suites are in the
process of being added: kselftest, KUnit, LTP, xfstests,
extended i-g-t coverage and many more.

The detailed schedule is available on a GitHub issue[2].

Please let us know if you have any questions, comments or
concerns either in this thread, on kernelci@groups.io or IRC
#kernelci on Freenode.

Stay tuned!

Thanks,
Guillaume


[1] bootrr: https://github.com/kernelci/bootrr
[2] schedule: https://github.com/kernelci/kernelci-backend/issues/238

