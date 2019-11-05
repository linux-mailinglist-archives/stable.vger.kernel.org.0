Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB4FBEFFCB
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 15:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730900AbfKEObN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 09:31:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:56006 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730869AbfKEObM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Nov 2019 09:31:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2C418B58C;
        Tue,  5 Nov 2019 14:31:11 +0000 (UTC)
Message-ID: <1572964268.2921.19.camel@suse.com>
Subject: Re: [PATCH 4.9 37/62] UAS: Revert commit 3ae62a42090f ("UAS: fix
 alignment of scatter/gather segments")
From:   Oliver Neukum <oneukum@suse.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Christoph Hellwig <hch@lst.de>
Date:   Tue, 05 Nov 2019 15:31:08 +0100
In-Reply-To: <20191104211940.713506931@linuxfoundation.org>
References: <20191104211901.387893698@linuxfoundation.org>
         <20191104211940.713506931@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Montag, den 04.11.2019, 22:44 +0100 schrieb Greg Kroah-Hartman:
>         All the host controllers capable of SuperSpeed operation can
>         handle fully general SG;
> 
>         Since commit ea44d190764b ("usbip: Implement SG support to
>         vhci-hcd and stub driver") was merged, the USB/IP driver can
>         also handle SG.

Not in 4.9.x. AFAICT the same story as 4.4.x
The patch is not strictly needed, but breaks UAS over usbip.

	Regards
		Oliver

