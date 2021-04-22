Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE2D368266
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 16:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236570AbhDVOYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 10:24:52 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:51852 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236398AbhDVOYv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Apr 2021 10:24:51 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id B43CF41382;
        Thu, 22 Apr 2021 14:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        mime-version:content-transfer-encoding:content-id:content-type
        :content-type:content-language:accept-language:in-reply-to
        :references:message-id:date:date:subject:subject:from:from
        :received:received:received:received; s=mta-01; t=1619101454; x=
        1620915855; bh=/FhBrEDX2nmpFWdFa02qGIRe/K4UGPET2M1GBVSWY5g=; b=X
        WhhUzFcAhMokqV4lrWMv7tjKPVH6e1oioHI0b5ynPecuURcdHUybQou2zTTI5arD
        qquyKH+4WIo1JIKLG9yKzvXZ+6JOylrDo0gQXfL9QztpG7XLq6Jr1V9938//Fajc
        DlaJv8wHSH/ifrsNXmDUmI9eh9KAzKyqF6gdhmZcqU=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id bTF4-5syA12f; Thu, 22 Apr 2021 17:24:14 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 777B4412E2;
        Thu, 22 Apr 2021 17:24:13 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (172.17.100.103) by
 T-EXCH-04.corp.yadro.com (172.17.100.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 22 Apr 2021 17:24:12 +0300
Received: from T-EXCH-03.corp.yadro.com ([fe80::39f4:7b05:b1d3:5272]) by
 T-EXCH-03.corp.yadro.com ([fe80::39f4:7b05:b1d3:5272%14]) with mapi id
 15.01.0669.032; Thu, 22 Apr 2021 17:24:13 +0300
From:   Anastasia Kovaleva <a.kovaleva@yadro.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>,
        "linux@yadro.com" <linux@yadro.com>
Subject: Re: [PATCH for-5.4 0/2] scsi: qla2xxx: Fix P2P mode
Thread-Topic: [PATCH for-5.4 0/2] scsi: qla2xxx: Fix P2P mode
Thread-Index: AQHXMjDf1yVSav1ZVkiN3VoZYLcCMKq3ALwAgAmhNgA=
Date:   Thu, 22 Apr 2021 14:24:13 +0000
Message-ID: <29D59EE6-9C42-4535-AD3D-A82528670FAE@yadro.com>
References: <20210415195144.91903-1-a.kovaleva@yadro.com>
 <YHmdRKaxSoKwbzZH@sashalap>
In-Reply-To: <YHmdRKaxSoKwbzZH@sashalap>
Accept-Language: ru-RU, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [172.17.204.113]
Content-Type: text/plain; charset="utf-8"
Content-ID: <CD097117E1CB9D498DA9295C46E846A6@yadro.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PlRoYW5rcyBmb3IgZGlhZ25vc2luZyB0aGlzIGlzc3VlISBQbGVhc2UgbGV0IG1lIGtub3cgaWYg
c29tZXRoaW5nIGlzDQo+c3RpbGwgYnJva2VuLg0KDQpIaSBTYXNoYSwNCg0KSSd2ZSB0ZXN0ZWQg
UDJQIG1vZGUgb24gdjUuNC4xMTQsIHRoZSBQMlAgbG9naW4gaXNzdWUgaXMgcmVzb2x2ZWQuDQoN
ClRoYW5rcyBhIGxvdCENCkFuYXN0YXNpYQ0KDQo=
