Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8C313443A
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 14:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbgAHNp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 08:45:28 -0500
Received: from foss.arm.com ([217.140.110.172]:44856 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726186AbgAHNp2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jan 2020 08:45:28 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2DB2431B;
        Wed,  8 Jan 2020 05:45:28 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B79F73F703;
        Wed,  8 Jan 2020 05:45:26 -0800 (PST)
Date:   Wed, 8 Jan 2020 13:45:24 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        maz@kernel.org, alexandru.elisei@arm.com
Cc:     drjones@redhat.com, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, peter.maydell@linaro.org,
        stable@vger.kernel.org, suzuki.poulose@arm.com, will@kernel.org
Subject: Re: [PATCHv2 0/3] KVM: arm/arm64: exception injection fixes
Message-ID: <20200108134524.GE49203@lakrids.cambridge.arm.com>
References: <20200108134324.46500-1-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200108134324.46500-1-mark.rutland@arm.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 08, 2020 at 01:43:21PM +0000, Mark Rutland wrote:
> Since v1 [2]:
> * Fix host_spsr_to_spsr32() bit preservation
> * Fix SPAN polarity; tested with a modified arm64 guest
> * Fix DIT preservation on 32-bit hosts
> * Add Alex's Reviewed-by to patch 3
> 
> Thanks,
> Mark.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/log/?h=kvm/exception-state

Whoops; I missed the list reference for v1:

[2] https://lore.kernel.org/r/20191220150549.31948-1-mark.rutland@arm.com

Mark.
