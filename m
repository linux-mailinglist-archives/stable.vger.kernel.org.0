Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06FCF60B60F
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 20:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbiJXSrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 14:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232206AbiJXSqn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 14:46:43 -0400
Received: from mx0a-0014ca01.pphosted.com (mx0a-0014ca01.pphosted.com [208.84.65.235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44CA01D5542;
        Mon, 24 Oct 2022 10:28:15 -0700 (PDT)
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29OCRlW9009445;
        Mon, 24 Oct 2022 07:10:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=jlRNUqv0hPz0fAjdwilYHAwIQE9cRPcvejM8Kwdow7Y=;
 b=l/vOb3cS3QGgI7wKtvrvPcRANXKjh22Vnw+vKoJd93pBN3Gm84JUjNvtDhnoGydKof9x
 OlwktYINGTgJ1MgDgmhdcCC2jya8Dgp2pijklbyuM+pAoR7oOygbZIUKRNhi0n+wpiSg
 fD+qRn1zpxxA4vqnId3GzziNr3VncPNo9AlFTbkIqzTKicZwNs/qOPx+yAwkI5BdtIjY
 pXdwLpng8psJIdwU3yQruLWZrtQPWJRH8PMQ52oLZSQfqjJ56msNxthyfSQ1mATbdVoG
 yp2eYwIsdtoGVH/mJ+JSwPeb6PQVtNs7/EJ7pQvQCYeZp7bz6G5iZVvQlHheXYYUWubr yw== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by mx0a-0014ca01.pphosted.com (PPS) with ESMTPS id 3kcd30rfn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 07:10:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hYor/PeR2jJH8jv28FLuT56puahx2VJszACqKyTcyrbYeOkcfktO6yIiFGYvfKycfIwo3I3Gmm9U8NZrErUuR+GrqopZG302VrGVcoRQaqZ2UyuWVcAGn+rDxSMAWzLwTArvQFkHg2xdG9dCWVEYq8xb/Ph0S7UC3EJr92xUb7iBhvvCQhX8Q0lqEajMNYpcStCF9x0WMGjboNV9tAGiiyb/fIRmqIOXofZl7Uf6c/BjmItZ6NCRCBH1jbmVXFQEERB+BubHfKofKUej6hQ2fPWHwJwiy4MGVGTxaNivJ9YPXn2homiwI+0GsRwH6Kw04vVDvLqFvpxmqTT4Z4m5XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jlRNUqv0hPz0fAjdwilYHAwIQE9cRPcvejM8Kwdow7Y=;
 b=GtEHevnjLuHXCIIDeo0ZBC1xBNQZALVN7lOvV6JMOcsTtNvjWz15iUc7UyOwLDPOc1LMFRahcCckMNHAJDbBFcbESm1e0VxwNFMolVQvIsbg+Yqoye0jkovIs3wSnXuwk8eDpjaMXHsXOawDdkbmp7owR5uTWlQL7TBzciQYzkztEflCXCFl2UfzHGILneZwtds5mw3xRWWxDiwiHQBYp/6t/5dClSk2Up1eKTU6b1qF++31FAm/bN5ipRSwsdmArTMJshH+a5FNShexEi9xeSEIAukXOeSKX4G9eE3tcjNAh0qBARrDL4RVZjotN6GiTAiOJSURsKdTCTPF9MszoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jlRNUqv0hPz0fAjdwilYHAwIQE9cRPcvejM8Kwdow7Y=;
 b=zjk6c/9GbrMt7tHZIzPs+0TYVnu+iQpAyaXYNeQUBeNv6iPN57tTC/AM8aaAh6XD1Ybp28QVF9U+zb3wQy+yJfmHfj+52+fsNafICwCCPEohy960S9uHnX0lN7Sx7b34keZWesbqabx2WAFUoKgxfpxzB7atpvurjYSvbccl5QI=
Received: from BYAPR07MB5381.namprd07.prod.outlook.com (2603:10b6:a03:6d::24)
 by MN2PR07MB6237.namprd07.prod.outlook.com (2603:10b6:208:113::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Mon, 24 Oct
 2022 14:10:31 +0000
Received: from BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::ea7c:b79f:752e:1afc]) by BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::ea7c:b79f:752e:1afc%4]) with mapi id 15.20.5746.021; Mon, 24 Oct 2022
 14:10:30 +0000
From:   Pawel Laszczak <pawell@cadence.com>
To:     Peter Chen <peter.chen@kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1
Thread-Topic: [PATCH] usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1
Thread-Index: AQHY44ERVMaQ2YM4VkyQ1o26SeztW64XRlkAgAEFafCAAiW3AIADKvRw
Date:   Mon, 24 Oct 2022 14:10:30 +0000
Message-ID: <BYAPR07MB5381BC3F7565C1BEC2DEF96FDD2E9@BYAPR07MB5381.namprd07.prod.outlook.com>
References: <1666159637-161135-1-git-send-email-pawell@cadence.com>
 <20221020132010.GA29690@nchen-desktop>
 <BYAPR07MB5381E4649DFD2BD0C528AC0FDD2D9@BYAPR07MB5381.namprd07.prod.outlook.com>
 <20221022134318.GA51416@nchen-desktop>
In-Reply-To: <20221022134318.GA51416@nchen-desktop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctOWJlOGMwYzAtNTNhNS0xMWVkLWE4NDctNjBhNWUyNWI5NmEzXGFtZS10ZXN0XDliZThjMGMyLTUzYTUtMTFlZC1hODQ3LTYwYTVlMjViOTZhM2JvZHkudHh0IiBzej0iMjM5MSIgdD0iMTMzMTEwOTQyMjc4ODc3MDg3IiBoPSJJSUI1ZjBKcVhnazBNalpYL1VERTlHN2JocEE9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR07MB5381:EE_|MN2PR07MB6237:EE_
x-ms-office365-filtering-correlation-id: 8c7f84d1-283b-48fe-0afa-08dab5c98284
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pSuEDg39N6WWPHxtPNj+9o4yGQT+wMf1VnKOJ0UaWgyS/NvRIJDrnAU1pCTbDPL70ml/veOJ9yoZoycDiqNNKzUr05ZqsLmu8Ds/P1z8NIJ4iPKeIktMcwDZ+O85P7CiQ0GeBqdBt3SbWvlvq2+0PEddnSFEDy8N4JuaJa+gOE9Yez6bRvHguUknLZ/pomOOo3wz1NcIb+Nhj3EpJbdpmh41ShZTFyhTTqZqV6G0nE1dhTpSzJ3LvKrbpdPPZjXVxrM72AXdb66KfGyap02AwNlwQBpP8RNv0AaPsy59bfe4xD7GHew+cfOAMyxEwGxcdBiMvD/YSdMxO0q/sww9/Yt5nkzGlSScg58L25C8lMlzJ4VAmKLbwA4+MkLkKPtbRcmw9pH/IVlrqc7P/wHK/E2t//Mh0/Hc/wETNyIqb9oXSpjAF+0F9QFGdWiP433U6lddSLWRBsj4cvO+V8LHC3v9+bAmccRTwLDqIQhBFCwYqCFZbkyEUJgYdo59tTZax53aJTVBbR1kRmkYAz5WTmD9xnWr0ylMmvYG82TbwSyE2WES+bwMizKkHi/90oK6qKU4pTh6pnvnrKPfZ+SoORdBU5SFLor/M4FzNF4MkreIU9K7wPDt+4qFGalZUOSCY/5mPHwq3l5CELIYO961n5+RNpvrEoAjx7zRQdMDEsiA1AAE6xLyIuIKb8Reh9wda4hh9RpSBvg0n4/dTxiqNBlh9yE5QISzauxazv/rshw7GpabO4HHX1ZxUSPChThoE2VGg0KWOgGckqhni1fruA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR07MB5381.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(346002)(39860400002)(366004)(36092001)(451199015)(478600001)(55016003)(38070700005)(6916009)(71200400001)(66476007)(66556008)(64756008)(8676002)(66946007)(7696005)(316002)(76116006)(5660300002)(4326008)(38100700002)(26005)(9686003)(6506007)(66446008)(52536014)(8936002)(41300700001)(186003)(122000001)(2906002)(86362001)(33656002)(83380400001)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Bxf6Tnnt/hT2MJaJXJvNjCs/+wJloOiqRyjhEugs6R0PSNvQdnqQWbUUkoS+?=
 =?us-ascii?Q?ft1kSMjvymJDd/Io4c8TQM4XAd78eWRKi/A/FsI6VYLP3xfe++LBBj2p3U1j?=
 =?us-ascii?Q?GI6kUBeBWBTx8mUfeYhoz2GBB3vx+Ap6kki6dK2bOkm5pRMny5GO0iVhToOE?=
 =?us-ascii?Q?pm2Zwn9vFab/HlBa2BVApzkS1CUouBO0T3iI8Cl1+FjV2EXBOeIn6RZbkLLZ?=
 =?us-ascii?Q?hO0y+P9V1201oj56n8LU0dVrmc0+JUCviAYMqOW149f0+jHMIb/6Snt+QWw/?=
 =?us-ascii?Q?3mXVovP0lyC9C8zNWD1BrDg+XNf08Eq4/NrfaHzhjnPZRs+zZR821CWZk7h0?=
 =?us-ascii?Q?fZZzDl3NrnZVEuNnWfMioufvSOX4nizQRSkeQ0St1vR29PreoG5LynEfVpf+?=
 =?us-ascii?Q?iDGVV6tY/Fd7GfcztkxsTMGOSQXozC/PPAWyz4sPQGCBt8lwteXAHDHURcmj?=
 =?us-ascii?Q?BZ9IjowSKUhZbwO7iUAKeaXGQ/IgTKYIzdmC3VQqScNMa+ryPuf1v1v4MxWD?=
 =?us-ascii?Q?x0TdZRz3DQpBVMiZuGjwfXsCNlAscCgGq3xrDJ5u7pLONh4EUgE4fWfBiw5C?=
 =?us-ascii?Q?B7gTyI6CJbUl6uppepZvxuOxyavXSow/lcU3hmBGkrSKm/a5UpyKlbpQfQT7?=
 =?us-ascii?Q?TOC84ZcY/Ugk1XTbomOlutylJiwKFQzwbcKY2Luz6WXH5+E+H3C7gmCIIaHx?=
 =?us-ascii?Q?jud7OXq388Buk7UJjqnIl9p0EsSNShbAyaWjTngUIpXEiJPvlvrcCRkFyNc+?=
 =?us-ascii?Q?dKIkVyWc9CvnWc3o7trjWvj3HWkuid53/O7+x3cm9ofCRjR3OPT89NqUH665?=
 =?us-ascii?Q?MOmZmWoyG3cLwzfqgbinw1zdz2q+0KvThMZrQFu7EhWYuKsinvRjBvScrldX?=
 =?us-ascii?Q?vucP59g+ycNw4KgCCuUrNspF+yVBgCom5hCBJjTksBWr2TPM821PAU/ro7Fh?=
 =?us-ascii?Q?qdQ7jonmlTSVdSRA8iroWE9+DrJNokwAL5OiM6PM4VB9KYiytltrcuwfpEN+?=
 =?us-ascii?Q?1Lfl/6h0BeagpzM3SYSeA3oNZW/d5Vnk0htWbeDkWAVTaUzvnpangk/EIi5o?=
 =?us-ascii?Q?A9qxitl5+5eJhR4Duo0Ynn2V/0I+c6AfBY3Ugxuh2uBU2Dxvgd02z5QwYL1q?=
 =?us-ascii?Q?MH1+qwXHfQsPH7sF8qM+bv3JTcZ21rXibbS/6AGLt2Ypm3gareehO909QKzC?=
 =?us-ascii?Q?zaNmZFdQFVyHDxyAxEqheZIgPtBFvgkD/P/ijCFDRW1RrsSng8NHZxwJfn+y?=
 =?us-ascii?Q?XErXV1+aLctoLJJWbvsIPDg4I3A4VFyUuSKFmBNAn5NjcxwGlJICU+dPtKo4?=
 =?us-ascii?Q?CTu4vHbG3VvZKlSNP6oj5W+9Zb1KNAH5G3CeR34nBKKUulkn0ehJVbJZFqhT?=
 =?us-ascii?Q?oUJ13rvxYMyCWzN3YblyAKWELhokE/Hhi1utU9zk+Y+hNj5OGocUdG1B7cnQ?=
 =?us-ascii?Q?8ysNyOsJ7S9lIJ+Q9zf4yNd4h0FVaLMZVh49OIJ6RVTuf/iAuoKcx/WarOG2?=
 =?us-ascii?Q?4SmTd3v+bJg46QVXUvMGUw45ud5val8QfCB6JIVf9EYPBRNHXpEkSZ+mrXu2?=
 =?us-ascii?Q?EskwBsHFcmuWNRTNBJCiNGvd8x+nzJP8VccnkA3Qy7J9K4yHUiv/sEdghFsL?=
 =?us-ascii?Q?vQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR07MB5381.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c7f84d1-283b-48fe-0afa-08dab5c98284
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2022 14:10:30.8623
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vKLt/0e+4Y3vi/XBer5MVlhPjMsSJd0veBwCISbV7YyN+qK93c31U2wyILRaJnjk1p6+NTdwfPu+AFCZgQ0SO/jnZJSP8QFTcj1fwCzsz5Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR07MB6237
X-Proofpoint-GUID: 0ncyyLqY-Sxqd6_rPo77ttkmRKqDMzkc
X-Proofpoint-ORIG-GUID: 0ncyyLqY-Sxqd6_rPo77ttkmRKqDMzkc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-24_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 bulkscore=0
 clxscore=1015 priorityscore=1501 impostorscore=0 malwarescore=0
 adultscore=0 suspectscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=407 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210240087
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>> >
>> >On 22-10-19 02:07:17, Pawel Laszczak wrote:
>> >> Patch modifies the TD_SIZE in TRB before ZLP TRB.
>> >> The TD_SIZE in TRB before ZLP TRB must be set to 1 to force
>> >> processing ZLP TRB by controller.
>> >>
>> >> Cc: <stable@vger.kernel.org>
>> >> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence
>> >> USBSSP DRD Driver")
>> >> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
>> >> ---
>> >>  drivers/usb/cdns3/cdnsp-ring.c | 15 ++++++++-------
>> >>  1 file changed, 8 insertions(+), 7 deletions(-)
>> >>
>> >> diff --git a/drivers/usb/cdns3/cdnsp-ring.c
>> >> b/drivers/usb/cdns3/cdnsp-ring.c index 794e413800ae..4809d0e894bb
>> >> 100644
>> >> --- a/drivers/usb/cdns3/cdnsp-ring.c
>> >> +++ b/drivers/usb/cdns3/cdnsp-ring.c
>> >> @@ -1765,18 +1765,19 @@ static u32 cdnsp_td_remainder(struct
>> >cdnsp_device *pdev,
>> >>  			      struct cdnsp_request *preq,
>> >>  			      bool more_trbs_coming)
>> >>  {
>> >> -	u32 maxp, total_packet_count;
>> >> -
>> >> -	/* One TRB with a zero-length data packet. */
>> >> -	if (!more_trbs_coming || (transferred =3D=3D 0 && trb_buff_len =3D=
=3D 0) ||
>> >> -	    trb_buff_len =3D=3D td_total_len)
>> >> -		return 0;
>> >> +	u32 maxp, total_packet_count, remainder;
>> >>
>> >>  	maxp =3D usb_endpoint_maxp(preq->pep->endpoint.desc);
>> >>  	total_packet_count =3D DIV_ROUND_UP(td_total_len, maxp);
>> >>
>> >>  	/* Queuing functions don't count the current TRB into transferred. =
*/
>> >> -	return (total_packet_count - ((transferred + trb_buff_len) / maxp))=
;
>> >> +	remainder =3D (total_packet_count - ((transferred + trb_buff_len) /
>> >> +maxp));
>> >> +
>> >> +	/* Before ZLP driver needs set TD_SIZE=3D1. */
>> >> +	if (!remainder && more_trbs_coming)
>> >> +		remainder =3D 1;
>> >
>> >Without ZLP, TD_SIZE =3D 0 for the last TRB.
>> >With ZLP, TD_SIZE =3D 1 for current TRB, and TD_SIZE =3D 0 for the next
>> >TRB (the last zero-length packet) right?
>>
>> Yes, you have right.
>>
>
>Pawel, With your changes, the return value is 1 for function
>cdnsp_queue_ctrl_tx. Without your changes, it is 0, something wrong?
>
Yes you have right.=20
It does not cause a problem, but it's not according with controller specifi=
cation.=20

I posted the fixed version of this patch.

Thanks,
Pawel

