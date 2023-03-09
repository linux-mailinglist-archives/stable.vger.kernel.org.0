Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E63C6B2662
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 15:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbjCIOL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 09:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbjCIOLT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 09:11:19 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0286BE38C;
        Thu,  9 Mar 2023 06:09:54 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 40F48AD7;
        Thu,  9 Mar 2023 06:10:37 -0800 (PST)
Received: from usa.arm.com (e103737-lin.cambridge.arm.com [10.1.197.49])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B658C3F5A1;
        Thu,  9 Mar 2023 06:09:52 -0800 (PST)
From:   Sudeep Holla <sudeep.holla@arm.com>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Cristian Marussi <cristian.marussi@arm.com>
Cc:     Sudeep Holla <sudeep.holla@arm.com>, viresh.kumar@linaro.org,
        vincent.guittot@linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH] firmware: arm_scmi: Fix device node validation for mailbox transport
Date:   Thu,  9 Mar 2023 14:09:50 +0000
Message-Id: <167837075465.2091199.6035203534481749476.b4-ty@arm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307162324.891866-1-cristian.marussi@arm.com>
References: <20230307162324.891866-1-cristian.marussi@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 07 Mar 2023 16:23:24 +0000, Cristian Marussi wrote:
> When mailboxes are used as a transport it is possible to setup the SCMI
> transport layer, depending on the underlying channels configuration, to use
> one or two mailboxes, associated, respectively, to one or two, distinct,
> shared memory areas: any other combination should be treated as invalid.
> 
> Add more strict checking of SCMI mailbox transport device node descriptors.
> 
> [...]

Applied to sudeep.holla/linux (for-next/scmi/fixes), thanks!

[1/1] firmware: arm_scmi: Fix device node validation for mailbox transport
      https://git.kernel.org/sudeep.holla/c/2ab4f4018cb6

--
Regards,
Sudeep

