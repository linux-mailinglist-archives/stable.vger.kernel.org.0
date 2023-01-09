Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0480663233
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 22:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234687AbjAIVFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 16:05:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238056AbjAIVFO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 16:05:14 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49F08CBFC;
        Mon,  9 Jan 2023 12:58:33 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 309KjKWA010089;
        Mon, 9 Jan 2023 20:58:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2022-7-12;
 bh=bWrCfCdKYEn2Sy8wjS6h0YtOWFcjL4VMOiaqeSRsvf4=;
 b=p3m/eQgFU30yzx+Htb93dO2SeUcB6xt2jcY57GG/Vjol8QhVGaxV9AK8h5/zMS5rCrG7
 /AYyYl3mb6sxDdcDrhjKScqUBMuolTyWLsKWrhRjn4z7gi16ZNBUD+27WYIQlXRdGUzm
 YyvdnUyBnMAfEmFhjb1PLostFJ7Hkj9TS8+s6Vwm5fQyo/LlLBzS7cLWmmOHL1p7ziXC
 pZDNoic9WfWGWh3sLodR1NqhH+4+KFcsNx3+N2E5StfskyIRqx7TCU54j9KmPfNhqX4r
 DMJhx8KBLxGBNvWamtXBKGIwXJ7+wlA/Ps5FCxpVju6cijiJ7lYcOm/Hx9uwmlv0TZMs hA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3my0btkq51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Jan 2023 20:58:26 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 309KmGhs017446;
        Mon, 9 Jan 2023 20:58:25 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mxy6as838-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Jan 2023 20:58:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lvgBxw6YkXYB09FKgMC2SiJpTVOG6UCWDyQfmi4DCjRNILgrCPd0Fjckz2NKg1c1z6YUNokj4+S9Dg8r7jcuFNMDwM7ipnT9WLQvCE6ImvBUv9IEeU5Pl3aene9mLWmbJHd6KH6Xryf1UE1cQ0TfrsUjuZLuC6RbI1ycqwM5v8n2orIEQnzg69CXI+tfzN+by2oIg/8nqohD/P/QQPitBnXskA4U7Bgn0vGYAJkM0Du/tm501eg3VdDTLx4NpDXM5+rqr2Q9Bv1jKylnKiVJ8U+rHjSgfjmhTQjWDQplSCGxfjJhBHw2wblXt0Hj/LybnKhN8vHPdaQGAxdUmUseag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bWrCfCdKYEn2Sy8wjS6h0YtOWFcjL4VMOiaqeSRsvf4=;
 b=cwGS0vEi/EZsEKiYJvuYxh61hT5gE0BPw+7aE5/3uSgAFZKNnykWxEU6+vu2qHpzxmjoMz+drah1YbacU47XZ5WjQaaDzdjc5baoMoeC+4Lf6cT9esv6pEqls3q2oJYcrsU2rpakcFPmJJvlkHMjmG30HdrCYTc14ksJPS3C3sdvGiI8jsbV2jl/4UfINa3HIxsRsekQlK/bTYmRNbRdUxVVCAhF0c6elygDLSlLKoHBhE4fHhrRoM7mVu3ovDdcjlyn10AXroFRLu+3GY96zdqKgrej3mE/GIB2lLWnD4CFP8K/5MQ5O492B7ejonRSZoar41RNXGZTgKEoLvOFjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bWrCfCdKYEn2Sy8wjS6h0YtOWFcjL4VMOiaqeSRsvf4=;
 b=LUWTqi65qfcOKQgBp9MJITp4YB77UYF8rNqSqL78MEOBdoh+eu2gf4z9LN+JH2QC+5ADe8tk2ofLVS7lX+JdCXSisVuzdpzoLRBWuKOxQQKR65fELzEIzJkM6o+vwFCjosrcrTUA5/HwbyE5sJEfHbG10CrDXHv/K7szXx3v3yg=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by SJ0PR10MB5860.namprd10.prod.outlook.com (2603:10b6:a03:3ee::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Mon, 9 Jan
 2023 20:58:20 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::a02:2ac8:ee3e:682]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::a02:2ac8:ee3e:682%4]) with mapi id 15.20.5944.019; Mon, 9 Jan 2023
 20:58:20 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "maple-tree@lists.infradead.org" <maple-tree@lists.infradead.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Liam Howlett <liam.howlett@oracle.com>
Subject: [PATCH] nommu: Fix split_vma() map_count error
Thread-Topic: [PATCH] nommu: Fix split_vma() map_count error
Thread-Index: AQHZJG0amtZ+KWpE+0SrLkRBQDWhyQ==
Date:   Mon, 9 Jan 2023 20:58:20 +0000
Message-ID: <20230109205809.956325-1-Liam.Howlett@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.35.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB3022:EE_|SJ0PR10MB5860:EE_
x-ms-office365-filtering-correlation-id: 8faad0ae-7c99-4ecc-4f40-08daf2843d77
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KnZ7nmcTY3CfFDLGBV88zo/8XUdQrKWtpU5ND4/3kitXZLsPxn+2wJyJL+41S0AfVWdsZXLb+A0GWdVPnH7pEIZDjf9NcpjG84ed5tqHPfYVhcCV8EgDwJK018ANnATkd9MYp8VqHjhJd6FJzvPaMA57E7VAXHvFndNAIHNdTzIOp4ZSEBaz1nARTOWCKhvdBGOlKnh+sj6WvWb1qQt9Sdz6MqcgJAI4r39jaW6+urKMy872Meby3krTJM3JuQMSN7MCrtgVzhP1dhoBuCS8fEdcW0Zj4T+ExGk3rxPQaMjFaLSf4fZY6eWAGFPu886eJ0UE4kV0zw4ThYkG8YM7bb610pOwpHHyVnfxg6a6kh3zM2y7W5miTV64fQFbWAHNUZr3wAJd703bdeapGLzci+oLo/p03k4Ygf+GfZhnVLNLELEM8VYtR2CmwIPDJ4YYcpcBE0YtiuWAR2KyCdoDyTmF2i7VBnfYEYsIjpVZMlrQByf34D//Em4ta3d5IrZ3ofIHlrmSGz18FGH/1glxKPo4bGSff/oePoV6M6v5PG7/SGTuqRvmwvhEDDVri4Tdp0eOTUU9fIqhqiePyHWltr15D5oNY00A22TRAT9iD1nE/2RSA58rQ9u+1sMbvVjyHlOovO8c5iD0rxOxB/t7xh4M+ge+5TXwXKQ5fcDCsli4pIlzBocm8z/yLJq0Fk35fUmIY2v3Oqt80NBKE0OI8w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(396003)(376002)(39860400002)(366004)(451199015)(38100700002)(36756003)(2906002)(8936002)(5660300002)(44832011)(122000001)(26005)(83380400001)(6486002)(41300700001)(54906003)(38070700005)(86362001)(76116006)(66556008)(71200400001)(66946007)(6506007)(110136005)(4326008)(66446008)(66476007)(107886003)(64756008)(1076003)(6512007)(2616005)(91956017)(186003)(478600001)(316002)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?FdonuaQLa/pZ/KZTNsTcPxh9wFmcP+JryTC5CJnjCZy4cDdpnlHa6Vel6P?=
 =?iso-8859-1?Q?8IhPmbt5RDDV8c3xMmtzIa+Ju3fbLxTQkqWleQ27BeGNWTDxmkcLxsFPGU?=
 =?iso-8859-1?Q?fAOr0BTcDSaXYNy5Ju8a7PIGj1aAcp9jblVu/U48REd2aC+Qdv6jcerm5o?=
 =?iso-8859-1?Q?vdKu9A1SJw53UFeHRrNhncgeRAx9vzUN2ILhqytLrXz0dRrXucl8/pMFI8?=
 =?iso-8859-1?Q?8PpLbtVmmkp//NE0U6lLriZTI2btLlE1KyEOdMhyQyZ91WA/QZu0QHh4ah?=
 =?iso-8859-1?Q?Zz9ysCFR+ulOLJsnbGYlZO3OHvg+zJQdpdFTlCO4qyw9OIkMEwccwWg+J3?=
 =?iso-8859-1?Q?RzbT9HD+3ooBWMLfH+NOvOpN0bG+m+roKMD1Tt2TdRHwk3+JiTVMiD0ljD?=
 =?iso-8859-1?Q?xP75fbcUm2LP1ypMFvh/Yo5Gih5zx4NVgScxmcN05zaFLgPjTbhxP7D4QJ?=
 =?iso-8859-1?Q?ymEEnK+Fr3qzUBNIOfHFVGOehrKiXZlwdSv/0Y6HfVt6oyD8PclJe2p7Ox?=
 =?iso-8859-1?Q?RIRq7a57im7IBe4zIwhbAmh6h3tytclCtemEBPyI6Vgw1HG4R/1vCy8Get?=
 =?iso-8859-1?Q?xxSb/XDKlm6p2HM+BIwfUY0ZK2E408tSukrzfo2knOiUTIF3NRsY8bS4Bk?=
 =?iso-8859-1?Q?HGaDDKrR5zHK++7n5F6WyKmq6THMsYC6JnpliDEdbrKZv28wYr20HvFYgi?=
 =?iso-8859-1?Q?cr+SuSngNQ9RxoDcm447SptR6T5jiP53S7otKtlJ9yJ4+Hn/r6zJ9UlYSS?=
 =?iso-8859-1?Q?cowyKHHLF+R6S8fmXGqpExAmoIxVFQi3VqVlf3/NaImZXxSjzm/Yx158AC?=
 =?iso-8859-1?Q?b57nE8/wb5lTLC/uKiFeLwdQuDozqmwQmzfH93HrROEW/3CGaIrXRHs3T0?=
 =?iso-8859-1?Q?24FpC7+saL8SygXo9pywrsTO2T29agLKDSTtDQZ+KMkhl1bortvrUTsux+?=
 =?iso-8859-1?Q?nNivFYqn9JuHR+FuML+Z5ccUehHTRe4M8xgbUx9TRCBx77ibz9qtmiXBk7?=
 =?iso-8859-1?Q?Pop3gX6urW3zHonhdii2gOZ3iXeBQmirSqVx2ROdTJLvLZHxAADjVItPmC?=
 =?iso-8859-1?Q?qEwkspt7NmfAR+tHeXTTyT5nOZ9C+7a0TILOhhuLZqIpyufhrrOgRuWqN8?=
 =?iso-8859-1?Q?muBRoZL1jDxu8PaYkAm2BgYQePt0YJ4nsQIYncHR7K/iBri1qsgDCRreqj?=
 =?iso-8859-1?Q?RD1pbounKgnvKgJk+rzbGy9DWuZ7r5+ncYRiy9gTk5Tb4igNKfyWT58SNP?=
 =?iso-8859-1?Q?XJff+UxFgw9/vgfH4aK+3MtN7Tpum3Ym7qd+SgTYs7MEpUq8/Lqii8+N3h?=
 =?iso-8859-1?Q?1mkdEc+A3LN/vSMt1DkecTfLhvYfnnhvvagwZXkVRjtkk47Obm3uu83K+2?=
 =?iso-8859-1?Q?BET/tMz9cjdtUUfR+BUjK4S9SG8YWO8eg+30RlJie0deT0xrrcSvYJCLwQ?=
 =?iso-8859-1?Q?7QMDN35a/ZGXXn6eX3x6yS4zBs8zOjBcrVxVs1xEqbTWu+rCTK5H/GS7Vy?=
 =?iso-8859-1?Q?O6QX4C2RF5fuUhNxtqWv6w2CTcZdspAkHKmcybr7R9Ep9IwvU0OVqH/Ww9?=
 =?iso-8859-1?Q?U9xuCGuR/B4kIgopel6BOyskkefCtiMUokNsLe/6lPGMQHCWJPc2jr6Fj3?=
 =?iso-8859-1?Q?+6UY56C7MgxqtcXPzVLZxo9vI0RzxnyLGjLmsF97QGibsVYFM8kpz/MA?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?iso-8859-1?Q?HuQwbEwqH8jbhqaznerNKmXwQULqoc+PNixJggas7lIJoA4z7dFGQ+rFoo?=
 =?iso-8859-1?Q?C9zH357nijzTqa16aBh7YUVNo1p8t7AT/IwSqY+09P5xX1gMbinnQj4ATY?=
 =?iso-8859-1?Q?iSVluIWf0vPsXE+12TlcwajKiCChjGxcETSWXwhdI57DBe/vZkjHA9G32W?=
 =?iso-8859-1?Q?/WP7LXelm5rQ5jVqqf5x7V0E0sCI2tc5yDR7bHyj/knbSn2f19zC5p6I69?=
 =?iso-8859-1?Q?8528TsA5TtWrOS79DRxD2eitfwMU9e6z2pyw77NK8D5D6l88JSYyLR00cl?=
 =?iso-8859-1?Q?OPfmuY8ar4o1Iqg1s6UJPameyF0eAz7B/3pZBA9AYhjDu7oWA5OTy8alKb?=
 =?iso-8859-1?Q?XDetbZVTnP327rIADhLj5vgf95XkqqkEv3nAZlT33VC1TyTTodgZGYtJfl?=
 =?iso-8859-1?Q?4HN6skpA4IfbFFJJKOlmWg0uNb+QZwsQOfZ1Kci6Rn5lDRkU75gKLZALFX?=
 =?iso-8859-1?Q?+8G2Z7JgDXB8zgkcibBZ1Veexp0vLVBmeQZCk1bWV8/ImwdQeY+S1q1PbQ?=
 =?iso-8859-1?Q?ftz8r0DYwncQWtEpuHOpDsr6F6ilo/g2caDvIU7qRCO0/seI5/XSjbLeWE?=
 =?iso-8859-1?Q?Xnit5pNp/K0eWsuPL9nK/WEDTSePE5EIzVMuYMLUlNt661JHpAE1ICRE7M?=
 =?iso-8859-1?Q?W3JPoA8xkwG+VBngz5v+9FMtkzrVMkmV5nUd7PC+GLzFCvHCui7ETNyEbv?=
 =?iso-8859-1?Q?XYmAhHQyJL7rYRflTGMj6IN4WGX55i1pV1TfzyDHsa7HcTjYLVmlsZyCvU?=
 =?iso-8859-1?Q?fMPSJsv4kLCpsCYL9OmEr5s5xdLQ+Cml7pYhGcDxT1yC1pawm4r/QARiKB?=
 =?iso-8859-1?Q?l/fMeGaB1gBRUlkhjbZ0CrVybT1gqqsVPd1T+VsKuGgHrnZ7AyVxh9/dnL?=
 =?iso-8859-1?Q?DNfN9tuBuVobAlyxfo8Ydkgl2LCVgH87U4JjpNq3CQGCbEWAVsd/EccrSb?=
 =?iso-8859-1?Q?MVtCmD4nTPaok3HiyxVxoYoqJrUj+bE8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8faad0ae-7c99-4ecc-4f40-08daf2843d77
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 20:58:20.6711
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8nGuie1xl/PoBStD5JzX2qjRxFnhOiHVVJ3IkWfzDd7769vYOJIXdkZU3GfSu/rajHV02WDqfQDQflVZBaf9yA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5860
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_14,2023-01-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 spamscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301090147
X-Proofpoint-GUID: VSnvJuw5ELok45XAnwc2Q13ScVV2xlxP
X-Proofpoint-ORIG-GUID: VSnvJuw5ELok45XAnwc2Q13ScVV2xlxP
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During the maple tree conversion of nommu, an error in counting the VMAs
was introduced by counting the existing VMA again.  The counting used to
be decremented by one and incremented by two, but now it only increments
by two.  Fix the counting error by moving the increment outside the
setup_vma_to_mm() function to the callers.

Fixes: 8220543df148 ("nommu: remove uses of VMA linked list")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/nommu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 844af5be7640..5b83938ecb67 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -559,7 +559,6 @@ void vma_mas_remove(struct vm_area_struct *vma, struct =
ma_state *mas)
=20
 static void setup_vma_to_mm(struct vm_area_struct *vma, struct mm_struct *=
mm)
 {
-	mm->map_count++;
 	vma->vm_mm =3D mm;
=20
 	/* add the VMA to the mapping */
@@ -587,6 +586,7 @@ static void mas_add_vma_to_mm(struct ma_state *mas, str=
uct mm_struct *mm,
 	BUG_ON(!vma->vm_region);
=20
 	setup_vma_to_mm(vma, mm);
+	mm->map_count++;
=20
 	/* add the VMA to the tree */
 	vma_mas_store(vma, mas);
@@ -1347,6 +1347,7 @@ int split_vma(struct mm_struct *mm, struct vm_area_st=
ruct *vma,
 	if (vma->vm_file)
 		return -ENOMEM;
=20
+	mm =3D vma->vm_mm;
 	if (mm->map_count >=3D sysctl_max_map_count)
 		return -ENOMEM;
=20
@@ -1398,6 +1399,7 @@ int split_vma(struct mm_struct *mm, struct vm_area_st=
ruct *vma,
 	mas_set_range(&mas, vma->vm_start, vma->vm_end - 1);
 	mas_store(&mas, vma);
 	vma_mas_store(new, &mas);
+	mm->map_count++;
 	return 0;
=20
 err_mas_preallocate:
--=20
2.35.1
