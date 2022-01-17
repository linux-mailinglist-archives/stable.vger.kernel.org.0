Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A17E4911D8
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 23:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235794AbiAQWni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 17:43:38 -0500
Received: from mail-dm6nam11on2080.outbound.protection.outlook.com ([40.107.223.80]:50940
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232161AbiAQWnh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jan 2022 17:43:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RX99JLXJ8bMXLbVtt0wlcBZHMXBcvd91V7YL5AQoQa0n4IVqH/MVq+ESu0f6pi7XRZDeU8NybFjp/j1CuiuDRAd4BHXEoQmzmy3ruVKNnIaavWSya6w5V0Ue2qnIT9t/9nCrEDUJaJgoVq/Lh3FWY/jn5LGDNpFMWRLSk2hLZtcvg3IzwNmAxb+wBjW+ZHLK4zljNQx8F0PW5JIg6UMs9ntri+C2hNz5OOVrzgWhONSJbOoyw9Zb5fB9QhjUQ+RUjhds5KVtRKSWoTvt4whlQ943GCoSeKIh7QJfTgAf1jzhVmXfMj7D+FjqCx/hkAuhfem0VnMv2o0+bJ7BTYBV9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kY81ULKbKG52GvQCz2ZwpFlVoSE6hatClPiArV2w1Yg=;
 b=WLMkw6OBqZ83sr4arjrG7GgVaWsvDXFs8OMQqKcUIYbGcmpJO+h7ONg1Af1tRuQXKs3KJcJlYhiBKOFLVkzmRoxhKSw984Rrclf6cqzeJRykXZO7M8kpQETqELc+D3Fv9wfCzzahE6IirfVdvfuMKDATGpMIIOjjxbswlFpSqC0ZRp3XwiT4u/jR3mQ5eKQmg2SUVsGsxPAauB4bbnDe8M+TILCuJxreVFmXJ0ZyRnBzeATenTf/RYvIjEhu82kWG57W2d+vKXgsFDpq3xKLRThOqMSvEUpyksT6x0iI7VCBPpa3DkfS7RnGgAnYuvjs9fA4fK228sa8/BPc0rNBJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kY81ULKbKG52GvQCz2ZwpFlVoSE6hatClPiArV2w1Yg=;
 b=mEloYsiqqHDVDIA0PqQ1rf4iJLlvBC+2zf3k8sFjFAblj23MfEz+LEdzNanzh2zApzU16DlFlxmwk3UQaHCCC15uqp+PltO54Y41EgXZKBqkhsqk8YedBDE7BFXvny6nI4xbdXcf1fW0Fel33gPcKIyxUMlw3vv1CbnzeQkDkBg=
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by DM6PR12MB4636.namprd12.prod.outlook.com (2603:10b6:5:161::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Mon, 17 Jan
 2022 22:43:34 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::42f:534d:e82:b59f]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::42f:534d:e82:b59f%4]) with mapi id 15.20.4888.014; Mon, 17 Jan 2022
 22:43:34 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "Deucher, Alexander" <Alexander.Deucher@amd.com>
Subject: UBSAN error on is_dsc_supported
Thread-Topic: UBSAN error on is_dsc_supported
Thread-Index: AdgL86VMMseCjkgtQjCeBfwwmyiUrQ==
Date:   Mon, 17 Jan 2022 22:43:34 +0000
Message-ID: <BL1PR12MB515740E9B2213800E5C16958E2579@BL1PR12MB5157.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-01-17T22:43:30Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=1ea236ef-f3eb-4c50-9a88-d9ac968e5050;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-01-17T22:43:33Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 0313e857-f195-4a8c-8c20-3c097de6c706
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e36bdb9-f2a2-4c5b-4aae-08d9da0acb70
x-ms-traffictypediagnostic: DM6PR12MB4636:EE_
x-microsoft-antispam-prvs: <DM6PR12MB4636BE4C97E88530AFDE5EA5E2579@DM6PR12MB4636.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z9s5VUk7L/jHgdbNjtv65LWoGK4YDbB/t/CH3FGFke1nwdDIHQl8eyI8Rv8WxKqH+n+J1jnHtyEh5E2p61hkIODEo8LpDGkEJ5i7nNtGhwZPkaxd421s+HCv9Rcb1JuS0o9z006M+zp+QKHwOFZgd0iFVezy5sqOIN0kHTgcmeSohMNavrr2G4zZipYhyrnzAg8VJuMP/E6pwdQS6mRUhSM/YMOsP96CL3eyye96m9kMEMcgaqH8H8iefDVks9NruaHLNCynvOC1bW8TnHWRA3gPrjbj2RG6espmVcvpxqrTzjQZJDqGbb7wDorMbZYxCEAjFqcCfOn1W1MjkOnsimnLrbv9EGsbP+NqROu6c9Z9nDaisT6i/itnRtZXcS4Z/uDStkH16fx1U5ZErOXHG9HzypsWjhEy845OUdcd5V34HH/hBbyiwpOwchrRm3B1G7rgT5h9HmThBEpaDyQQEKIpDaYfNsUhRa8RN+0pThMpkFVRbGQV43RacimeJFLRSwF/sUHIi8umw642Q4AiMJbPj0Gvlo0qC8zA9jmqA1l3kd49kbbEvrTxqbP5lf5Mb70Gi34DgoSefSPOZfHHbxnjbNTZN8EsNP3OB5gUwhIcfSgIv1sB1siNWtl9c/05G7536XGXvNSfrsnfLdZ6tQPmD+ojGCtHZFEdpGqNxFFQI4jtL7Q4xwO7/lSt/Wfs0deOFEUJzYY2pbhxC7naNw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66446008)(9686003)(66946007)(66476007)(64756008)(5660300002)(66556008)(71200400001)(2906002)(6916009)(33656002)(508600001)(6506007)(7696005)(4326008)(26005)(186003)(55016003)(122000001)(558084003)(8936002)(8676002)(38070700005)(76116006)(86362001)(316002)(38100700002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2faEB2GIhcHpeWxSFcp1kod4qQ0m6S8xyNuUAI0gy3B7GXPuC+yIY2aPzKqX?=
 =?us-ascii?Q?FFe1vaNbATBC65PqQYX3ojW3Yg6dAhQUwNxS8TyFyiB5aMVzV78nJxeoxE/x?=
 =?us-ascii?Q?HE8XeuIQs0WJB+NAFQKrkV3YYEmQiEZx3lqoa95uCAo+xyFn72jwby7Bf93a?=
 =?us-ascii?Q?NgpwM3nsUZYcUtRdiVmemc/2JVbtfV8ND1f4wA3g9lpePw4zoDpcTbCN6vgQ?=
 =?us-ascii?Q?wQUgqW7GwXVE1e15prc4RcMxwQSmM/t4Ks3AOaqMNsU/iKRPUsOS3a6bkOpD?=
 =?us-ascii?Q?+fwvy11j+4Gq+/6aXxZ78SL36KiZaNzmAetXAHQ7WmSFXdrqDYfi45+S1Xsl?=
 =?us-ascii?Q?7+d5WUBx/rPT0BIWd85FcWsLjSKk99OJ4S1oXMl2bTCKC9DqdMk1YBQPbI2f?=
 =?us-ascii?Q?1hSSMvJowk+Qp8Rb3mtXC5aAWS/xUJZp76yhqHTgqDZrNC/XnKONfNw9oZdF?=
 =?us-ascii?Q?VwEOHTB4iHEY1Sqz75+CaXw45ObLioy71dkNqfORC1wI0C8QYJEiie6W7aSF?=
 =?us-ascii?Q?8Ww9rbzzrZ2wwbvDSZa6V5TM4VtDgUEZ0cZh8KtD54+kV0M2ywP+7CHeC/ru?=
 =?us-ascii?Q?G5V3tnuuC7mq8arT80xb7M4EEq3MVlPxXopLvcR0Eb0fKFDr0Q1DxacoejeC?=
 =?us-ascii?Q?YAKJQE8DLFF/fN3nrxv5ltNE3fEQ7Xdq91Mx9w3GVNCE0EEMrHwrKcu3V68K?=
 =?us-ascii?Q?6kudjDf9gwTw7tc0FNwd1cvBhkQO29HwDS7YBrYem0EfeYOt49QIDu1w7yHL?=
 =?us-ascii?Q?Ueh7Eg5wnF4BLF/iUDZInoMfq3n3sevWjGpvGRKW6/8JOZjNTsVEyhUObe71?=
 =?us-ascii?Q?fzOxTwrRHVVGh6Pz1KpxeZN+qUglyibGRq/AYUTHJlWQSNbSp24K3I9PSSmn?=
 =?us-ascii?Q?OrLdv3gVBU5ux/lv3ZLyucs0HOI1njzJ2r7dqvNeIf0MXEDuOYcbrEX4Dmwf?=
 =?us-ascii?Q?+1EOGT6A8zFrHJ9szFxx3liBIUuaLAw7vY/WqUwmiyYyDFJtD5eHVoTgL0XC?=
 =?us-ascii?Q?nLdafpQJH/Q6G3r27oP3U5puVaSA0iSNl4zqllS3lzMvWFXoDdz868qiHPY6?=
 =?us-ascii?Q?nbrAVkHm9iOgknQZPSBUw36GJbGtEoMCgPZzKb0WvlFDzKnAh8znC46QSXkl?=
 =?us-ascii?Q?zjTOAoZOlwhy9QYh2FiVF8B3AYoXiKTRyiWpfUJC5mRSN6lNxhOh88w6xhU3?=
 =?us-ascii?Q?GRoxyQncJb0NsVGyjQc3Ea83afdyhtsqLXqxPTxB1QrPNxwZiNnu94agPysi?=
 =?us-ascii?Q?71Ndn6Q21vUbIsuluTKE3gBDBNNK4FRsIZuzb/C0Vna1heoblCnP7vnC0iiD?=
 =?us-ascii?Q?T0bDc7MMyczFLs40PTUPc9btpKmePgi/1whZKgb/L1UM9kIpk6aaIncWtbYN?=
 =?us-ascii?Q?Pjn7qM3uQuuqt0I/xn0d4PDRIDbHuBu/7k1spaUvgBsB4bWcdU4LAffS9WNv?=
 =?us-ascii?Q?g/D4RRVFtsfylYCkLzm8w7jaB/FK1dnfsGmJLP7jcC76XOAp/oOmkImcPBch?=
 =?us-ascii?Q?eOfzawXUKqmjMmnLawEqY+/8Xx74A4PCuvU61DhtWof+e+qom5Jn8MrkOu13?=
 =?us-ascii?Q?GG5A2aEOarhK9a5TkbS8PU9LsHunCZb47CpN/pUL99D/Yj7JtrDByiKbOGDG?=
 =?us-ascii?Q?Uw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e36bdb9-f2a2-4c5b-4aae-08d9da0acb70
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2022 22:43:34.6360
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bLUnB1t8RgEI15GxjiVfHMqTUCEE5SJ3PwnUVFfHGNgdoa3MGnoT3fQgnqjHYQRHwrYFcO9b2Mt7HROgggQDpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4636
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

Hi stable,

Can you please pull in commit 63ad5371cd1e379519395c49a4b6a652c36c98e5 ("dr=
m/amd/display: explicitly set is_dsc_supported to false before use") to 5.1=
5.y?

This fixes address sanitizer errors on hotplug found by the Canonical team.

Thanks,
