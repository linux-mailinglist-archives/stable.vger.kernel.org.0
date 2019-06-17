Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F29E48285
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 14:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfFQMdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 08:33:08 -0400
Received: from foss.arm.com ([217.140.110.172]:48200 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbfFQMdI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 08:33:08 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E75C22B;
        Mon, 17 Jun 2019 05:33:07 -0700 (PDT)
Received: from [10.1.197.45] (e112298-lin.cambridge.arm.com [10.1.197.45])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8519F3F246;
        Mon, 17 Jun 2019 05:33:02 -0700 (PDT)
Subject: Re: [PATCH v4.4 20/45] mm: Introduce lm_alias
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
 <8500aeb27596eef7bd952f988c8db0a4b2f655c6.1560480942.git.viresh.kumar@linaro.org>
From:   Julien Thierry <julien.thierry@arm.com>
Message-ID: <7b682848-d47d-94cc-6eae-7e97a0ca821a@arm.com>
Date:   Mon, 17 Jun 2019 13:33:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <8500aeb27596eef7bd952f988c8db0a4b2f655c6.1560480942.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Viresh,

On 14/06/2019 04:08, Viresh Kumar wrote:
> From: Laura Abbott <labbott@redhat.com>
> 
> commit 568c5fe5a54f2654f5a4c599c45b8a62ed9a2013 upstream.
> 
> Certain architectures may have the kernel image mapped separately to
> alias the linear map. Introduce a macro lm_alias to translate a kernel
> image symbol into its linear alias. This is used in part with work to
> add CONFIG_DEBUG_VIRTUAL support for arm64.
> 

I think this commit was backported in 4.9 because one of the commits you
dropped (6840bdd73d07 arm64: KVM: Use per-CPU vector when BP hardening
is enabled) depended on it. I have yet to check whether that other
commit can be just dropped, however on your branch 4.4 branch, lm_alias
isn't used anywhere, so we probably don't want to backport this
particular patch (unless we need to actually backport the other patch in
some way).

Cheers,

-- 
Julien Thierry
