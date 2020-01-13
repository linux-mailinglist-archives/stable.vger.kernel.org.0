Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 636A6139D40
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 00:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbgAMX1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 18:27:16 -0500
Received: from imap3.hz.codethink.co.uk ([176.9.8.87]:43130 "EHLO
        imap3.hz.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728769AbgAMX1Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jan 2020 18:27:16 -0500
X-Greylist: delayed 1483 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jan 2020 18:27:15 EST
Received: from [167.98.27.226] (helo=xylophone)
        by imap3.hz.codethink.co.uk with esmtpsa  (Exim 4.92 #3 (Debian))
        id 1ir8j8-00032E-MC; Mon, 13 Jan 2020 23:02:30 +0000
Message-ID: <d91f97da6e3a36c9b2d1ec8a9c613ffcc2391cbe.camel@codethink.co.uk>
Subject: [5.4-stable] Driver memory fixes
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <Alexander.Levin@microsoft.com>
Cc:     stable <stable@vger.kernel.org>
Date:   Mon, 13 Jan 2020 23:02:29 +0000
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please pick the following commits for 5.4-stable:

3d94a4a8373b mwifiex: fix possible heap overflow in mwifiex_process_country_ie()
bbe692e349e2 rpmsg: char: release allocated memory
db8fd2cde932 mwifiex: pcie: Fix memory leak in mwifiex_pcie_alloc_cmdrsp_buf
0e62395da2bd scsi: bfa: release allocated memory in case of error
a2cdd07488e6 rtl8xxxu: prevent leaking urb
b8d17e7d93d2 ath10k: fix memory leak

They all apply and build cleanly.

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom

