Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7863DF195
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 17:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236691AbhHCPcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 11:32:39 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:34804 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236593AbhHCPci (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 11:32:38 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B143D200E0;
        Tue,  3 Aug 2021 15:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628004746; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6OSGPF5D3q2JVOZFpz/DvWMm2k1bbReM2uj7mjlJYE4=;
        b=oZHbQhBn1C2LmR02dutvb14acpqmuNknv0BhcGeMdv3uRwLRp+n+jy32/l/hhflLEjobVj
        Ej83IJ1ZlF7lCcehxTog55L6zU2qHOPcNuX9yZT4/sm0DcHB9yIFAPvK0lTJE3iGHDaD2+
        PdbfB0vXWhNySVWwz5LS/vVNXXQlBeA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628004746;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6OSGPF5D3q2JVOZFpz/DvWMm2k1bbReM2uj7mjlJYE4=;
        b=ZmXcoS0024uai/HmjA25bhV/Nph9in9Uy5KqMAhxMcZI82DT3WPJeK9oLIFWZ+OqnQ3+tw
        FVL9emYRQbRBMYDQ==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 3E9BA13B68;
        Tue,  3 Aug 2021 15:32:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id rmcYC4phCWFBeQAAGKfGzw
        (envelope-from <jdelvare@suse.de>); Tue, 03 Aug 2021 15:32:26 +0000
Date:   Tue, 3 Aug 2021 17:32:24 +0200
From:   Jean Delvare <jdelvare@suse.de>
To:     Jan Kiszka <jan.kiszka@siemens.com>
Cc:     linux-watchdog@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Michael Marley <michael@michaelmarley.com>
Subject: Re: Faulty commit "watchdog: iTCO_wdt: Account for rebooting on
 second timeout"
Message-ID: <20210803173224.7bdfcbc7@endymion>
In-Reply-To: <e13f45c4-70e2-e2c2-9513-ce38c8235b4f@siemens.com>
References: <20210803165108.4154cd52@endymion>
        <e13f45c4-70e2-e2c2-9513-ce38c8235b4f@siemens.com>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 3 Aug 2021 16:59:02 +0200, Jan Kiszka wrote:
> https://lkml.org/lkml/2021/7/26/349

For the record, I tested this fix successfully on my system (as in: no
more random reboots).

Tested-by: Jean Delvare <jdelvare@suse.de>

Thanks,
-- 
Jean Delvare
SUSE L3 Support
