Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3E764462A
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730480AbfFMQtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:49:31 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:33449 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725859AbfFMEaq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 00:30:46 -0400
Received: from tarshish (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 9A8F144030A;
        Thu, 13 Jun 2019 07:30:34 +0300 (IDT)
User-agent: mu4e 1.0; emacs 26.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     stable@vger.kernel.org
Cc:     Erik =?utf-8?Q?=C4=8Cuk?= <erik.cuk@domel.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: rtc: pcf8523: don't return invalid date when battery is low
Date:   Thu, 13 Jun 2019 07:30:34 +0300
Message-ID: <877e9qt8d1.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi stable kernel team,

Please consider upstream commit ecb4a353d3afd45 ("rtc: pcf8523: don't
return invalid date when battery is low") for stable backport. As the
commit log explains, this fixes bogus system date when RTC backup
battery is low.  With this fix date is set to the well known 01-01-1970
value instead.

This commit should be applicable to v4.9+.

Thanks,
baruch

--
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
