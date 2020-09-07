Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8429C2606DB
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 00:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgIGWUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 18:20:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726446AbgIGWU0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 18:20:26 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02B1F215A4;
        Mon,  7 Sep 2020 22:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599517226;
        bh=POwIZrc3jundMX/1zFDV+2LUCeiFEqghK1av9Hb76OU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X5fXeoxRIe/18MD+6uwPL9odkxQ1Dujt2S4pvYo09VuZjz+F4mXBHzFsQMGcVjxUU
         MC7CFjFo4Z72T+qhzRGtHtFtBl0jyd6LyEc3LkCD/LwFmc07OmGoqjlMxX5MqhKWSS
         FOTAKOWcOyI985CavZGzJ8CO8fzavEVAQeYxOrIg=
Date:   Mon, 7 Sep 2020 18:20:24 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Max Chou <max.chou@realtek.com>,
        Felix =?iso-8859-1?Q?D=F6rre?= <debian@felixdoerre.de>
Subject: Re: Please apply commit 24b065727ceb ("Bluetooth: Return NOTIFY_DONE
 for hci_suspend_notifier") to v5.8.y
Message-ID: <20200907222024.GP8670@sasha-vm>
References: <20200907200437.GA908020@eldamar.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200907200437.GA908020@eldamar.local>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 07, 2020 at 10:04:37PM +0200, Salvatore Bonaccorso wrote:
>Hi
>
>Please apply the commit 24b065727ceb ("Bluetooth: Return NOTIFY_DONE
>for hci_suspend_notifier") to the v5.8.y branch as well. As the commit
>message says it fixes actually an issue:
>
>> The original return is NOTIFY_STOP, but notifier_call_chain would stop
>> the future call for register_pm_notifier even registered on other Kernel
>> modules with the same priority which value is zero.
>
>The commit misses a Fixes tag on 9952d90ea288 ("Bluetooth: Handle
>PM_SUSPEND_PREPARE and PM_POST_SUSPEND") and so was not backported as
>well.
>
>This was affecting Felix Dörre (https://bugs.debian.org/964839#65)
>with an out of tree module, but as the commit explains the issue seem
>to be more general.

Queued up, thanks!

-- 
Thanks,
Sasha
