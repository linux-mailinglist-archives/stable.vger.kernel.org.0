Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2C3961EAC9
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 07:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiKGGB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 01:01:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiKGGB0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 01:01:26 -0500
Received: from mx0a-0014ca01.pphosted.com (mx0b-0014ca01.pphosted.com [208.86.201.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C18BCBD;
        Sun,  6 Nov 2022 22:01:25 -0800 (PST)
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2A6FGFHt014854;
        Sun, 6 Nov 2022 22:01:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=JvUa5D7vCrvDjTpxZCMGQHPbW+ZeLmifemHqIlbjHbQ=;
 b=TlFejhDugPxcAwbn1uTLjZGY03kZxCA/IljQo0EepMM9DqSKgrdFgTYu/2NmDAz7LgwR
 bv7PE/N0I3bQASOyQqrw8PqgLs6Jnam9Qdjvovs3GgcNcJoR0ZjRAKJ8JuClAhm6uwB1
 YvI02DyJNRtCqqt8EahYzvSsI86ZU7SeR41p8XK8kcii/zKj2ROeP57gtGLGgZ7glOoJ
 JgDlsi3cQ7TSriab+Odw/Cf2YG61TSzjwXshehRBR1SRgfiY6mHGXK++Xo4cJQBbW7dH
 +lN4wkqoKOGDW9qERJqtRL0p5GXMX+rdsCzmm8Dzoy94ovr31yBfLbFCprxgqC/hWvA1 tQ== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by mx0b-0014ca01.pphosted.com (PPS) with ESMTPS id 3kpe5jt726-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 06 Nov 2022 22:01:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OllfnA55FAOgslCOH4hkACS9BVyOk4Zmp4BsBLQvp7AxJCs1r6VJDQltyqEUONfdt/pLpXeXM4RplpXqsSMYJGEIqsGY6zy+J8Xpekn/12gRhrYn1WU1JplUfK/Nyl46VC9eqtiWdoKaeyngA9oPdxEsz/OWINO5alRqcK+m3GPWOqK4D7I7yyVRJfLLWn840OAkZGSCFY2PnUJ4wTGE5szMHT6OltfG/QqetViTnNPn85Ik2wuEPA8nbQOMqYMtG2bXn+KeL7Klk33Pd28e3/9MZYE96wpY0K0xZ8SCxPbOwagyuBcEnN5kYQzxRCb9+AcjW+1jn/YcQSTPKUj+BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JvUa5D7vCrvDjTpxZCMGQHPbW+ZeLmifemHqIlbjHbQ=;
 b=K+PHBmpG1RquL8cqEqaRhshiYsHLYuUISQ5Nl5jGlRCmVZHpc5cc8TSNMzjAyPIw179pt91LLMRLF4tNHIUz5IoKp20JJ7sHqIfN/4c/EyRgjeIIomL+CpvIhGH9rkfu96AJdupHpvpE8VUnoGSjW4vB5HjqYbhodPStB8NXefBv0peem6lQY3fpUEjlDw1XBhkOSaDv49k4H9Mv8CtJqffY3RXDQBpYuatH06Oa+A8Dbtit9PJcSLEZvbpNwBQcQIFoodeU6f5MNElQ5iKNYDcH/RSfYPl4cEUPGktafoorgLkjY32zltZdlT1nbtj6xVsp6qGnBDnekM4ZeEuqPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JvUa5D7vCrvDjTpxZCMGQHPbW+ZeLmifemHqIlbjHbQ=;
 b=1klURKPLzgIji1lj4XAFvdbhZ9x3FqR0Ifk7ODe+G3T8Gb1i5vjEZLUTF0O0/lxXFp0eh/5RKoji1GYWuky5wOvspmRAitPEO4x5dcEIOJE0xKt9m6/B/GiQGkfSYCL2vOFxl9PCc7oZV7riy7hq3IHTFhtIxEAV2R2xk6pe1gg=
Received: from BYAPR07MB5381.namprd07.prod.outlook.com (2603:10b6:a03:6d::24)
 by CO1PR07MB9179.namprd07.prod.outlook.com (2603:10b6:303:15a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Mon, 7 Nov
 2022 06:01:11 +0000
Received: from BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::ea7c:b79f:752e:1afc]) by BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::ea7c:b79f:752e:1afc%4]) with mapi id 15.20.5791.025; Mon, 7 Nov 2022
 06:01:11 +0000
From:   Pawel Laszczak <pawell@cadence.com>
To:     Peter Chen <peter.chen@kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] usb: cdnsp: Fix issue with Clear Feature Halt Endpoint
Thread-Topic: [PATCH] usb: cdnsp: Fix issue with Clear Feature Halt Endpoint
Thread-Index: AQHY6R6Kb+CO20jKM0iAijOjlYxMN64xrF6AgAFZHNA=
Date:   Mon, 7 Nov 2022 06:01:10 +0000
Message-ID: <BYAPR07MB538173AA9BFCC5C7CE02A07CDD3C9@BYAPR07MB5381.namprd07.prod.outlook.com>
References: <20221026093710.449809-1-pawell@cadence.com>
 <20221106090815.GB152143@nchen-desktop>
In-Reply-To: <20221106090815.GB152143@nchen-desktop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctOTI5Y2VhMWYtNWU2MS0xMWVkLWE4NDgtMDBiZTQzMTQxNTFkXGFtZS10ZXN0XDkyOWNlYTIxLTVlNjEtMTFlZC1hODQ4LTAwYmU0MzE0MTUxZGJvZHkudHh0IiBzej0iMzI5OCIgdD0iMTMzMTIyNzQ0NjkzMDE3NjMwIiBoPSIvUERiUVlwS29wRllUNEM5a3JramNqeGJNMHM9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR07MB5381:EE_|CO1PR07MB9179:EE_
x-ms-office365-filtering-correlation-id: cbf45496-48ff-4242-a29b-08dac0857872
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vJ3D/WFA9TJVbKvwg1P3OpLhh+46qV6ax7/Y/iSJAnhSSKpFNz2oLd6S0IsuU8Z4jXqHFO3mBFLhOo4033KjfbH+PVyMvB6FftlmQ3ObFjTPqxeJGfu4aNl4czCSpSJFgbowuiJDUkxvP1pC6+OvZ3KPFb2qM0lcfzVnNm6PfzUImehsqnY0sOr3D1HnslrstPJesi3GpDCeSft7/5YTu+zIOGbb7DpWIp1adj4A39KDZ9+zWRRdPKCzy9ND7UOPDea8pgIkD69ppvjt35g/CBkCsadwnj0YsBUdjFa7XBzgpYVq8veC7ght0JUU/jNStus+pMFauUTdHJW3VQdQftPR9A4EFX7VEopRipba5SR0TxTMXPMJuRfKO/HnuVy0WLDQK44dXGe8yWLi2c95pNwNfwVGw9rYI2C4eS4TPyovAWTMytzzqvQ1eEYKfXMGlJsp6JahiMGEPQqJSQdGnHFHUHnEx3ltqfzbub4uV41UMIcw/hgdjrAYw5w1oxpWMkzXYpgQp1md3q+0sdK+4CjjkNqkLWBphPYmckuYzHOEVPJuByBPGDDVY90/SSAurdHhtjHoRYPH4aCkZq4CcM43OWJhUbwj+60hJKaMkWZJ7v0c1B57hbYBswxDVUSQALMid2qdB/0nNyOy0W8kE8tGrZDrOuCx+bYa3Ijz5/lHw+pHNK7rC9cjBrmoLUrI5MrEJFm6fhPd1NdydQtr0DDm1U/8pXC/lsNyY49HCaKn1BU8CXIWTOlmbbSJBpVSG1SvTwkNjNEJGIVyuIJT+g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR07MB5381.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(136003)(366004)(376002)(346002)(36092001)(451199015)(2906002)(5660300002)(54906003)(6916009)(9686003)(26005)(7696005)(6506007)(71200400001)(66556008)(66446008)(64756008)(66476007)(316002)(86362001)(33656002)(38070700005)(8676002)(55016003)(52536014)(8936002)(186003)(41300700001)(478600001)(83380400001)(4326008)(38100700002)(122000001)(66946007)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dbPrPa7mqEUhRHnnGCAFtTvQzqGw/Ma/YG8KwpdYS1obQJOEu9xBUWejvxqN?=
 =?us-ascii?Q?SDnBn/YXdJLfFEkfR47GuCZC/p03+sTreZUjiGnynlmc1yqJYUyyHMZQHjnv?=
 =?us-ascii?Q?t+KTRS/idj3WdTQLHrBR2UhcDrVHORmNcbJQbLQoA+u+JUCc/XqGoPHJ76Ci?=
 =?us-ascii?Q?KFfN7C39QLntFO+JVfRBzkMvHa8Lf/U+0QCmHDyfXIW6limfgSB24oTe8g0H?=
 =?us-ascii?Q?Q28GJv1FDFI1OgSFtFWqGVPNmeZpTWmzmOkF8qXMaeGrsNqxY5TGjVyu56Jo?=
 =?us-ascii?Q?UYy+rg65Z6F7ZqY5pcHT2viFG/0LBY5KOGVEDCgV+fOHpyYtTSl3wByTHVlE?=
 =?us-ascii?Q?eeto8lyAdtsNY6WQj9ZWjJUQwPG2OIc8jUmpT7aSUpaUBV/Wz4+qXTrLEC47?=
 =?us-ascii?Q?zGcQ1J9dDnbDxTAvWvWct53tHbBVgKVfAURwElOFQ628KO+CEBnFYR5rQu/2?=
 =?us-ascii?Q?MgjD8L1gS51grwnoK3pT0JTxUPLIsuzv0Ut3W9DocHkKP6QyeAWPxSusMnLq?=
 =?us-ascii?Q?jKYUQVMgCw0NpUKTTaYLUXZD++o1dQZ5NXHM4aRebO9ZRIuRGa7QARaohizp?=
 =?us-ascii?Q?ujmvGxMeITqAitxTWnn13Vre0mP70kMRxxsdRMElhfIsTTSCpgWWuStNxTQi?=
 =?us-ascii?Q?eF5l2XTiA+tfNRFQTeFtZnnSE9wwRs0w881GJkMMP6QIKlpMmtTidRwDGvPn?=
 =?us-ascii?Q?ChhosRXpCG7Pl6Z0UR1oxvqCR+iz60ie9REqkMQDcWpdfqRdjcPaEuxfWrgT?=
 =?us-ascii?Q?QLUf07ilGGlNvCI2K1iFKQLGfq3EbkbehDyyvhJtwJRYaopq2XzI2+MTiRnH?=
 =?us-ascii?Q?HNtkPsrATsmNjeCek9mmUe3H+aYUJbOcxNDkrb6fDiXQ5iM47w0mY3ivYAoi?=
 =?us-ascii?Q?MtFOeCNVFahP0pCCUMx4/qoEc+qhm3NahWieNsEF7aVP/OO9Yhd6M4UjZkCp?=
 =?us-ascii?Q?hbYbxiQNcLpfVKcGnWtiskva5vdrTs/+HJeh9HMCIj+n5slam9Flv3DqkaUO?=
 =?us-ascii?Q?+hlbauWjwxA4nVfDdMoyyMvnjKq43yoBFABT/PR5mT9bFH9aUn4LH1k/a/qM?=
 =?us-ascii?Q?zDzr5+KifkCLm1nwUlV1QJXuKbwjMuiSVOa8Z4mFPf1XXdR9FebGgSEoSBpq?=
 =?us-ascii?Q?6JnyHcjLEK3CSWFVXT3CZwkfBJyEnkhQCzC4d3pwOSTpyGFdx8QUqtFOF1Ky?=
 =?us-ascii?Q?nyFmtdWLITFfUktci/JVkgBvSAaCJGha5U/4Dou4UyDmrJVavrrVfVl2Xr4E?=
 =?us-ascii?Q?8C4s0d9j7lEcadBus3vhEr6hWjAoJX7z/CnJcOCtQNWZA5NTtv3LjIoE9X0S?=
 =?us-ascii?Q?Rse4UsQKuHuzEhCudijSFjIcmAe6V1MNEpmNSBkmZWBmGJj4oKR3fklsIUOr?=
 =?us-ascii?Q?MGX8R9ZryLjyG4JsUM7PpJ6Sm79RJZNQsRSQ2aIvnjaP9BQi2vR8H1Od6kkn?=
 =?us-ascii?Q?EviqGbQLHAtCvXj9FCeQib1iXdnhZMM61hSY5HeH2/B3rwdkHf2Yxqa7G0h9?=
 =?us-ascii?Q?h/uzv41+gZbES1BqcFLxrTTSBzP6aQehQPBUGod8/4asIJbflWuBWqwR6IsQ?=
 =?us-ascii?Q?tLBCPl2fJCVB3lkM/VwjiOHok/F5jUrHbl7dQMD1oGC4KVqO7xhmapY+IobN?=
 =?us-ascii?Q?WA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR07MB5381.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbf45496-48ff-4242-a29b-08dac0857872
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2022 06:01:10.9683
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cgys4HBiP8j2aRkIcE9yxRzSzkFNfXsUn9YGQYJ/rjm5O/kX+DwKWYEfePw5vqEF3UreSyejBM/3JS3JywFL2CzqHCi+788WLPpjb6+NYt0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR07MB9179
X-Proofpoint-GUID: x639djqNcdnPtcgdCTdNizHlnsU5qwq8
X-Proofpoint-ORIG-GUID: x639djqNcdnPtcgdCTdNizHlnsU5qwq8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-06_16,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 malwarescore=0
 priorityscore=1501 clxscore=1015 lowpriorityscore=0 bulkscore=0
 impostorscore=0 adultscore=0 mlxscore=0 phishscore=0 mlxlogscore=605
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211070051
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>
>On 22-10-26 05:37:10, Pawel Laszczak wrote:
>> During handling Clear Halt Endpoint Feature request driver invokes
>> Reset Endpoint command. Because this command has some issue with
>
>What are issues? Would you please explain more?

I don't know the internal behavior of controller. I know that there is the =
issue with resetting endpoint
in running state, resulting in the  controller after rearming start handlin=
g incorrect TRB.

>
>> transition endpoint from Running to Idle state the driver must stop
>> the endpoint by using Stop Endpoint command.
>>
>> cc: <stable@vger.kernel.org>
>> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence
>> USBSSP DRD Driver")
>> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
>> ---
>>  drivers/usb/cdns3/cdnsp-gadget.c | 12 ++++--------
>>  drivers/usb/cdns3/cdnsp-ring.c   |  3 ++-
>>  2 files changed, 6 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/usb/cdns3/cdnsp-gadget.c
>> b/drivers/usb/cdns3/cdnsp-gadget.c
>> index e2e7d16f43f4..0576f9b0e4aa 100644
>> --- a/drivers/usb/cdns3/cdnsp-gadget.c
>> +++ b/drivers/usb/cdns3/cdnsp-gadget.c
>> @@ -600,11 +600,11 @@ int cdnsp_halt_endpoint(struct cdnsp_device
>> *pdev,
>>
>>  	trace_cdnsp_ep_halt(value ? "Set" : "Clear");
>>
>> -	if (value) {
>> -		ret =3D cdnsp_cmd_stop_ep(pdev, pep);
>> -		if (ret)
>> -			return ret;
>> +	ret =3D cdnsp_cmd_stop_ep(pdev, pep);
>> +	if (ret)
>> +		return ret;
>>
>
>In your change ,it call cdnsp_cmd_stop_ep unconditionally, no matter set o=
r
>clear halt? Is it your expectation? If it is, why?

No exactly unconditionally.

The below condition:
	if (ep_state =3D=3D EP_STATE_STOPPED || ep_state =3D=3D EP_STATE_DISABLED=
=20
		||   ep_state =3D=3D EP_STATE_HALTED) {
			goto ep_stopped;

Will decide whether command will be called or not.
It will be called only when endpoint is in RUNNING state.

Pawel

>
>> +	if (value) {
>>  		if (GET_EP_CTX_STATE(pep->out_ctx) =3D=3D
>EP_STATE_STOPPED) {
>>  			cdnsp_queue_halt_endpoint(pdev, pep->idx);
>>  			cdnsp_ring_cmd_db(pdev);
>> @@ -613,10 +613,6 @@ int cdnsp_halt_endpoint(struct cdnsp_device
>> *pdev,
>>
>>  		pep->ep_state |=3D EP_HALTED;
>>  	} else {
>> -		/*
>> -		 * In device mode driver can call reset endpoint command
>> -		 * from any endpoint state.
>> -		 */
>>  		cdnsp_queue_reset_ep(pdev, pep->idx);
>>  		cdnsp_ring_cmd_db(pdev);
>>  		ret =3D cdnsp_wait_for_cmd_compl(pdev); diff --git
>> a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
>> index 25e5e51cf5a2..aa79bce89d8a 100644
>> --- a/drivers/usb/cdns3/cdnsp-ring.c
>> +++ b/drivers/usb/cdns3/cdnsp-ring.c
>> @@ -2081,7 +2081,8 @@ int cdnsp_cmd_stop_ep(struct cdnsp_device
>*pdev, struct cdnsp_ep *pep)
>>  	u32 ep_state =3D GET_EP_CTX_STATE(pep->out_ctx);
>>  	int ret =3D 0;
>>
>> -	if (ep_state =3D=3D EP_STATE_STOPPED || ep_state =3D=3D
>EP_STATE_DISABLED) {
>> +	if (ep_state =3D=3D EP_STATE_STOPPED || ep_state =3D=3D
>EP_STATE_DISABLED ||
>> +	    ep_state =3D=3D EP_STATE_HALTED) {
>>  		trace_cdnsp_ep_stopped_or_disabled(pep->out_ctx);
>>  		goto ep_stopped;
>>  	}
>> --
>> 2.25.1
>>
>
>--
>
>Thanks,
>Peter Chen

Regards,
Pawel Laszczak
