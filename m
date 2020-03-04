Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D104178ED3
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 11:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgCDKsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 05:48:17 -0500
Received: from foss.arm.com ([217.140.110.172]:60782 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726137AbgCDKsR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 05:48:17 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 96E2F30E;
        Wed,  4 Mar 2020 02:48:16 -0800 (PST)
Received: from bogus (e103737-lin.cambridge.arm.com [10.1.197.49])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EA4713F534;
        Wed,  4 Mar 2020 02:48:14 -0800 (PST)
Date:   Wed, 4 Mar 2020 10:48:12 +0000
From:   Sudeep Holla <sudeep.holla@arm.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        linux-pm@vger.kernel.org, "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lina Iyer <ilina@codeaurora.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Benjamin Gaignard <benjamin.gaignard@st.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/4] PM / Domains: Allow no domain-idle-states DT
 property in genpd when parsing
Message-ID: <20200304104812.GB25004@bogus>
References: <20200303203559.23995-1-ulf.hansson@linaro.org>
 <20200303203559.23995-2-ulf.hansson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303203559.23995-2-ulf.hansson@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 03, 2020 at 09:35:56PM +0100, Ulf Hansson wrote:
> Commit 2c361684803e ("PM / Domains: Don't treat zero found compatible idle
> states as an error"), moved of_genpd_parse_idle_states() towards allowing
> none compatible idle state to be found for the device node, rather than
> returning an error code.
>
> However, it didn't consider that the "domain-idle-states" DT property may
> be missing as it's optional, which makes of_count_phandle_with_args() to
> return -ENOENT. Let's fix this to make the behaviour consistent.
>

Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>

--
Regards,
Sudeep
