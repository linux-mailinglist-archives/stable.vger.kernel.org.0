Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D39A2182808
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 06:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387739AbgCLFII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 01:08:08 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:60540 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387676AbgCLFIH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Mar 2020 01:08:07 -0400
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id C6355C0F79;
        Thu, 12 Mar 2020 05:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1583989686; bh=n6rRsgWTaWMb6aTt70cDBXpWxLAJuSAu67GVLhmJnI0=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=aqNXVN+fhb/labHVMJNQA/tWJBzBAoMrdIWqQXgo1y/l7AkYdb0XtzErAG94hXG1/
         0Hd9zzfOOtaDibI3dg/NCJ+8Ei/vHySRWw/hOHDlgUk6btTCEx1WLgMm/VbIh8/E6J
         Ql9jDOT93/RF8r1vrdbqAYCNEd2zGC6S08zH8txzNThOjVXkA5gj6Vdkp7mYuDoluI
         HiBRS3LFWlbq2dE4nqWBPy7XJp3OVndrntOnUNLZLDl81VSLpQbPssy+LwGAhgDlq0
         cB4IBqCnS3lDiKlGyhWKNXU1551tfRRvCGc2PO4g2T4fu0DiM7NeQq68tEST2Y9ukK
         CEwfgXxWH4ivw==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id C5A15A0091;
        Thu, 12 Mar 2020 05:08:00 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 11 Mar 2020 22:07:45 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 11 Mar 2020 22:07:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FvGfaTJmqXS9XBVUxBIavkdfmTMlelKQL/iBNSwwfC1t9v4n8aJUabH9k1O/GDyvAAqTzvBpskkSbGLYzOkYiiPi/+F7APyQAK/PRho35BoZHBggUkGmr3afBGundohcqyLynTkdb/DWjtFInHxFQ6LmNKO2qwwyzPtgq+75vbv1v58Ky+5eKfHLpVx4pzOuCi40vxH6c5u6LTTcQ3bzqxnQwDS6oG8fItU2rsylKN9U21LUh6kHJiMN/JwhDEGOXFKplU+Zv1Lt89u+Exls4DlN86khqeqayFgbaAjFNmTiT5qdCTfNnAr4vIYQVE1HOV9qfPyFLANxIvFQrQRMig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TN4bLkuc0g1eGKCt7BoKdT9j4woJcHH2eq9937bnMkM=;
 b=e+sr2rS2U393F2O93qMUsXbKrhgTrnZkFUDDZ7NbNU+JRwo4baghhrqCEUZe35BpgVK3Ts6xhCUKAMOGgOQTdwXa6XNDVnsCFYaGy1LhUxhtGV822T1Rvxzt2ThPDE69+PkwzWsaPHyh9EXm0r+lL7O5dqYGzmyupKbcrj+E4eld+mSlfwwMcl1E7TVQHstq0sczUi9PhNiUNiGzFMJsP6OqGS5jpy+m0kRhrxxWurGX60Gm7vKx+kHHQxWRefyKfoR02pqXKjDsBH8D0IHdYuLZfbzDaJJ37AWeD9HvwHsTP012LUJXqzj1UyyAXxTP144TTsIOQktHQWXgedPLAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TN4bLkuc0g1eGKCt7BoKdT9j4woJcHH2eq9937bnMkM=;
 b=SdITBpnkrF4iojTcpaTjpoDPB24+v4TMI1PcFToSSyYwOHLbLnwtwpc8d4tQcjHXBYzxQMTxNe1/43DVCv4k2pNflpegCpg5ZoIcUaSOXx/4VwsQTDpIstx5H+CjBQm+SQTWGyeVh6lbJK57TLJmrcgEfQr/wnI0trr0vFrM5rQ=
Received: from CY4PR1201MB0120.namprd12.prod.outlook.com
 (2603:10b6:910:1c::14) by CY4PR1201MB0040.namprd12.prod.outlook.com
 (2603:10b6:910:1b::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Thu, 12 Mar
 2020 05:07:43 +0000
Received: from CY4PR1201MB0120.namprd12.prod.outlook.com
 ([fe80::744c:4e95:39be:9d44]) by CY4PR1201MB0120.namprd12.prod.outlook.com
 ([fe80::744c:4e95:39be:9d44%12]) with mapi id 15.20.2793.018; Thu, 12 Mar
 2020 05:07:43 +0000
From:   Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
Subject: RE: [PATCH] DRM: ARC: PGU: interlaced mode not supported
Thread-Topic: [PATCH] DRM: ARC: PGU: interlaced mode not supported
Thread-Index: AQHV96bp/V5nm7FKPEO5H8ws3IVb16hDYMAAgAEHV3A=
Date:   Thu, 12 Mar 2020 05:07:43 +0000
Message-ID: <CY4PR1201MB01209514869D4C361AC6DA57A1FD0@CY4PR1201MB0120.namprd12.prod.outlook.com>
References: <20200311131310.20446-1-Eugeniy.Paltsev@synopsys.com>
 <20200311132152.GA3902788@kroah.com>
In-Reply-To: <20200311132152.GA3902788@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYWJyb2RraW5c?=
 =?us-ascii?Q?YXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRi?=
 =?us-ascii?Q?YTI5ZTM1Ylxtc2dzXG1zZy02NWM1Zjk5OS02NDFmLTExZWEtODAzMi04OGIx?=
 =?us-ascii?Q?MTFjZGUyMTdcYW1lLXRlc3RcNjVjNWY5OWItNjQxZi0xMWVhLTgwMzItODhi?=
 =?us-ascii?Q?MTExY2RlMjE3Ym9keS50eHQiIHN6PSIyMzMzIiB0PSIxMzIyODQ2MzI2MTI2?=
 =?us-ascii?Q?MTM0NjMiIGg9IlBzNUZLWUdRcjZlTUdiTFBtSzExQUtzdkhVWT0iIGlkPSIi?=
 =?us-ascii?Q?IGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUJRSkFB?=
 =?us-ascii?Q?QlhMUjRvTFBqVkFhL1hqM0lsUUJkSHI5ZVBjaVZBRjBjT0FBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFIQUFBQUNrQ0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFFQUFRQUJBQUFBTW9OL3h3QUFBQUFBQUFBQUFBQUFBSjRBQUFCbUFHa0Fi?=
 =?us-ascii?Q?Z0JoQUc0QVl3QmxBRjhBY0FCc0FHRUFiZ0J1QUdrQWJnQm5BRjhBZHdCaEFI?=
 =?us-ascii?Q?UUFaUUJ5QUcwQVlRQnlBR3NBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR1lBYndCMUFHNEFaQUJ5QUhrQVh3?=
 =?us-ascii?Q?QndBR0VBY2dCMEFHNEFaUUJ5QUhNQVh3Qm5BR1lBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
 =?us-ascii?Q?QUFBQUNlQUFBQVpnQnZBSFVBYmdCa0FISUFlUUJmQUhBQVlRQnlBSFFBYmdC?=
 =?us-ascii?Q?bEFISUFjd0JmQUhNQVlRQnRBSE1BZFFCdUFHY0FYd0JqQUc4QWJnQm1BQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJtQUc4?=
 =?us-ascii?Q?QWRRQnVBR1FBY2dCNUFGOEFjQUJoQUhJQWRBQnVBR1VBY2dCekFGOEFjd0Jo?=
 =?us-ascii?Q?QUcwQWN3QjFBRzRBWndCZkFISUFaUUJ6QUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHWUFid0IxQUc0QVpBQnlBSGtB?=
 =?us-ascii?Q?WHdCd0FHRUFjZ0IwQUc0QVpRQnlBSE1BWHdCekFHMEFhUUJqQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFD?=
 =?us-ascii?Q?QUFBQUFBQ2VBQUFBWmdCdkFIVUFiZ0JrQUhJQWVRQmZBSEFBWVFCeUFIUUFi?=
 =?us-ascii?Q?Z0JsQUhJQWN3QmZBSE1BZEFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQm1B?=
 =?us-ascii?Q?RzhBZFFCdUFHUUFjZ0I1QUY4QWNBQmhBSElBZEFCdUFHVUFjZ0J6QUY4QWRB?=
 =?us-ascii?Q?QnpBRzBBWXdBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdZQWJ3QjFBRzRBWkFCeUFI?=
 =?us-ascii?Q?a0FYd0J3QUdFQWNnQjBBRzRBWlFCeUFITUFYd0IxQUcwQVl3QUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFB?=
 =?us-ascii?Q?QUNBQUFBQUFDZUFBQUFad0IwQUhNQVh3QndBSElBYndCa0FIVUFZd0IwQUY4?=
 =?us-ascii?Q?QWRBQnlBR0VBYVFCdUFHa0FiZ0JuQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFC?=
 =?us-ascii?Q?ekFHRUFiQUJsQUhNQVh3QmhBR01BWXdCdkFIVUFiZ0IwQUY4QWNBQnNBR0VB?=
 =?us-ascii?Q?YmdBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBSE1BWVFCc0FHVUFjd0Jm?=
 =?us-ascii?Q?QUhFQWRRQnZBSFFBWlFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFB?=
 =?us-ascii?Q?QUFBQ0FBQUFBQUNlQUFBQWN3QnVBSEFBY3dCZkFHd0FhUUJqQUdVQWJnQnpB?=
 =?us-ascii?Q?R1VBWHdCMEFHVUFjZ0J0QUY4QU1RQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFB?=
 =?us-ascii?Q?QUJ6QUc0QWNBQnpBRjhBYkFCcEFHTUFaUUJ1QUhNQVpRQmZBSFFBWlFCeUFH?=
 =?us-ascii?Q?MEFYd0J6QUhRQWRRQmtBR1VBYmdCMEFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFIWUFad0JmQUdzQVpR?=
 =?us-ascii?Q?QjVBSGNBYndCeUFHUUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFB?=
 =?us-ascii?Q?QUFBQUFDQUFBQUFBQT0iLz48L21ldGE+?=
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=abrodkin@synopsys.com; 
x-originating-ip: [183.89.24.137]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 80c89079-187e-454c-2c6b-08d7c6434c1c
x-ms-traffictypediagnostic: CY4PR1201MB0040:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR1201MB0040E6378C759095FDE5AE50A1FD0@CY4PR1201MB0040.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0340850FCD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(346002)(39860400002)(376002)(396003)(199004)(7696005)(107886003)(66446008)(76116006)(6506007)(53546011)(66476007)(64756008)(66556008)(66946007)(2906002)(6916009)(86362001)(966005)(8676002)(478600001)(81156014)(52536014)(33656002)(55016002)(9686003)(81166006)(8936002)(4326008)(71200400001)(54906003)(5660300002)(316002)(26005)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR1201MB0040;H:CY4PR1201MB0120.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v0PRen37Mr5R1Ty2K8u4RQA1EZcCCRHpWIDhh9TIpdBSa8jIn69gxWSSizf9NpnwooQq05QP+aYpLOOsM3rkWSATW67vnOpqcRKHuyKvneyWW283PIF52vJvTBQaFdxZLMEBEtnQlJ6e5Cyi+fIrQ5d5SwdngMMXVVfIhQLbxdUaJoxqztULX8PS4cfZPpEOBxt5AE7yRxuV9Govy/xHypmBLsZQgX00z36DPvq2/e5DayV3j6GymeYknc3/s4huwGw3ylN5CoiviEOvwNO5i65VrP5iPaus5sSnSaltGSJONaQz5atspqvIdhloDK7eAx/ERX90/aEte/ieihd8Bpo1mFhW2TihHfwVV40V5RMbAEpu8kLrZ+jBlh3eFngwAsRi6biIvQGnpHHGkDnoGJFwfNVmNyS8ITkuZ0scpga/NbCY0Yj5CuQ1igbMLWz/eRY5zcgCIy5U1wlBiGB17ibrkS65rYJ3fzENA/Krgt9Jpcur+77BGdvjLNnA9v29D0IGBbLdWc3APOOJs7wa+Q==
x-ms-exchange-antispam-messagedata: rjSwTKX3/Z3mXWGr1E5MB3eP50fkS1/jCxwqOOYH5UjXDtww0J0ObMg12y22NK90kEH/AWBeACTTFmGYFM9bXDsuHTl8qgZF6HCD8UMGyW5RcnEfEyXz9DAjisDnCDeWEHzq6dZl+b5RjfpSFHXjsQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 80c89079-187e-454c-2c6b-08d7c6434c1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2020 05:07:43.7508
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uij73lDJi7xXS+09klapBj8QWy/m/uKw8X4xRHQVLWEBf82KhElfJckwPUbVKa+cYsrdsa/ARxriSIzPjZdukg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0040
X-OriginatorOrg: synopsys.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Wednesday, March 11, 2020 8:22 PM
> To: Eugeniy Paltsev <paltsev@synopsys.com>
> Cc: dri-devel@lists.freedesktop.org; Alexey Brodkin <abrodkin@synopsys.co=
m>; linux-snps-
> arc@lists.infradead.org; linux-kernel@vger.kernel.org; David Airlie <airl=
ied@linux.ie>; Daniel Vetter
> <daniel@ffwll.ch>; stable@vger.kernel.org
> Subject: Re: [PATCH] DRM: ARC: PGU: interlaced mode not supported
>=20
> On Wed, Mar 11, 2020 at 04:13:10PM +0300, Eugeniy Paltsev wrote:
> > Filter out interlaced modes as they are not supported by ARC PGU
> > hardware.
> >
> > Signed-off-by: Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
> > ---
> >  drivers/gpu/drm/arc/arcpgu_crtc.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/gpu/drm/arc/arcpgu_crtc.c b/drivers/gpu/drm/arc/ar=
cpgu_crtc.c
> > index 8ae1e1f97a73..c854066d4c75 100644
> > --- a/drivers/gpu/drm/arc/arcpgu_crtc.c
> > +++ b/drivers/gpu/drm/arc/arcpgu_crtc.c
> > @@ -67,6 +67,9 @@ static enum drm_mode_status arc_pgu_crtc_mode_valid(s=
truct drm_crtc *crtc,
> >  	long rate, clk_rate =3D mode->clock * 1000;
> >  	long diff =3D clk_rate / 200; /* +-0.5% allowed by HDMI spec */
> >
> > +	if (mode->flags & DRM_MODE_FLAG_INTERLACE)
> > +		return MODE_NO_INTERLACE;
> > +
> >  	rate =3D clk_round_rate(arcpgu->clk, clk_rate);
> >  	if ((max(rate, clk_rate) - min(rate, clk_rate) < diff) && (rate > 0))
> >  		return MODE_OK;
> > --
> > 2.21.1
> >
>=20
> <formletter>
>=20
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://urldefense.proofpoint.com/v2/url?u=3Dhttps-
> 3A__www.kernel.org_doc_html_latest_process_stable-2Dkernel-
> 2Drules.html&d=3DDwIBAg&c=3DDPL6_X_6JkXFx7AXWqB0tg&r=3DlqdeeSSEes0GFDDl65=
6eViXO7breS55ytWkhpk5R81I&m=3DoXPD1Sz
> FBs-0-4u24Ah1rK1Y65Fma8tJZix0Jih-yqY&s=3DWTVW1dC7E2oD0muPxtNd9KAHzwIZwEU9=
jGuCHWx1iQk&e=3D
> for how to do this properly.
>=20
> </formletter>

Thanks for the comment. I'll add "Cc: stable@vger.kernel.org" tag to the
patch on committing it to my maintainer tree so one the patch makes its way
up to the Linus' tree you'll get notified as usual.

-Alexey
