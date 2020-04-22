Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47821B4E38
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 22:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgDVUO0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 16:14:26 -0400
Received: from imap3.hz.codethink.co.uk ([176.9.8.87]:53076 "EHLO
        imap3.hz.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgDVUO0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 16:14:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126] helo=xylophone)
        by imap3.hz.codethink.co.uk with esmtpsa  (Exim 4.92 #3 (Debian))
        id 1jRLlI-0003dS-3G; Wed, 22 Apr 2020 21:14:24 +0100
Message-ID: <9a4108b50032eb2ae22d3a136fbb74cacd47c60b.camel@codethink.co.uk>
Subject: [5.4] f2fs: fix to avoid memory leakage in f2fs_listxattr
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <Alexander.Levin@microsoft.com>
Cc:     stable <stable@vger.kernel.org>
Date:   Wed, 22 Apr 2020 21:14:18 +0100
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please pick:

commit 688078e7f36c293dae25b338ddc9e0a2790f6e06
Author: Randall Huang <huangrandall@google.com>
Date:   Fri Oct 18 14:56:22 2019 +0800

    f2fs: fix to avoid memory leakage in f2fs_listxattr

for the 5.4-stable branch.  It's also needed for earlier branches, but
needs adjustment so I will send a backport later.

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom

