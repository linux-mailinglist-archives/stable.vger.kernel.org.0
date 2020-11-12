Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3B92B0447
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 12:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbgKLLro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 06:47:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:46918 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728202AbgKLLlw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Nov 2020 06:41:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1605181307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X/n6UpDyJVwB5goaPNmbsDM4fZLd8WdN7ZS7QZYSWBc=;
        b=FzguKGOUo6kDKnHsaIA7oukI5xSjiIcH4VwZDbDprUL5euMZrNZUtH+cA2amv7Z/swbvkC
        9PVVZpvKyp0ApLHc3StJLUxIZPKKspCcu8j2qXb0HxJxmCGGWVqjMFlAa8nFjHk8v/7TFv
        Keh32ZZk/9WUAUQvg7MyZtTAEDGCl1E=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 31ACBAB95;
        Thu, 12 Nov 2020 11:41:47 +0000 (UTC)
Message-ID: <5e366bb0d11d1d2f95f964406dfe01fda59214af.camel@suse.com>
Subject: Re: [PATCH] usb: cdc-acm: Add DISABLE_ECHO for Renesas USB Download
 mode
From:   Oliver Neukum <oneukum@suse.com>
To:     Chris Brandt <chris.brandt@renesas.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Jesse Pfeister <jpfeister@fender.com>,
        stable <stable@vger.kernel.org>
Date:   Thu, 12 Nov 2020 12:41:44 +0100
In-Reply-To: <20201111131209.3977903-1-chris.brandt@renesas.com>
References: <20201111131209.3977903-1-chris.brandt@renesas.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Mittwoch, den 11.11.2020, 08:12 -0500 schrieb Chris Brandt:
> Renesas R-Car and RZ/G SoCs have a firmware download mode over USB.
> However, on reset a banner string is transmitted out which is not expected
> to be echoed back and will corrupt the protocol.
> 
> Signed-off-by: Chris Brandt <chris.brandt@renesas.com>
> Cc: stable <stable@vger.kernel.org>
Acked-by: Oliver Neukum <oneukum@suse.com>

