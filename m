Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BEB8479C9F
	for <lists+stable@lfdr.de>; Sat, 18 Dec 2021 21:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234171AbhLRUpE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 18 Dec 2021 15:45:04 -0500
Received: from u12.atthost.pl ([185.255.40.32]:33176 "EHLO u12.atthost.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232208AbhLRUpE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Dec 2021 15:45:04 -0500
X-Greylist: delayed 323 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Dec 2021 15:45:03 EST
Received: from localhost (unknown [127.0.0.1])
        by u12.atthost.pl (Postfix) with ESMTP id 8A59D634AC;
        Sat, 18 Dec 2021 20:39:35 +0000 (UTC)
X-Virus-Scanned: amavisd-new at atthost.pl
Received: from u12.atthost.pl ([185.255.40.32])
        by localhost (atthost.pl [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ANJuBeLBD5iv; Sat, 18 Dec 2021 21:39:27 +0100 (CET)
Received: from dell.localnet (staticline-195-234-21-179.toya.net.pl [195.234.21.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: tomasz@cebula.eu.org)
        by u12.atthost.pl (Postfix) with ESMTPSA id E19AE63809;
        Sat, 18 Dec 2021 21:39:26 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 u12.atthost.pl E19AE63809
From:   "Tomasz C." <tlinux@cebula.eu.org>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     tlinux@cebula.eu.org, linux-input@vger.kernel.org,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: FWD: Holtek mouse stopped working after kernel upgrade from 5.15.7 to 5.15.8
Date:   Sat, 18 Dec 2021 21:39:25 +0100
Message-ID: <4366861.LvFx2qVVIh@dell>
In-Reply-To: <fc7e6040-b760-02f1-57ef-71aa4b88aea6@leemhuis.info>
References: <e4efbf13-bd8d-0370-629b-6c80c0044b15@leemhuis.info> <42903605-7e8b-4e84-fcd6-1b23169b8639@redhat.com> <fc7e6040-b760-02f1-57ef-71aa4b88aea6@leemhuis.info>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

I haven't had time to test it yet. But I see that another ArchLinux user has 
compiled kernel 5.15.10 with this patch and confirms that the mouse works.
Details on:
https://bugs.archlinux.org/task/73048#comment204441

Is this enough for you as a test?

-- 
Tomasz Cebula
Dnia piątek, 17 grudnia 2021 09:37:11 CET Thorsten Leemhuis pisze:

> Tomasz, could you give it a try please?



