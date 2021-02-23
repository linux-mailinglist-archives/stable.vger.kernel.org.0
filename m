Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393C83224BD
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 04:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbhBWDlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 22:41:22 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54262 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbhBWDlV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 22:41:21 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11N3TP0L172021;
        Tue, 23 Feb 2021 03:40:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=b9bOKXglL5hJIKc5N5bVvcFRzWdp24hiBHTjXd2aCsc=;
 b=pC6vP8hd+RhKnUYwsnQ8lHaGQ0vPqIaBEi+DL5ttURveb8UyyZgDe+JU/ayRLuflASic
 rIqbCNa2CaWps0kwbouzrnICaiiiy+Dr5TbGVDK7zEFZx8u9wc8WAZt5M6GQzVqqmgUH
 WC639f6L7w9anY9XPo2KeGvM4lj4QoGJolSACmojX2od6kIqFn7wwV3f8sMY3MAQcrK+
 oTah6E8VrN8myysIocFXDBYo3eBHceE5FWtXgooHs7hhmF3H/gh0ZECNmSuVd8MgdS+W
 xgcccMmWTsYgNMbk/fxW3+OkAiWwKwJpGy5QMztsoePiVJ60gt0tYisdI1zgi5rV3Isc Xw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 36tsuqwt2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 03:40:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11N3QY0l014348;
        Tue, 23 Feb 2021 03:40:13 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by aserp3030.oracle.com with ESMTP id 36v9m41j6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 03:40:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bMUN84WS0+NxEprC04mmlKaBXuxwbQbjZ4pUU0U9Zy7blv5DHZoUVxIDIhQ3xu5JpWqpDxF4KI0OdRL4vnD81x16w3ijxD8sZIosfp9mQLqmkvHGLlYuUYaYQFWVVtZ6H5EEgF4fme7jXw0ugFNa6V/W7nM2lQG6/BNIBSN4T3/yL6RcF7ijiMctexixrcAEBjkCjYfKxUedo0FT/z8/GUu9+RJAsf3vFDZz369Zgj1cB/qvUP6cXM1h3tEhPRdNrsaO+R8l4W0VpXtOf59upXbo8TfDlwdjN2g9lqqjL6bICRyfiW8ZyUs/O6SxPvEMJ4GmCnuZXMOmrNTr98bDcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b9bOKXglL5hJIKc5N5bVvcFRzWdp24hiBHTjXd2aCsc=;
 b=AEjqNKAJ0uqhGZksh2Ua628g2nUJ0BAOqyixAtJlo9UQhQu3QklMRZTGwBqyszZYsEtwMoLQL3BdQWVrNN2wWNojOZ4j8f3oEJCWH8ezQcbA5wwKp6cF0TSTI831Tq1b7DnrMXrudXGXgSGawuBEOUJdOVR159LmtmW6NrF9rbHZ/nY1fOPUFD1YNSdQopk+PnGYkPe3XtZoE7sXiFOc/X2+glazMg1J7yX3bjBgCFjwYvg6MqhQOOPokiggq1mSzWiEIRlfIdytyrdpMRK7WpwIgwb5ErvqICoMjw0NomM3fHCkGGmkhRk+tW07vnkCt4ZZFajn0hotVrL9Tt3A/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b9bOKXglL5hJIKc5N5bVvcFRzWdp24hiBHTjXd2aCsc=;
 b=qbuS+6GKXICM/EhzN1CqgRG2XVEIrVTzBEcwOspxFSGNAtNMtF9nEkBDC2Hf2RhEOl4rzVATzaDtNbuT2iBjsOYViNf0geiO4rCnuZk+EbIpQ+CImZEuWzGYtVkxZAYpMoGHvOB1xTskbdoPGqcpeEfKedrW+2bmx5mqrBQRYjU=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4437.namprd10.prod.outlook.com (2603:10b6:510:3a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32; Tue, 23 Feb
 2021 03:40:11 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 03:40:11 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, chriscjsus@yahoo.com,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Alan Stern <stern@rowland.harvard.edu>, stable@vger.kernel.org
Subject: Re: [PATCH v2] scsi/sd: Fix Opal support
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1eeh7fo53.fsf@ca-mkp.ca.oracle.com>
References: <20210222021042.3534-1-bvanassche@acm.org>
Date:   Mon, 22 Feb 2021 22:40:09 -0500
In-Reply-To: <20210222021042.3534-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Sun, 21 Feb 2021 18:10:42 -0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR05CA0003.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::8) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR05CA0003.namprd05.prod.outlook.com (2603:10b6:a03:33b::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.9 via Frontend Transport; Tue, 23 Feb 2021 03:40:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67967993-1efb-4bfe-b1e6-08d8d7acb937
X-MS-TrafficTypeDiagnostic: PH0PR10MB4437:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44375F984C99D46226135B2C8E809@PH0PR10MB4437.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yr/ujISMZLWJ0wGUM6/JFo4js6mNomRFcOZtbbR62rMnfeWeOEYzAKtZy1dCbgR6xzHcXEcqFGVD85ieKy20e+0BymLK/x6XZkCWAdfNh3DK5abONpABWu8gDrtD5mWU4z8RB3KptpkLy4+AvX0l2goLeP9ZZ/T/T1U6tHxFwdHADTJIulx0eYIB/0dVx031ruzkzmtHXv7ag8thXhD9HU+/YdyqvodRMYupSobv/RJd1hq4AtkkgysNPmyfnbdaf2JaVDe1DnxZKqx7ni1AmKm2W9t1HayTZqQKtK8HIzy+EkquoLOEhMaoFCTYDXr7JOEqg0HHMrZXKRg0CYss42sSlCVaEyR2mTWKOrEX5J4oOmgrYh/mZmAmWQ/kTaqt+3NrrZaF1qzZ4dgxzIyk9+VEWboTQaPGIpF23zUjuJps97UI9X2YNFvg+AhVpuZmv+aTponOMQCzNgaVwTtrjAOTWShuDCpWNi7EnNW56ICjjcQCCx6H680HWOrHZ9uAuJqaruCWSDb4Mdb3Z9btoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(39860400002)(366004)(376002)(186003)(8936002)(6916009)(8676002)(4326008)(16526019)(54906003)(55016002)(26005)(66556008)(66946007)(66476007)(4744005)(5660300002)(86362001)(2906002)(83380400001)(7696005)(36916002)(956004)(52116002)(316002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tDU+qmHBx2u/3ckTuIq68rxap0KgK3IanxHoKPj5n6UvvEtIst6jPqWe0S7v?=
 =?us-ascii?Q?HiMw+g7lPlxbyC/cKkXLhW8z/ZDnfIuPWgqe03IGKAVh5iYKeY74Wzkp+0Fh?=
 =?us-ascii?Q?p+OohnC8HUBKtkyOdrCZ+4M7c6DdLgA3OQAFjqQSw7/PZdnG8CXMzgoyCmuW?=
 =?us-ascii?Q?qV9NXW8uRiNaIfUFRyC8v04BM7/n/6efkO9R2b/hrYUO0NiSgI1rrAOCS+Xz?=
 =?us-ascii?Q?MFZD5rEnOJXWrnfnJd6PwdIY7J2IGCIdwuicHsylzQBnHMwkZ2jsxKmNhDpE?=
 =?us-ascii?Q?4W5bC2lxJSyFcDsr+aKWtHh7xhxZwp1xxBIgiiZbpYY7eyrOS+irwulN3jRb?=
 =?us-ascii?Q?rG9yZ5kp695Hpf7738upo4jZkLXAo+7umyH7GIEPO1COSvzK4cTGsIHiZUEM?=
 =?us-ascii?Q?iPI2JCGFA8Xe5FwelTCvIT5sy62WazO3PilsHRSRBWkEEatvlQ6wDO5sw69e?=
 =?us-ascii?Q?c0CgzN7Mwa94mfvm11MTzO3mKZw7AYzAVX4yXngpQpDW8J10Sx80KNESMxda?=
 =?us-ascii?Q?W/03y45aLAvSRxAHMeVexrjIc8GxCGUAfL3rWhGRtP/v4HKdqqX5NCoyQQmj?=
 =?us-ascii?Q?73nbeXAT+99b2t0L/O48UjV56eLqpHsub0sRmtMsVx1LWwwJi7U6tA7I9uYz?=
 =?us-ascii?Q?J5qMBZIcOC3Yz6f8tpbJH5Kd5Ue1YMo68aDrWqmhK+LlY3YOfleNmIpqKbVn?=
 =?us-ascii?Q?MPyML+tWNsLXTGBaQXTUnVuenLpT0fEtXr3eEse15e150JOhf8UsW87FrJyW?=
 =?us-ascii?Q?AjsZqElZuOp1rcCFq8UtohUcdu7VGJJUi2XqlZtYyf1Gs95/LHAMENvwFsoo?=
 =?us-ascii?Q?N9eY12euMIm8WOdu7Ph8c1Qm3XC+r72W8wQhiIODWgY8xZ4GMn9iMdrruRuv?=
 =?us-ascii?Q?BBBtpOACQt9Fru584HvYrOTkVu8jT6l/KAa3MKtXTyR/0n1TkIh7WAFW/Ano?=
 =?us-ascii?Q?PgCv24TvJl6pgCFDjrik0mMxLf89RAvcuvnXWdvUYitQZ0+OeVvJJsZG72ti?=
 =?us-ascii?Q?a83YHFK1l0Igm1LdXpTfiWioXdXeVCuK8a5DnodQ9dKlcxqeWnHFq8DOcoDn?=
 =?us-ascii?Q?7yovryBKnXEHGASjI1bQoaN2sjjIWpkyE+BhIJoc0uLTx68IyYrvCWI+mSyQ?=
 =?us-ascii?Q?+eMaEEc9ZP6Hb26z3YLSbL67hzNxWfsWpjbVA4XI5sSItVZJN4Z9HO3dlHsB?=
 =?us-ascii?Q?+kTUYpascOWv9+HPosBYSCkbYH5rfXemXrnxcAtWhEgGfgmjHk/z5qkXa72c?=
 =?us-ascii?Q?ORtNFo3TUzOFXNDC9nsj4Q4xJGkTkmZrilIRzDTpAlq5HTZUhNblDgoSqdPZ?=
 =?us-ascii?Q?t3sK5S5PUSjAyjBaga2TKQNU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67967993-1efb-4bfe-b1e6-08d8d7acb937
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 03:40:11.6429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6TT+wtlaLK5vfAoSehTI5G5iNavviBOJ5yHpHgUnXxv6xDPUtk3aoy1FUkWJNFWJ6weLKjaShsua4JVGKqi2NNpUu/jTrNlXpO00N2LM0ck=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4437
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9903 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230027
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9903 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1011 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102230027
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Bart,

> The SCSI core has been modified recently such that it only processes
> PM requests if rpm_status != RPM_ACTIVE. Since some Opal requests are
> submitted while rpm_status != RPM_ACTIVE, set flag RQF_PM for Opal
> requests.

Applied to 5.12/scsi-staging. Thanks for fixing this up!

-- 
Martin K. Petersen	Oracle Linux Engineering
