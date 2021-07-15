Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE3A13C9C0A
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 11:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbhGOJmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 05:42:01 -0400
Received: from mx04.melco.co.jp ([192.218.140.144]:34990 "EHLO
        mx04.melco.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231655AbhGOJmA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 05:42:00 -0400
Received: from mr04.melco.co.jp (mr04 [133.141.98.166])
        by mx04.melco.co.jp (Postfix) with ESMTP id 4GQTpg1MhqzMsLtF;
        Thu, 15 Jul 2021 18:39:07 +0900 (JST)
Received: from mr04.melco.co.jp (unknown [127.0.0.1])
        by mr04.imss (Postfix) with ESMTP id 4GQTpg0yZzzMr9SZ;
        Thu, 15 Jul 2021 18:39:07 +0900 (JST)
Received: from mf04_second.melco.co.jp (unknown [192.168.20.184])
        by mr04.melco.co.jp (Postfix) with ESMTP id 4GQTpg0fMvzMr9SV;
        Thu, 15 Jul 2021 18:39:07 +0900 (JST)
Received: from mf04.melco.co.jp (unknown [133.141.98.184])
        by mf04_second.melco.co.jp (Postfix) with ESMTP id 4GQTpg0cSjzN0rZp;
        Thu, 15 Jul 2021 18:39:07 +0900 (JST)
Received: from JPN01-OS2-obe.outbound.protection.outlook.com (unknown [104.47.92.59])
        by mf04.melco.co.jp (Postfix) with ESMTP id 4GQTpg0PW1zN0rZn;
        Thu, 15 Jul 2021 18:39:07 +0900 (JST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mj4sjYbotxOLxQ4cIK/eO5KeA1NyFZDpjxNaZD/fKg5fm9NmECmyFD6UXj2R/3NBlWjAenIPZvQ6tZWZkYbNU/zYwamdtqrZlBzDrpq1voBk6FS1bj0gSVVuq9ONhzaXgz+uE/DJzO2N+ZJSgLaFf4Mptw2/LrXfV6DsNCWOC2Z+sOV5swUXionzVu+z0XfGcrTKq9s1xQSs6F4DDmHtBe6wvv8cIFbd7GiMProyp+NKo7lvNJykdLpuwqxK2UaozLfnKKDpZg5AS9zoKIVmUKucIS2bkfxY0xQwL3E8UY4qRpUmZXdipP8W6VnBVlRM1Ms0Bfj77Qo8lpZ+to5cxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+/ZQBLmGt4iuJaiI3UtMXVjbBQNNthNdAGCYbd4x4mo=;
 b=ETA1J88ay58hzIfHBN0bxo6T40/0C/8AQ0g3RtyDwOrNyFmKYzjrP/dBdCXIHn5dt2B83H6x35Sk9bwWeAAFtHVBcmIy45dO8tGr7LR3wiKkJ9LtJx4lqiCAsDEJnHGByqni8FCG7t/q6i7TxYQX6/Nu7SWZihaxasyJK64QifOYBF9YexVHrbjSqsPPerOPHue22M+aIE4HKkQHH0qsVdIIvUXf+FGFG/lPZpL0R6TruWWgcqL9ucrL0eqRl6IK8fMGYrxriHW8Uarq0K1JGkgWuWERyp08wO5vdUEYwksNUVvDNCuR3BzdTsZefcZZGEe4SJ4oWshbBEO8ynyCPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dc.mitsubishielectric.co.jp; dmarc=pass action=none
 header.from=dc.mitsubishielectric.co.jp; dkim=pass
 header.d=dc.mitsubishielectric.co.jp; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mitsubishielectricgroup.onmicrosoft.com;
 s=selector2-mitsubishielectricgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+/ZQBLmGt4iuJaiI3UtMXVjbBQNNthNdAGCYbd4x4mo=;
 b=gvqSBjmf2ecXk6TPQLkGw5kbIMlglq3aYjstRTVtHitzA6pyDFPChkiQq+m6VXz4LQXWNvlEh2VHFyBiFEx1o0Nyy4CxduuHeAr36eD2WkbtuTvkElFwkupQ6wDNA0wgDv6aoOn5v8GHN54AFuVWofaB7eP6MH4PqPsNFxGbPxw=
Received: from OSBPR01MB4535.jpnprd01.prod.outlook.com (2603:1096:604:76::20)
 by OSAPR01MB2020.jpnprd01.prod.outlook.com (2603:1096:603:19::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Thu, 15 Jul
 2021 09:39:06 +0000
Received: from OSBPR01MB4535.jpnprd01.prod.outlook.com
 ([fe80::389f:1ae4:77c1:a9a9]) by OSBPR01MB4535.jpnprd01.prod.outlook.com
 ([fe80::389f:1ae4:77c1:a9a9%7]) with mapi id 15.20.4331.024; Thu, 15 Jul 2021
 09:39:06 +0000
From:   "Kohada.Tetsuhiro@dc.MitsubishiElectric.co.jp" 
        <Kohada.Tetsuhiro@dc.MitsubishiElectric.co.jp>
To:     "'namjae.jeon@samsung.com'" <namjae.jeon@samsung.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
CC:     "flrncrmr@gmail.com" <flrncrmr@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] exfat: handle wrong stream entry size in exfat_readdir()
Thread-Topic: [PATCH] exfat: handle wrong stream entry size in exfat_readdir()
Thread-Index: AQHXXlu4ZPuuUBCNZkORJfcd+Jgt4qtD/TJd
Date:   Thu, 15 Jul 2021 09:39:06 +0000
Message-ID: <OSBPR01MB45357B200F44AF64D446D42790129@OSBPR01MB4535.jpnprd01.prod.outlook.com>
References: <CGME20210611004956epcas1p262dc7907165782173692d7cf9e571dfe@epcas1p2.samsung.com>,<20210611004024.2925-1-namjae.jeon@samsung.com>
In-Reply-To: <20210611004024.2925-1-namjae.jeon@samsung.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none
 header.from=dc.MitsubishiElectric.co.jp;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f33014b-e7f4-4544-a8e3-08d947746396
x-ms-traffictypediagnostic: OSAPR01MB2020:
x-microsoft-antispam-prvs: <OSAPR01MB2020F27977BE818D1E3A8E2A90129@OSAPR01MB2020.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tA/8KK8yZDR+w1PWn5wJeO8hhz0ekx3HsWkGVhKTT+bv8YsTdqv1LM7jIaFd9MazZ3in0506j2W+uO7ha4IUDAoodQAg1tBsP0+7cB+pTG/vMjEGe0inPi2df+vjaBIw4eLyIoBj33AJxsAc5deszhLLYdN/2n9kT8gwkV4AhTkKjTP3R2N/IsAQKoYSfJd4snzEJ5VIrkAuSo1thBTY8BsJeo6YLnaIGK2KpCdL3xQvur7V2adbWYMiT/bMsNHdWLWKwL1QnSuR6ZeQKExCx34w77WJ83N0PdgQaN0bdGq8rUITbQyESN7eYcm8seShAAY9gt0von3MuQysVp2tnR1EU6QBxtsrlIl4/mnfh7n+K8oP4OeEP6h4HFBaN/IWEtEIfKJFao3dmV32XWpZfuY+Fcfgg1ufs/cdsPtdXtuQx+pRpWSH0546lptt08/Wij90n04osDVJ93eT3dNZniKjOYse2gBd4QbwswexXSRm/poJIhm3Qpw19Rh0gh3b9mlMAQ3ySt7zIFCrDy8O+msjr3yOjbhNdkiDocBrojE9uNfzBI9FjMWsZmFFJdmtAn0i+iEHixTwBvu2a9HKCC55k+Yg7OHVi2CGPd2Vv2a055se7FgXDfH2R3gUFpfwApOWGK1Rh4lpvvsas+raLGAfQqtEZaRtbKX8mg+krmWQyg7zP4PboQuf8u7/mjQijFhWWAZzL9Zc5k8R5/1PoHI+ens6O6u+AtNMjyXuucGVFb5bfsVmaTXeEiTk/lak
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSBPR01MB4535.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(136003)(366004)(396003)(8936002)(55016002)(110136005)(38100700002)(54906003)(316002)(66476007)(66556008)(66946007)(76116006)(186003)(66446008)(8676002)(4326008)(2906002)(64756008)(86362001)(9686003)(71200400001)(52536014)(478600001)(83380400001)(6506007)(5660300002)(4744005)(33656002)(7696005)(122000001)(38070700004)(95630200002)(491001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-2022-jp?B?eTBXZWxWK2RSRlBSakxXa3ZuUFdQQ3phNVdzbG9jNXpucnBZU2tKTDY2?=
 =?iso-2022-jp?B?cW9RVkQ3SjJlMkMwMTNKc3dxVU94VVg0anZ1N2tjbHZoWGlTYjBPaTMr?=
 =?iso-2022-jp?B?V2JwRTZONUtWSmNyY3ZpOVNwUFJ4aHVyL2pNQUJ3bTljOGMzajJhamFK?=
 =?iso-2022-jp?B?M0g3ZjlYVG5Fa3pmZDl1TjBVSnJzOEpENmFmUUpWRUJwQ0pKcWRpZVJu?=
 =?iso-2022-jp?B?QzN2aVJnSGhWTzhmNCtEc1U5M0QybGFwRzE3QmRWVElmRHliUTRMQm1H?=
 =?iso-2022-jp?B?SE9SclJLMk1YTDNJQ0VGUlUwNDhFOERLQmkwcmZvYWhyRGZpb29kWHJS?=
 =?iso-2022-jp?B?dHFxYUdsejhnOUlYaUMzNnBpNXgwSkhvZjh5ZU1jUkx1aTJ1S0lYdHJk?=
 =?iso-2022-jp?B?aEVjRHYzU1d3aHMvTnV6MGp5YllDb0UwVHl4S0g5cWhpaFk1bmNFMCtR?=
 =?iso-2022-jp?B?emVVdmZWVlhMd085SHVMdHdjaHNLcG9DamxiSyt6bFBGZE12bG9ITnBj?=
 =?iso-2022-jp?B?Y0M1Y1lISTJoemlkb21IM05zK2ovY3JQY0FpVEZQZDJsOWFyRGRCdkhx?=
 =?iso-2022-jp?B?QVJrWGdjalg1OWp3UDh5NGUxcjdxZlRKVUJOTnhTQ0Y4eVdDZzR0TEg0?=
 =?iso-2022-jp?B?UVUxL1hEdTZlSmwrTlZ1a25CQWQvNWQreEpFbUJFZEQ0cG9HVUM4N1da?=
 =?iso-2022-jp?B?Z1E0T24ydktYRUZSMU1MVGEyQ1Fzb3JuRnFmZXdLT1N5UlFodlZ3OUMr?=
 =?iso-2022-jp?B?WTNzd1BCK0Voak8vNVZzeDRGUkZaenV3bWhlU0FTTExkRE1xb21PMERu?=
 =?iso-2022-jp?B?SWVtRzU0UmlVU1ROVDFJRk1NeFE4ZWd2d1ZFcjJJUkxCbE1QSXlWVmhz?=
 =?iso-2022-jp?B?Y2M5R1BvWDlNeHJtNTRjdUh2NFZaSmNvdytzTFk0NEJxL2pZaWIrVjY2?=
 =?iso-2022-jp?B?SkN2Q3FoTXB4TCtJVHdmZy94KzNBVXpWMmE3K1pQaHF0aTZxQzIzZVQ0?=
 =?iso-2022-jp?B?cTE4RTFZWnpNc2JCTVBKMzJzOUpXbVMxSVRnVUtJZTA2MnUwbjlaZVdQ?=
 =?iso-2022-jp?B?L290S2FCYlUzeHlIbW1EdURBMFZoSU1TWHNWMm5qNkhQaXo0WW1GSjR4?=
 =?iso-2022-jp?B?WDJVa1FjQ25MNXdzSTBERkx1NlhpL294amtWbThteHhuai9keU01eDJv?=
 =?iso-2022-jp?B?aXc0aUxFN1VIYWY0RG1OMTBpWkcyK0RPUUlIR1FrL1RqeDRpMGZBOGtu?=
 =?iso-2022-jp?B?ZE1yVWtBdmt2eFpsN2g4b3k0cUp1MDk0TGdDTzF5U2JEMUlWVzBoLzJi?=
 =?iso-2022-jp?B?bWNlVE94a1drR3ZOdHF6VGNBQjlkVDFVQ0lpZWN0cHp3czhYWUwxSExh?=
 =?iso-2022-jp?B?bWtaWHJoaFpVa0JkeCtpWkN6Z2FiSGxuVUpka05WKy9EQVMvRFg2NDhD?=
 =?iso-2022-jp?B?WlhxRHFiaDFhamwrVWg5QlpjSnNCK1FyZ2xYMUkwQ1pNOFl3b2NwaG1s?=
 =?iso-2022-jp?B?eVJUNEZFZGErZ3RCR05lZlJZREpWSDNkWUx1MGZiRFd2ck9iVlliL01B?=
 =?iso-2022-jp?B?aGRpWXVJelVBSWpUUVBEM1dkSGZyeG1WemRRS0JlTCtSWERXUEp5d081?=
 =?iso-2022-jp?B?bFoyMExJTHBpczltL1M5c3ZrZjhCdk5lYzYvSllJZ1ZQMlVkalc5cEVa?=
 =?iso-2022-jp?B?bHZwblZkL09lZmkrK1FwZytGTVZleWkvSG90eExBTFE2ZUFwQ1NlN0h2?=
 =?iso-2022-jp?B?MUxoenhqbERBZjExMzV1YjVMUWRPWGxDV1NEVEt3dytDYjFkV0Vab2xN?=
 =?iso-2022-jp?B?eS9JL3kvYU9CaFcybGFqZVE5RVlSRU15VjNHak5qOW4wU2QyS3o0YTVn?=
 =?iso-2022-jp?B?VnBBNTdWSURjdVBiSnh3VVp2WW9nV085Z2JUdHhhbWNoK0Y5VGN2Rk5Y?=
 =?iso-2022-jp?B?Z0xhYjJVK2RTcHIrdCt0MU9xbHhWTW1vdC9HNE1HR2tPREgxc0JvM1lL?=
 =?iso-2022-jp?B?QT0=?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: dc.MitsubishiElectric.co.jp
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSBPR01MB4535.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f33014b-e7f4-4544-a8e3-08d947746396
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2021 09:39:06.1092
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c5a75b62-4bff-4c96-a720-6621ce9978e5
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tOjjFJMzfPtahz8jFzRgSMpdADCCFumP2CVnwHs7E5Yu4jZcvvrG8CP/Ren2kOJvF0dtExJS1QLS40qmAo0EZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB2020
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> This patch check DataLength in stream=0A=
> entry only if the type is ALLOC_NO_FAT_CHAIN and add the check ensure=0A=
> that dentry offset does not exceed max dentries size(256 MB) to avoid=0A=
> the circular FAT chain issue.=0A=
=0A=
I think it's preferable to add a 256MB check during dir-scan.(as I said in =
the previous)=0A=
If you want to solve "the circular FAT chain issue", you should add it to o=
ther dir-scan loops.=0A=
(exfat_search_empty_slot, exfat_check_dir_empty, exfat_count_dir_entries, e=
tc ...).=0A=
=0A=
Also, the dir-scan loop may not terminate when TYPE_UNUSED is detected.=0A=
Even if TYPE_UNUSED is detected, just break the inner for-loop will continu=
e the outer while-loop,=0A=
so the next cluster will be accessed.=0A=
If we can't use DataLength for checking, we should check the contents more =
strictly instead.=0A=
=0A=
The current implementation has several similar dir-scan loops.=0A=
These are similar logics and should be abstracted, if possible.=0A=
=0A=
BR=0A=
Kohada Tetsuhiro <Kohada.Tetsuhiro@dc.MitsubishiElectric.co.jp>=0A=
=0A=
