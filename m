Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B11A18A7BB
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 23:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbgCRWJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 18:09:24 -0400
Received: from imap2.colo.codethink.co.uk ([78.40.148.184]:32780 "EHLO
        imap2.colo.codethink.co.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726619AbgCRWJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Mar 2020 18:09:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126] helo=xylophone)
        by imap2.colo.codethink.co.uk with esmtpsa  (Exim 4.92 #3 (Debian))
        id 1jEgsL-0003I5-Qt; Wed, 18 Mar 2020 22:09:22 +0000
Message-ID: <2082b1e11fdbf3b64f0da022fb15a8b615c3678c.camel@codethink.co.uk>
Subject: [stable] locks: fix a potential use-after-free problem when wakeup
 a waiter
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <Alexander.Levin@microsoft.com>
Cc:     stable <stable@vger.kernel.org>
Date:   Wed, 18 Mar 2020 22:09:20 +0000
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This commit (included in 5.6-rc5) seems to be needed for 5.4 and 5.5
branches:

commit 6d390e4b5d48ec03bb87e63cf0a2bff5f4e116da
Author: yangerkun <yangerkun@huawei.com>
Date:   Wed Mar 4 15:25:56 2020 +0800

    locks: fix a potential use-after-free problem when wakeup a waiter

I'm a bit surprised that it hasn't yet been applied, while some fixes
from 5.6-rc6 have.

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom

