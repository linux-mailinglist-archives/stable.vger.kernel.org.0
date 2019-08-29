Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04EE0A1BD1
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 15:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbfH2NuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 09:50:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:51626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbfH2NuZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 09:50:25 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3C092189D;
        Thu, 29 Aug 2019 13:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567086623;
        bh=Uh2uOq4Ob8d47W0KPG477Y07xsJB4CFrYSm7rfe/lpk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gnpWWrivvds3zCSxR7lT5mO2TVEjBrvDyEubxdQQAEQnUSQyMiQqQQyxGOE+jpNQR
         4rHTs2rgPcr1vbx3N77UeqLyrbklguPRfTZv0h/WXZA9n0uzFe8HgP8IYePfD/tdfv
         PkNRjFnKaPmyOg1+uoAtsdYKTedgNq9AU2Fdl0b8=
Date:   Thu, 29 Aug 2019 09:50:22 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kbuild test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 2/2] software node: Fix use of potentially uninitialized
 variable
Message-ID: <20190829135022.GI5281@sasha-vm>
References: <20190829132116.76120-1-heikki.krogerus@linux.intel.com>
 <20190829132116.76120-3-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190829132116.76120-3-heikki.krogerus@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 29, 2019 at 04:21:16PM +0300, Heikki Krogerus wrote:
>reported by smatch:
>drivers/base/swnode.c:71 software_node_to_swnode() error: uninitialized symbol 'swnode'.

Could you describe the actual problem it fixes? Under what scenario
would this issue occur and how would it manifest?

We're not here to fix smatch warnings, we're here to fix bugs that
smatch warns us about :)

--
Thanks,
Sasha
