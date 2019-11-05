Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52446EFFF9
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 15:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730869AbfKEOgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 09:36:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:59128 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730671AbfKEOgW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Nov 2019 09:36:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0CE08AC44;
        Tue,  5 Nov 2019 14:36:21 +0000 (UTC)
Message-ID: <1572964580.2921.21.camel@suse.com>
Subject: Re: [PATCH 4.19 114/149] UAS: Revert commit 3ae62a42090f ("UAS: fix
 alignment of scatter/gather segments")
From:   Oliver Neukum <oneukum@suse.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Christoph Hellwig <hch@lst.de>
Date:   Tue, 05 Nov 2019 15:36:20 +0100
In-Reply-To: <20191104212144.343422897@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
         <20191104212144.343422897@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Montag, den 04.11.2019, 22:45 +0100 schrieb Greg Kroah-Hartman:
>         Since commit ea44d190764b ("usbip: Implement SG support to
>         vhci-hcd and stub driver") was merged, the USB/IP driver can
>         also handle SG.

Hi,

same story as 4.4.x

	Regards
		Oliver

