Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A90C1A12AD
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 19:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgDGR1C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 13:27:02 -0400
Received: from mailout07.rmx.de ([94.199.90.95]:48401 "EHLO mailout07.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726277AbgDGR1B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 13:27:01 -0400
X-Greylist: delayed 1908 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Apr 2020 13:27:01 EDT
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout07.rmx.de (Postfix) with ESMTPS id 48xYRy36PQzBtp9
        for <stable@vger.kernel.org>; Tue,  7 Apr 2020 18:55:10 +0200 (CEST)
Received: from ppmail.arri.de (unknown [217.111.95.7])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 48xYRv4M2wz2xDR
        for <stable@vger.kernel.org>; Tue,  7 Apr 2020 18:55:07 +0200 (CEST)
Received: from mta.arri.de ([192.168.100.141]) by ppmail.arri.de over TLS secured channel with Microsoft SMTPSVC(7.0.6002.18264);
         Tue, 7 Apr 2020 18:55:06 +0200
Received: from n95hx1g2.localnet (192.168.54.39) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Tue, 7 Apr
 2020 18:55:06 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     <stable@vger.kernel.org>
CC:     Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawnguo@kernel.org>
Subject: Missing patches related to ARM_ERRATA_814220 in linux-5.4.y branch
Date:   Tue, 7 Apr 2020 18:52:22 +0200
Message-ID: <48084060.SnRd2sqJNp@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.39]
X-OriginalArrivalTime: 07 Apr 2020 16:55:07.0092 (UTC) FILETIME=[4A8B7140:01D60CFD]
X-RMX-ID: 20200407-185507-48xYRv4M2wz2xDR-0@kdin01
X-RMX-SOURCE: 217.111.95.7
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

subject of the patch:
ARM: imx: Enable ARM_ERRATA_814220 for i.MX6UL and i.MX7D

the commit ID:
4562fa4c86c92a2df635fe0697c9e06379738741

why you think it should be applied: 
ARM_ERRATA_814220 is already available in v5.4.x, but not yet automatically selected for i.MX6UL(L)

and what kernel version you wish it to be applied to.
linux-5.4.y



subject of the patch:
ARM: imx: only select ARM_ERRATA_814220 for ARMv7-A

the commit ID:
c74067a0f776c1d695a713a4388c3b6a094ee40a

why you think it should be applied: 
This is a follow up for the previous patch.

and what kernel version you wish it to be applied to.
linux-5.4.y










