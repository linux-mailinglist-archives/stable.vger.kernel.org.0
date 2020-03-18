Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0577818A7D5
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 23:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgCRWOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 18:14:33 -0400
Received: from imap3.hz.codethink.co.uk ([176.9.8.87]:47432 "EHLO
        imap3.hz.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbgCRWOc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Mar 2020 18:14:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126] helo=xylophone)
        by imap3.hz.codethink.co.uk with esmtpsa  (Exim 4.92 #3 (Debian))
        id 1jEgxK-0001yT-Dc; Wed, 18 Mar 2020 22:14:30 +0000
Message-ID: <955a1f7af63548fb6a311c04329663961eb2b610.camel@codethink.co.uk>
Subject: [4.19] i2400m fixes
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <Alexander.Levin@microsoft.com>
Cc:     stable <stable@vger.kernel.org>
Date:   Wed, 18 Mar 2020 22:14:29 +0000
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please pick the following commits for the 4.19 branch:

2507e6ab7a9a wimax: i2400: fix memory leak
6f3ef5c25cc7 wimax: i2400: Fix memory leak in i2400m_op_rfkill_sw_toggle

I previously sent these to you for other stable branches, but
accidentally missed 4.19.

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom

