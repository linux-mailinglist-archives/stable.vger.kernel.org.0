Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7B22BBC4
	for <lists+stable@lfdr.de>; Mon, 27 May 2019 23:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfE0VbH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 17:31:07 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:52425 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbfE0VbH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 May 2019 17:31:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126] helo=xylophone)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1hVNCz-0002U5-GM; Mon, 27 May 2019 22:31:05 +0100
Message-ID: <1558992664.2631.12.camel@codethink.co.uk>
Subject: [stable] Security fixes for brcmfmac
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <Alexander.Levin@microsoft.com>
Cc:     stable <stable@vger.kernel.org>
Date:   Mon, 27 May 2019 22:31:04 +0100
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please pick the following fixes to brcmfmac for the 4.14, 4.19, and 5.0
stable branches:

1b5e2423164b brcmfmac: assure SSID length from firmware is limited
a4176ec356c7 brcmfmac: add subtype check for event handling in data path

They are also needed for earlier branches, but they don't apply cleanly
so I will send patches later.

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom
