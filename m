Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA363C6840
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 03:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbhGMBxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 21:53:22 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:30552 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230000AbhGMBxV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 21:53:21 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16D1jkeT014421;
        Tue, 13 Jul 2021 01:50:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=tVAcnxTXNCZNnVkhECU+8yPkSy/ps36+Ji0lGDI9KVY=;
 b=plYRtn7G47+H9tSJkXlCLr2Qfg3nr4/ZCnd3ZEs9hlE039wb/zoHMWfma/31uOogumd/
 JfRHVKITwTgQG72MYrlu+9orzsJg8HbD3oLUgmfVUuhQq07PLhEUm8noahHs1EYjcw+e
 XvPInW8fZiVhxwHAYA5wHLkDQJylHgR9qrKJ3JK97GkT2j0zsqUz3cygd8qpVVpJJmbC
 BG3rnZ6bWfeBNPuZTFpLp072hD5TIPrDxTVM/8ZkSu/+8salvGZwo2f23evPxEl2Eur1
 VQXeZJFoArGzZm6p+4mdtc3uI+Rtjz8FBtCtI/W+nWBVle6JX7bJXWt4Hk7pxog1brOc KQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39rpd8seak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 01:50:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16D1kSgo122936;
        Tue, 13 Jul 2021 01:50:27 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by userp3030.oracle.com with ESMTP id 39q0p2bp3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 01:50:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T3CPfRQHpfnVyHRceZ6KlDZFaJQE25bm810Bcj6bOvzvs6tyNHwwC96ZSAe9+aiJ5CGZVV0dY/HTiQJmDspRd19Olo9yBA9qs8hofAZ6eOsZMXnMQ3y/B7kCH+aTlepA1prQCkjW/7MjwiCLJRiYeXHqlM7F8v1ffCYqSbDizv3U9jiYcOli131U0h+jupci2I2ONO5pVWYz5fkCF2OQVljejrpU7GlK6mSxrN+3Q5Nq/NGr3022j1Qmq0uwqf7CZESrhV9EUjtBGo38p9UsJoFj1GCl7FzMBrn2fJXkP7Ea8AbfrZ92hy9A9zKk+5XrqwBchGzThjurIqjamZXg+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tVAcnxTXNCZNnVkhECU+8yPkSy/ps36+Ji0lGDI9KVY=;
 b=kIYtecNad/QwGspauB46pQ/GsZMAHGHpvHF+twnFsGfGyVcLRllnn2vxdNnpq7ne06ECKdMtlonLmns+q5+lLzlRBWe7skfSQVM4I8/znDspICqjLZIpQA1LOGBaE/W7E+5CYUPW1kIrBBYuNWdeZ+gE+yrPeMxdbwcrVfMbQFoH+YIvN+uZMRq1btKQPWyOS3KlXKen6NHE0tEz6QemupsICSRSBOSdV0kalecJTnrI8sSERLOm0hzH6ayYkm61fpDn6IkUlQgaGni/2K2lxTWq+YNKwi2QFkq9I7ohzQlznvJmxMMZyvY/XafqCkybsHm9Ypn6t3BGiuGAsGdydw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tVAcnxTXNCZNnVkhECU+8yPkSy/ps36+Ji0lGDI9KVY=;
 b=bqVLPbmSNXc72QtAP9/Qmvw5TMrnwT62tvrS11Eb2HXvdEv/3KJxNktaRu8jxNZgcwzNLTZZcNmSvHH6WU8gvfPvRaPAlsM7l8sCg0fumxKCqrJOHD1+Zei9U8HL3fKP0upH/8AkGC09tW0rumDx0AK+2y8wH4lLF8cXBk83pQg=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1616.namprd10.prod.outlook.com (2603:10b6:301:9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Tue, 13 Jul
 2021 01:50:25 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2%5]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 01:50:24 +0000
To:     Tyrel Datwyler <tyreld@linux.ibm.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        ming.lei@redhat.com, james.bottomley@hansenpartnership.com,
        brking@linux.ibm.com, stable@vger.kernel.org
Subject: Re: [PATCH] scsi: core: fix bad pointer dereference when ehandler
 kthread is invalid
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sg0j56kc.fsf@ca-mkp.ca.oracle.com>
References: <20210701195659.3185475-1-tyreld@linux.ibm.com>
Date:   Mon, 12 Jul 2021 21:50:22 -0400
In-Reply-To: <20210701195659.3185475-1-tyreld@linux.ibm.com> (Tyrel Datwyler's
        message of "Thu, 1 Jul 2021 13:56:59 -0600")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0104.namprd05.prod.outlook.com
 (2603:10b6:a03:334::19) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR05CA0104.namprd05.prod.outlook.com (2603:10b6:a03:334::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.11 via Frontend Transport; Tue, 13 Jul 2021 01:50:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3977633b-436e-4555-2602-08d945a094fc
X-MS-TrafficTypeDiagnostic: MWHPR10MB1616:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB16168E683A30DC0E5D6F1D348E149@MWHPR10MB1616.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pc7fvoI5r8m5uH3tqthgSV5D3OJ5BUe7qgHvAShmJs+elCohW+AvMhJ00lSU9sQM7IO6gnOPWVFQtZpojAN/Fps02FUuzM9Vdyap5mBwow/RrEHUcgrl9gw/uyu+TJnddvQA9VgcUc/UsZmsIWiu53UlSblwXxKCAwQljSuJcE/haySrHyo5Yi/LkgCbi3cNuOZxEC4k5ANZzSQhEMCtxlZno7HAveG+nwPZcZfZL9AhdvLoOYlo7ADEf9tf5V4e5EE3LaLvvU0ceOE9goAF6Jfe23KNbnKCwtGMXmaazTUUmAq1p5krhEtU1Yy9PhWqwy/ix+VBD6e3YzMlOlJvNPdvSypJgkWE9jLYS/SXkcnejuwSCxI8aI60kVbJU2c0E+jJcrnbX+zVoIGWppPKZU+rlXnegmdCY13XcdYTL06jhZ+T/PWPDFPOfqP/68EqlSVgPyDV70nw4CQJ4dqeScjQ7v/KoqS5kHRu3KNXsfc4Kn43k91lmebwIRe1faajYLEGvHYE7cLKT6UO0qpLENP/vJBlYcM5Okbxj3hUPn1gG2Wh/A5InThmn56bTCqnJx1IdAf3Mg4niIzI7897pXxIhJll6PEyu8i7X8DZ8L9Vfpc86NCwWBrmeJjCO3ahkqhadJalSl5NqiQh33zz8igysOogR6kwiPOhJCQ8E5pxw9NcBiS+Bu1oW0qpqN4nUmPNivfc6k42YsGUQGObuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(376002)(366004)(39860400002)(26005)(186003)(4326008)(52116002)(5660300002)(36916002)(478600001)(6916009)(86362001)(7696005)(55016002)(316002)(8936002)(2906002)(8676002)(66946007)(38100700002)(38350700002)(66476007)(66556008)(956004)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GQ7wU2sb+9v7dKEBMs/ulWhEOdQaLz0QDWTeCv3IzH6ymDijNtTKvwSgrCcb?=
 =?us-ascii?Q?mDAbHQcmBJ03+6i4d7UNZS4+JYsxwA2vqDB83SR7f4BnaYgj/f6TdAlbmu/K?=
 =?us-ascii?Q?zw1q/TwzpswaWBICqeV0EjYCx4qjnidkq9a+KUaVS0o3fmZ0MQdQZLJLIYEB?=
 =?us-ascii?Q?3rFiufxKldKDJ6GQoOLsJ2JUbCXbo4ZzHPhhpNKW4ICyQnTmJKdLDZwKd0zh?=
 =?us-ascii?Q?F5EZT0nn0lso/R3VQLQCdl7AZ2+hfJbptTnZe3/5ErVq/R6ZxbAqM1UfN7J7?=
 =?us-ascii?Q?3hTAWsvfBU55+v7U9PGIYSDxzFzvOKonj3R1dqBsB+t9MZJqUI194AqJ2myW?=
 =?us-ascii?Q?JGmcoLQSvyq5/Ux1rvNx1TJnNiZa58G3atq019kauMvSF5n9mgiRw4drIfq2?=
 =?us-ascii?Q?/kz6Iysf7wNQtxBgXpY9AlBSDACL6lhAtq5RnzUvMHPhxbAn3UyLJJlqk8Go?=
 =?us-ascii?Q?hrNFxTMQMJjBtOKcBVCew9dx3KhcKDdGDg/0bW7GCaB8hDr1sJWGO3z/ybbW?=
 =?us-ascii?Q?2nenZMIJML7nJ1NEh2UHdiuafZv8WFkitc9XRhZCliH3oJXGiKzzDLdrwrZh?=
 =?us-ascii?Q?ggmCYa8Iz1/JAxtpImaNJmrlnW7LI7PCfY1Ohy8HK47bdXtzpOth0GkyswjA?=
 =?us-ascii?Q?z9+bDF0tOTXsvcHe78EIJo/oqOB7HslmI3Q6F/MKZgSNEpCp1cB46htd1quv?=
 =?us-ascii?Q?88NwhoecdBF8QRvdiDQw6fg+jjA7RIq318RHd8mPn3Ii/IBnamvf8ehP2yq+?=
 =?us-ascii?Q?Ja7DzpAixoLgT7vkiBopJA8nB8u5QjZ/IFDbKYbhBeXGarJj/Vlll6+8E/Ff?=
 =?us-ascii?Q?in4h0c97BYiilG00w1szck2Tv4CIjcNKLBBUA74zG5Fa9+2bxLpigWLxtqEW?=
 =?us-ascii?Q?oeJbH1/Gtq3c1idcGxJ32+CZXGa7SUNzR9YDKzCzRufP8z959Wt01RmaHLUf?=
 =?us-ascii?Q?N33BmNaXH+JyTObVECGatzLh4zvCbfzkLXazarjTrb95IVjRsN9okOBJmc7+?=
 =?us-ascii?Q?zf7A+d6vlxSWfpY8BfOu0xL0HIGd4PkTYC3SOW4c9HR2Q3kYDcnlRTGU6iEI?=
 =?us-ascii?Q?MbEjyYWHj4k7XK+csKpav/EzfojCiM5ShRjvaSHJNYQ9DENTB/q8WvJzXiWh?=
 =?us-ascii?Q?B4xpcvnisyvFAVOteongxjsv+Jvn8Fmx36FVJc7Lm42qunqcU3UKG6s4laDm?=
 =?us-ascii?Q?r3XfFkNZtcB5BJ91gRXF4dt82Ouhc/p3CPahWAj3juoXRaS2YhLgbk3+fRBp?=
 =?us-ascii?Q?rRoQHVHu3cHAIiuGsNthObMiT4njeOn0JMFTjH+GH+sJy4SJ85HqN001eLAe?=
 =?us-ascii?Q?US9dXJQ561zW7yFRdgT5Cnfy?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3977633b-436e-4555-2602-08d945a094fc
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 01:50:24.7666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SHFlpPHjeL3QMi2EcfS0/+hKTZTIIFx7JcmfSUoptjexXilHQvQn2Tb15czP+Oh+Dfp1w9P5sDKxnoSdZURNmNXbEVFSzJW6e6M4zEaOLCA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1616
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10043 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107130009
X-Proofpoint-GUID: y3D7vaofsnGlO5b0ONHRe7aVWQJoQptX
X-Proofpoint-ORIG-GUID: y3D7vaofsnGlO5b0ONHRe7aVWQJoQptX
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Tyrel,

> Commit 66a834d ("scsi: core: Fix error handling of scsi_host_alloc()")

$ git config core.abbrev 12

Applied to 5.14/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
