Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCC7AD6C06
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 01:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfJNX2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 19:28:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726170AbfJNX2t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Oct 2019 19:28:49 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D455217F9;
        Mon, 14 Oct 2019 23:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571095729;
        bh=Vjb7D4082/6F6a09KhxVdWW3xVvMz7uIEG/auDMghKI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SnwF7v3NWjK452e+7StLrVTGuDpQwjnaxqdEPG1I/iboBQc1BSogJkZi8wako+JlO
         LhDsC7MV2PFSyjE/BnoPBVL/G5HIW6kYtdZTrSKFKklIPYw2Rd+NxbZokGH22K6Eol
         uKoZ1h1oHgeFJUZNpplRXJvYoNzogjFuwZNk5uDg=
Date:   Mon, 14 Oct 2019 19:28:48 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com,
        maz@kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [stable-4.4][PATCH 0/2] arm64: cpufeature: Fix truncating a
 feature value
Message-ID: <20191014232848.GB31224@sasha-vm>
References: <20191014123254.22002-1-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191014123254.22002-1-suzuki.poulose@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 14, 2019 at 01:32:52PM +0100, Suzuki K Poulose wrote:
>This series fixes the issue with arm64_ftr_value() where the signed
>fields are truncated to unsigned values corrupting the system wide
>safe values.

Queued both for 4.4, thanks!

-- 
Thanks,
Sasha
