Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA3333E014
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 22:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbhCPVMB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 16 Mar 2021 17:12:01 -0400
Received: from smtp.econet.co.zw ([77.246.51.158]:12653 "EHLO
        ironportDMZ.econet.co.zw" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231460AbhCPVLe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 17:11:34 -0400
IronPort-SDR: iUPdYPtFjkAQNOWGFlfPvrM7CB6fHyPQcV26LURIbGqeTqsffA3KEs6bgEfZDEYrpUzrqnlIFD
 kEm+n/VWHps30JYtTgAnnGlkjLtY+f/C5G9FFXA7DNlSqBkmq4JH2C7blL97OPBpDNXu+kdKON
 L56I2UFHOpT448xJxH7nBI4VBOeJMvf0Z90RRrquPiKp/HxTvIOq0EsomedP1JZPQLzaP/brmA
 zTJm7vDcKNDtEhxOPv9JSFZUkwDb6k1oi/ctZIXtkCHs4O0e2P7hEVro5v67C0fbV9pRlgVAZP
 0uA=
X-IronPort-AV: E=Sophos;i="5.81,254,1610402400"; 
   d="scan'208";a="6224323"
X-IPAS-Result: =?us-ascii?q?A2D//wDi6VBg/yNlqMADV4EQFoFwgQszgQgBHER9XYJmO?=
 =?us-ascii?q?Ig6gzEsgU07OYM4iAuIL4o2DIFcCwEBAQEBAQEBAQkxAQIEAQGBBg6CdT4DA?=
 =?us-ascii?q?QFIDAEBAQEDAoEdFRE4EwUBAQEDAgMBAQIBBwEBAQEFAwEBhhgMBxQdAoFMA?=
 =?us-ascii?q?QEPSAEBARwBBAEBAQEBAQEBAQEDAQEMAYNXAQIQBAEBAxcRAiABGRMCCAIBD?=
 =?us-ascii?q?QMOBgwSBBcBBBEJCQodAQwIAgECAgEBJCaCFoJVATEPrRiBMRoCFoUUgkgGg?=
 =?us-ascii?q?lMJAYEGgg6KZIE2BoIMJoJihVwNBQERAgFfglgTPIIQgU8PN2ATIxsWKRNFK?=
 =?us-ascii?q?xVPEQkwAUIDhjiJZyUvinqBepwQBwODAod/i22ISSuBDIIyilyFawODZYwnA?=
 =?us-ascii?q?bJBgQ6EIoFrgQpwgQWBWQoYGIFQERmHY4dsAQKNQiQxd1MIEgEKAYslAQEBA?=
 =?us-ascii?q?QICAQKBQl0BAQ?=
IronPort-PHdr: A9a23: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
 KspWsCZtxPYNxBWfsQikRIZ
IronPort-HdrOrdr: A9a23:BPWaXKviiTHot9Lka0UcCfqA7skD2NV00zAX/kB9WHVpW+afkN
 2jm+le6AT9jywfVGpltdeLPqSBRn20z+8X3aA6O7C+UA76/Fa5NY0K1+vf6hDpBiGWzIBg/I
 h6dawWMrHNJHxbqeq/3wWiCdYnx7C8kZyAoevF1X9iQUVLRshbnmFEIz2WGEF3WwVKbKBRfP
 H32uN9qyOkaTAraK2Aa0UtZOTfu8bN0KvvfB9uPW9e1CC1kTiq5LTmeiL24j4iVVp0sM4f2F
 mAtzbc7qWn98ihyhnG13LChq4m/efJ+59mDMyIhtN9EESJti+YIKBgX7GlmRxdmpDJ1H8a1O
 DWoxE6P9ligkmhHF2InQ==
Received: from unknown (HELO wvale-jmb-svr-1.econetzw.local) ([192.168.101.35])
  by ironportLAN.econet.co.zw with ESMTP; 16 Mar 2021 04:20:58 +0200
Received: from WVALE-MB-SVR-10.econetzw.local (192.168.101.149) by
 wvale-jmb-svr-1.econetzw.local (192.168.101.35) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Tue, 16 Mar 2021 04:20:14 +0200
Received: from WVALE-CAS-SVR-9.econetzw.local (192.168.101.184) by
 wvale-mb-svr-10.econetzw.local (192.168.101.149) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Tue, 16 Mar 2021 04:20:10 +0200
Received: from User (165.231.148.189) by WVALE-CAS-SVR-9.econetzw.local
 (10.10.11.230) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 16 Mar 2021 04:20:31 +0200
Reply-To: <reem2018@daum.net>
From:   "Reem E. A" <ecosure@econet.co.zw>
Subject: HOW ARE YOU?
Date:   Tue, 16 Mar 2021 03:20:09 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="Windows-1251"
Content-Transfer-Encoding: 8BIT
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2600.0000
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2600.0000
Message-ID: <1ce819f580524bfdb41ea05b5619c4ee@WVALE-CAS-SVR-9.econetzw.local>
To:     Undisclosed recipients:;
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Friend

My name is Ms. Reem Ebrahim Al-Hashimi, I am the "Minister of state
for International Cooperation" in UAE. I write to you on behalf of
my other "two (2) colleagues" who has Authorized me to solicit for
your "partnership in claiming of {us$47=Million}" from a Financial
Home on their behalf and for our "Mutual Benefits".

The said Fund {us$47=Million} is our share from the (over-invoiced) Oil/Gas
deal with Turkish Government within 2013/2014. Because of the nature of the
deal we don't want our government to know about the fund that is why we
decided to contact you. If this proposal interests you, let me know, by
sending me an email and I will send to you detailed information on how this
business would be successfully transacted. Be informed that nobody knows about
the secret of this fund except us, and we know how to carry out the entire
transaction. So I am compelled to ask, that you will stand on our behalf and
receive this fund into any account that is solely controlled by you.

We will compensate you with 15% of the total amount involved as
gratification for being our partner in this transaction. Reply to:
 reem.alhashimi@yandex.com

Regards,
Ms. Reem.
This mail was sent through Econet Wireless, a Global telecoms leader.

DISCLAIMER

The information in this message is confidential and is legally privileged. It is intended solely for the addressee. Access to this message by anyone else is unauthorized. If received in error please accept our apologies and notify the sender immediately. You must also delete the original message from your machine. If you are not the intended recipient, any use, disclosure, copying, distribution or action taken in reliance of it, is prohibited and may be unlawful. The information, attachments, opinions or advice contained in this email are not the views or opinions of Econet Wireless, its subsidiaries or affiliates. Econet Wireless therefore accepts no liability for claims, losses, or damages arising from the inaccuracy, incorrectness, or lack of integrity of such information.
[https://mail.econet.co.zw/OWA/auth/current/themes/resources/Agile/AgileBanner.png]
WORK ISN'T A PLACE
IT'S WHAT WE DO
________________________________

EcoSure



[https://mail.econet.co.zw/OWA/auth/current/themes/resources/Agile/telephone.png]




[https://mail.econet.co.zw/OWA/auth/current/themes/resources/Agile/email.png]

ecosure@econet.co.zw<mailto:ecosure@econet.co.zw>


[https://mail.econet.co.zw/OWA/auth/current/themes/resources/Agile/location.png]




[https://mail.econet.co.zw/OWA/auth/current/themes/resources/Agile/website.png]

www.econet.co.zw<https://www.econet.co.zw>


[https://mail.econet.co.zw/OWA/auth/current/themes/resources/Agile/inspired.jpg]
