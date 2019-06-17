Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2476E488F2
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 18:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfFQQat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 12:30:49 -0400
Received: from foss.arm.com ([217.140.110.172]:55728 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726920AbfFQQat (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 12:30:49 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8DC2B28;
        Mon, 17 Jun 2019 09:30:48 -0700 (PDT)
Received: from [10.1.197.45] (e112298-lin.cambridge.arm.com [10.1.197.45])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3B6313F718;
        Mon, 17 Jun 2019 09:30:45 -0700 (PDT)
Subject: Re: [PATCH v4.4 00/45] V4.4 backport of arm64 Spectre patches
To:     Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Cc:     stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
References: <cover.1560480942.git.viresh.kumar@linaro.org>
From:   Julien Thierry <julien.thierry@arm.com>
Message-ID: <c1589c0b-ce49-742e-f722-4e2dd11a40d7@arm.com>
Date:   Mon, 17 Jun 2019 17:30:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Viresh,

After discussing it internally, we think it would be better to drop the
patches related to KVM for now. In 4.4 KVM Arm not very mature and has
changed a lot since then.

If someone wants to backport the mitigations for KVM in 4.4, it should
be done as a separate series. The series is big enough as it is. For
now, the main point is to focus on the kernel itself.

Sorry you already went through some trouble to backport those. But
dropping will simply review and testing, and as mentioned, 4.4 KVM on
Arm is probably not worth the hassle.

Cheers,

-- 
Julien Thierry
