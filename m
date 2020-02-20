Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8F411661F7
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 17:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbgBTQMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 11:12:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:33062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728493AbgBTQMN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Feb 2020 11:12:13 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CF9B20658;
        Thu, 20 Feb 2020 16:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582215133;
        bh=7sh9tmZCNa/XG2MFk6jwAzLZ290b8gu6jJpshQH8oBk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Tw6lme9cckLT8eZtoLZ70Lm5AzuDcvbStw+EMEzKYsN1j6lkpTcp5avqdF8UJRLUF
         Jv2+WimGHRjAJYL9cy6ojcPmcejgLEosDQKOYH6yUcHM1c6tvZTJa9A1rTAQUU+49O
         cNPyqrZk/gATUiD+2SQgllJOlko0vPz4wcLJqCDw=
Date:   Thu, 20 Feb 2020 11:12:12 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Frederic Barrat <fbarrat@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH AUTOSEL 5.5 096/542] powerpc/powernv/ioda: Fix ref count
 for devices with their own PE
Message-ID: <20200220161212.GC1734@sasha-vm>
References: <20200214154854.6746-1-sashal@kernel.org>
 <20200214154854.6746-96-sashal@kernel.org>
 <0867167a-73b8-0735-78ce-0d984f7a80b5@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0867167a-73b8-0735-78ce-0d984f7a80b5@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 17, 2020 at 09:49:41AM +0100, Frederic Barrat wrote:
>
>
>Le 14/02/2020 à 16:41, Sasha Levin a écrit :
>>From: Frederic Barrat <fbarrat@linux.ibm.com>
>>
>>[ Upstream commit 05dd7da76986937fb288b4213b1fa10dbe0d1b33 ]
>
>
>Hi,
>
>Upstream commit 05dd7da76986937fb288b4213b1fa10dbe0d1b33 doesn't 
>really need to go to stable (any of 4.19, 5.4 and 5.5). While it's 
>probably safe, the patch replaces a refcount leak by another one, 
>which makes sense as part of the full series merged in 5.6-rc1, but 
>isn't terribly useful standalone on the current stable branches.

I'll drop it, thank you.

-- 
Thanks,
Sasha
