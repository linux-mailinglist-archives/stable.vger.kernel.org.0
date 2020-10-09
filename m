Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFFF289146
	for <lists+stable@lfdr.de>; Fri,  9 Oct 2020 20:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730740AbgJISiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 14:38:18 -0400
Received: from mail.csu.ru ([195.54.14.68]:49415 "HELO mail.csu.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
        id S1725852AbgJIShV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Oct 2020 14:37:21 -0400
X-Greylist: delayed 1932 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Oct 2020 14:37:11 EDT
Received: from webmail.csu.ru (webmail.csu.ru [195.54.14.80])
        (Authenticated sender: gmu)
        by mail.csu.ru (Postfix) with ESMTPA id 4EB68146ACE;
        Fri,  9 Oct 2020 23:04:42 +0500 (+05)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.csu.ru 4EB68146ACE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=csu.ru; s=lso;
        t=1602266691; bh=EHyoM7tvrYOQrxF04FX0pRVRvphefdiNsT3iXJDpiBo=;
        h=Date:Subject:From:Reply-To:From;
        b=AkU6a5Ug3MW1vmmjfxzJHROve1qzrVOskW98zPBWqwGHEY7b7Mk1v8Cs4hkNvHkEc
         mYC7pjQb/hzg21XefS4YRufwd4CLGeV/4uF6HTx1yjJ173s/gPzO74NQNDzDtmJw0i
         9Z/+ALP2ARxiQQV/SvHpecwaeAEu0CY0x8n6i71s=
Received: from 156.146.59.22
        (SquirrelMail authenticated user gmu)
        by webmail.csu.ru with HTTP;
        Fri, 9 Oct 2020 23:04:44 +0500
Message-ID: <4b858450690a3cf6ebdd989321b80c72.squirrel@webmail.csu.ru>
Date:   Fri, 9 Oct 2020 23:04:44 +0500
Subject: Vorschlag
From:   "Yi Huiman" <info@csu.ru>
Reply-To: info@huiman.cf
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
X-Priority: 3 (Normal)
Importance: Normal
X-KLMS-Rule-ID: 1
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Lua-Profiles: 159051 [Oct 09 2020]
X-KLMS-AntiSpam-Version: 5.9.11.0
X-KLMS-AntiSpam-Envelope-From: info@csu.ru
X-KLMS-AntiSpam-Auth: dmarc=none header.from=csu.ru;spf=softfail smtp.mailfrom=csu.ru;dkim=none
X-KLMS-AntiSpam-Rate: 70
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Info: LuaCore: 381 381 faef97d3f9d8f5dd6a9feadc50ba5b34b9486c58, {rep_avail}, {Tracking_content_type, plain}, {Prob_reply_not_match_from}, {Prob_to_header_missing}, {Prob_Reply_to_without_To}, {Tracking_susp_macro_from_formal}, webmail.csu.ru:7.1.1;csu.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;huiman.cf:7.1.1;127.0.0.199:7.1.2;195.54.14.80:7.1.2, ApMailHostAddress: 195.54.14.80
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2020/10/09 16:54:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2020/10/09 00:29:00 #15463494
X-KLMS-AntiVirus-Status: Clean, skipped
Content-Transfer-Encoding: quoted-printable
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ich habe ein Gesch=E4ft Vorschlag f=FCr dich.

