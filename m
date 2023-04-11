Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD0D6DDF31
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 17:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbjDKPMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 11:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbjDKPMO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 11:12:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4142259ED;
        Tue, 11 Apr 2023 08:12:00 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BEwu5C022973;
        Tue, 11 Apr 2023 15:11:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=YCmdLu6Drwx9ZBMzi2mLIBHa0w0b8jE3MogqeFXzZeY=;
 b=2dGgA1/aC/kA7EqezVAMKDQ8uudY8l4Sa5qzl0hq6zE9nr5UJMDmze6t4s9yhPbzKkiU
 79yhxeTScH91XqQNBgtgOeiDP0MU5d2jvTqAZnJa+qEjZ4PjZGftWXFha+YOJXpchmSS
 r+iqZovsRlNWg4+QiQWZaWjZTxfFOSWSXmU5opZxTwcEKFPy6BcF1nsXYvXzSMsfajjX
 dnxnDooIpxiLVe9SxfdRdJ2PxM0sofScFTBwsJQXIA5WCfq1RfXz+GUQQRVue9w/D4KS
 i6/qHVkmon9pmTp/OXps+/jyASasaPQ+NGlLYG49v9uzAi9XhbzXFzi5sCqXCHTv6oF+ 0g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0bwdrw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 15:11:36 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33BESDYe031027;
        Tue, 11 Apr 2023 15:11:35 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puwbn8fwu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 15:11:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BLJT80aAmvXIEdIKgo8krmaXM+HJI91kAyaSXVt0kH0x/OUJsTa2yeU9KUfFX8P68wl9o7HjGu1dqlBW9hD28es+U0NrBI6OeE4OPdlvQ4h0G44fljbybDbFDkVSejpoK25mSQ0+EaF/XaOtX/SVVUh/TUX4GmDdp8iQJCCst0W1/dZZ5gDDhOwXZsvcpIQG2MjS4xsRRXuB2LqjZ/CfWyknzCxwZ9AOUzyB5kbMtHQjwOoBdN6kGsL+lkKhPTZHWw51pu5+up+WXTkDnUAsNeUZ1ztLH2lkUjFoQJ+deBWgyn/MWw823YKtXkHbt28s0831B6Z0WOdKR5GKmgRcTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YCmdLu6Drwx9ZBMzi2mLIBHa0w0b8jE3MogqeFXzZeY=;
 b=gVx0oqysdJRr2ZPpy0R6/YDrB2Q4sW6zoXHuFDciK/mc2qLXdwY00UhUNGtW3JCnBX2ycZE6qLY4wvM3AGPSsqXYGbB05l4HpX3RdjVJjU8sPHaJO4aAqVaw5GnDYs8P/l6JtJ5qEGUw0tQX+/YZLV1oKPHYy4BfesO5gJGXjLBLa1osOvnixvDCNLbHq7ebytvRPiBoRcVW/nVP+bBYhwgI60/B9iMIgkQ0CQJqkDvcLL2EHF5Yp/qiICjcJPICg+buyZgRAiVOEu+d8aXs+RUGaLjZtj+hZMLM0LxF7ZDP5leWdqBNtB7T+HbbXnzgizPIPgTb5vNgx1hYJFxJfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YCmdLu6Drwx9ZBMzi2mLIBHa0w0b8jE3MogqeFXzZeY=;
 b=K00UdnDeWdkztkrH/xZYzcGIknSRt9VVB7MWsM6iyA0lNUCn8hTNWPztdaqWPAbIjKhC0tePcwCso0YV88YaxW4TIX8XYdj2lUSWdobstw15thggpSwhcs9n568n//1f3+0EfMra3MJ4Z+UL/nOSgrmlaB666spyAvTvSBLF2i8=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by SJ0PR10MB4718.namprd10.prod.outlook.com (2603:10b6:a03:2dd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 11 Apr
 2023 15:11:33 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da%7]) with mapi id 15.20.6277.035; Tue, 11 Apr 2023
 15:11:33 +0000
From:   "Liam R. Howlett" <Liam.Howlett@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Stable@vger.kernel.org,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        syzbot+502859d610c661e56545@syzkaller.appspotmail.com
Subject: [PATCH 6.1 05/14] maple_tree: fix mas_prev() and mas_find() state handling
Date:   Tue, 11 Apr 2023 11:10:46 -0400
Message-Id: <20230411151055.2910579-6-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230411151055.2910579-1-Liam.Howlett@oracle.com>
References: <20230411151055.2910579-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0146.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ac::14) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|SJ0PR10MB4718:EE_
X-MS-Office365-Filtering-Correlation-Id: cdc2ef4d-1cad-4c3c-465b-08db3a9f092f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i3iHZI/xplQ3seTKHHGyGg8E3l+Qh/RTB8zL8qrEoTjqnfl5iX6pMS34CRBvJdSxvRPRcG6FBMIoX7qa0yxkcq1ToIecprbGx60mWeSecozG5BLv6GSa93gNlDlvmtHuGlPNY6rmRjS5zc1tDsf/mrtQLCRCbIVd4pG0gDqiqCf9EOan+Jc+ITRkUJqD/5A5f0x56zxNqEv3t2gqEDzh8vT0+iERGICYRiKhBwY7nIL/lz4nxQ+yGBHP0HtbCl856Pp1lBuG2qPGrmSjM7+KmY26jv2dgQchzuQWJUcwWZjISBZUhJy19TaxSoDDh3d7izNIsO9xVRyPjwVi/q3PZhX9+9VMolc/97yONIIXktt/MCv7cLKJ63g8f04gNoWChSHLsFKSMfvkEPz3HAwkp0lkkha9oP+pS+22IuRhRQRPiGOUo387bH5Ixovvyp+ycCYIYgZhYXhn59qg0cg6KwHqStPJQcramk6DpxgEG/otAdsgqWjA4W+lE+g6kBVgzAHGOBM+OOqGmgV1AL2UkMsdt5pgpFOhBp55QUIEGk0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(396003)(366004)(376002)(39860400002)(451199021)(38100700002)(6512007)(6506007)(186003)(6666004)(26005)(1076003)(2616005)(8676002)(83380400001)(2906002)(6486002)(5660300002)(8936002)(966005)(36756003)(478600001)(4326008)(86362001)(316002)(66476007)(41300700001)(66556008)(54906003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7kPiPbj5FPOYI/fLFQ4T+n8l8AK8lVY17QZVkRR091EjPqr+72gW83yDy/gs?=
 =?us-ascii?Q?cpdh0Ler5MQZvEOjhoQw/T12JufYtdQVMVtzqz5IIxze95WQni+xR+nvMNFU?=
 =?us-ascii?Q?3X/J0ZZ14tMqzcLbeVk7C9dT97FGALQnkLtvoGrEijEhe3BJdvAQZrgjm1R+?=
 =?us-ascii?Q?3DtmENVbSRmTUeSuY2wchI2DVj2+IfFvNW33Cjv7SHvJTUovRYZDBGV/IXFb?=
 =?us-ascii?Q?FaLXQobWw+6//ljqqoG9NYshQMgWfRfPyivx8Bpj3A0YZ0dl0nqz4Cnr15du?=
 =?us-ascii?Q?ssVydCY+Jr0yBTHbSLICk+9iTbtmnqhphLauLwYghje1DSmfXtLbEwi8ZGfD?=
 =?us-ascii?Q?7zO6deGT1YYsdfK+iPFZFzrnsOw6PNwYMTtAObE/tqvula7QXbxMJ5HiZ532?=
 =?us-ascii?Q?vKUpgyDW4r0MuyDHZIfuXSdW4EgQbhPXJeC3yNSusE+QceFqcH7klYTkZHy4?=
 =?us-ascii?Q?ONxg1Ri7IYQP5V4j7BmrTFKKFuQGmGPPLMn2telcFS9zdOmMs22ylNAmAlvk?=
 =?us-ascii?Q?d+oK2/kjL3M2pCRIYLyfg5DPHTGbRFNRPp0zLrnBDX03KrJPmyjMLRJ202lP?=
 =?us-ascii?Q?L1JUp1BkkDE7IrGjyjgqWsKGfM3ZmjaU8tuvKtaEXd6ZyaoQioU8F9GL1U/s?=
 =?us-ascii?Q?/eYWO/s0ZDtCrV3bPsEbp+aUIUUqvDOvG4MooJStyEeN8uIdr4n/vK7TDI76?=
 =?us-ascii?Q?I9c1qydU1XeMUXqq4zLcKAsTZtk3BfbHVUkEdOTCl9/Snk14WOQblpQByg5M?=
 =?us-ascii?Q?wSjiagO8SH0nojzuqoUJL9lT6h5R9QcvZMHY2It+pHJhy7uwUyFhZ4sJHJF0?=
 =?us-ascii?Q?lltGLuTlrxdUbgTGZauN4WeadWT0/4JLQjgJZAEnFvx8qxITqbkbvRpXy8cK?=
 =?us-ascii?Q?hAABA0FK/7iNdq6uaLEKAZ36bIrUmXoloQ/Mfe7P2hELk3+ANoB8m3CFJfWF?=
 =?us-ascii?Q?BCmclj6V+f2r9EzLyYUXvoIsE57ytLWTzGla+VXyzxkG6CPmsbiIT924aDZ/?=
 =?us-ascii?Q?vkYHBbTaZ0jrxP05JuVuf9S64uhsE2XSvYXLkpVAzSX/XlrLdLLx3C8ZStUk?=
 =?us-ascii?Q?vCtVCvRCf688lAhKUqyvH972A4bZ7nhEg4U144P4HE8Hn5DT9RGPMNWr97FU?=
 =?us-ascii?Q?4LB9ZPngqHEW6VIyWScyvyL3cx4ViAE3DJCRaAMg4Ut2QXTUP+jBHLNf4sgq?=
 =?us-ascii?Q?hVrGq+o6lWMr0Nak/xqPrLryfAqe2uV50fDDvdanPDYFWAV63RK5wVyb2cjp?=
 =?us-ascii?Q?YBgmNLXcz0Bnq1q4z2GMpfU1/zmMmZdTPGrBc7T+DxMla5Nf6Af9DT753Ino?=
 =?us-ascii?Q?QAIpJ29F32H92KF3ZwBNiN3PSaY//XmQ/tVXYeO39YBp0qI587VO7Ww4wWFW?=
 =?us-ascii?Q?WwwLwjPTf9209dglD92HJ5b1TSs8OrpBWWAHseuNeexb+jOUKWZzHuLf/X1v?=
 =?us-ascii?Q?53b6Xvpl8+MijXe6ujg4rV4aB5NL4u54DfoA4sMeP4Aw7Z+IK297LmT9SsYU?=
 =?us-ascii?Q?G1fMPYEaPR6IoRWOZXqJMM7XfUXZ28f95IN+6uKXJ7nyLAkPDAvH63FawG9d?=
 =?us-ascii?Q?LQpO2SSzal0m09aAG3dbHQeDwYbCSktmsi0U5o6aMeZxxvOjt/PiRoLhxJqi?=
 =?us-ascii?Q?6A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?s0q4f9dPgBLzQNIXOHx2HD+8jQVjhSIZFiygUBn6g2O9y5/rDsgTUZOuyVKI?=
 =?us-ascii?Q?u80KrseHXEIwygjFISjZ0olwUgwGl1Oq/KeYJHZ2ivwH2ihEUsN16SrWP726?=
 =?us-ascii?Q?6sL6V1ayPglHCHPlYxIpN6vb0VMCPlKjB4YDezQKXEwa6oZpiXOnA+yf2j+t?=
 =?us-ascii?Q?tf/ewadVLFFTMhYbl4Rc4xD7Da9nfnTbZFKwDm1Wov/j5tBeyAymhIhSJ4Th?=
 =?us-ascii?Q?PjP+Z00NmfotkMMfIN9+oYhoYrf19ol9d1CneJwY53glebqu0myMKx9pcw7m?=
 =?us-ascii?Q?bFL52itcmIsHFdEDDb5jIZHNTrGRz4jBK1I3Qk8/rH0KrjLR+BP1iuYy8U77?=
 =?us-ascii?Q?IEHcUW4mQuii8NnUuTBwcbdTCxO5CZP3acg5BjTpeWoy8FIuhpYu4+86/UZj?=
 =?us-ascii?Q?xXr6EvuJ8XxjpGQdubyJ5igOfi5uvkVLSAgIfRUVZxIhpZowMwgvCzKiL/65?=
 =?us-ascii?Q?ZGYzFc4h1kxhe8cO57CqRTvK+3mu2iFfWa1Sl7wYmIjvCYkJ8WhZaCDzHE56?=
 =?us-ascii?Q?jmnWdnH95i8yxfuJ3I+zMeQIECRrKjO1EhHh5Y68d5Qb6Jbziah71Ix6TH19?=
 =?us-ascii?Q?BaJ1NA/cQkVNQkHAVevxPyWUlqS/gPFFKqONvrR+tGaMKeoy/Z4hXOZTO+Xd?=
 =?us-ascii?Q?z/1s5urB++paG/XaZydRlo92eeBMmYhadKz38GWG1T6PACeESkRs1+sqoXjJ?=
 =?us-ascii?Q?1pFQlLLdyTDS41KYtEzXAth1MXq4jc1KegxcvkiAGk/tKDQKCaiZlslHHT44?=
 =?us-ascii?Q?Gjuw5yOkWYPO9/GWu39CxeCpKwomQuE1SvJgtEf6M6Ueln89Ly14Zq5lT679?=
 =?us-ascii?Q?xCtpVfuioVREB59aszgFTTLrqakI1RSavTZPHgzZ6Q8qHouRyMlyW5nIf0YN?=
 =?us-ascii?Q?i3Nt/vItap8Fxp9W+WWR9CIGSHVOoUhn29EG5v+C4GtnsXTzqeEu/XI9x560?=
 =?us-ascii?Q?KIH4DgHlgEr/Yd3ij22Wgg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdc2ef4d-1cad-4c3c-465b-08db3a9f092f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 15:11:33.2304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jVlG9ZT+mH/ml7PbTu5C3rPTEH85NHA6h5zyVYXrzc6TaKlnzMBBOaD8AgfUcjarbE6zNqiW7CdIvRr7OLVKNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4718
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_10,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304110138
X-Proofpoint-ORIG-GUID: fx5fl5F5qSMq6g0cmw94k0RuOq7x1Gd2
X-Proofpoint-GUID: fx5fl5F5qSMq6g0cmw94k0RuOq7x1Gd2
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

commit 17dc622c7b0f94e49bed030726df4db12ecaa6b5 upstream.

When mas_prev() does not find anything, set the state to MAS_NONE.

Handle the MAS_NONE in mas_find() like a MAS_START.

Link: https://lkml.kernel.org/r/20230120162650.984577-7-Liam.Howlett@oracle.com
Cc: <Stable@vger.kernel.org>
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: <syzbot+502859d610c661e56545@syzkaller.appspotmail.com>
---
 lib/maple_tree.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 50604fecd476..fc3e22cff642 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -4850,7 +4850,7 @@ static inline void *mas_prev_entry(struct ma_state *mas, unsigned long min)
 
 	if (mas->index < min) {
 		mas->index = mas->last = min;
-		mas_pause(mas);
+		mas->node = MAS_NONE;
 		return NULL;
 	}
 retry:
@@ -5926,6 +5926,7 @@ void *mas_prev(struct ma_state *mas, unsigned long min)
 	if (!mas->index) {
 		/* Nothing comes before 0 */
 		mas->last = 0;
+		mas->node = MAS_NONE;
 		return NULL;
 	}
 
@@ -6016,6 +6017,9 @@ void *mas_find(struct ma_state *mas, unsigned long max)
 		mas->index = ++mas->last;
 	}
 
+	if (unlikely(mas_is_none(mas)))
+		mas->node = MAS_START;
+
 	if (unlikely(mas_is_start(mas))) {
 		/* First run or continue */
 		void *entry;
-- 
2.39.2

