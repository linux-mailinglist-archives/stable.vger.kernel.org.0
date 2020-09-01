Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375A125859D
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 04:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgIACbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 22:31:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725993AbgIACba (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 22:31:30 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88A2820719;
        Tue,  1 Sep 2020 02:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598927489;
        bh=FA7S3BVx+mwO58Pg438IhBFhTwFtN6C9KrPhP3fnsyQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qnWmKKOn+JXg6ltmPGWCwMOAyj0mcl/oSi6H+thVzQJeLrTX0wjBDIyiJuJJJ4Qxp
         GJcFu72Y7wiHdfFNUPm/FZY6g79OlWHepVuYj9ZyWo/wZ6SzCFSLBR6KEHb/m7SISo
         mHodnbG9EvbfK84NbfbGkjOZKdziWSeu+ozXyJGU=
Date:   Mon, 31 Aug 2020 22:31:28 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc:     gregkh@linuxfoundation.org, jarkko.sakkinen@linux.intel.com,
        stable@vger.kernel.org, Stefan Berger <stefanb@linux.ibm.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>
Subject: Re: [PATCH for-4.19] tpm: Unify the mismatching TPM space buffer
 sizes
Message-ID: <20200901023128.GE8670@sasha-vm>
References: <20200831185929.2696998-1-stefanb@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200831185929.2696998-1-stefanb@linux.vnet.ibm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 31, 2020 at 02:59:29PM -0400, Stefan Berger wrote:
>From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>
>The size of the buffers for storing context's and sessions can vary from
>arch to arch as PAGE_SIZE can be anything between 4 kB and 256 kB (the
>maximum for PPC64). Define a fixed buffer size set to 16 kB. This should be
>enough for most use with three handles (that is how many we allow at the
>moment). Parametrize the buffer size while doing this, so that it is easier
>to revisit this later on if required.
>
>Cc: stable@vger.kernel.org
>Reported-by: Stefan Berger <stefanb@linux.ibm.com>
>Fixes: 745b361e989a ("tpm: infrastructure for TPM spaces")
>Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
>Tested-by: Stefan Berger <stefanb@linux.ibm.com>
>Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

I've queued this and the 4.14 backport, thanks!

-- 
Thanks,
Sasha
