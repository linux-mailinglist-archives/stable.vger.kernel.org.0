Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA135FB82D
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 18:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiJKQVC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 12:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJKQVA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 12:21:00 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A80393781;
        Tue, 11 Oct 2022 09:20:57 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29BFOUkO005204;
        Tue, 11 Oct 2022 16:20:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=vY34O3GE+cqOnefe38DcQu/nQZbCOltELWGtEtlLoY4=;
 b=e8dPXhAov0yYSzFk0StFdB11Jam/5EtBBusio/5OcUMSaJA3xq8ZaNsITNd/AhEHlJd7
 5mB9VzAfKc5K/a8FAi67Z2ISsqo+E1Rt+BxIeo9hMaPfKNGRVIOtg0+U5nbwl9c8gGG5
 vbZwqUyscd0M+x2PNc7n27eAKtg4tuDPbW5fcYCmCoXP5hTxc0EB2syJ65UhQBFj6k9N
 MYrEOpk6eLR7AFMqtgHL41ZWumJ+fyLESjmjrATtjk23suP72WeVq7bXxSDbcI57ARfe
 CZQcGVW3Op0OLCsRtwTqpSAJPXw0ZH1CBbis4M1PdyzZKwOrnO34O+IKHQ6c0kvABwe1 Jw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k2ymcy3eu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Oct 2022 16:20:45 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29BFUaIp027365;
        Tue, 11 Oct 2022 16:20:44 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k2ynabxa6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Oct 2022 16:20:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=naCRMYHtCp48R6cvcx38oQ6vC2Bv7eVqfc0cdXuKhG16FQdlhP1mdRx4TP8qJ56baxvU2zNul1eoRnSMHu0Btm5Pzw2hqcv5N4maQELt7zI0XK5O0cv1qSCdNSR8/Ag2xpaJfz4GbiF9f+HO22yath9Zu4BMWuqvGrIwcSjU9OuG8Yc6LkGUxkW3hl+IRs56R6cjnnVlrhcy3zTd5rY8H+9zXLHHw5JDYYM96SBSiJ0eQd4JVXsj3FUUe6yb1EnnD4s3axWrnnV0jb3JW9U3jvpRprJstUKJaWAdrhogWKI6otSKSGGwVglGuUBTzZkYuHusJ1nVxnBnlUXOrz3FeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vY34O3GE+cqOnefe38DcQu/nQZbCOltELWGtEtlLoY4=;
 b=b7lTvVpRz4GfS63U1hhogw950nNXBvb+XWRvguuR04c6sjn4xl3naNDMCOZ8ZR4fyADRbfBok6cuR4MtiRMWqUV/jepKLichLuBKwhnyIYcYwmyAB92uLo5TLCr4OeFDsBxxjiUxuz2+ev9jsy4tQlcpv3KsI/+3ZmIZEgqj9zSt3vKShz0FgpWlsbM2Pneq7CXyxu5Sp4+AgIuSmt+rMOXLy1DYOTB4OcxsTYB7/RiTE/r4guKMB8dLKycFyI8HhQ8NPmn0SPFESEqcnIC5zdxhG9fHJ3cPLJb/RLafJiVr7X6U3Zg9d7mgn8g69LF3ZqEMhuYZ30ctK8eplKjKqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vY34O3GE+cqOnefe38DcQu/nQZbCOltELWGtEtlLoY4=;
 b=RmX1UNxgQXlBhkUxh9v3sqdwOqlE/PgUTzZptRdhmY2HW+/f+UWDP5FL7i/ww04QwDXcebZtufmoXeUHSaTgHdNo7fDdd+c+Msj+9fqs9YPQgShIksqgNk6z4DSefij/XwCskexhV21O2BPUUxNao09DxHga7uK8wHcI6IiO53Y=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by PH7PR10MB6131.namprd10.prod.outlook.com (2603:10b6:510:1f5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.15; Tue, 11 Oct
 2022 16:20:42 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::2d77:5bd1:1bba:df5e]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::2d77:5bd1:1bba:df5e%2]) with mapi id 15.20.5709.021; Tue, 11 Oct 2022
 16:20:42 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     Carlos Llamas <cmllamas@google.com>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Michal Hocko <mhocko@suse.com>,
        Christian Brauner <brauner@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        Suren Baghdasaryan <surenb@google.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] mm/mmap: undo ->mmap() when arch_validate_flags() fails
Thread-Topic: [PATCH] mm/mmap: undo ->mmap() when arch_validate_flags() fails
Thread-Index: AQHY1GUEffQzm7jnEEi2QMlNBLqhq64JcfoA
Date:   Tue, 11 Oct 2022 16:20:42 +0000
Message-ID: <20221011162032.lqj7dajril6ijkf7@revolver>
References: <20220930003844.1210987-1-cmllamas@google.com>
In-Reply-To: <20220930003844.1210987-1-cmllamas@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB3022:EE_|PH7PR10MB6131:EE_
x-ms-office365-filtering-correlation-id: b0e04be6-1b78-4723-668c-08daaba48b52
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KZQn1SBn2kDFCUtqPA3nnAinBFc9LwAtzb5TPPQmwU3DPcC8fTebSMcVbnlQaZysUFMh/sLINAoAVP+NpsFxu8aH579cYyhF3PGzb4vFE9/ruKdHy9cK/HUpP/+3NR7XDSnItqshWtJT5niGahO6kfFi039ax1+S5l2cs8v48EnmGfqoKvMgOL0D5MpWg5vieEU2XTT/c3R5zn+dtDxUd7diicUL19r5Np6ACl4oHqyZ3N8eOk+pxB8sFhiGVC/UkyGqPWhU2OJ0ZJSbZhqWLfbIcKrW7TFBMyvDuSrr0GPY+Fs/Ml5N9ne+VwuC2d5ieZHS86VBGwGR7dyChtQQwHDGB9Bu18nZV5DCcdkzPgKqZsbg72GEXRc9XZVDZVksMEgy9Eo7BhNNXLQW5zVSUxtmG0xB8M6OwrFpnlmkYCrKIVMbdeJtMXkMA79nJyT/yEYdMOU28VhkuqGJK4ZI2psYI7wSf+CoYxtG7DM4x+MQds0ilDoQoKWHeQXtsT0Q46efKH9ACtalDc6bEqEAv8iO4ClqDBlJ9Z7xCPElCkrK2rriW4kyX5Xm3CcHls7hGSZds75FpeokS1kexTkdCM/XpgN59gSkVqnzGd8TwF/00Uo15A9IzT72Hdl4YPvLONaOgv/lh59s8FhkIg+w59wDNwM6tNSFmB80UM26wKr+vRZyPMm3F7vO9UwKcGuBYjT5k1clURNGRtPzTROZrlZflb1yLlSqltrYf2X39149A4t0f7GKJS9xIcqmldtLBjJoiHshOnDQ2Wa2sDt6Cg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(136003)(39860400002)(376002)(396003)(366004)(451199015)(7416002)(4744005)(44832011)(186003)(9686003)(1076003)(71200400001)(2906002)(6512007)(66556008)(26005)(83380400001)(8936002)(66446008)(91956017)(76116006)(38070700005)(64756008)(6506007)(33716001)(4326008)(6916009)(8676002)(41300700001)(66946007)(316002)(38100700002)(5660300002)(478600001)(54906003)(122000001)(66476007)(86362001)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RxYXjYLfHsJMrSN8CIk8osy0aqc3TEXAqrqgjq+URn9rMa+wuqbYhVdKOmuF?=
 =?us-ascii?Q?Ug1s7b8BZD1vM2z7lIhfXIpQAsLMMbNJlRU0jSmBIco9a8Df3rBbe8Q1F7VN?=
 =?us-ascii?Q?lRJfW3EleHc/5es2Y1XgdgwvCSovlfJGQQa+afqVxPHkuedJbUt+x+agZK1r?=
 =?us-ascii?Q?RqQkSbddB6SJIXyzQkbasJ0wTEWaa/xUvtWmfnwIdV2U+w89mjZAsxYKInFX?=
 =?us-ascii?Q?iCKWlO7Nq2Aa6cX+tKl1IWKjuPdHoRrUMdrnQUmcZ6Fvay1Ot769xlz0G3Hf?=
 =?us-ascii?Q?ncZqrHy0cBQJ2svy8bjK/8NJq9XsiXAzJhM3ybE4lIK06pjQfb9u61FVPx+c?=
 =?us-ascii?Q?+rKrYFwWrCGI082ZLIDKndRQnff+uSKOnUv925E98WfVtxRvONqvQxY9Sfz4?=
 =?us-ascii?Q?Moqc0q0PuAHFfZR6kcyP7jZWvYlVN4XzeD1kO2uzyKO2MldvFPTN9xPwl0ft?=
 =?us-ascii?Q?VsVKhh+t0YFsT0Ko93LeLCNYvZFMJ1LLTkrEuf9p4t7kPBFeWIOROKrw/XMz?=
 =?us-ascii?Q?ANzBgilSckfh6+/CjsLsDhBMPpxjjIJsjV7HryQR7tNf4ojTCSkOTry2tjy3?=
 =?us-ascii?Q?m9CbDuwAdPOZ+SagS7YjpocaJeC0uUKSilZya2b0teB+46+K14a+ZcLjLsUB?=
 =?us-ascii?Q?kniS6CE/2n7S3C5PeA4hukjKd/GMoJkDbcTwJ7EY2c92e6q83qCkFu1XxmLa?=
 =?us-ascii?Q?GRxcz8GxYkeYjxfOIxuXK1vYzI1ozcva3g22jeknNyhqZcfCTNV8uoP11vfE?=
 =?us-ascii?Q?TwQovP7dfQ3zOBWB2QsM/0wRqrj9jH0OVbd6KzOK3//12xjFL0cRegAE7WN+?=
 =?us-ascii?Q?6BKveqn8qI1HE2Xf7dNawsyvEQ79lcwd1HVZ8dE1COkWLFE7MqPWRuHJ2YFl?=
 =?us-ascii?Q?SxVBSkhPAMFbYlPdTfC5CitwRki/YplT8c4b6xdAESAuf0QVpdxcZTSkR9Q4?=
 =?us-ascii?Q?m7JMSJvnym6uUOd2pA/ycDvAslJ7zGVmR+WSDIzVkOzoEUkm1h2xup2QjUvk?=
 =?us-ascii?Q?oX7nT+aebZDK4OVLI1B1j03NGkrrfPgShPMUVZUaLOtA1EC71W0Pj2Uej63J?=
 =?us-ascii?Q?vsAokdsp8OAgr/u7qfq7TM3SNoWXOsWXkQX1NLrkfgrmEM8RdyNTGu1B7dZS?=
 =?us-ascii?Q?89I5X6rOoj0LPrHp2Xzdb3sEGDDpOlQHvHzmdFVFImDsQTeB5MP5DGdF1tyA?=
 =?us-ascii?Q?X87TBOZ/UWG1Mrqs1Or7rBV1K8VodYmwuNJsDammwVUOEowJPu14AgSVlafu?=
 =?us-ascii?Q?Oa0BalXcGqolMnIXb+KJWdX+PR7aysAnZiCieQfVKH0NtMFvGclF//ixk5pw?=
 =?us-ascii?Q?LHyoTbqEBBGJaORtfFD2Gfntl3oQWSscuIl8yTmXEf8UPNRGti2ThEIrwpLU?=
 =?us-ascii?Q?qWQ1j4QyFlGXSlfLCj7L1l8T/g6Q9uqcZ+eWFM3GVGnwC9OF4DqE5EN2uQR9?=
 =?us-ascii?Q?jfXDIzhqzP1IAfxQCHyWUOpID7fpOTA3M6TEO3cJKVSqgGD+/fng3g8UNmG/?=
 =?us-ascii?Q?jf9EBVHZ6hHpjR6bvaUGqvrZxKWaSkv2x4751fX1lpdS7Yan9+965ZT+En3d?=
 =?us-ascii?Q?UUVz/+Un9dhzl9byKOwetVyCjsRULA6fB7/1vMkoh8UqLt9UHEmWTgIJF06I?=
 =?us-ascii?Q?zw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DB6901BED77A1647BA5B081FD3CA3CB5@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0e04be6-1b78-4723-668c-08daaba48b52
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2022 16:20:42.6141
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MOuinuXhrM/Hj6eOaRUGWohJGFEUE6emfRYZSVG+13k2jWW4MQnOULhYcibrLreawxSq8z+YjNQDK7CTaakPZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6131
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-11_08,2022-10-11_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=873 suspectscore=0
 adultscore=0 mlxscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210110094
X-Proofpoint-GUID: kvcT9mXk57AtKl1ZIOgBZsJUA7zqMYBP
X-Proofpoint-ORIG-GUID: kvcT9mXk57AtKl1ZIOgBZsJUA7zqMYBP
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> ---
>  mm/mmap.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 9d780f415be3..36c08e2c78da 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1797,7 +1797,7 @@ unsigned long mmap_region(struct file *file, unsign=
ed long addr,
>  	if (!arch_validate_flags(vma->vm_flags)) {
>  		error =3D -EINVAL;
>  		if (file)
> -			goto unmap_and_free_vma;
> +			goto close_and_free_vma;
>  		else
>  			goto free_vma;
>  	}
> @@ -1844,6 +1844,9 @@ unsigned long mmap_region(struct file *file, unsign=
ed long addr,
> =20
>  	return addr;
> =20
> +close_and_free_vma:
> +	if (vma->vm_ops && vma->vm_ops->close)
> +		vma->vm_ops->close(vma);
>  unmap_and_free_vma:
>  	fput(vma->vm_file);
>  	vma->vm_file =3D NULL;
> --=20
> 2.38.0.rc1.362.ged0d419d3c-goog
>=20

Sorry for the late reply, I was out of the office.

The analysis looks good and I agree that open() should have a matching
close() call in the unwinding.

Reviewed-by: Liam Howlett <liam.howlett@oracle.com>=
