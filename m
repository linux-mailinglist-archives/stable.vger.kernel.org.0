Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29EEC1BE7F3
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 21:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgD2T5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 15:57:22 -0400
Received: from mailout06.rmx.de ([94.199.90.92]:57115 "EHLO mailout06.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbgD2T5W (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Apr 2020 15:57:22 -0400
Received: from kdin02.retarus.com (unknown [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout06.rmx.de (Postfix) with ESMTPS id 49C8Rz3K94z9wX3
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 21:57:19 +0200 (CEST)
Received: from ppmail.arri.de (unknown [217.111.95.7])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 49C8Rw4nMFz2TRlL
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 21:57:16 +0200 (CEST)
Received: from mta.arri.de ([192.168.100.141]) by ppmail.arri.de over TLS secured channel with Microsoft SMTPSVC(7.0.6002.18264);
         Wed, 29 Apr 2020 21:57:16 +0200
Received: from n95hx1g2.localnet (192.168.54.16) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Wed, 29 Apr
 2020 21:57:14 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     <stable@vger.kernel.org>
CC:     Christian Berger <Christian.Berger@de.bosch.com>,
        =?utf-8?B?0JrQvtGH0LXRgtC60L7QsiDQnNCw0LrRgdC40Lw=?= 
        <fido_max@inbox.ru>, Richard Weinberger <richard@nod.at>
Subject: Missing UBIFS patch in linux-5.4.y branch
Date:   Wed, 29 Apr 2020 21:57:14 +0200
Message-ID: <2210477.bKEgftg5c8@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.16]
X-OriginalArrivalTime: 29 Apr 2020 19:57:16.0292 (UTC) FILETIME=[61F18440:01D61E60]
X-RMX-ID: 20200429-215716-49C8Rw4nMFz2TRlL-0@172
X-RMX-SOURCE: 217.111.95.7
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

subject of the patch:
ubifs: Fix ubifs_tnc_lookup() usage in do_kill_orphans()

the commit ID:
4ab25ac8b2b5514151d5f91cf9514df08dd26938

why you think it should be applied: 
I ran into the problem fixed by this patch on linux-5.4.28-rt19.
After applying this patch to my internal tree, the problem
was solved.

and what kernel version you wish it to be applied to.
linux-5.4.y (tested by me) and maybe others




