Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6B566648A
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 21:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239461AbjAKUFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 15:05:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239624AbjAKUFS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 15:05:18 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FE83C0E6;
        Wed, 11 Jan 2023 12:02:24 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30BK0b26010487;
        Wed, 11 Jan 2023 20:02:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2022-7-12;
 bh=/giV7n4JTaPemz7+NdwElfmaSGHFNlj8fxm9YZZDFwE=;
 b=h9CM1LDHXoDOVheEQnkZdmLFgXrPLGwxi9X+xBfN7YRojSvVj/+30JVRiNvbnkIM2j6E
 56i2Iwyzgqly2A0ko0AlyaG9cLvb+4M5FUWo9mXlWL6v3sICgOhQZBZPILPMkHeHNHGA
 AO8ewlZNDYjpCfF1rLMj8iSTIXwI7+vzaeg5Nb/t/oRi58PEXPQT3iuslfChZK8y/iOL
 L1V3GMgjr9w1N/RUdBBcKWUcI7S8sBVZFGp6GA0CmjfnvH9CtiEixmT6WRzMgy7unPRV
 IbBTBVNKOLMAXwSefNliIIHHTvOs0amLctHZLIVciVcM0kLMqugT/y9UFuUhwt/DCYIj uQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3my0btrpv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Jan 2023 20:02:10 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30BJ0Ghg022622;
        Wed, 11 Jan 2023 20:02:10 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2044.outbound.protection.outlook.com [104.47.51.44])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n1k4e8a7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Jan 2023 20:02:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FCm5pP6i9u829iAYxx6hK+e+YWa3J0lCkT5gdEzEQtl0q51xhUWXg6rN6ZbbbPKdosyLgVMfp2AlzG9PQlVzsxjKL4j/NONXqdJTFnWh/46hCVC6k+pCwk/aUIfxKoD35VkBnuyRXvWmfTuqPyvTT/6mtGM+NesAe6W2cW2ki90t3V3FVUn4ruq3LYOVYSqzxACbJLGFij4dwlFmyS3ZKqegMa7TJHNOoaYSorIADND+egc/hD/Ut2gbB9fMzYZVOU7OTXGS2ZEzdNBVM0b2sx2yN88aBRB35vuIummHqI7j6G3DMloJ06yxaYCBiAMFhyxJu98GQHxcK0USFCfg4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/giV7n4JTaPemz7+NdwElfmaSGHFNlj8fxm9YZZDFwE=;
 b=kRNcmLwdWA8fJiCVer7Ic5Tkh1jHcbd83R4b0MHOHKXOYvWua3neC67IUj6Y3tWGiFoV+KlwvvOnAf/5enos0zi0ihaSvGJCHsxaIhISq1h4LVSZ5QKQceS0havXXVOrX91FuDg6wkT3lBZnl78Hp3RkHXiXlXKWNmVgxX+2MS7jtcUA4sh3HgBsg7igv+uoU6ZA+p2+KjX24JN7fCrxTstd+uiVjSIOwcGI9J4lz47ZdUTKjYSSaHMy+e9RKwTx7vwsy/GCGQr8vEVMjU/BL2BclWY1PFGGXCiYkmYv/+Wgt0O0YOPGFI6Xs1wyVDXgoI7qD6sEwbJo+GHZTrY0eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/giV7n4JTaPemz7+NdwElfmaSGHFNlj8fxm9YZZDFwE=;
 b=sqybfn7O1vm4/9OiDRp+SFCG7q6N+Qs627kI9xL+xIUUUxMNY5K+Sya9Rr9FC/oMiIh/mycEtqoiet/F1h5FUCTXLKQCfZ4eKGxH0O9IKfZYrBlflbSkwjsFUTF/85bVthESADF6RW+NdYfBeOl3edLwMJGDYCO1chpxpsJd3x8=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by MW4PR10MB6485.namprd10.prod.outlook.com (2603:10b6:303:221::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Wed, 11 Jan
 2023 20:02:07 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::a02:2ac8:ee3e:682]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::a02:2ac8:ee3e:682%4]) with mapi id 15.20.6002.012; Wed, 11 Jan 2023
 20:02:07 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "maple-tree@lists.infradead.org" <maple-tree@lists.infradead.org>
CC:     Liam Howlett <liam.howlett@oracle.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "amanieu@gmail.com" <amanieu@gmail.com>
Subject: [PATCH] maple_tree: Fix mas_empty_area_rev() lower bound validation
Thread-Topic: [PATCH] maple_tree: Fix mas_empty_area_rev() lower bound
 validation
Thread-Index: AQHZJfeVpjkMGiGWmkC63s6AhkX/Pg==
Date:   Wed, 11 Jan 2023 20:02:07 +0000
Message-ID: <20230111200136.1851322-1-Liam.Howlett@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.35.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB3022:EE_|MW4PR10MB6485:EE_
x-ms-office365-filtering-correlation-id: 9895b4a6-4d77-43f5-9d04-08daf40eb7a3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e/RckrV2XJSY8Qo+Hb4V51s0ByprUZ2biE7o/T9SNwwknea1WtAgkRR/k7DTIa8TSFLAQag5Ejm/MaAZ1npMBYpeZVBG4FNL3AQm4dGNgI6c7AXSYvj5a+ytxMELC4Eys4yhXbPOk0K3SBd2z/dGfGAvR7AX8tmD/cUpFM9ib4cWQXdsRHO8FeVPTQmFkBIJrzORkwT3Z35rTiMK/sZMEjBhWZy+QZmVtgdUZwwwTkXSh8Kpv4O0wyjfvvCqsB7Wm/Er3bKw3En0wojeNW7hIkrwRHcxrPu6DSAAJRNtFsSiE6weFy/PxPTbZ+5RLTT1ctpb91Ahd9bHgNF73MVf9U71Dfrt606+kDuyTlLC3FMEwtncPnTZTMFG9ldAd1YXcFLPf/57hVn3OA0EEEgQzKvcq9lk/vguChixS0x4iOdpVy9vY0oCvCayyeYOSbPCE5zBAymBMxZitQQXWtvxcAlIM3YfghDNukdcOgzANARhzKchW11iF78YzFMGH27Ii36F2rtf9VBuxoQRFoLp6QTg6NUFCxGGNn59X5s/RCC1dyfs2sTVRJSGAHLA72RS+mtZBlf7holkpqSoa13R3xDCNeCc37zrs00BTWsd1VGPnrKRwqZU2ougs45Q+wAcssyE3h1AmmJxyFCOps+1cYKb7QSbnuEp8Xq/publlxG3WL/jNKFghS09LUZktdK6HsWD95AbpvrTAXXIZG8ywKYP/DRh2yZbSwbN+iWAxM8c3tDr1744UmnGY6xmBLHqdVEupdKI//Dcoba/sIGrXw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(346002)(396003)(39860400002)(376002)(451199015)(86362001)(38100700002)(71200400001)(38070700005)(478600001)(6486002)(966005)(186003)(26005)(36756003)(6506007)(6512007)(66946007)(91956017)(76116006)(41300700001)(4326008)(66446008)(64756008)(66556008)(66476007)(8676002)(5660300002)(83380400001)(110136005)(316002)(2616005)(54906003)(1076003)(8936002)(122000001)(2906002)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?RncZ4WGKDyBVoNp5I6S7Z9au69Ru3IWkNi+zlTv+eZNiXnBhvOcODY07nb?=
 =?iso-8859-1?Q?eNV7tbH53MDnwySXBdOkCPXF5hbfEdF4G0HDpQEnaZ08sYoJ25GQmq/omr?=
 =?iso-8859-1?Q?LhYCZ3Vo0AE5wkxU3KRFlomUXjxviXNd5tMQ3bKFb8qawdPyXE7h0nhUMs?=
 =?iso-8859-1?Q?m9u+EEaTRQSfPlmxjJVdsdxzXTQzgqXdRVoFHnaPQuPtlJTYvKfykeGx+5?=
 =?iso-8859-1?Q?4OILYmJ1+YfcXKKZsroW7Y4NqPyORv7dbwQ+D6ZUMrc931oPcwBkIkIAZi?=
 =?iso-8859-1?Q?TkbIRSJ4nBYqWBTuq5TT1IZNLZqVTzJw9IlUa3nxQs8LX6btI2/GdUxzTX?=
 =?iso-8859-1?Q?XKUg58+liuX5Og3WFRjjAkpP8SUxLrkrqjBllDgmVKQM2PLFHSqwWvfsDd?=
 =?iso-8859-1?Q?HoYRLYWT6qxL0qi3tnS+MKjuNjHUmkdAI30uyM9HqvfbcZ25SDdcLy4bRL?=
 =?iso-8859-1?Q?i/X3Qpg0cGZFc3yugRT8rHzUEAgn5u62A0khrtWhswvUdsPVS6jDg/4SWj?=
 =?iso-8859-1?Q?5YEx2C826K96stPFK5n/kfX+NT9E3iAqlXa1OyCsHa63Ms6LmJ+y1ONS52?=
 =?iso-8859-1?Q?1m+bgEz7X/YgDWGivmIkKlpHzVdfTAqcaujQ9E8qFxRtw6dGFTuS4nrK6F?=
 =?iso-8859-1?Q?2j1Ur72TtVEPvG8rfu23fsXoskDIpYtvcGClF8oNCzLVUO+7EzVVaRxE/2?=
 =?iso-8859-1?Q?iB50fzeIeaqVwO2sqKFC/fP88M8Ll/KXK+M+eRffjOKnzs+LCG/O0N4//O?=
 =?iso-8859-1?Q?bvLyvASW1gigamb+eWkoCnyHdBxPkqBg7AkZkW+wgON9nmM+HFxWDfsQgd?=
 =?iso-8859-1?Q?p8yfXEl0sc+jn0fNRoXg0i+d9w3mt99y/bjS4P5uBE3UIMIoZZIeplMgrI?=
 =?iso-8859-1?Q?iP8qkeSXW3/bLLhWFb6idMnNHdQQlHclKIvDatnA2APqCdvCgvfdQHE88o?=
 =?iso-8859-1?Q?8eFLgTOwM+Z1WyGEW4IS04gd77tGIQjDT1L4nOEgTPLesbFQnU1nG2mvS7?=
 =?iso-8859-1?Q?8SQ021umGhN4oKd9g/MfMc91uBbYYDD/zxnsUuj3/q3nLJywwKqFaEThQ8?=
 =?iso-8859-1?Q?4ltgZAEAt4M7JbJM0ChE3GXewPA2DEaZrUQZXlHLWQ5w8AAgZsJar2Ebul?=
 =?iso-8859-1?Q?HTMbjTjiidaBqU6w+21v+LSc8W87x6NBAkT5mMONfLONgQbAU7s/URclYV?=
 =?iso-8859-1?Q?4EsW59bqopoQwTEtL8HuUDZ49JhWGnZ3Jt44oOl7fNsROJRD7abaWFyh3P?=
 =?iso-8859-1?Q?zrIvRF8xHhnngKGxnKPpi4S35bgy9I4Tr1o4TFlKkI6/b9r/l6SPIcsMdT?=
 =?iso-8859-1?Q?v6V/8JyAllX7PtuNPf0oBftbEX5kXXj2Dk8jy0eXcLCR+4IOZn2whPvW0O?=
 =?iso-8859-1?Q?f3e+M/uJ0kSvCynQpbQ7JAWdMG4vg1SstJ2gvAULvZXRp60DFV9ghEXd9G?=
 =?iso-8859-1?Q?UU2/F9GV/73Bfcaq4lROt0T6Qj8QdzW5WKv5nhfz+alPeUlQZMzDILRvqm?=
 =?iso-8859-1?Q?Yqq13wjV/7HGYBFKmGkm39AMbWnJGXEUmrE9+Eg9pbTNajNkp/Dro36W3+?=
 =?iso-8859-1?Q?VDT1tSk8Fvlk2mLL/PvB71f8yYlwLzcvtFjvHpFE+hrHFFvwKwGyT44Njk?=
 =?iso-8859-1?Q?8FK8Iu++OB4D3jR+VQbpyasbnpVa6YoeRX1bFejlNo01KHKD6sh2SIgg?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Q3MjMFhzRaWU7rw9JFTQRMCRzKio7nSCI0Mw4MfcBG633jlC5ii0xFhtUwVBE7AdssCetNBCCnkEjNcDxVZxZRjwM+H1o93kWQjJsIZu+BQNtAshLu3ET26aMdVMEhr4vg4IadPei2AMAhttgBnvfrsrOsw2MnJ5U1om0FCW7ettx/63/0b3Ac9KOseM3M7l0WP5RPrDhEpHvM/0vw1OhXU0PT2lWB7Zqf0YUcwO/Vuw4swAMSZYQvMTVn1gXMKBbRcnM0PswtQ9aRp7elEdvlvopV+CYk22lkUq+OwLcsA2shB1eq8iHjiZP1AUSI9ZRq1IqrH/X1qYwHXv0wpuJrEALSaaFmeHqG4O69/eTosWfswMt3t1GcozYr/mlNYQcMKeT0b5krV2+nR+L61te069e3yxti59aKAEdhuU8sjslkKsfzwKhrG5iB967EkmMEPptGQxTmyQQpxKPtYnT/lLV5ktra4rT6OJ04EBFUfzG7uBl72rkhfM3jtJQ+6XIzYoet96apNDmggdLSIPa+d8kP67tIW4mbBMdHuDn9jPvPc7HstPOZVAlyUrh/ovdpagqMYTu4KwBRl49D9Rc2qVWwY4F41PY7e3+VqloyRIdmUs2QtT42AV7Xvq6yfM4rfNWWM4LObfjioCS68WivnzwM/lmsvPaTOxNVHrqYj1wNQ1dR4QULsWK0OfPt1KbWIIR5XuagCr1W77KQ/PwBKQVRruJlkiTwCzikk8k7Lfgu58IKmBvNul1EuRdqt3oA/DCNZ4W8nei/At+842EaXgH8qn8E7bzxoNSURMnWTvfMGeVZN0nOAYv4E0IM9dBZGMNjdxkbL5GYST0/4AUgZ1IKkCLhP+a4FMZMgi7t5YNlZjGT0BVy/TYAakOVo5KawsG8ZAdsheBYnFEDDdw6L9ViUS/ztmExgnPLZzItM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9895b4a6-4d77-43f5-9d04-08daf40eb7a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2023 20:02:07.3394
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pKQytOwCNUeLfqNNRgH0kIT3EhClhiwLiJ5a87vcFPQN8HeuAYRkJXPHOIKSaTB650jeNsjO6T7LQeIVRTjwQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6485
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-11_10,2023-01-11_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 suspectscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301110147
X-Proofpoint-GUID: IAOAUpJghuApEp9UFfl9tlhYcyNDrj9f
X-Proofpoint-ORIG-GUID: IAOAUpJghuApEp9UFfl9tlhYcyNDrj9f
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

mas_empty_area_rev() was not correctly validating the start of a gap
against the lower limit.  This could lead to the range starting lower
than the requested minimum.

Fix the issue by better validating a gap once one is found.

This commit also adds tests to the maple tree test suite for this issue
and tests the mas_empty_area() function for similar bound checking.

Cc: stable@vger.kernel.org
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=3D216911
Reported-by: amanieu@gmail.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Link: https://lore.kernel.org/linux-mm/0b9f5425-08d4-8013-aa4c-e620c3b10bb2=
@leemhuis.info/
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c      | 17 ++++-----
 lib/test_maple_tree.c | 89 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 97 insertions(+), 9 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 26e2045d3cda..b990ccea454e 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -4887,7 +4887,7 @@ static bool mas_rev_awalk(struct ma_state *mas, unsig=
ned long size)
 	unsigned long *pivots, *gaps;
 	void __rcu **slots;
 	unsigned long gap =3D 0;
-	unsigned long max, min, index;
+	unsigned long max, min;
 	unsigned char offset;
=20
 	if (unlikely(mas_is_err(mas)))
@@ -4909,8 +4909,7 @@ static bool mas_rev_awalk(struct ma_state *mas, unsig=
ned long size)
 		min =3D mas_safe_min(mas, pivots, --offset);
=20
 	max =3D mas_safe_pivot(mas, pivots, offset, type);
-	index =3D mas->index;
-	while (index <=3D max) {
+	while (mas->index <=3D max) {
 		gap =3D 0;
 		if (gaps)
 			gap =3D gaps[offset];
@@ -4941,10 +4940,8 @@ static bool mas_rev_awalk(struct ma_state *mas, unsi=
gned long size)
 		min =3D mas_safe_min(mas, pivots, offset);
 	}
=20
-	if (unlikely(index > max)) {
-		mas_set_err(mas, -EBUSY);
-		return false;
-	}
+	if (unlikely((mas->index > max) || (size - 1 > max - mas->index)))
+		goto no_space;
=20
 	if (unlikely(ma_is_leaf(type))) {
 		mas->offset =3D offset;
@@ -4961,9 +4958,11 @@ static bool mas_rev_awalk(struct ma_state *mas, unsi=
gned long size)
 	return false;
=20
 ascend:
-	if (mte_is_root(mas->node))
-		mas_set_err(mas, -EBUSY);
+	if (!mte_is_root(mas->node))
+		return false;
=20
+no_space:
+	mas_set_err(mas, -EBUSY);
 	return false;
 }
=20
diff --git a/lib/test_maple_tree.c b/lib/test_maple_tree.c
index 497fc93ccf9e..ec847bf4dcb4 100644
--- a/lib/test_maple_tree.c
+++ b/lib/test_maple_tree.c
@@ -2517,6 +2517,91 @@ static noinline void check_bnode_min_spanning(struct=
 maple_tree *mt)
 	mt_set_non_kernel(0);
 }
=20
+static noinline void check_empty_area_window(struct maple_tree *mt)
+{
+	unsigned long i, nr_entries =3D 20;
+	MA_STATE(mas, mt, 0, 0);
+
+	for (i =3D 1; i <=3D nr_entries; i++)
+		mtree_store_range(mt, i*10, i*10 + 9,
+				  xa_mk_value(i), GFP_KERNEL);
+
+	/* Create another hole besides the one at 0 */
+	mtree_store_range(mt, 160, 169, NULL, GFP_KERNEL);
+
+	/* Check lower bounds that don't fit */
+	rcu_read_lock();
+	MT_BUG_ON(mt, mas_empty_area_rev(&mas, 5, 90, 10) !=3D -EBUSY);
+
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area_rev(&mas, 6, 90, 5) !=3D -EBUSY);
+
+	/* Check lower bound that does fit */
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area_rev(&mas, 5, 90, 5) !=3D 0);
+	MT_BUG_ON(mt, mas.index !=3D 5);
+	MT_BUG_ON(mt, mas.last !=3D 9);
+	rcu_read_unlock();
+
+	/* Check one gap that doesn't fit and one that does */
+	rcu_read_lock();
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area_rev(&mas, 5, 217, 9) !=3D 0);
+	MT_BUG_ON(mt, mas.index !=3D 161);
+	MT_BUG_ON(mt, mas.last !=3D 169);
+
+	/* Check one gap that does fit above the min */
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area_rev(&mas, 100, 218, 3) !=3D 0);
+	MT_BUG_ON(mt, mas.index !=3D 216);
+	MT_BUG_ON(mt, mas.last !=3D 218);
+
+	/* Check size that doesn't fit any gap */
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area_rev(&mas, 100, 218, 16) !=3D -EBUSY);
+
+	/*
+	 * Check size that doesn't fit the lower end of the window but
+	 * does fit the gap
+	 */
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area_rev(&mas, 167, 200, 4) !=3D -EBUSY);
+
+	/*
+	 * Check size that doesn't fit the upper end of the window but
+	 * does fit the gap
+	 */
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area_rev(&mas, 100, 162, 4) !=3D -EBUSY);
+
+	/* Check mas_empty_area forward */
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area(&mas, 0, 100, 9) !=3D 0);
+	MT_BUG_ON(mt, mas.index !=3D 0);
+	MT_BUG_ON(mt, mas.last !=3D 8);
+
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area(&mas, 0, 100, 4) !=3D 0);
+	MT_BUG_ON(mt, mas.index !=3D 0);
+	MT_BUG_ON(mt, mas.last !=3D 3);
+
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area(&mas, 0, 100, 11) !=3D -EBUSY);
+
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area(&mas, 5, 100, 6) !=3D -EBUSY);
+
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area(&mas, 0, 8, 10) !=3D -EBUSY);
+
+	mas_reset(&mas);
+	mas_empty_area(&mas, 100, 165, 3);
+
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area(&mas, 100, 163, 6) !=3D -EBUSY);
+	rcu_read_unlock();
+}
+
 static DEFINE_MTREE(tree);
 static int maple_tree_seed(void)
 {
@@ -2765,6 +2850,10 @@ static int maple_tree_seed(void)
 	check_bnode_min_spanning(&tree);
 	mtree_destroy(&tree);
=20
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
+	check_empty_area_window(&tree);
+	mtree_destroy(&tree);
+
 #if defined(BENCH)
 skip:
 #endif
--=20
2.35.1
