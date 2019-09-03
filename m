Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74CFDA748E
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 22:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbfICUVP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 16:21:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbfICUVP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 16:21:15 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4377621883;
        Tue,  3 Sep 2019 20:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567542074;
        bh=cBzIGGTiODtRVJXfSA4DKLs/6XgUja9tZtSmGCoeVkA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BBzy2XpK1LOW+c2coxNsKUZzFPnpRJEWhp/TL19Ot+JcUmjlmjc4nYHREk4N/5Vxw
         kqXgzZmuyTr0e8KhcRcPhUMfEoGkHPCnDNaDkcjATnFEm6WVOzzyH4eRCcW3Jjnbqm
         zy3dz88dxLup9/DQiCRcWuNfGyJkdRuA0lMkQCnE=
Date:   Tue, 3 Sep 2019 16:21:13 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     aik@ozlabs.ru, paulus@ozlabs.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: PPC: Book3S: Fix incorrect
 guest-to-user-translation" failed to apply to 4.19-stable tree
Message-ID: <20190903202113.GK5281@sasha-vm>
References: <156753601315657@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <156753601315657@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 03, 2019 at 08:40:13PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.

I've fixed it up for 4.19 and 4.14. The issue was mostly due to missing
2001825efcea7 ("KVM: PPC: Book3S HV: Avoid lockdep debugging in TCE
realmode handlers").

--
Thanks,
Sasha
