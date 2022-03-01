Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237E54C9435
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 20:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234672AbiCAT1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 14:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbiCAT1Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 14:27:24 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133FB140CC;
        Tue,  1 Mar 2022 11:26:42 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 221IflnS032613;
        Tue, 1 Mar 2022 19:26:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=8FAR0YUArHX3dRbvPP7fSb5374OvQq6XSo5NckODtIs=;
 b=V4Pl8Pszg7bIXEFtWBn/M+Div5rO/PJ9hlTuDPjNnZhtsAZLlRuyJgK0eQykqdB89KHe
 GLg7eCRIRjGMXrD+2YBzVy9ez+r6Xk1H/3e9e6cIA8ylEfW6gW763Cwj3DP/HWP3q1Qk
 RM5CXTmUIHN3hw8aqVb3qh5Y+04XynJ1qIaCft8ULRjqs2xgnQtciWQ2b5+fJD1QLT8K
 dp9Oy/3CaPi08I2qerN4wc33flNFiYbwCev6RBCyrXz2iAeG6w1h2tuj8rOV/fmuMWnM
 gy0OcNfaLQ/Mzoz9qpfwuNxAexyf+6bqzCgPnwIU6ElV7RfDvcn5+VCubwpLo6isF2fR gw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ehh2ehm2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 19:26:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 221JLL2p080888;
        Tue, 1 Mar 2022 19:26:39 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by userp3020.oracle.com with ESMTP id 3efdnne1pt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 19:26:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hWreh+aAosYNWrlTxXRurERYQZGs3Pnj8+VNR89Rc9rE+aO7O6nDC+qm/vNpz0cEX2gKc+ZU42vvYuxvem27XZ7urCh1wVgMVoYFO1ni9kEfp+PJFzrseXD8vrV5nYL6Vz/7OXFX+dgtIcIRKb/vzPcIsZtRxJDiY2l8rmi5GQuYzpl/H3/RXVQ6cDCFhJ9SPbL695t2k1/XwWbg8BrwXe4wX5cN9j2KHalxNbGOAZj2aIjudwrQXfZXse0Alc3ekUWC0AB4M4s7KBuOko/ja4hL6CGZ0uLo8obGg8lGgSfbizPQDun14yS9yMw1FayS1U9mXvp6JKMaO5nijgtJpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8FAR0YUArHX3dRbvPP7fSb5374OvQq6XSo5NckODtIs=;
 b=mUSqb4DPSqnbOg6n3etblxtzr1g2MHiHFr2T1UxYIM+E1TMNBjtCoa8HMnXjxuzg7f8/lye5yBG3xYQUVmrjGFB1xGNsp4jNwuv/fdHjEK+lS8k6M4oP6dEKU3u753O0demXEt9OYgZsxTUx+uk7pQLF85GRebM9XVdqYL6dCs4SIYq+rq4UO9JjY1UBP3uTAkbtC0PXW3B3oFJBHghYRN1JIf8KJnqtmtECHJ0q5Ubh9Q2BhKsWzMv+liPLQtoLRrP9ZA8wEkprhFkRmwDCNZgtOgZcegbvZEo0wpsPoa872X9mgCq1WEl99mhiWGD6NVnGxpYwVWKx60/xrl2EJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8FAR0YUArHX3dRbvPP7fSb5374OvQq6XSo5NckODtIs=;
 b=eVHC15DTdnuG/X3TxigVAeJWdPK3mnO1ROmbrMhm19vKUndGnpE4IiVb0q4A4c/cIvesw36D/gFrXlTcqHGDImj49935jwYaAulBKk6cKhYJMqRwycwj0BZRAYjpF9ZGEguCmz49HF+9AkuwBDppsYcmvaWq0MEqnaVgmC+bzOY=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SJ0PR10MB5438.namprd10.prod.outlook.com (2603:10b6:a03:3b8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Tue, 1 Mar
 2022 19:26:36 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::98be:91a7:9773:9d39]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::98be:91a7:9773:9d39%4]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 19:26:35 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     James Smart <jsmart2021@gmail.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shyam Sundar <ssundar@marvell.com>,
        Nilesh Javali <njavali@marvell.com>
Subject: Re: [PATCH][REPOST] scsi_transport_fc: Fix FPIN Link Integrity
 statistics counters
Thread-Topic: [PATCH][REPOST] scsi_transport_fc: Fix FPIN Link Integrity
 statistics counters
Thread-Index: AQHYLZWXC8QNlmf7bUqHCBPmEkbEYqyq6VyA
Date:   Tue, 1 Mar 2022 19:26:35 +0000
Message-ID: <7E6F326B-1A17-4F1D-95A6-CA9440F4F910@oracle.com>
References: <20220301175536.60250-1-jsmart2021@gmail.com>
In-Reply-To: <20220301175536.60250-1-jsmart2021@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ed68f3c4-fd56-4e7e-67c6-08d9fbb96698
x-ms-traffictypediagnostic: SJ0PR10MB5438:EE_
x-microsoft-antispam-prvs: <SJ0PR10MB5438429707537B692F9181C4E6029@SJ0PR10MB5438.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +4zUSOPOP3Qn1OzvvWToXXt9FarYxxJRUULYEi3Ax4P2Q7KP9fIfiN1pJ5ZlVY5Uoebmu/s6oyH35/5monZRJoe0pDk8L/OU9FbtU4pvDRFmkZ+zQdjRSWrgb1Co3SWVOx56iwEvBjnGzHfuS6ZLXq+uiegQdnuyI0qhKZ4AXO28H/yT+AuT5MpR+XZQcP4cdzek450ZAJtHhsjtt2tGOuTJ+qtftgyC8TKKs5P1vHLalfmXFvrExABkH+Kka9nNjkkH0fzXfGWABBldlzpZyjgdvosDpY6oztPYJ5sSLbfedXL14FeVptmu/J0cqHg9twjFk6X6L3gk40dWL1DfhMtZ9xS10zMZFavCXwdL7NPITvLprQVBjW5y393WenQBEpDbyhUkfnf27VATRnXxXXvZPYHSaqnmQ+0zT7sBJmbgcNbIp2DS+s7/SitPz7+ebnqy8ftuWTMCptOL+c1WlA94fkaOWeP5wECc5cSVzPSx4e+xNiBVFPSIPBk05mQTX0ZyzDomO2zfk4eq+20R52hCSRBPQcXSVmDYqdhAbQIQLJOx0UXrAqPenuNE/0PgKbT2BBVROk/OEPcFCzpFYI+fvH23kB+WLwf49S5RAmFeZo+NjaEt/U/4ErFhSfwiHrTHumm5BGovR/w/JpN01HKmLkSBtzAkyZhmAZyIMEO+WLeYUHu7XKGJ/YJ2Ict0iqq78wlf9/xXlkuO3bh+z0PMJ647bPGi4t8Eq9rGZDkIQ2DjE/KbDtnLb7eVY9NFeVgje4XLXXTZaFmW2EeLd56sxUs00A3nhC9XEjGiOb0YTFDyPXQ2nnIbd7dcp6/FOtyIhegIDxnksCg0JR62WA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66446008)(66946007)(66556008)(4326008)(122000001)(2906002)(64756008)(2616005)(44832011)(8936002)(5660300002)(8676002)(76116006)(66476007)(86362001)(38070700005)(33656002)(36756003)(91956017)(38100700002)(316002)(186003)(26005)(83380400001)(966005)(6486002)(508600001)(54906003)(6916009)(53546011)(6506007)(6512007)(71200400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iH1YOSoeCjABj30ctRk+uMuhdjsCCThEkJIwBvWosQTO0IdtuIWz6HEPR4rk?=
 =?us-ascii?Q?TJOpT7YpEDpseaxzuQblFKN6362OkWzcrnOner2RZiMi6idXR+GTZuj4Kb0y?=
 =?us-ascii?Q?fGydB1mBIZ6a/HiMTmhtMcTU+jwuGZRGpGxxcSFXB6LTI8rufjor2N6LkqFW?=
 =?us-ascii?Q?x0PVLVV8cEBaNvxW69mYOHX/ijqgWB0WiK9XFyQP2hHx4YHeRplrSKgJOGJs?=
 =?us-ascii?Q?i219Dq7a2ZmyZjh+OJkUMtHFTnGM3WRmHr/GQer+KH91feMAy71I4X0RNNr7?=
 =?us-ascii?Q?YeNppgbssQGh3K36cGNA4Vtq72P3zQAbcLdyvs32+Vt8mTiV8W+mPWgCyTRe?=
 =?us-ascii?Q?voGEDqjyluOnLFBZVpT0lnN+g7yvVjJ/8eWrVc3cNBMdO9crL9uM7VaNKqAw?=
 =?us-ascii?Q?m162CbcanOaSRPscMHSf6QIIGRkBbhCoAAioedKAqdowxtP2/drsUTXBO/Lv?=
 =?us-ascii?Q?YHkSvrKtPbZIUNpm8tpS63KRwFO7cM+ljkGwCmBL1G1RElJ7QEIN7ipypXh4?=
 =?us-ascii?Q?3PQvdXyAcEDvZSDKSIJIpR62QZ3bxdLUyJJCoiH+QDgIB/KPyoyI2v+8025G?=
 =?us-ascii?Q?h86GTAs6kfRBNBWgvxZtTLODFsGI1/rLU18GQ5+mTUPNPQrO5SLjY98HxtaM?=
 =?us-ascii?Q?+KBgugfAqn7DnMsTn4CS/1Q6kqTUCbjeIbKOjvn322wGdQfMrglfTJ0BpU7u?=
 =?us-ascii?Q?L5GUoVTzOEGKRo5W83amdlZCWyz2KA7P9i81qu0/4stFdTOYSgCKAlM54JS1?=
 =?us-ascii?Q?z1liz4m3AHGZzrApx+Q5e4I1B1yA3te0uTpD8J+fvn7T3sqnqWr9mAAzh7Sg?=
 =?us-ascii?Q?mPGdpBIRoPs5vINXFz1e8+vweyvm0kIzpM3eNPtTm51Ex4MJH7nCcFmhyqL/?=
 =?us-ascii?Q?3+jVgknmVSAvODsshYdCtP3LZsbq4NRXGrjPqBHjs0ioHAxmQbgOMcCp8xQ4?=
 =?us-ascii?Q?ioMZ9lyYpGbQuy7wAJbljUQjN+EvoL2oPIEhytRT+ImQxLPS16PnNOvD2eoo?=
 =?us-ascii?Q?fSg5e5z08O/wSglltCBog1XYul9n646V3SFzMYi8oQkjrcivwYVkHuLdxIlj?=
 =?us-ascii?Q?cjwMLcZ0fU0J9TlcBsfiPglALEdxZEDqhqGM5uRLyS1LloZ7vm8Drs5OTojJ?=
 =?us-ascii?Q?5t3c7PoCidoqfqfNv5UWndpMbxniyFrcXhOSpxjY7F3E7xUfPXHYukDCU7bp?=
 =?us-ascii?Q?VB1GhzsWHvwglPXqm2GU0nbJFUEGbNSW8ukGtLtEidM1DR8WestHd7Oert0k?=
 =?us-ascii?Q?PshC28YLmkUBjGXNN8yO7SSs0OVMdaMIW7u7wbUUhObM4oJX2ChP1HMC5oOI?=
 =?us-ascii?Q?V89VNxgWax+0REWIlOQHiOElR7VrwF/wo6L9AV9WG392kmifnb4GyU2boaRB?=
 =?us-ascii?Q?SEsENWFAlNN7UgM0gAMrCoTluCdj9yVUtgHHZhjK0U6JzN9qIl7bvQGI2Qv+?=
 =?us-ascii?Q?bz0ppFZN8ULw2Lw0vh05xQpNt25K4M/R/6ep0kTKgG2z0oSFKmMXAFkPcGKR?=
 =?us-ascii?Q?WMz2F0n1D+clyTVjbDCkdNfBeGHXwbOgJ33YCZOfjYQGuhIESUtFxIcboX8a?=
 =?us-ascii?Q?Su9jInDcrOMDunUdqPpXR8sMZUFCgGfgtzSsaah8H3auT8qz0Fz5GnDtyJuH?=
 =?us-ascii?Q?HtKt2VY6tL8jBpc1flWznChhtHd8ehBBK/GZn+WHHKk7rec3c0jvwIWudD5k?=
 =?us-ascii?Q?0NyVJGAO50DMvzlm7vb+MLck6+I=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5FCF9D73BE8CA8458885EA7EA38DA22E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed68f3c4-fd56-4e7e-67c6-08d9fbb96698
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2022 19:26:35.7327
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w4ak/E8t9Z9lK9+r0n5sVtapR1iOXm6wcp+e7JqhnDDomIHDC+Fy8Xv8vOvZz/ixTlpsylpZQ00tOMuD6UJf52Gfj1iTuZYRg7a2QuQR9M4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5438
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10273 signatures=685966
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203010097
X-Proofpoint-ORIG-GUID: Rq5BoQDzako5YbwK0LR5NGvCLKqjfVQQ
X-Proofpoint-GUID: Rq5BoQDzako5YbwK0LR5NGvCLKqjfVQQ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Mar 1, 2022, at 9:55 AM, James Smart <jsmart2021@gmail.com> wrote:
>=20
> In the original FPIN commit, stats were incremented by the event_count.
> Event_count is the minimum # of events that must occur before an FPIN is
> sent. Thus, its not the actual number of events, and could be
> significantly off (too low) as it doesn't reflect anything not reported.
> Rather than attempt to count events, have the statistic count how many
> FPINS cross the threshold and were reported.
>=20
> Fixes: 3dcfe0de5a97 ("scsi: fc: Parse FPIN packets and update statistics"=
)
> Cc: <stable@vger.kernel.org> # v5.11+
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> Cc: Shyam Sundar <ssundar@marvell.com>
> Cc: Nilesh Javali <njavali@marvell.com>
>=20
> ---
> This issue was originally reported in this thread, with no comments.
> https://lore.kernel.org/linux-scsi/b472606d-e67c-66f1-06d1-ecc5fbb2071a@b=
roadcom.com/
> ---
> drivers/scsi/scsi_transport_fc.c | 39 +++++++++++++-------------------
> 1 file changed, 16 insertions(+), 23 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transpo=
rt_fc.c
> index 60e406bcf42a..a2524106206d 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -34,7 +34,7 @@ static int fc_bsg_hostadd(struct Scsi_Host *, struct fc=
_host_attrs *);
> static int fc_bsg_rportadd(struct Scsi_Host *, struct fc_rport *);
> static void fc_bsg_remove(struct request_queue *);
> static void fc_bsg_goose_queue(struct fc_rport *);
> -static void fc_li_stats_update(struct fc_fn_li_desc *li_desc,
> +static void fc_li_stats_update(u16 event_type,
> 			       struct fc_fpin_stats *stats);
> static void fc_delivery_stats_update(u32 reason_code,
> 				     struct fc_fpin_stats *stats);
> @@ -670,42 +670,34 @@ fc_find_rport_by_wwpn(struct Scsi_Host *shost, u64 =
wwpn)
> EXPORT_SYMBOL(fc_find_rport_by_wwpn);
>=20
> static void
> -fc_li_stats_update(struct fc_fn_li_desc *li_desc,
> +fc_li_stats_update(u16 event_type,
> 		   struct fc_fpin_stats *stats)
> {
> -	stats->li +=3D be32_to_cpu(li_desc->event_count);
> -	switch (be16_to_cpu(li_desc->event_type)) {
> +	stats->li++;
> +	switch (event_type) {
> 	case FPIN_LI_UNKNOWN:
> -		stats->li_failure_unknown +=3D
> -		    be32_to_cpu(li_desc->event_count);
> +		stats->li_failure_unknown++;
> 		break;
> 	case FPIN_LI_LINK_FAILURE:
> -		stats->li_link_failure_count +=3D
> -		    be32_to_cpu(li_desc->event_count);
> +		stats->li_link_failure_count++;
> 		break;
> 	case FPIN_LI_LOSS_OF_SYNC:
> -		stats->li_loss_of_sync_count +=3D
> -		    be32_to_cpu(li_desc->event_count);
> +		stats->li_loss_of_sync_count++;
> 		break;
> 	case FPIN_LI_LOSS_OF_SIG:
> -		stats->li_loss_of_signals_count +=3D
> -		    be32_to_cpu(li_desc->event_count);
> +		stats->li_loss_of_signals_count++;
> 		break;
> 	case FPIN_LI_PRIM_SEQ_ERR:
> -		stats->li_prim_seq_err_count +=3D
> -		    be32_to_cpu(li_desc->event_count);
> +		stats->li_prim_seq_err_count++;
> 		break;
> 	case FPIN_LI_INVALID_TX_WD:
> -		stats->li_invalid_tx_word_count +=3D
> -		    be32_to_cpu(li_desc->event_count);
> +		stats->li_invalid_tx_word_count++;
> 		break;
> 	case FPIN_LI_INVALID_CRC:
> -		stats->li_invalid_crc_count +=3D
> -		    be32_to_cpu(li_desc->event_count);
> +		stats->li_invalid_crc_count++;
> 		break;
> 	case FPIN_LI_DEVICE_SPEC:
> -		stats->li_device_specific +=3D
> -		    be32_to_cpu(li_desc->event_count);
> +		stats->li_device_specific++;
> 		break;
> 	}
> }
> @@ -767,6 +759,7 @@ fc_fpin_li_stats_update(struct Scsi_Host *shost, stru=
ct fc_tlv_desc *tlv)
> 	struct fc_rport *attach_rport =3D NULL;
> 	struct fc_host_attrs *fc_host =3D shost_to_fc_host(shost);
> 	struct fc_fn_li_desc *li_desc =3D (struct fc_fn_li_desc *)tlv;
> +	u16 event_type =3D be16_to_cpu(li_desc->event_type);
> 	u64 wwpn;
>=20
> 	rport =3D fc_find_rport_by_wwpn(shost,
> @@ -775,7 +768,7 @@ fc_fpin_li_stats_update(struct Scsi_Host *shost, stru=
ct fc_tlv_desc *tlv)
> 	    (rport->roles & FC_PORT_ROLE_FCP_TARGET ||
> 	     rport->roles & FC_PORT_ROLE_NVME_TARGET)) {
> 		attach_rport =3D rport;
> -		fc_li_stats_update(li_desc, &attach_rport->fpin_stats);
> +		fc_li_stats_update(event_type, &attach_rport->fpin_stats);
> 	}
>=20
> 	if (be32_to_cpu(li_desc->pname_count) > 0) {
> @@ -789,14 +782,14 @@ fc_fpin_li_stats_update(struct Scsi_Host *shost, st=
ruct fc_tlv_desc *tlv)
> 			    rport->roles & FC_PORT_ROLE_NVME_TARGET)) {
> 				if (rport =3D=3D attach_rport)
> 					continue;
> -				fc_li_stats_update(li_desc,
> +				fc_li_stats_update(event_type,
> 						   &rport->fpin_stats);
> 			}
> 		}
> 	}
>=20
> 	if (fc_host->port_name =3D=3D be64_to_cpu(li_desc->attached_wwpn))
> -		fc_li_stats_update(li_desc, &fc_host->fpin_stats);
> +		fc_li_stats_update(event_type, &fc_host->fpin_stats);
> }
>=20
> /*
> --=20
> 2.26.2
>=20

Looks Good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

