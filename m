Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 878485AF007
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 18:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237600AbiIFQMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 12:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbiIFQMh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 12:12:37 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49174A80C
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 08:39:15 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 286CnXMM006226
        for <stable@vger.kernel.org>; Tue, 6 Sep 2022 15:39:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=ZE2TJXaxeHH8rb5eIMsDPi9eJhLHgUCl5i1ZS1fZbs0=;
 b=mdYwj64pf78Iwx4IjCrRtxz2m7sJSB9Dj6PLFPZeqgnP3nXxdDVy1/u3T37AvSyy8vmw
 t+G1Mv7PPwGZxeP8Sx/1aoNG0LAN5bjGQdj+GdG96lzjrulNCYmzzkKxFEDmzbf1kaKx
 GBaJWIvxtuf2JmBeC0qrDcgyZyr/Ci9OoUi8+EltlMS5gLbkCMUVXwVqyOiM6ET0mJeD
 X6zbPr2P9bxFD+14oKN7gTiR6J3dafaLscjNL8GznZvKMxWi9SOmFHkc5Cghp68zkXZc
 u/R0Tvfc5IoF6U+lIbzZlI+GOzvMeWC4SjOnch5raelvqhT9V5aVxsHq3kcXDOC06/B3 WQ== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3jbvxdtr4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 06 Sep 2022 15:39:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N2rVYnNxBIPVSRd4m7IcbRjE0wKPGbtdZBEFEEX2NbMP9LKxnAVN/u5LR/OxKJCtk+r3X60vt7YmitXjimxa8XhKF8a64eaKJXitqGn1yNVWgiUEMGrVYnPcDP5E0K3PxBPYmlbVdn/BcESzmNlF135y1/54dlP/WRBXvE7Fl/5Mkcq1huQlIg22lLVVSscBIqlGEOWeDEF4YiKPny5GnBCa4t54t2CXTmcKLBGk6LUIR0hDdVoAnahxbok0s1REIvXT7UnyXuYrajC2ByuvNVC4ocLcngu5EAzcS8WAQGYpxhJ0vnTRnDKH7xC6Uro0GXWPr32Zru4vEVnuM+iImQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZE2TJXaxeHH8rb5eIMsDPi9eJhLHgUCl5i1ZS1fZbs0=;
 b=L6fRYVtanl0hPyJijBtaTS4W33ol7s7ktuPZik24//3MlizB4/lA540xSCI++jeTdWRKHbb1tsEq8vlIgmANnfjPXPxpbko9a2XAzc4TYnFUBusKPDz2v/Bl4UuDT2tDlrrMut5mNK8ArtjaIbXC02izrEXmJRdRBLJpF8tMjwCp4T3k06ALf5sW0KYi2EY/ZkJ8FshbxwsYBAFeWxm8GSDdFcQ0IsyXy0lw2rv8neAskC+vssGuMKnwznrCKACa1veF1MEhh+o0rrOqYp0I6y1HBIx76rFwj3B1hBPCZW2EcrQTFV+idqEQrXaL4WEkJe+0JH/25L+cVf20aUY7cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by MWHPR1101MB2095.namprd11.prod.outlook.com (2603:10b6:301:5b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.15; Tue, 6 Sep
 2022 15:39:12 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::b4a9:c48a:51c2:d3fd]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::b4a9:c48a:51c2:d3fd%4]) with mapi id 15.20.5588.018; Tue, 6 Sep 2022
 15:39:12 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 0/3] bpf: fix CVE-2021-4159
Date:   Tue,  6 Sep 2022 18:38:52 +0300
Message-Id: <20220906153855.2515437-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.37.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0125.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::27) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 551a9edd-05a5-4219-cfcd-08da901df26e
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2095:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q8T5pGsN0wg1VNdfWRYcKOL4H2IjllXD6sKbk8wBXaDN6tZ72gYZ6NMOQihpJxlIxFImoqQb3AV/rVNyxRFUni1ZytLbb6dL+7iSubYBzrrLS6+AAMh2JBfItI3YGNjhoxLVgWA4GLYZXDUueZoDpBlMEAocOmQ2qOc/EnuTLBGo+G7Am16vwKKXCTnFduE7OLGIV5PULwSgIIRtXCMvzRrztBvvD8h1jvPraw9mT6BdjZBLe98Xmjf4iM2K2o47zOx0pFL4aaI9qb3Zrw6bYdFedAfvbjbba+G1NtolK3tpClonikOqjwp4en/35+656/pcX01Um+Fn9hJ+m7IFx/eGPBJqAJBnvm4d43V2s6zClpkovX1EnPyXu0lnIfB1iDRNozLBjR3f1CutlcN23fT8ca6b/6L8rHgHXps+DaAqdZsYKX0FDC1BT2f24ALpREwZgKIZky9AZHvY9k09HcwjPB5jnlQ61sNTM7I0UQ8V4gYv6KkIoTzurITtB/4GpjkRRLAxiLZvbWStqeOQSvaLQfEuxQ+lHWC2apQUgn+AsBtHcqqB2iOYifb1lALfgjRwyPDyAy3qUjQJrIT+AYjBoHfUiU7Gce8fvycSMcB9aXBbwDkEfQAnaerJQPOBnWe20ffd4zymW+ZsuuQtymZuznguqXFvoYhMXHkZ/DzPVhVCU8QzNmXNpNSQh4aLrXP23xMsSdAnijns4Yjza7hokEoBsC4KRT5Zkq7986c402UawiEEaMhyGdNWyP39
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39850400004)(366004)(346002)(136003)(396003)(6666004)(38100700002)(107886003)(5660300002)(41300700001)(6512007)(52116002)(38350700002)(6486002)(83380400001)(26005)(186003)(6506007)(2616005)(478600001)(1076003)(316002)(66476007)(66946007)(86362001)(44832011)(36756003)(8936002)(8676002)(2906002)(4326008)(66556008)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CEUNzkVvMOWcABwyJQZdrNaXjfZ84zUWS0vsHVUK+h2gnkmNsYz7IS+2daiX?=
 =?us-ascii?Q?vgq09vKp6boQusxOnBQIU3WScqTp/BXKeovEme8sHGfRdTGn6bAahp2tkSZd?=
 =?us-ascii?Q?2NxKkGRlCadJlFguahTTCKA51A86CzJgvimz/qvmOrxMI1uzoBEqEOMJRkNE?=
 =?us-ascii?Q?/fyMUoqS3BOxXwFpZ7EZHRhx+xMdsI5NJCTNJMKgwwGdTghmnXANi1NU/8gy?=
 =?us-ascii?Q?p4oSZF2pb4othq31dBlf4EwtO8+x8PX+RXJ3orISRwj0KRl1VZ1PtXRXjgam?=
 =?us-ascii?Q?GVF1UvvdWxXG1MxBntQrJ5oIlB55AlxAmvoqd/wJs2/83M0Bt7jgEzy+eD+b?=
 =?us-ascii?Q?zSq4gyAYuMTxwOO+U7OLpJwvVQ/DzPyqAzTMVOxbybStlWX6pr19OOnUuaXx?=
 =?us-ascii?Q?QQ5/jboyn+ZdHcbgP+JBHvaeZ+snNUE6/8lE+3AcfB3xZyuysl6QWgP607io?=
 =?us-ascii?Q?4sszrZoOoaadNr98jzZKWYdaGkPNhrr0P47eNbdSpre6S5SUsAuSsP9Btg49?=
 =?us-ascii?Q?+J3X6zK4bVtjQZXUjh4RO2/g5kQSLZ6Gi9RTPhB3J3iUxHlzZZk4ODgmvQL3?=
 =?us-ascii?Q?bfds5zrPR/nIR0S1UXrgG1VqR5wo4YDQI/HHEV+PYSQVcHKM9cXB7thA+2k6?=
 =?us-ascii?Q?CptELyJpAv6+EPPVsW728b1oN4EIF7IgJo9jDd3V7Fo+KO6PxzM0t1EOUjXf?=
 =?us-ascii?Q?rN1j+rVkfgE8BJpJwvoug5I9FUO9T528lGbUnmgmAtW4DarynP4k+ecQ1cLF?=
 =?us-ascii?Q?xmKoJ/KKfWdMjxFhwagb54sYZDFJvn9wrpn602XGJp1lrvTm8uGv+C6hWpXQ?=
 =?us-ascii?Q?YLZDSJPdBvHBGVQl0EtSKXUb46J+jBGrKGRtyxq/05IrNkLNlgMAk1Lv4uYa?=
 =?us-ascii?Q?9w95LZmxlWL2oW/x/909Pa12ebi42S7g81GPZWwz6YeDmXsGD1MhpBDOxnii?=
 =?us-ascii?Q?yM7nlrJB+vixgT6A9+aysvxYuGItrJ8cnWufWG9omGZLq9+6+GRBwsMEnIt2?=
 =?us-ascii?Q?FCwWy7uKTE1IWkYTsC2VuND5OUz7suf+JwBNYPU5YkV5VY0OAuJaKuYGViK0?=
 =?us-ascii?Q?Ut4rwD03MmsRHLKX9h2t95KTabnq7Wu8LhjwMGv4sMIcaSEMYGiMoLaod4My?=
 =?us-ascii?Q?R8aQu85beX/6oIQfAxAsEvI9o1/aD2+UGwvRgsmxh88QHEX8SzM/igdrTwEH?=
 =?us-ascii?Q?HNo/0w4C7hNcOuY+Oe1ontTTIVyA0jPv7kzNRtD9GBh5vmSK1+fP49W1dXs/?=
 =?us-ascii?Q?IG/dvsvy4Nqz3xRm2sd53cliWEs+xh7OJqck9MBgFfHb8gluoqe5GRuaqcQH?=
 =?us-ascii?Q?BgRlfI7tgRp/qMExI+l98lHW7r2T77oGaPX1xei5O89hdHXvqx5TFLlLf9kz?=
 =?us-ascii?Q?p2ewIWJkYC7+F6bFms4plvlwlgqw4sX1TVUzK5B5FOB/VFyY2s9hJElebGR3?=
 =?us-ascii?Q?S32oFPyprEMUtp6j6nW5sh49+o0SsI0ufE/IPJqdJeu6BPxEkIj64Oh8ULKk?=
 =?us-ascii?Q?wETiBqF9QkZC5q/wAWqR/8Sxgkruuyi1w5NywkOlD/lP6TqCZbjb6g9SS5ya?=
 =?us-ascii?Q?/alRZ6lmZo+BYUeWVWNMaO2X91xknIUoMiTjAWh3qP2EUz1tPFKdTbmMp2n4?=
 =?us-ascii?Q?fA=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 551a9edd-05a5-4219-cfcd-08da901df26e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 15:39:12.5597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +2mJ9a20q/fo0pBo4NLRTtyxNfk0wVSdIzQVbgxAp+BUiXzzxq4oYH+M0K5peoIOCbS6A43pm2V27xtt7kHadmWcPxD+6IQ7hnFdcz2Dg80=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2095
X-Proofpoint-GUID: sEN1x0RkVvMDlqkhNOQbrlltvRVsOOYM
X-Proofpoint-ORIG-GUID: sEN1x0RkVvMDlqkhNOQbrlltvRVsOOYM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-06_08,2022-09-06_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 suspectscore=0 clxscore=1015 adultscore=0
 mlxlogscore=533 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209060073
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

All test_verifier/test_align selftests pass in qemu for x86-64 with this
series applied:
root@intel-x86-64:~# ./test_verifier
...
#433/p xadd/w check unaligned pkt OK
#434/p pass unmodified ctx pointer to helper OK
#435/p pass modified ctx pointer to helper, 1 OK
#436/u pass modified ctx pointer to helper, 2 OK
#436/p pass modified ctx pointer to helper, 2 OK
#437/p pass modified ctx pointer to helper, 3 OK
Summary: 667 PASSED, 0 FAILED

root@intel-x86-64:~# ./test_align
Test   0: mov ... PASS
Test   1: shift ... PASS
Test   2: addsub ... PASS
Test   3: mul ... PASS
Test   4: unknown shift ... PASS
Test   5: unknown mul ... PASS
Test   6: packet const offset ... PASS
Test   7: packet variable offset ... PASS
Test   8: packet variable offset 2 ... PASS
Test   9: dubious pointer arithmetic ... PASS
Test  10: variable subtraction ... PASS
Test  11: pointer variable subtraction ... PASS
Results: 12 pass 0 fail


John Fastabend (1):
  bpf: Verifer, adjust_scalar_min_max_vals to always call
    update_reg_bounds()

Maxim Mikityanskiy (1):
  bpf: Fix the off-by-two error in range markings

Stanislav Fomichev (1):
  selftests/bpf: Fix test_align verifier log patterns

 kernel/bpf/verifier.c                       |  1 +
 tools/testing/selftests/bpf/test_align.c    | 27 +++++++++++----------
 tools/testing/selftests/bpf/test_verifier.c | 16 ++++++------
 3 files changed, 23 insertions(+), 21 deletions(-)

-- 
2.37.2

