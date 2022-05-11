Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 227C652353F
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 16:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbiEKOSm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 10:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234147AbiEKOSl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 10:18:41 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23416644EE;
        Wed, 11 May 2022 07:18:38 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24BDhQTV022886;
        Wed, 11 May 2022 14:16:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=DOcbBlogEMDx8hV/sVP9XO3Lmx9ItOC9Px1llkmcRGg=;
 b=GGPRVRX227FWtht7cIwX8g+PGyz4l/aTDfwfeWBUaZDgqqAapjHtB+JMw4nQdBpAT8gL
 Tx3nZS2Ec9ASZVXWnONTwcuuZSdKOUIRTO7oeZGAFo5x9IdnH+TeAfQ8ofHarA41qSVT
 2i0RyuZRgIrcsmWnsmG8LjE+zPoIcwcdKjBzSluGUpjLYZZIFTncF+s4rSOYFzuuCpxo
 saRLeHL1rzZ//IiYmE5eYguGAYq6fH7XtOvEAsJkrDKXuW+YaydMUcxs6QNfDd6cC0Mc
 AwKhlyaeHn6Qg9BCxIxwUZ9Xq3l3UsRyI+EWaMWewx2uQCPck4YhfyloNeCaC+72h0AZ vQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwhathx54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 May 2022 14:16:22 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24BEFgjc031596;
        Wed, 11 May 2022 14:16:21 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fwf74dv9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 May 2022 14:16:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NMq+JY++x0+tlQUhFJ2FL8uuu+WS40UciVqB/lltdkgK87OENM0F+jxizVE0bUUYzAgdMdocB4X9uHp7MF8KyVqOTc3qzY09xdvp/52IyMh5YVi2CC5nFeAYECA75+hB5FkNFMQvk4sxd7+wdioM8+R3pCaLd3MwhbRYiXCVYo/jALvMKsFb0nFoKyvgX41XJ+llDK5tGAcuNaX4ma61F36lodKJXFJYLy2Z/FrNeR6CF9iyYjtSlv/Q9m6k/Qrj0cYhzfH/J9uMoo0xDeQS6lTjWuI1XDc6+hk2pFjAQhkjyK8lbNX86p6ymYcRNgI4dnvjEig6vHGH0wCkVgyX3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DOcbBlogEMDx8hV/sVP9XO3Lmx9ItOC9Px1llkmcRGg=;
 b=FaahBuwQ0XkL2dTP/uMBenfJeyXh9YtfP6KCDOxfBqnzaA+di1KBDcR1vfCiv7mw6TCjIBoYOgnDXqU4J6ykTGHnxqREYlPnkdnEbRXxdoNGCLqhpRhulPWlSOb9VvEPmedLnFZ51/E0NCYMoyit6roQoFeQ5MJnzVHVYnZ/D6c07fnvT4uUdbWeVkYcc6EroAVIB94oYH9J1YoeuovbObEUrC058GWBe1kjyaUT5EQoBBlsUIDAbOvTEc+hIaweqvgyowIFlgygAx4Xh83nUHRvW8KklBUIDOn6rCIfzt0qTdu6DCrkYO80bEuOuJ9lq9AM3ZOEKn5J2/AmDyE0vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DOcbBlogEMDx8hV/sVP9XO3Lmx9ItOC9Px1llkmcRGg=;
 b=XD9E3OHrTSnhebC1tqSL0PC6VOJdJgneeAiI1f2utxo0/towaBUGVex85xvJi2xrwFIWPOvWSS1nQgvg29arbunfzP2bBQjmEFO2P2K/L3HSi1RQj2rMBNToka3KfIUT8XFh1qJQOXSkonzQ2BdSMi6R4IUgANcaTSWR0Ro4f0w=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by CO6PR10MB5556.namprd10.prod.outlook.com (2603:10b6:303:143::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Wed, 11 May
 2022 14:16:19 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f%8]) with mapi id 15.20.5227.023; Wed, 11 May 2022
 14:16:19 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Wolfgang Walter <linux@stwm.de>
CC:     linux-stable <stable@vger.kernel.org>,
        Trond Myklebust <trondmy@gmail.com>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 5.4.188 and later: massive performance regression with nfsd
Thread-Topic: 5.4.188 and later: massive performance regression with nfsd
Thread-Index: AQHYZR5cM0piVXjf4kWw2Fv1L4O8aq0Zna6AgAAbcgA=
Date:   Wed, 11 May 2022 14:16:19 +0000
Message-ID: <6A15DEE1-CAC9-4C64-8643-AD28EA423046@oracle.com>
References: <f8d9b9112607df4807fba8948ac6e145@stwm.de>
 <YnuuLZe6h80KCNhd@kroah.com>
In-Reply-To: <YnuuLZe6h80KCNhd@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b4ba5c9-999c-4afc-6d3d-08da3358d1ce
x-ms-traffictypediagnostic: CO6PR10MB5556:EE_
x-microsoft-antispam-prvs: <CO6PR10MB55565D87684A91C65764DA5E93C89@CO6PR10MB5556.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Mp5d744IOWlKPSlDES4U3+sZGQoVs7sRcuFFMX9cKRzkGE71KeG7+oLdXygYPpw/J97eH9r+9JFMjh3uCjW9A+mBj4v4c9ML2S8RRuDOPFSM/VpxyYEmHpTd8ElGrfs0xdQJQ1gzZ+SI3IYLOrFagJL5MWTfmOM+GWaOKgCYvrdAqJg6ECAYMTIxtoAGEPrUI32ZUoJVyyMYCZZ5PU++8rPjp3mjtyVyFiSLUNIFX+lpmi/M0iE87q0F/DwdT7NCHuMPuREWX8u7w+5phEaWW3GBlM6l8zIrYEXIC6yJ6bDofplVXzQqVx8gQv+tdvHBUB2TCSbkMNGDzdL7P9fBJaBgJdWl5F4qQZjXQgDucTZ0sKqZmIepuK/jPNhjAgRUxeh2drfAdkSj8YvvYpHHaBtKQW1Z6sutYSrlU4urLh7rdiNw1rWroqVqkiCYfvOrSJUZf74RlEgR9MP4kGrUmp2aYxWVmeJqe2ZekY1tCrllStFKYAurqTytEvF8tIkrnO53t+8qb5gfgrs4zIig40LSeZuYuDH1nPyXaraYibE6es4iQIHALuWaAZQ1MoIUW+/4b1VxrQuCz7MrbV8Es99I+t+WoPwQmwm04g4XQOn+BiR3h/tIf+hkN0kDVpA5f7MztbprHgGorqSuB+MGYn7XhkHc9n3uwa5YS9fBVnO6Sl/sSt1hcvoX6+zMwCHkrGLYwuZZxWTgEqRo9bbdU1fSg0pGzGpep0CRuBGJQE6CqObmN4oLfhEm5k5596vsqBIXtMKD0SK+fWecpwPPqw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38070700005)(33656002)(83380400001)(38100700002)(186003)(5660300002)(36756003)(64756008)(8936002)(2616005)(6486002)(8676002)(86362001)(4326008)(316002)(91956017)(54906003)(66476007)(66946007)(66446008)(66556008)(110136005)(76116006)(2906002)(6506007)(26005)(508600001)(71200400001)(122000001)(6512007)(53546011)(14583001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Nq1/jZvL9VQdGyyuRSt5Zxd04EBPsBA3HENhZYXKfzdSxoi+Bg2XOzXUp9Z+?=
 =?us-ascii?Q?vyz5WLPhAD4SvsW2TE+usi/W+ClZpadl0X6IqtiJ2jMySQXmXAZ8XGjrefeP?=
 =?us-ascii?Q?c+AS9qJ+kbafFRzIERZ9sxySyM2VqnAJ08N3ug2/IjpzyJNAlUZfo0laoe/e?=
 =?us-ascii?Q?Z/4Tc3rg2T/t6w93Igrleyy9wh+F/AjRQZT6FymCm+HVP/VRur35v2DVle8f?=
 =?us-ascii?Q?PKO/Gi3SA8b6rkhA1JYvBVjxxswJAHItgHDz3OnNNWbD82U/+0EPI5PxJu9Y?=
 =?us-ascii?Q?BNTkYMUeluez5GKy+vBHLq2xiL38pCNVUtipVSfIYboudV7H2OeWt8exB/1d?=
 =?us-ascii?Q?/ZWJjZXwkWyszeN6G6dZ+pnf8jqZrxpyhFeoKGU5tPpUaoMA34YVhl4EUwsD?=
 =?us-ascii?Q?wgN+TlXRMVE388Xz8sNIBRKbFxC/A7n3G/VHgudQikDkKN4b7bfpVJBmDmtt?=
 =?us-ascii?Q?weU1j91Vgl1O1asQjzikDW8LWPCShN21zlCmAMbUUBdwY3MbdGWzxY07AcFF?=
 =?us-ascii?Q?nndJNStEtl1ef7JiA8JjwyfKyH9EaD1LHjiKXitTUTaJnJh14th4nxmosDg7?=
 =?us-ascii?Q?fYZ5ARnSfNxKLQXT4g/UEbSCmhCJrGcjSfbhQiwwXksjh56HytpGmyvG2+AU?=
 =?us-ascii?Q?0nT96FEAIaAOtIinR7o4dDYGKc6cs7w0mo+pcDi0BI8pxXSDut/iGM52vbP/?=
 =?us-ascii?Q?WnkFsZu9hXEp0vvMuvHC3sKS8VhKon1U/rFQhsdfd0zNIvSmO/NEzbER3bq8?=
 =?us-ascii?Q?GXJScgNHDLJKQCsIzBQ2Wodc/t2ICLWWW7c+CiX0pnj/se3L5WzhPVWVc1jM?=
 =?us-ascii?Q?k1xXMvf9CI1jqaejVuWcSZK10NYgpkNcU6ZXw+rpn9Vf7L258JI5Q+oabTGz?=
 =?us-ascii?Q?BXOC4Uo8IEMNzSt/ZGxF/3of46BjhxKoBAMUqER4ealTmwVSoXjmGpXtcdP9?=
 =?us-ascii?Q?MX/Qno+TIaELHYxoe+0Sp7oQPewCt6Mz17bLbjVkIxRb50NsDKCdmFZpJJRT?=
 =?us-ascii?Q?/cWr4Ragd3k20oTgh5EUIMCEeRFVZA/hzLSU04E/9fB5Z8sCOJ6rGPWvwzAI?=
 =?us-ascii?Q?miOFUShq5jiGc13Rz+rlhdTYJY3HYTpPrB3kVNm8ToRBQ9kpBHOyTtln42Vu?=
 =?us-ascii?Q?uTEK1hwSS75D6wYKyPxaWKqKdgAPZLSnROYb4nroWVk4O3+iLo7M7AHb2plf?=
 =?us-ascii?Q?Y9GOKimaO7pavT49kfJwQOSJaCPuZRAVW7t2e7dNY+ffGDZMbSqrNARICPFs?=
 =?us-ascii?Q?9K1GIevA0ghuY3w0vyyRB/BKyWKqBDnBa7UmiQhRCO3GkZb5/xXFhaEPjy47?=
 =?us-ascii?Q?WC2btR6SMFg3UcNgETG3/QBMst5FTdIBxLqKY/acc1SdB7o0raEHKHzNeGlV?=
 =?us-ascii?Q?N1s+Uade5HFDUh3eV6l4WHxln7Epyv53LZ65duicWBCUuWehj0EwqHyFvIKB?=
 =?us-ascii?Q?Ek5JkjmRXJvt9CaNr+T5z0vGXY0WWqR0N+l8Inm92h/75WbjTdIyw3MMxFjY?=
 =?us-ascii?Q?V+XMZZ88c6bITzNHrQWu8q72wpgIcM4Rm2itNCtoX9cRUqQGaiVo9IxL+7vS?=
 =?us-ascii?Q?30JnpT+jQVuyzshaUJatSD4+Y+duZ+K4XlsmWrsGVpjYt9OeX8kMy9EmORdc?=
 =?us-ascii?Q?y88OPJp0UheTd4i9nCpdg27PwjFgTtW93EYRx08+dDpaCk2+wQZ/HcqGw5Ho?=
 =?us-ascii?Q?qysOsL3cBAxJJlu7NFS6v/uL7wo3QABl5u/hrXKlx9SQuA/VOSIQ4PHFPrKg?=
 =?us-ascii?Q?ERPbVKnTC4hJKDvlTROeKQLgz5VQoB8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <29E075AC0631A342BAF2EE8E624F4A01@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b4ba5c9-999c-4afc-6d3d-08da3358d1ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2022 14:16:19.5826
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ow88Jn3e4GFNMk4/gsFJY8sfl9FR3JcWycaThvIth4IQxh9DUXla+dzAA27ISkZQ0xjAAhsqDzpRqEHvKo71aA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5556
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-11_05:2022-05-11,2022-05-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205110068
X-Proofpoint-GUID: ATeX09zZ_bUvbhKqyJQikrcElrRP2Cez
X-Proofpoint-ORIG-GUID: ATeX09zZ_bUvbhKqyJQikrcElrRP2Cez
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On May 11, 2022, at 8:38 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>=20
> On Wed, May 11, 2022 at 12:03:13PM +0200, Wolfgang Walter wrote:
>> Hi,
>>=20
>> starting with 5.4.188 wie see a massive performance regression on our
>> nfs-server. It basically is serving requests very very slowly with cpu
>> utilization of 100% (with 5.4.187 and earlier it is 10%) so that it is
>> unusable as a fileserver.
>>=20
>> The culprit are commits (or one of it):
>>=20
>> c32f1041382a88b17da5736886da4a492353a1bb "nfsd: cleanup
>> nfsd_file_lru_dispose()"
>> 628adfa21815f74c04724abc85847f24b5dd1645 "nfsd: Containerise filecache
>> laundrette"
>>=20
>> (upstream 36ebbdb96b694dd9c6b25ad98f2bbd263d022b63 and
>> 9542e6a643fc69d528dfb3303f145719c61d3050)
>>=20
>> If I revert them in v5.4.192 the kernel works as before and performance =
is
>> ok again.
>>=20
>> I did not try to revert them one by one as any disruption of our nfs-ser=
ver
>> is a severe problem for us and I'm not sure if they are related.
>>=20
>> 5.10 and 5.15 both always performed very badly on our nfs-server in a
>> similar way so we were stuck with 5.4.
>>=20
>> I now think this is because of 36ebbdb96b694dd9c6b25ad98f2bbd263d022b63
>> and/or 9542e6a643fc69d528dfb3303f145719c61d3050 though I didn't tried to
>> revert them in 5.15 yet.
>=20
> Odds are 5.18-rc6 is also a problem?

We believe that

6b8a94332ee4 ("nfsd: Fix a write performance regression")

addresses the performance regression. It was merged into 5.18-rc.


> If so, I'll just wait for the fix to get into Linus's tree as this does
> not seem to be a stable-tree-only issue.

Unfortunately I've received a recent report that the fix introduces
a "sleep while spinlock is held" for NFSv4.0 in rare cases.


--
Chuck Lever



