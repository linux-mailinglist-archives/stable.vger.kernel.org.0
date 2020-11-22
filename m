Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC372BC772
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 18:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgKVRRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 12:17:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:58960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727876AbgKVRRy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Nov 2020 12:17:54 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E07F2075A;
        Sun, 22 Nov 2020 17:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606065473;
        bh=ts8TCzRhEcispDdJYMvefat5deFu3he6iUPAKhUAmV0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WtOd8lZH+V8mCKh8vILDS9TfLpW89V+GOOgqE+B0WMwPpeOHkgwf0W8cO3cNzlfQp
         ZRy05TPN7EuREt0UdF5121vQOuTnNqQ1053uEIZH1/nrcYEMkhdr2JP2c1FUBkPt+l
         i4fKY1lg6qa3RmuEGXVqgiP3TFtZkjCinmmvwV0c=
Date:   Sun, 22 Nov 2020 12:17:52 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Burton <paul.burton@imgtec.com>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: request for 4.4-stable: 1eefcbc89cf3 ("MIPS: Fix
 BUILD_ROLLBACK_PROLOGUE for microMIPS")
Message-ID: <20201122171752.GF643756@sasha-vm>
References: <20201121141112.kz2t74nxo6txb5sk@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201121141112.kz2t74nxo6txb5sk@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 21, 2020 at 02:11:12PM +0000, Sudip Mukherjee wrote:
>Hi Greg, Sasha,
>
>Some mips builds of v4.4.y were failing. Please consider the attached
>backport of 1eefcbc89cf3 ("MIPS: Fix BUILD_ROLLBACK_PROLOGUE for microMIPS").

I'll grab it, thanks!

-- 
Thanks,
Sasha
