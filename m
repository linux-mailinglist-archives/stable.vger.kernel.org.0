Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC3AC998E
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 10:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbfJCIKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 04:10:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:51730 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728113AbfJCIKi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 04:10:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CEF66B126;
        Thu,  3 Oct 2019 08:10:36 +0000 (UTC)
Message-ID: <1570090234.18913.0.camel@suse.com>
Subject: Re: [PATCH] USB: microtek: fix info-leak at probe
From:   Oliver Neukum <oneukum@suse.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        syzbot+5630ca7c3b2be5c9da5e@syzkaller.appspotmail.com,
        linux-usb@vger.kernel.org, stable <stable@vger.kernel.org>
Date:   Thu, 03 Oct 2019 10:10:34 +0200
In-Reply-To: <20191003070931.17009-1-johan@kernel.org>
References: <0000000000000e235d0593f474ba@google.com>
         <20191003070931.17009-1-johan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Donnerstag, den 03.10.2019, 09:09 +0200 schrieb Johan Hovold:
> Add missing bulk-in endpoint sanity check to prevent uninitialised stack
> data from being reported to the system log and used as endpoint
> addresses.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable <stable@vger.kernel.org>
> Reported-by: syzbot+5630ca7c3b2be5c9da5e@syzkaller.appspotmail.com
> Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Oliver Neukum <oneukum@suse.com>
