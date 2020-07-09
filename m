Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4707D21959A
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 03:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbgGIB1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 21:27:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725982AbgGIB1h (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jul 2020 21:27:37 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70D9D20739;
        Thu,  9 Jul 2020 01:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594258056;
        bh=rgIJIT6h9+jSvr31lBXUMHr0PI7lL+rZsPS91ImM10s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kxan13qQ4EfocnnjcutzbdSSn39uvQii+R5/Dz9zjeXrdOxYkhLxu9teH2j3bjXmr
         MIhXXogtpxPJBTK+IcXc1dn0S0cCMhDrn6ywwf8JsKa3Jnm+fs2AXlItgccnOm+J3q
         4PfG/l9NeLLrsg9S8fpIAvjb49VASwMgLGvhVX8Q=
Date:   Wed, 8 Jul 2020 21:27:35 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Maurizio Drocco <maurizio.drocco@ibm.com>,
        Bruno Meneguele <bmeneg@redhat.com>,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.7 03/30] ima: extend boot_aggregate with kernel
 measurements
Message-ID: <20200709012735.GX2722994@sasha-vm>
References: <20200708154116.3199728-1-sashal@kernel.org>
 <20200708154116.3199728-3-sashal@kernel.org>
 <1594224793.23056.251.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1594224793.23056.251.camel@linux.ibm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 08, 2020 at 12:13:13PM -0400, Mimi Zohar wrote:
>Hi Sasha,
>
>On Wed, 2020-07-08 at 11:40 -0400, Sasha Levin wrote:
>> From: Maurizio Drocco <maurizio.drocco@ibm.com>
>>
>> [ Upstream commit 20c59ce010f84300f6c655d32db2610d3433f85c ]
>>
>> Registers 8-9 are used to store measurements of the kernel and its
>> command line (e.g., grub2 bootloader with tpm module enabled). IMA
>> should include them in the boot aggregate. Registers 8-9 should be
>> only included in non-SHA1 digests to avoid ambiguity.
>
>Prior to Linux 5.8, the SHA1 template data hashes were padded before
>being extended into the TPM.  Support for calculating and extending
>the per TPM bank template data digests is only being upstreamed in
>Linux 5.8.
>
>How will attestation servers know whether to include PCRs 8 & 9 in the
>the boot_aggregate calculation?  Now, there is a direct relationship
>between the template data SHA1 padded digest not including PCRs 8 & 9,
>and the new per TPM bank template data digest including them.

Got it, I'll drop it then, thank you!

-- 
Thanks,
Sasha
