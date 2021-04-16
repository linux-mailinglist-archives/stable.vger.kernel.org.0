Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9676362185
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 15:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235745AbhDPNzG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 09:55:06 -0400
Received: from lists.nic.cz ([217.31.204.67]:42124 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235464AbhDPNzF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Apr 2021 09:55:05 -0400
Received: from dellmb (unknown [IPv6:2001:1488:fffe:6:be02:5020:4be2:aff5])
        by mail.nic.cz (Postfix) with ESMTPSA id EB5D41409FC;
        Fri, 16 Apr 2021 15:54:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1618581280; bh=3zLHGzqpXiOFijTJd2eKBv8+LmxOxZvIGjl2GPyBxrw=;
        h=Date:From:To;
        b=jFMbcYHztMPfNJ90M41/vHcqBqFD53GdHRJ+BSbImb1zfob0iD5pqYKjznQg1oSqX
         efC+0dI02L8hIRmWNMT1g8vQvREy8JeIkSZVJKjtScIR5ZEGTdRgr4knBHqK4fzzsY
         STp+R9PA9NvxASxaFEx5dhoEjzGUJAgQlhCNoEo0=
Date:   Fri, 16 Apr 2021 15:54:00 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>,
        linux-pci@vger.kernel.org,
        =?UTF-8?B?UsO2dHRp?= 
        <espressobinboardarmbiantempmailaddress@posteo.de>,
        Pali =?UTF-8?B?Um9o?= =?UTF-8?B?w6Fy?= <pali@kernel.org>,
        stable@vger.kernel.org, Zachary Zhang <zhangzg@marvell.com>
Subject: Re: [PATCH] PCI: Add Max Payload Size quirk for ASMedia ASM1062
 SATA controller
Message-ID: <20210416155400.695f7629@dellmb>
In-Reply-To: <20210317224549.GA93134@bjorn-Precision-5520>
References: <20210317115924.31885-1-kabel@kernel.org>
        <20210317224549.GA93134@bjorn-Precision-5520>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 17 Mar 2021 17:45:49 -0500
Bjorn Helgaas <helgaas@kernel.org> wrote:

> Can you please open a report at bugzilla.kernel.org and attach the
> complete "sudo lspci -vv" output for both systems?  I think it's OK to
> collect these with the patch applied; we should still be able to see
> the information we use to compute the MPS values.  But please include
> the CONFIG_PCIE_BUS_* settings and any "pcie_bus_*" kernel command
> line arguments.

Bjorn, I have submitted a report on bugzilla 

https://bugzilla.kernel.org/show_bug.cgi?id=212695

is this enough?

Marek
