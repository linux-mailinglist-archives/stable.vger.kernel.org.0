Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCC42EAB2D
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 13:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728950AbhAEMuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 07:50:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:41290 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728006AbhAEMuV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Jan 2021 07:50:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 487B0AD0B;
        Tue,  5 Jan 2021 12:49:39 +0000 (UTC)
Message-ID: <f66f965e30ab44bb3a9a2c0f63383e603011932d.camel@suse.de>
Subject: Re: [PATCH] usb: uas: Add PNY USB Portable SSD to unusual_uas
From:   Oliver Neukum <oneukum@suse.de>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        usb-storage@lists.one-eyed-alien.net
Cc:     stable@vger.kernel.org, linux-usb@vger.kernel.org
Date:   Tue, 05 Jan 2021 13:49:35 +0100
In-Reply-To: <2edc7af892d0913bf06f5b35e49ec463f03d5ed8.1609819418.git.Thinh.Nguyen@synopsys.com>
References: <2edc7af892d0913bf06f5b35e49ec463f03d5ed8.1609819418.git.Thinh.Nguyen@synopsys.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Montag, den 04.01.2021, 20:07 -0800 schrieb Thinh Nguyen:
> Here's another variant PNY Pro Elite USB 3.1 Gen 2 portable SSD that
> hangs and doesn't respond to ATA_1x pass-through commands. If it doesn't
> support these commands, it should respond properly to the host. Add it
> to the unusual uas list to be able to move forward with other
> operations.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Acked-by: Oliver Neukum <oneukum@suse.com>

