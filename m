Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D352C674A
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 14:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730049AbgK0N6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 08:58:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730041AbgK0N6k (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Nov 2020 08:58:40 -0500
X-Greylist: delayed 494 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 27 Nov 2020 05:58:39 PST
Received: from mx3.securetransport.de (mx3.securetransport.de [IPv6:2a01:4f8:c0c:92be::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6B2C0613D1
        for <stable@vger.kernel.org>; Fri, 27 Nov 2020 05:58:39 -0800 (PST)
Received: from mail.dh-electronics.com (business-24-134-97-169.pool2.vodafone-ip.de [24.134.97.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx3.securetransport.de (Postfix) with ESMTPSA id 835B45DD13
        for <stable@vger.kernel.org>; Fri, 27 Nov 2020 14:50:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dh-electronics.com;
        s=dhelectronicscom; t=1606485019;
        bh=AWfMb5jpnFJ19ofIKsFIQVOqZBLuUbvfaXBgKgY7vws=;
        h=From:To:Subject:Date:From;
        b=up/WD9hlyR85M1/ilejKTC9eKjXI/IzftlUP4xAGfcggtM8Bx7nhO+hqGrDFKIVBA
         LlQ7ZVi7C+tYiUfkjr35D4wki0o7bqSVPLqGFDDcJ7cRgITAnvQj/6psuPYuekJnKX
         cj2ddIXA7cBUQNhrt12yuuiRqW/EdNYPcZdYI1HrRnx0Q267S8ysiJRJkYjIgNa5ZO
         V4hSl8TKqwjQ5vQN1ee4SSP3oWKugt8YTfL7885Kgze4Zf1yJEVyTbRcNLaMcLp+we
         D/6hHMWmgSJYXlPS37Cwz3kMIFWRIEhMj4jrQjUHLa6nS7G8XlF1lxvd1cEUAU8lnB
         i7v29uLITwHsg==
Received: from DHPWEX01.DH-ELECTRONICS.ORG (2001:470:76a7:2::30) by
 DHPWEX01.DH-ELECTRONICS.ORG (2001:470:76a7:2::30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.659.4;
 Fri, 27 Nov 2020 14:50:10 +0100
Received: from DHPWEX01.DH-ELECTRONICS.ORG ([fe80::6ced:fa7f:9a9c:e579]) by
 DHPWEX01.DH-ELECTRONICS.ORG ([fe80::6ced:fa7f:9a9c:e579%6]) with mapi id
 15.02.0659.008; Fri, 27 Nov 2020 14:50:10 +0100
X-secureTransport-forwarded: yes
From:   Christoph Niedermaier <cniedermaier@dh-electronics.com>
Complaints-To: abuse@cubewerk.de
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Missing fixes commit on linux-4.19.y
Thread-Topic: Missing fixes commit on linux-4.19.y
Thread-Index: AdbExCWIB6Z0M2MSQfq9plHp14n48g==
Date:   Fri, 27 Nov 2020 13:50:10 +0000
Message-ID: <86287ab712444551b3740703a8092aa8@dh-electronics.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.64.3.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

Is it possible to apply the following commit on the branch linux-4.19.y?
de9f8eea5a44 ("drm/atomic_helper: Stop modesets on unregistered connectors =
harder")

This commit is applied to the other LTS kernels, but is missing on
linux-4.19.y. Without this patch my i.MX6ULL SoM doesn't initialize
the display correctly after booting.

Thanks in advance,
Christoph

___________________________________________________________________________=
_________
DH electronics GmbH | Am Anger 8 | 83346 Bergen | Germany | Fon: +49 8662 4=
882 0
HRB Traunstein 9602 | Ust Id Nr.: DE174205805
Board of Management | Dipl.-Ing.(FH) Stefan Daxenberger | Dipl.-Ing.(FH) He=
lmut Henschke

