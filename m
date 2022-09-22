Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 325145E5ED7
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 11:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbiIVJou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 05:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbiIVJos (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 05:44:48 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014EA23BFC;
        Thu, 22 Sep 2022 02:44:45 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28M9ZHac007165;
        Thu, 22 Sep 2022 09:44:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2022-7-12;
 bh=3i/XYYwmQ4Vwv6/bg0kV2DoPnRXPWBWDJe0Yj190sV4=;
 b=fbrzCQlT6OY1b64OBxelmXmucs/qCi1uW4cTA1FaOlBfKQKC8B8LIHkXlq1G1eQq1b48
 Q8tmLzo7arnWl99cLaJ1vOWiJBBpjYVWCPkUqP4p27Xkv1aatdSp6iE83LrqMEXrhVMP
 NNj7T6NfL2JIVhcxmYnAhfQzOWgOyX2NzwZVs11mh9O5o3Yv8UMOLj1Pysg2Hlo7K6Ru
 JimbH1E/hr3LIiKJKZuktu4LzCjWUIcef7tEpAwcEw3aP5pBDrnhtqFnLjBVPv/z1uO9
 DVPpkILOJZEtm9+6XGVfvNrM2QtAXBv89CvVjp0DDowI3JRdss5lqeHJi4fLQYKz8Z7f 2Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn6f0mkgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 09:44:39 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M8lVA8033840;
        Thu, 22 Sep 2022 09:44:38 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39ndugx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 09:44:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lub+SvNzOP6qiR7kUnvuNOsXyIOQYp+dcUVN1tx9PfM/RbqL/rChMctZNvZlLH081VXovecAcloWlZ2n1UHMk6OccfxpqRvYvg3G4xKrtNYcBtEcSIntr+tPzRF1DPxw+eHQKSZO0zlxym5DJClajdy/E/pEpeE0o+NUe6jeRLdn7NG8AxnQynEDt6rl5lAzWN9212dwcysDuImuiqVvHmA1I4TNwVK9ccFyZdjBkTlOD02j50zYzgETA9zaRGA0hhTtiwtgtox8IvbzGnTp9sN6Ul1kAC4mqXPbAxPvnbYVpvfVBRVnGVhMM3go3bzdhywjMBcmvpKI2DK7HS1b7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3i/XYYwmQ4Vwv6/bg0kV2DoPnRXPWBWDJe0Yj190sV4=;
 b=X16GlD1UEFZemjXbBAr2vIMj9h45n0gvDaye4YW5BTbqOlnc6ioFiU95SJdsL856nu/mA2+EUEADPLM519A8SvqFAySQS3QQAZmagErtU7qcePZmUiJ8LQRBUItqZONeYcJkGiLvGnmyv1aWWK1nO//xZ1tHgek46TyjIAhwdsXSAboLws6xr9Trs346r4QgosE8ht/MMpYdxo04k4LZEzDJhLeXPDf+/eikm2o0jcyIDacfk3d4Z0vM/I2CtOnOA0WtPoFwv8mlyhgM/RDhPCMaYoleAcAfjThZqGej3tV5NroKcTJ9vAzTq1pf3icv8Ew44iJmFlq9erGLAahVnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3i/XYYwmQ4Vwv6/bg0kV2DoPnRXPWBWDJe0Yj190sV4=;
 b=k4MLFEAN7Ys+7O50Kx4wtZbqBOM18cQcBWKB0TTkh5e/esCTlBR50ILUNN7zhq7xlaByZG9b/Jm///q48WGmLxmBpPGgbAmzfgQ3bXR2+tNxr7fqHUrNwvNGSOKc2sRJjL9BV3sNpTh3Q/fDWTyrIuJsupkhNJBl06w9nI2HmWE=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by IA0PR10MB6721.namprd10.prod.outlook.com (2603:10b6:208:441::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Thu, 22 Sep
 2022 09:44:36 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Thu, 22 Sep 2022
 09:44:36 +0000
References: <20220921032352.307699-1-chandan.babu@oracle.com>
 <YyrS7dE8UtDydjZF@kroah.com> <Yysu56U3OYFozSLD@kroah.com>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4 00/17] xfs stable patches for 5.4.y (from v5.5)
Date:   Thu, 22 Sep 2022 14:46:16 +0530
In-reply-to: <Yysu56U3OYFozSLD@kroah.com>
Message-ID: <871qs3pwu9.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0246.apcprd06.prod.outlook.com
 (2603:1096:4:ac::30) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|IA0PR10MB6721:EE_
X-MS-Office365-Filtering-Correlation-Id: 85ecb91d-013a-4c5d-a8ef-08da9c7f0f56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yaEIzbq1k1qPkRLyNaBYC2l1JOjRFvvdPq6/N07rLFkQNP5YfC1b9S+Jl34P/uKcgMjXpqrLnkvekwlD4NMGjkYbRKIjl3UEHIM7ePulra79/fO+JECki+uDcknItHHYRr9DATr16Dr0deKt8sdFdrIXYiUxs2yIoc2HsqnXnt1B2elkR8+P9WX5XoQpN4kZP3wzvEQ62cl8NedaleDTGdyq7b67bGOK976GBaIUaR1P3woiLaxjD2P+LtHdZxhGaEP9cghZO/wSHOBzJQyf/TN7oSU2ZZK71d4+xJjlQVeu2moRiUNz0Sw2qQb03yTx4UAuoC80Vtk+RSHW6MhK5xFW+qPzWxR7j172nrnmwusPPl0MfcUKaGZaW2DSMnOBOI/Ao5wko1hlg3siJMA8l1/qxCcsH58Az+MGijvMIqhV4p5DvspEnD+EekijjsBFCexiZ+a0f6tKPQO/Qy9lo0XzhzntZ97nrUPvsV+P+ra7oXAHtL/9iJdX3WXOeUiuZEgG8pR/9x7p1pt01oQbAs6rlzo+zsQk+meVXDKN9eDFtSbIr+7XbNIfQAa4CioysHB3FBQSb+bmFYRLDg+cFe1Pq9z+SxIeAbOoVYXDNhRHEOd9SLQOYoevZhKnJyxhDa219BQP3DGLkZrbxsW7NhDR9eE33cwPfd05teMhOVKP7tECkNQqYp+oAq/L6areQ966ot/AAOQYKRz6pkNkqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(366004)(376002)(136003)(396003)(346002)(451199015)(9686003)(186003)(53546011)(26005)(6506007)(6512007)(6666004)(4326008)(83380400001)(2906002)(5660300002)(66946007)(4744005)(6916009)(478600001)(33716001)(6486002)(66556008)(8676002)(66476007)(41300700001)(316002)(8936002)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JBG3mgvmYwJTid6v7SqZ1i2bIdJUKwXrAlDuwBhTurq95sBQX4kiWQdlzAdJ?=
 =?us-ascii?Q?/O4Alqwpz2guq2imOnUqwvLSjNMizbXHPAEtVvAXfNR2eGXxTMRuBgFaSAKK?=
 =?us-ascii?Q?jmQPsnzdqQZiXs9OM9ZgTPc+lAqvdcvl5sgw1O+k4hwDHsLzPyiw8wIwjGw7?=
 =?us-ascii?Q?YQCRxWrZnpqwCOGVqsBdsImS94H32UOmzS0PebZPPO6vJFpijkOyn1K8mUr1?=
 =?us-ascii?Q?LI1ZxeRxMnW2l8F5xHTrACdXxo91oCX1WHI8e8gNlavLZl87wD2Oa9tfAPxA?=
 =?us-ascii?Q?s9nwu8VUwabsdPjTOrsY2OsrmHZWXgMqjr4P+pvWduTQEyTw5pUSHcyswx9Q?=
 =?us-ascii?Q?/ckfOo5NrXgEiVcDCqZPZpL/AIg7AifGI9VFnBzRxyxAE62xRFa7A/cEeoQK?=
 =?us-ascii?Q?O5cpJGrVIB5KCNhK8xPMw5EA3CI9ctm5Dqk+syJw89X+6nkN8hHXOE9jGqKB?=
 =?us-ascii?Q?F4W2bxnfg2ZDywR6OEz3uqpulqim3Q85MPrQ7gi8/6FvMlqG9hJwNCzjz/hh?=
 =?us-ascii?Q?VEtwi9ruCishMVqe4NAeU8y08cqYzG8z/LRBK3dEXV0Xwzm/ybtviHz0PY2N?=
 =?us-ascii?Q?xyB3OJnDVxvUjbHreKovCqC8/7vbCCoUuURcvyW4A+iLd0tsjdN0zntulvLp?=
 =?us-ascii?Q?Wy1R9yToE/HZCAE9cI1OuyKh01xKZpqsU6DnWKK0EXMCN7zwWyHs7oVUiw49?=
 =?us-ascii?Q?pMTkts7QC6vqyargr7RTZgvnIL/YZ8r9uods4W4AoXNHWUV1ZvNnwRuhCjWd?=
 =?us-ascii?Q?v7uEzDiexyeN1mX2oLCcpIWTtxU4rk08bEBCPvLH5b/S42rTDq9JhKGjz8ar?=
 =?us-ascii?Q?Ueb4zfxzrXfFuQm2nQVYWfG/c2mtoUqDZWRzGzH0T0akkXjWRcQzn+4GX7RV?=
 =?us-ascii?Q?13whAzGW7t+uXfj5B+eoezaDRw4NEbXZ2GoLh8xtvxw8bQyTB6+ACOxf9SvV?=
 =?us-ascii?Q?fp6QZHyjJR6Maa7F3PRDzXjJLhuQwJEyYFokTKZamEsJvIUY5H9mr4BAr4kP?=
 =?us-ascii?Q?8srfoAAN0NZgrWXeRUqO0Y/0Eq0rAFGk8NjnuuROTwZlVLUcAYOQYIUBuzhK?=
 =?us-ascii?Q?SQeXgE2NUHDBIx3V1BSqDvCx6GEjc/6OIneQ6/8N7hDBLAe5wkT6A4DyUSdK?=
 =?us-ascii?Q?im3+reEb1QLBg2beXGzOtVcdFWU14pD4pLlvmNb/5LpkUpsmKTfnSAHq5n+1?=
 =?us-ascii?Q?LiGtrrNXfwxaacaDJbXxWCSg7C3Jl71IMo8jrpo9gu6i0ZTj4PZ7zkLbqD8H?=
 =?us-ascii?Q?vQSI/BmqFQ6MukDN3TNM1YwO8xfQlCQkRpqvbmzKn9KNv/eUh925p413Etdp?=
 =?us-ascii?Q?Ny+UtS+3SnJtCtqIjfSijvnzHwXj/IpAYZ7bz94zvVPvVfb9X7hDU0kSbPnt?=
 =?us-ascii?Q?S3pKE1jlLslchetQtM9IZSQ5fvKls+RCfiwKUDXXkyc3877EZLT3pE/RQZix?=
 =?us-ascii?Q?N66h26ibJ9hSwdNuDaJSC8do8DkP9dQXxs8qAiQAr5AwzqoboU0l6uGvJwrP?=
 =?us-ascii?Q?6M8646lhpdM2kSJHGvD0JdTWEFl/AhGpdFNviFZg8a3x+JiIUaWJzr7txQ2G?=
 =?us-ascii?Q?Ey/sNNksFvXXl93XRJ+ttfs/FQmMMDasjT7U7we9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85ecb91d-013a-4c5d-a8ef-08da9c7f0f56
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 09:44:36.1758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TIcM5OI6BM8LTRTJsiiYtaU8dUJbklW1mNzJF4v4zujQbYv5CADgD3XGXze7ub2Iiwhe9iZBlGE4e5OCGY4yrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6721
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_06,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220064
X-Proofpoint-GUID: JFJuE84g-qN8F-9Phatotr6v1umnihyM
X-Proofpoint-ORIG-GUID: JFJuE84g-qN8F-9Phatotr6v1umnihyM
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 21, 2022 at 05:33:59 PM +0200, Greg KH wrote:
> On Wed, Sep 21, 2022 at 11:01:33AM +0200, Greg KH wrote:
>> On Wed, Sep 21, 2022 at 08:53:35AM +0530, Chandan Babu R wrote:
>> > Hi Greg,
>> > 
>> > This 5.4.y backport series contains fixes from v5.5. The patchset has
>> > been acked by Darrick.
>> > 
[...]
>> > 
>> 
>> All now queued up, thanks.
>
> Any specific reason why you didn't also include 2 other commits in this
> series, that fix issues that were created by some patches in this
> series?
>
> I am referring to:
> 	496b9bcd62b0 ("xfs: fix use-after-free when aborting corrupt attr inactivation")
> 	6da1b4b1ab36 ("xfs: fix an ABBA deadlock in xfs_rename")
>

I had not considered the possibility of fixes introducing regressions. I will
test these patches and send them to the mailing list soon. Thanks for pointing
out the missing patches.

-- 
chandan
