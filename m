Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533C61A82AB
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 17:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439712AbgDNP0l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 11:26:41 -0400
Received: from foss.arm.com ([217.140.110.172]:58290 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439675AbgDNP0i (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Apr 2020 11:26:38 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BDF2230E;
        Tue, 14 Apr 2020 08:26:37 -0700 (PDT)
Received: from [10.37.9.9] (unknown [10.37.9.9])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F1CD33F73D;
        Tue, 14 Apr 2020 08:26:35 -0700 (PDT)
Subject: Re: [PATCH 1/5] arm64: vdso: don't free unallocated pages
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        will@kernel.org, stable@vger.kernel.org
References: <20200414104252.16061-1-mark.rutland@arm.com>
 <20200414104252.16061-2-mark.rutland@arm.com>
 <c5596228-2685-abb3-5ab1-9519759e1f7a@arm.com>
 <20200414132751.GF2486@C02TD0UTHF1T.local>
 <8681c958-0fd9-130e-f7bb-99bfd3a027cb@arm.com>
 <20200414151247.GJ2486@C02TD0UTHF1T.local>
From:   Vincenzo Frascino <vincenzo.frascino@arm.com>
Message-ID: <d6b6cc44-e5db-7601-9938-416ff8823cc8@arm.com>
Date:   Tue, 14 Apr 2020 16:27:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200414151247.GJ2486@C02TD0UTHF1T.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mark,

On 4/14/20 4:12 PM, Mark Rutland wrote:
> Regardless, this is all academic unless you disagree with the first two
> bullets above.

Nothing to object on those.

-- 
Regards,
Vincenzo
