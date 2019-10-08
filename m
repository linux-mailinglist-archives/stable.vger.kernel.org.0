Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99B65D0398
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 00:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729178AbfJHWwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 18:52:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbfJHWwe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 18:52:34 -0400
Received: from localhost (unknown [131.107.159.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DA8321835;
        Tue,  8 Oct 2019 22:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570575154;
        bh=yFHygWZqS86l78m23Cj/INTyDSdEr4RgMKRtVcd3118=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l2fj4v/udVKnz30k8Rmei4flK2+HRot/fz84laqurQY4Gt6hNDxgfn94Y+HH6GYBu
         vM19d3LuP0XZrIknWgHKewGWfB5nx+2Kx9rXcPOmGNYqMIHC8gR1ogY0Np53wkMXg2
         b+E4wE5XV3bKNOMTRcypxXPbleL+C5T7B7wZN9ls=
Date:   Tue, 8 Oct 2019 18:52:33 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     aneesh.kumar@linux.ibm.com, mpe@ellerman.id.au,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] powerpc/book3s64/radix: Rename
 CPU_FTR_P9_TLBIE_BUG feature" failed to apply to 4.19-stable tree
Message-ID: <20191008225233.GI1396@sasha-vm>
References: <1570519950118156@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1570519950118156@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 08, 2019 at 09:32:30AM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 09ce98cacd51fcd0fa0af2f79d1e1d3192f4cbb0 Mon Sep 17 00:00:00 2001
>From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
>Date: Tue, 24 Sep 2019 09:22:52 +0530
>Subject: [PATCH] powerpc/book3s64/radix: Rename CPU_FTR_P9_TLBIE_BUG feature
> flag
>
>Rename the #define to indicate this is related to store vs tlbie
>ordering issue. In the next patch, we will be adding another feature
>flag that is used to handles ERAT flush vs tlbie ordering issue.
>
>Fixes: a5d4b5891c2f ("powerpc/mm: Fixup tlbie vs store ordering issue on POWER9")
>Cc: stable@vger.kernel.org # v4.16+
>Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
>Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>Link: https://lore.kernel.org/r/20190924035254.24612-2-aneesh.kumar@linux.ibm.com

Fixed up code movement and queued for 4.19.

-- 
Thanks,
Sasha
