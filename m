Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 819B294B2A
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 19:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbfHSRCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 13:02:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726879AbfHSRCr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Aug 2019 13:02:47 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41B8A22CE9;
        Mon, 19 Aug 2019 17:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566234167;
        bh=S/EEkvOO0/hEPp16GlMcgRgGiMdnmBoldj92hrerFQM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RHZvBJhxTp/nMPx7U4ibmsnFlOhvVWDc/HUcwkpAH7PGStmmgR3P2OAPWnSuRf1Ei
         8HHIg4z2paez1BkDew7zQLgf10PQlD4gCqp1xVAY3yjMaRNZ773X2p6Pes6YUoHIB7
         6O00qmhsiJPdxeHJ/jjsTv6C7oKbkx4ivw8B5izk=
Date:   Mon, 19 Aug 2019 13:02:46 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Aaron Armstrong Skomra <skomra@gmail.com>
Cc:     linux-input@vger.kernel.org, jikos@kernel.org,
        benjamin.tissoires@redhat.com, ping.cheng@wacom.com,
        jason.gerecke@wacom.com,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
        "# v4 . 3+" <stable@vger.kernel.org>
Subject: Re: [PATCH] HID: wacom: correct misreported EKR ring values
Message-ID: <20190819170246.GA30205@sasha-vm>
References: <1566232914-9919-1-git-send-email-aaron.skomra@wacom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1566232914-9919-1-git-send-email-aaron.skomra@wacom.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 19, 2019 at 09:41:54AM -0700, Aaron Armstrong Skomra wrote:
>The EKR ring claims a range of 0 to 71 but actually reports
>values 1 to 72. The ring is used in relative mode so this
>change should not affect users.
>
>Signed-off-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
>Fixes: 72b236d60218f ("HID: wacom: Add support for Express Key Remote.")
>Cc: <stable@vger.kernel.org> # v4.3+
>Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
>Reviewed-by: Jason Gerecke <jason.gerecke@wacom.com>
>---
>Patch specifically targeted to v4.9.189

Is this not a problem upstream as well? Why not?

If it is, this patch will need to go upstream first, and then it'll get
to stable branches from there.

--
Thanks,
Sasha
