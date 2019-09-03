Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96A7BA766D
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 23:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbfICVn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 17:43:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbfICVn3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 17:43:29 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4C4A22CF7;
        Tue,  3 Sep 2019 21:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567547008;
        bh=H4egSEv5FjxaUYXP6J54vNyFj12cJZ7NqtMrOXorqP8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PU/UmuVf/qscyisa8lZl+3YfDUkqcuifBWlschWWacbFGy3xJXqtS7W/oWxIcl7QH
         mYla15yH3QUFAPxgUnipunnrUmQs4g6HVBFPIJj5J85BdtdBjXa/MgbFM+VDpIhGfq
         FVc7KzUl2chMnf1fl5/2W82ApzLRVpYaG3VmO3oA=
Date:   Tue, 3 Sep 2019 17:43:27 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     andrew.cooks@opengear.com, jdelvare@suse.de, wsa@the-dreams.de,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] i2c: piix4: Fix port selection for AMD
 Family 16h Model 30h" failed to apply to 4.19-stable tree
Message-ID: <20190903214327.GU5281@sasha-vm>
References: <15675374782510@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15675374782510@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 03, 2019 at 09:04:38PM +0200, gregkh@linuxfoundation.org wrote:
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.

I've fixed it up to work around missing 24beb83ad289c ("i2c-piix4: Add
Hygon Dhyana SMBus support") and queued it for 4.19, 4.14, and 4.9. It's
not needed on 4.4.

--
Thanks,
Sasha
