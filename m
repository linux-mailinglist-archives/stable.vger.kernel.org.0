Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC25496D95
	for <lists+stable@lfdr.de>; Sat, 22 Jan 2022 20:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiAVTSm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jan 2022 14:18:42 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46904 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiAVTSl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jan 2022 14:18:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27126B80AB4;
        Sat, 22 Jan 2022 19:18:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85EDC004E1;
        Sat, 22 Jan 2022 19:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642879118;
        bh=+uDpqTIZtAPLAYnQOlLFD/r2FjMhHDDcoyocz5WLUFM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V02UAbNKS3W/97afYLqmJWJaqrkPfXvj2B1Bz1djJnAxHOZHAyR0f6e8VkhaC5ieM
         if7DZr3twNMNUaNIchkHHjtuuFUuPijx5IXBsOKL2X74fHx2hYBrD+mimDnKrLefyB
         ak5nLL76UdWZWkw8ZFlKbnL8s7qvN4bguLf3LdBeww6HKaodR1QymrXXL1IA9vpoYI
         QMGsv8rSMv4tbnMm9UkfZBKhTM3ax0o2LbS54mNILSMesjAYOO76ROaUpa195QGKkb
         fQanrEhp0h4c9IOiJHLCni/CIzJ8NQdIPBWYR/YDj+zB3Vn1823Szl99CsnhMItejW
         huvvL6AQWzHNg==
Date:   Sat, 22 Jan 2022 14:18:37 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>, gor@linux.ibm.com,
        egorenar@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, ebiederm@xmission.com,
        valentin.schneider@arm.com, rppt@kernel.org, iii@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.15 081/188] s390/nmi: add missing __pa/__va
 address conversion of extended save area
Message-ID: <YexYjV+Cm3RoLRk9@sashalap>
References: <20220118023152.1948105-1-sashal@kernel.org>
 <20220118023152.1948105-81-sashal@kernel.org>
 <aef11e2f-2b92-e713-a407-3bebf9b3340d@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aef11e2f-2b92-e713-a407-3bebf9b3340d@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18, 2022 at 09:18:40AM +0100, Christian Borntraeger wrote:
>Am 18.01.22 um 03:30 schrieb Sasha Levin:
>>From: Heiko Carstens <hca@linux.ibm.com>
>>
>>[ Upstream commit 402ff5a3387dc8ec6987a80d3ce26b0c25773622 ]
>>
>>Add missing __pa/__va address conversion of machine check extended
>>save area designation, which is an absolute address.
>>
>
>vv
>>Note: this currently doesn't fix a real bug, since virtual addresses
>>are indentical to physical ones.
>^^
>
>Sasha,
>please note the disclaimer above. There will be plenty of such fixes
>in s390 code and there is no point in backporting single fixes to stable.
>It will provide no benefit on its own but adds a risk of regression.

Sure, I'll drop it. Thanks!

-- 
Thanks,
Sasha
