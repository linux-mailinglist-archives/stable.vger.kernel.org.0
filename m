Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8162FF35
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 17:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbfE3PRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 11:17:15 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:57604 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3PRO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 11:17:14 -0400
Received: from [167.98.27.226] (helo=xylophone)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1hWMnY-0008Bg-0Q; Thu, 30 May 2019 16:16:56 +0100
Message-ID: <1559229415.24330.2.camel@codethink.co.uk>
Subject: [stable] xen/pciback: Don't disable PCI_COMMAND on PCI device reset.
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc:     Prarit Bhargava <prarit@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        xen-devel@lists.xenproject.org, stable <stable@vger.kernel.org>
Date:   Thu, 30 May 2019 16:16:55 +0100
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm looking at CVE-2015-8553 which is fixed by:

commit 7681f31ec9cdacab4fd10570be924f2cef6669ba
Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date:   Wed Feb 13 18:21:31 2019 -0500

    xen/pciback: Don't disable PCI_COMMAND on PCI device reset.

I'm aware that this change is incompatible with qemu < 2.5, but that's
now quite old.  Do you think it makes sense to apply this change to
some stable branches?

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom
