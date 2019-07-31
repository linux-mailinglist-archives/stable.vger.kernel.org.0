Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADC327D1C5
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 01:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729992AbfGaXTW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 19:19:22 -0400
Received: from cmta18.telus.net ([209.171.16.91]:34498 "EHLO cmta18.telus.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729885AbfGaXTR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Jul 2019 19:19:17 -0400
Received: from dougxps ([173.180.45.4])
        by cmsmtp with SMTP
        id sxsFhbpqL7TgTsxsHhHHOJ; Wed, 31 Jul 2019 17:19:15 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=telus.net; s=neo;
        t=1564615155; bh=3rzn4hYxIH9EzUzyImMhDAPA+7iJOX/pi/weI4QgB7I=;
        h=From:To:Cc:References:In-Reply-To:Subject:Date;
        b=LCGpVOoLu+jUaCaWp4KfyFBqxs6GqHCqsPXIwiHTEQ10xLHufMpdzEUcs9ropvfqB
         M3ZzYGtKNcNwUY2TVJAMDtkqLicOH8ABlw6QxXUGgoiDBHgLDBh8snRb9fKj8/BlGq
         SZbJDRdXu+HRCqYqFEBzClPzC2vL2On+QLervLD7pdOPl0zrE+dq372fbXnjq57Rzl
         z2FBWsTsjLPO08neKVrW+Ulhzu+33XNRM5U2ypwOMqEykTrtH0Uwwg0A1j2/UuvYVi
         3xQg8n6IwZxm8Ua3YqJrlsfvTWTWCzdjiO/LwSsFCeFEAxwCpg4lZ7+SeH9hUdNRMV
         5LIolfiJLjKLA==
X-Telus-Authed: none
X-Authority-Analysis: v=2.3 cv=e6N4tph/ c=1 sm=1 tr=0
 a=zJWegnE7BH9C0Gl4FFgQyA==:117 a=zJWegnE7BH9C0Gl4FFgQyA==:17
 a=Pyq9K9CWowscuQLKlpiwfMBGOR0=:19 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19
 a=kj9zAlcOel0A:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=KKAkSRfTAAAA:8
 a=gu6fZOg2AAAA:8 a=fGXEpK-jy_bYTHPgIHoA:9 a=CjuIK1q_8ugA:10 a=-FEs8UIgK8oA:10
 a=NWVoK91CQyQA:10 a=AjGcO6oz07-iQ99wixmX:22 a=cvBusfyB2V15izCimMoJ:22
 a=2RSlZUUhi9gRBrsHwhhZ:22
From:   "Doug Smythies" <dsmythies@telus.net>
To:     "'Viresh Kumar'" <viresh.kumar@linaro.org>,
        "'Rafael Wysocki'" <rjw@rjwysocki.net>,
        "'Ingo Molnar'" <mingo@redhat.com>,
        "'Peter Zijlstra'" <peterz@infradead.org>
Cc:     <linux-pm@vger.kernel.org>,
        "'Vincent Guittot'" <vincent.guittot@linaro.org>,
        "'v4 . 18+'" <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <04ff2be6ef108585d57aa2462aa7a4c676b6d1cd.1564541875.git.viresh.kumar@linaro.org>
In-Reply-To: <04ff2be6ef108585d57aa2462aa7a4c676b6d1cd.1564541875.git.viresh.kumar@linaro.org>
Subject: RE: [PATCH] cpufreq: schedutil: Don't skip freq update when limits change
Date:   Wed, 31 Jul 2019 16:19:10 -0700
Message-ID: <000701d547f6$5e4254f0$1ac6fed0$@net>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Content-Language: en-ca
Thread-Index: AdVHS+4YI9BnHjPrQbmpxp6l6KKevwApiyrA
X-CMAE-Envelope: MS4wfGh9dvqKE8TMltwZiw0xfBDEnZROYYG2ebYYPQEoBjk9gSYuUsYTGBgldRZnlNwe8tfA/CPF2gKNKkKLNXT7Vgmsm8SkvXihyBqtFFxQsLncZoziYcFi
 1LVOpox3Z+Wc4Y2YyKQUs0tz9X1AwODr9TV6Jn6tSBbkVfbOgxUkjLHjvhwt8EpNUVObY6g3GdgxnBZ0xor0g958P9+8yTCkyJudLwSp8qnt8IHIjxmaMlhN
 GpUy4UZzOSTftTdYLrLO8Ljbo1J02QkFqEoTj5Q8AIOE+IuJOTPAXcEtHHRPLq1MqoMg3UrEPCEDT5jXoeXFr8E5lZ7J7MjgnitmwXNeMejCPhztfkIYYHrh
 iwdNYKfLcE7KTWKTPtf5t0H7jDHCfS2KnNMNl3NA9EDXv2iI4Rw=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019.07.31 Viresh Kumar wrote:
> To avoid reducing the frequency of a CPU prematurely, we skip reducing
> the frequency if the CPU had been busy recently.
>
> This should not be done when the limits of the policy are changed, for
> example due to thermal throttling. We should always get the frequency
> within the new limits as soon as possible.
> 
> Fixes: ecd288429126 ("cpufreq: schedutil: Don't set next_freq to UINT_MAX")
> Cc: v4.18+ <stable@vger.kernel.org> # v4.18+
> Reported-by: Doug Smythies <doug.smythies@gmail.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> @Doug: Can you please provide your Tested-by for this commit, as it
> already fixed the issue around acpi-cpufreq driver.
>
> We will continue to see what's wrong with intel-pstate though.

Please give me a few more hours.
I'll reply to another thread with new information at that time.

My recommendation will be to scrap this "patch2" and go back
to "patch1" [1], with a couple of modifications. The logic
of patch1 is sound.
Teaser: it is working for intel_cpufreq/schedutil, but I
have yet to test acpi-cpufreq/schedutil.

[1] https://marc.info/?l=linux-pm&m=156377832225470&w=2

... Doug


