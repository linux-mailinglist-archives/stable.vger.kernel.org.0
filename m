Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3DB611EB1B
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 20:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728833AbfLMTYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Dec 2019 14:24:19 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:46856 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728631AbfLMTYT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Dec 2019 14:24:19 -0500
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 9D26F4060D;
        Fri, 13 Dec 2019 19:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576265058; bh=2HCRCMT0lnlcQv2rNYIM7SDUCX0x+USzVcUkgTa4nGE=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=Z7EiXKi7bboj2NlcwZDEgkcjnexg8nY8/doTgIDuILWTJ7pgVMFtPVLmKjLIU1xxE
         LHMhcWtWoNBvydVQABaBVBYQFjzzbHM7dQ/NkTVv4H7XkGOyCGXE9YY90QSWfh+FzX
         WPRlkkMUQcPc7w8jEEyZs42AdxuyRjRo3KlQkd9H7EMyudZm8PjtbaSqDuxYabOl6b
         tIfFJpLNedSdRULgE6/pdcyEqqAwmDxEBCRDkDpmZMY9XZpYCFqklBVtnDdRZ24xgZ
         ZUGbCGZE+q+3V6vAK3y/VwJJaBAXiMxFF3SCtFIgQI0Z86jMA/3vOal5jJM172vQmY
         Q8SqVHgdfY7Ww==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 5B7D2A0083;
        Fri, 13 Dec 2019 19:24:15 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 13 Dec 2019 11:23:14 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Fri, 13 Dec 2019 11:23:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ob7ctWhJJR6BP+Npxbd1qCVwkabbwmxgiRf16OBQ19DW9QSFbSJdeXHrfGPH23iryQ50G4oI2S+5I53mBHQbHMs50TiYne/sc7VccFBICSAspeeEtXLe8LZkfkD3ukmqQAhXJrVvQJGReHEAISoHQxo8gGvbNBrW+8rSrxeH38MuzrNYi1a5fiEK0JwRpVl81IJ9ZnTnfYbKVJlmGofBoL16zAHMGepFW+6046iz+0RzZmd+BMaG4KbRkZHVTVCh7Qk1n6tE90CV66kYIYw6fuIlQBi2TxW+4fQwdpD3sS7DijBOtSz8OhhyZmea967ywJeOb27qe56S7fIuBxC+yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NNw5wB0KY74oDpB/om061AlnENyOa34FNMdaWiNhm+w=;
 b=fxxj/+m3sAju4g0IOvXxZfkTdMH5FzTPJiGL0RqQc+lW0AQ8xIxKqfKLJC02tsl3VQsiTfN6bMOsIRSa5VfLadPqbPmrLG4tanj6IJpafwqsRalHpQ9U83mAin05X09hoURN38WAeqJJ/z1WD5Mbz8T6alTDkyQVQRFDgblBieVFmrom7pk+Ii+3fYGY4niF+CaDF6hx/rerCVUuY4H4r77WR985KNKOm7J6DpmFG0LMMM80Bs2cO66D63x0Tu5BwOtlaXwVcmqCY9ESPJ73KdeihbNuZEBioFFqyy8sLPHsi6HQyK1UGJSIKBs+Wh7TfaeZ8DN8Tg2ZiRW0sgktjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NNw5wB0KY74oDpB/om061AlnENyOa34FNMdaWiNhm+w=;
 b=ArSoiCfr046loQDvc3lexM1bJLqL0q3yHl8iaEgZVsYUiiOSQ4J8+wDwdWau+8altH/lir7WMY0uazjfdn3sQNjRYeEheg4DoJalgBH0sctGyFkfNCvnhTphZoep030sZDk12zISeMcH42eMmJWVJnVJWuSwXi0YSlu3x1SK5ds=
Received: from CY4PR1201MB0037.namprd12.prod.outlook.com (10.172.78.22) by
 CY4PR1201MB2485.namprd12.prod.outlook.com (10.172.117.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Fri, 13 Dec 2019 19:23:12 +0000
Received: from CY4PR1201MB0037.namprd12.prod.outlook.com
 ([fe80::5d88:202f:2fff:24b4]) by CY4PR1201MB0037.namprd12.prod.outlook.com
 ([fe80::5d88:202f:2fff:24b4%8]) with mapi id 15.20.2516.018; Fri, 13 Dec 2019
 19:23:12 +0000
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 099/243] usb: dwc3: debugfs: Properly print/set link
 state for HS
Thread-Topic: [PATCH 4.19 099/243] usb: dwc3: debugfs: Properly print/set link
 state for HS
Thread-Index: AQHVsDaLtpPSN5OMLk2Tn5J854A5uKe30MGAgACkVYA=
Date:   Fri, 13 Dec 2019 19:23:12 +0000
Message-ID: <f3c4d47c-ae00-1b5a-1894-d48da26ed5fd@synopsys.com>
References: <20191211150339.185439726@linuxfoundation.org>
 <20191211150345.799359877@linuxfoundation.org> <20191213093501.GA27976@amd>
In-Reply-To: <20191213093501.GA27976@amd>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=thinhn@synopsys.com; 
x-originating-ip: [149.117.75.11]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 71f00fef-6d6b-4503-189f-08d78001e547
x-ms-traffictypediagnostic: CY4PR1201MB2485:
x-microsoft-antispam-prvs: <CY4PR1201MB2485AEBC2E60ECD5B950BA2CAA540@CY4PR1201MB2485.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:612;
x-forefront-prvs: 0250B840C1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(376002)(39860400002)(136003)(346002)(189003)(199004)(36756003)(4744005)(81166006)(8676002)(4001150100001)(31696002)(478600001)(86362001)(8936002)(4326008)(31686004)(5660300002)(81156014)(26005)(6486002)(76116006)(66446008)(186003)(54906003)(2616005)(2906002)(64756008)(71200400001)(66556008)(6506007)(66476007)(6512007)(110136005)(66946007)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR1201MB2485;H:CY4PR1201MB0037.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vEgq3T7HcI1Y5agguSDf3y5T57jfhMsPEFlvJ90JWg0b/02MnWkrVfgyzdHHCxBnXePBvfg6JlE1m2UzFrmISt8PjNWwYqhCx2Ygqcd/+K/t6YCzOunn9SSK2bRO62VJ/qeAojtEmAR+3BPZKYGBphKPBTk7BRsdnDVL8EVMBNGkWVNW4brwq8XJxONJo0w07FlHsyN7ZnbksumILSH0SDcH1dLmyH77Vvlm6OhXbyz1pFt++8e8JY5OdksdMAMKNl0pobQGt1q+42otOzhiBlkyUkaQSyfxRg3lom8HIw8StVlhh/WJSX8KxHp5vZDJ8d8tOFUn/ytQPcrd/+oAaVqm3x8ooB1B/S2ZKxkxQvhWpll21mDCPBIvOZ1x146b+s1zAMDFlQB+JAnA/Ev5/yFNdAxk51NVr4dGRsKIqwufg3DQUA+jObGChQl1/t/x
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <081814DAFDBAA84CB1F8929E6A500D21@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 71f00fef-6d6b-4503-189f-08d78001e547
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2019 19:23:12.5099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E5ZXhiiJDGwv9q/mdKDwSMCzgFyi/16LvmQRnand2LO/BdzoawGlttscfWc1Hgd6ABIUHLIpVotc29JKIU9xWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB2485
X-OriginatorOrg: synopsys.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Pavel Machek wrote:
> On Wed 2019-12-11 16:04:21, Greg Kroah-Hartman wrote:
>> From: Thinh Nguyen <thinh.nguyen@synopsys.com>
>>
>> [ Upstream commit 0d36dede457873404becd7c9cb9d0f2bcfd0dcd9 ]
>>
>> Highspeed device and below has different state names than superspeed and
>> higher. Add proper checks and printouts of link states for highspeed and
>> below.
> This is debugfs, so I don't believe it was suitable for stable in the
> first place, but....
>
>
>> +	case DWC3_LINK_STATE_RESUME:
>> +		return "Resume";
>> +	default:
>> +		return "UNKNOWN link state\n";
>> +	}
> You may want to delete \n here, it will be duplicated if this ever
> triggers.

We already fixed it upstream:
038761ce68c2 ("usb: dwc3: debug: Remove newline printout")

> Best regards,
> 								Pavel

BR
Thinh
