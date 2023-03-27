Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD4E6CAEAF
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 21:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbjC0Tcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 15:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjC0Tce (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 27 Mar 2023 15:32:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DFF30F5;
        Mon, 27 Mar 2023 12:32:31 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32RJK4ZU006613;
        Mon, 27 Mar 2023 19:32:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=9958vdTUG0kfKUD1Gb4WTYzGWMv36VHhSQpJWxkmkHw=;
 b=1E7UtTX/TLIquZWlD8T+bwZHvCtFtvAjQYdOsV+TXKhp3MN63+w0ThCeAFbdED30WZAz
 T8XvTl1JHicbTByfe5vGhqrUr4NEx+KGBmZT7SOS+Yq9dxwNvQMjUzNXY0zRqGnrXhU2
 o4RgqvKZ5SWr9UW+yYv8bC9gH1fVyaPJvI+aa6UtRimh37TxTBMaUCv8A9urfCxAqmtq
 N4Ur0Fpp+NUKBj/TndMSZRqnxWM3fvirKzpdQpylHvVFqEMBe0xzYAfRBkHmcCmv91xX
 yw6zpm6tYTYtSFHugLjWCyuWD/ZNyJ3rSPhH2URAXkHXEdyu1a8kKx248M/of2b8BoNO oA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pkh71r179-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Mar 2023 19:32:21 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32RIR9fK005488;
        Mon, 27 Mar 2023 18:55:45 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3phqd5cnnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Mar 2023 18:55:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KQbTLq8sUd/Ja4AOts8bbKRdiXhsrVFkonFpzTThFJZpiy3XUbHfJNw8KTjwxGEckOz2ZC7y1iFO2lA509L7aDwe9fXHYdnugx+1v5Q8bpUQFiP6eDBcglTRQ9Vw0xNToWaCC0xlZvUQJ7PJQ9jlIjlOFXevd49Gbj0WReaf8YX1wpx0IxZXTjG8jeYPC7/2fs2dGeuhcymkwmwt18fNgYiLx6Eo18OAuiQABph1phYZoNbpJwvpSkkk1hnc4jZPOVKprGIhux5d4QE6zB+5ba44P0+OhLRCaCJcnsqABqQ23DV70dLcLuAWOCGnQxaho1agnuH47n1jGV/ORcBrNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9958vdTUG0kfKUD1Gb4WTYzGWMv36VHhSQpJWxkmkHw=;
 b=KDkWuuZI/s3LRhlUXNNBeRYcev086AC9XvbLAnc9N9ERdw2uXqjv2hFficKXFePhkPIlz5zFD/g7i0CB7L4hP/1k8E2us4l9XV9xnFT7DHe7rv/UyaHAH2xan0X3iC83hzKFdd6lWDTDHTa8uE30Oj3Xfb5/wbdDV/hwC4I3QgIxd4Ei7JY9/cJxIgT+3dVzAxugthBNOE/X2mBOFLlaH6jcvhggLPpNIRAbV3vbP4QvyEYcCVESfK6MW+M1RvlDY/c3l2RL92cALgm6k2KwF0OvqWVXB0uJOvU7g47DMpySjKnK4i0kISdEvxaJs1wdixxO9pRZwYDC7Q+dSr0V8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9958vdTUG0kfKUD1Gb4WTYzGWMv36VHhSQpJWxkmkHw=;
 b=IK8z7yesrGXAB3dzLfSk3u1BYvtieQCCnWkW6eZP1ddow7qBSW/wwOtfh44ccnxno7zQsiWGj4bW1TkmMjikQe3cSjFYLTtkNoWqGuqqElMoUFHpehJhjSS3OCdwstqF+bvDUS2yWJIE3PeNFo+9wXuzcTv7pspUEJOIBztjrZE=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by PH7PR10MB5722.namprd10.prod.outlook.com (2603:10b6:510:126::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Mon, 27 Mar
 2023 18:55:43 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::9fc8:73bb:cc29:9060]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::9fc8:73bb:cc29:9060%5]) with mapi id 15.20.6222.029; Mon, 27 Mar 2023
 18:55:43 +0000
From:   "Liam R. Howlett" <Liam.Howlett@oracle.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Suren Baghdasaryan <surenb@google.com>
Cc:     "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Stable@vger.kernel.org,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 3/8] maple_tree: fix freeing of nodes in rcu mode
Date:   Mon, 27 Mar 2023 14:55:27 -0400
Message-Id: <20230327185532.2354250-4-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230327185532.2354250-1-Liam.Howlett@oracle.com>
References: <20230327185532.2354250-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT1P288CA0019.CANP288.PROD.OUTLOOK.COM (2603:10b6:b01::32)
 To SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|PH7PR10MB5722:EE_
X-MS-Office365-Filtering-Correlation-Id: 2539281e-35c3-498a-b524-08db2ef4dde3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bv9MQ5jVW2K2O5rsvDNm8Dw0wAxERyzzRxTQL/mWTK+M3ZQVJi1tzcKTdsXhGNtPtUL7C4gVUdW0QDoGvEFyfaetehdbxTkjeKB9iaajSMzFeFeLhClw2mcLjJQBqthEZ+S4hAaT3ih+vBsoO3BI4gzOfUF1VYHkpiZZ3Y3HGy/I91JegEPFOAOmPli4IuRfYK8mw49n8ZadVB6Bsp9+rucrqkJXwiQiO0gC2xoCmA+NLtgCS0ijVFOrmAOmH+HR9nqiCGEi7N9rWc7jz0IKM5hPiwt9U+l8nwzx+DHu4rIvEDYhqkzNRWuWe/8vzN653h+CL6Qy9GoOp4/Izbv9W3/zHFtzKVKH8yDYmXwl4elI3ExEtV9FKbNf9Raw1M+FWpWOUJK/pq0+nYQP4YF5Xjt5mOYdyYJt2YeqnJod4DVHOUiRSfyieFiIcOy/J6CrJ5mi2/1qbg5M9T2mt9XUUBuhDa0RJn06zO2i/9rETYuFWVS1xlslmB5ktzw8g9go+BUiOI0bSLaVCfTUqEehsncWluVYjmTCvTGclhOIUjA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(366004)(396003)(346002)(39860400002)(451199021)(2906002)(38100700002)(83380400001)(36756003)(5660300002)(41300700001)(8936002)(86362001)(2616005)(6666004)(107886003)(110136005)(54906003)(6506007)(1076003)(6512007)(26005)(316002)(6486002)(966005)(478600001)(186003)(4326008)(8676002)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2jc1Yn+tEOEOT9QilGmI4y6qFkEXfrQ+JfHHyHEbDpWIjsW1uRUCS39Ibe3w?=
 =?us-ascii?Q?SgPElwgougkmj1IE+JMuBa1HxUmbIjZ6kxkqRVLnLdzadjTHfuk8zMC4v7u0?=
 =?us-ascii?Q?PP/VkgimtQVIv1uw72OCFygPmPEj5PcAPHypcfBgJcM0aH1R+WPRgLEboszV?=
 =?us-ascii?Q?0ulwgvLQaSm+xS1JYXxjd7y5d7WfUEPPgpYiEcRV7+uUmEGDN30xZ/Dnw9I7?=
 =?us-ascii?Q?oepYlPP4H/IhgnpgBJfIPCH5yZbgYR0grsIVxUAlSsnhzU4tixruq/YSR9XL?=
 =?us-ascii?Q?KDxLkD7nd0Ku9nl0u5kkyUqv6LlEzp/h5klBjE/Avx+/fSbN/Ux8BPFXoWci?=
 =?us-ascii?Q?iPDAwYeeIHYd6apQqNTt7CWWMkX/TLTy7cROa/DtyzyR7cvx/fkBIPhi8Eis?=
 =?us-ascii?Q?QnkeeAQRaQV4QbAA2/aDgcl05DXOSWtTKm9/vSeZNEjmbOwFDCshfz9jmGDz?=
 =?us-ascii?Q?9gPRCXzZoh1RncIITif32WpJa6hXZr4yz4FUVnBHY/4baOiHOXhgAkwCJiyJ?=
 =?us-ascii?Q?RMZb2pXBnLESlqwwLj5jk/g5EdtXY1K61FDYOGtzjYf/bG5/goHoHSAVHkZ+?=
 =?us-ascii?Q?eaLPs/w+/usTLtql0mI4YXUj63icLWaSLisWzjv5i0BNeXhY3MaAc8enMWUC?=
 =?us-ascii?Q?CDXr/m9wOaDP9dzz0wAgjCn7O5j6Z/16dHCTayceFB/f71TyTRxs5rHV8YYx?=
 =?us-ascii?Q?zk9XHKWISqGcdPYenYTjfPEt+/JX2ahJmEe4uu8QwhFbL4vg8hBSkHifJgVo?=
 =?us-ascii?Q?1eNVFLA+3D7gpDJQldfno1ww16cEMpwlUPzElhiKzzm0wdZZBl7VTURPudKI?=
 =?us-ascii?Q?wGfyVin4kF/0OsdiY7vJHth4xTshJXkv00K0SVmhnOc+aF7vVKIM70xTij7a?=
 =?us-ascii?Q?ku9U5Wf+yADpfpIaulYuDvj3lGzRcadzrCe551Bcj6OvakUe3UrfuY1mBUH6?=
 =?us-ascii?Q?Qbf/GxrbtOkTuuwqQL4j+KZIX3dmhvebmmVkB5Bf4ryOZaRI/uaOqSPx0poD?=
 =?us-ascii?Q?0HzGm9BcaHrAThI8s7w7P5czxDuscZsO4pm4pnhlP4+TY90eCYDh1Y7QR/TA?=
 =?us-ascii?Q?y98V4WEmzWuZIABgS5LCp6SCNHHgddsooJhM7cMIMd7B3Mq/eL8PDe39UI2s?=
 =?us-ascii?Q?Wy6toAW0pMyXawilP7PKniy73nLpz5AYvPCM9Zsw+Ur/M2QfHSxDREHmC108?=
 =?us-ascii?Q?x9AnQ93eJLMEmERST7RR+FnQ9r3M2xssByx4e9ZJB9vnTXHVvDW82ottntHH?=
 =?us-ascii?Q?lBvyVm5AShogKS6IsHw/RxjgBAA9Mv7/7ko0svIwr5dNPyAluuX8/D0eLA0R?=
 =?us-ascii?Q?atviCKOmDi6Ou07DjlGa262umJO7pw2Gjwj6ISRnB6bp0pISOB0UlQzFZX1W?=
 =?us-ascii?Q?b28VZX/JEbkGiIvL1xcaaHc+yHJ8FFq0tl8smCD+rcxlKuHKr5nHzjknxPwO?=
 =?us-ascii?Q?V2Un0/1ydK4j4oAxX0uPX4ocOvmAQ6eaaNeNzru8XoFAFHJeKfbyzEZsFxda?=
 =?us-ascii?Q?f5gQO8lBLsUATvdSwDqWFk9FZTic2Xbx7QY3MkMWwcl1t6+NpGfGZYuNA891?=
 =?us-ascii?Q?UZSDctuReVH39HfpevOZKv4bJImkIkCeoTKi7n4ENIE0Se/2XpTO59IrFsgl?=
 =?us-ascii?Q?2g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?ncntFVIsuvaLBaTgKoJBJXRp3DbxSWstKyEtg9kFBSZ2nchguKeFGiJpmwR0?=
 =?us-ascii?Q?vx2N1LLfTQ5whABFM7JzenHYiCZkULMQvVlqGPN3m5ceLU5CrJ11NEAWK9vv?=
 =?us-ascii?Q?bBQAD7NIYPyatkTHqjQxyezmZwvspKCTe3sztink5ADBKR+TFIUnZ4UIY1Mm?=
 =?us-ascii?Q?u7zxzz/WBL1CGj4piGhC1XHRE1H+jz3NGpfw2oDugYdmf8kxXelAUnEx3+iO?=
 =?us-ascii?Q?aEPq2M5DwWEOpBAHQqNSxIrcBi+4Cn00Lgvd8f+3iXP9CF68IboNhaYIVIj3?=
 =?us-ascii?Q?I90kvuKLaX7lePtwXlBGzRfsdT2XrN6vLKF+gJoJHaxzecj7PsQYmKgkAZrR?=
 =?us-ascii?Q?OI52B5tLO0NHc4+m0rC52tCQN24j9gywilRZoiITW8ffTrzsO271Dt2XslgY?=
 =?us-ascii?Q?i8BZ8P8Grw3SNwR0z7cE+VXhJQgR1gT1HW/NQCzG0sTFG7I0LMYZi6RsYRI1?=
 =?us-ascii?Q?EheFOKULzrYas6HlfuRoYKF+27LhGHBZiBJ6NMtW0tranKiNhDzHOeryNsZy?=
 =?us-ascii?Q?31+uIvOeVOIy1gH3vo5Eq3+/JIP45AHyQwrs4PuIbetjqyJQe8A2wVMVJUTi?=
 =?us-ascii?Q?66MQITbAhoqG4UAB45ksOlYNFaU+aSquO9e21Cbm0XLCkgXeTZXoTMs4yzdF?=
 =?us-ascii?Q?Jli9L6gL8jDOQO8fcFvmpnxq4TuWzMPh29t3nUUoTkqL6N+vuZ3PZZ1ccx4X?=
 =?us-ascii?Q?UO2kMa8LjhkHFJjxw4kRyj8QLv8dkQOESrRlpd9WxXkODL3vW7BeqS06sccj?=
 =?us-ascii?Q?DYuExihCRdSh5ants1unnJjsmo8iqfiRM/lxo5kMT1646VndMai1XSRnn1CN?=
 =?us-ascii?Q?5AND0iwkNQaTXmKXgyFM7HD83y2Naa2CQOWzRWrJvnujMmvLTOmo+ogQOGII?=
 =?us-ascii?Q?YakIo+DVRXSkQYR38pjgSWU9f2XdYY/akdkEg8EADVQIwoI9dIzc/IboplYE?=
 =?us-ascii?Q?4RiUMro/ajqdQIrTWVFXdw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2539281e-35c3-498a-b524-08db2ef4dde3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 18:55:43.4030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Oc5rhuITm+0u++RPSgD8H3z9uj9nbUHeiR5k5QgqZnFxygLKpEEtWlCcqmYs9QSQuHYSeRJmhrOord+M6odFjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5722
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-27_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303270155
X-Proofpoint-ORIG-GUID: MqwT9VG-NhxC3Y_REuPVz0JyaVsjifX_
X-Proofpoint-GUID: MqwT9VG-NhxC3Y_REuPVz0JyaVsjifX_
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

The walk to destroy the nodes was not always setting the node type and
would result in a destroy method potentially using the values as nodes.
Avoid this by setting the correct node types.  This is necessary for the
RCU mode of the maple tree.

Link: https://lkml.kernel.org/r/20230227173632.3292573-4-surenb@google.com
Cc: <Stable@vger.kernel.org>
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 73 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 62 insertions(+), 11 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 089cd76ec379..44d6ce30b28e 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -902,6 +902,44 @@ static inline void ma_set_meta(struct maple_node *mn, enum maple_type mt,
 	meta->end = end;
 }
 
+/*
+ * mas_clear_meta() - clear the metadata information of a node, if it exists
+ * @mas: The maple state
+ * @mn: The maple node
+ * @mt: The maple node type
+ * @offset: The offset of the highest sub-gap in this node.
+ * @end: The end of the data in this node.
+ */
+static inline void mas_clear_meta(struct ma_state *mas, struct maple_node *mn,
+				  enum maple_type mt)
+{
+	struct maple_metadata *meta;
+	unsigned long *pivots;
+	void __rcu **slots;
+	void *next;
+
+	switch (mt) {
+	case maple_range_64:
+		pivots = mn->mr64.pivot;
+		if (unlikely(pivots[MAPLE_RANGE64_SLOTS - 2])) {
+			slots = mn->mr64.slot;
+			next = mas_slot_locked(mas, slots,
+					       MAPLE_RANGE64_SLOTS - 1);
+			if (unlikely((mte_to_node(next) && mte_node_type(next))))
+				return; /* The last slot is a node, no metadata */
+		}
+		fallthrough;
+	case maple_arange_64:
+		meta = ma_meta(mn, mt);
+		break;
+	default:
+		return;
+	}
+
+	meta->gap = 0;
+	meta->end = 0;
+}
+
 /*
  * ma_meta_end() - Get the data end of a node from the metadata
  * @mn: The maple node
@@ -5455,20 +5493,22 @@ static inline int mas_rev_alloc(struct ma_state *mas, unsigned long min,
  * mas_dead_leaves() - Mark all leaves of a node as dead.
  * @mas: The maple state
  * @slots: Pointer to the slot array
+ * @type: The maple node type
  *
  * Must hold the write lock.
  *
  * Return: The number of leaves marked as dead.
  */
 static inline
-unsigned char mas_dead_leaves(struct ma_state *mas, void __rcu **slots)
+unsigned char mas_dead_leaves(struct ma_state *mas, void __rcu **slots,
+			      enum maple_type mt)
 {
 	struct maple_node *node;
 	enum maple_type type;
 	void *entry;
 	int offset;
 
-	for (offset = 0; offset < mt_slot_count(mas->node); offset++) {
+	for (offset = 0; offset < mt_slots[mt]; offset++) {
 		entry = mas_slot_locked(mas, slots, offset);
 		type = mte_node_type(entry);
 		node = mte_to_node(entry);
@@ -5487,14 +5527,13 @@ unsigned char mas_dead_leaves(struct ma_state *mas, void __rcu **slots)
 
 static void __rcu **mas_dead_walk(struct ma_state *mas, unsigned char offset)
 {
-	struct maple_node *node, *next;
+	struct maple_node *next;
 	void __rcu **slots = NULL;
 
 	next = mas_mn(mas);
 	do {
-		mas->node = ma_enode_ptr(next);
-		node = mas_mn(mas);
-		slots = ma_slots(node, node->type);
+		mas->node = mt_mk_node(next, next->type);
+		slots = ma_slots(next, next->type);
 		next = mas_slot_locked(mas, slots, offset);
 		offset = 0;
 	} while (!ma_is_leaf(next->type));
@@ -5558,11 +5597,14 @@ static inline void __rcu **mas_destroy_descend(struct ma_state *mas,
 		node = mas_mn(mas);
 		slots = ma_slots(node, mte_node_type(mas->node));
 		next = mas_slot_locked(mas, slots, 0);
-		if ((mte_dead_node(next)))
+		if ((mte_dead_node(next))) {
+			mte_to_node(next)->type = mte_node_type(next);
 			next = mas_slot_locked(mas, slots, 1);
+		}
 
 		mte_set_node_dead(mas->node);
 		node->type = mte_node_type(mas->node);
+		mas_clear_meta(mas, node, node->type);
 		node->piv_parent = prev;
 		node->parent_slot = offset;
 		offset = 0;
@@ -5582,13 +5624,18 @@ static void mt_destroy_walk(struct maple_enode *enode, unsigned char ma_flags,
 
 	MA_STATE(mas, &mt, 0, 0);
 
-	if (mte_is_leaf(enode))
+	mas.node = enode;
+	if (mte_is_leaf(enode)) {
+		node->type = mte_node_type(enode);
 		goto free_leaf;
+	}
 
+	ma_flags &= ~MT_FLAGS_LOCK_MASK;
 	mt_init_flags(&mt, ma_flags);
 	mas_lock(&mas);
 
-	mas.node = start = enode;
+	mte_to_node(enode)->ma_flags = ma_flags;
+	start = enode;
 	slots = mas_destroy_descend(&mas, start, 0);
 	node = mas_mn(&mas);
 	do {
@@ -5596,7 +5643,8 @@ static void mt_destroy_walk(struct maple_enode *enode, unsigned char ma_flags,
 		unsigned char offset;
 		struct maple_enode *parent, *tmp;
 
-		node->slot_len = mas_dead_leaves(&mas, slots);
+		node->type = mte_node_type(mas.node);
+		node->slot_len = mas_dead_leaves(&mas, slots, node->type);
 		if (free)
 			mt_free_bulk(node->slot_len, slots);
 		offset = node->parent_slot + 1;
@@ -5620,7 +5668,8 @@ static void mt_destroy_walk(struct maple_enode *enode, unsigned char ma_flags,
 	} while (start != mas.node);
 
 	node = mas_mn(&mas);
-	node->slot_len = mas_dead_leaves(&mas, slots);
+	node->type = mte_node_type(mas.node);
+	node->slot_len = mas_dead_leaves(&mas, slots, node->type);
 	if (free)
 		mt_free_bulk(node->slot_len, slots);
 
@@ -5630,6 +5679,8 @@ static void mt_destroy_walk(struct maple_enode *enode, unsigned char ma_flags,
 free_leaf:
 	if (free)
 		mt_free_rcu(&node->rcu);
+	else
+		mas_clear_meta(&mas, node, node->type);
 }
 
 /*
-- 
2.39.2

