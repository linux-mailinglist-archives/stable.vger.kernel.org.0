Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D745F1B873C
	for <lists+stable@lfdr.de>; Sat, 25 Apr 2020 17:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbgDYPAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Apr 2020 11:00:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbgDYPAc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 Apr 2020 11:00:32 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 764982071C;
        Sat, 25 Apr 2020 15:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587826831;
        bh=vLsTNvAtB8UdNTwK8YxWUdOCKQziYzomk2spCy9b7f8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CDrGzv+8QKY5rcp/D7K7PGok7MEPFBlMhUZUuM1PFbEHWmJofXmhXVQZiKPO1f7KT
         iGdjPeNtLO5GyK2AdW3DT2kfPdW3jT3B5GuPbwr0G+3CSBqvE4aNcqcFxFHxlZ1qHL
         rAD26tnSXILGIxhdzzohEdNsa7OlDxh+oyvWxVPA=
Date:   Sat, 25 Apr 2020 11:00:30 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Frederic Barrat <fbarrat@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH AUTOSEL 5.4 69/78] powerpc/powernv/ioda: Fix ref count
 for devices with their own PE
Message-ID: <20200425150030.GH13035@sasha-vm>
References: <20200418144047.9013-1-sashal@kernel.org>
 <20200418144047.9013-69-sashal@kernel.org>
 <b4fcb316-4fe8-47ec-81c7-4a79b0543b15@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b4fcb316-4fe8-47ec-81c7-4a79b0543b15@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 21, 2020 at 01:02:31PM +0200, Frederic Barrat wrote:
>
>
>Le 18/04/2020 à 16:40, Sasha Levin a écrit :
>>From: Frederic Barrat <fbarrat@linux.ibm.com>
>>
>>[ Upstream commit 05dd7da76986937fb288b4213b1fa10dbe0d1b33 ]
>
>
>This shouldn't be backported to stable.

I've dropped this and the other two commits you've pointed out from all
branches, thanks!

-- 
Thanks,
Sasha
