Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5FB361761
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 04:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237820AbhDPCG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 22:06:57 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49464 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236754AbhDPCG4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 22:06:56 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G23vro098691;
        Fri, 16 Apr 2021 02:06:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=+K5wNG3CkYZ3MqPRfsN15ktvV1jh2qB5PPIWYV8C3JQ=;
 b=XMxpwcY/yZbFDgaXok9LufgUwwceVUSBG4HC1IhiLF+LSO6iibJOQgErw8Zo3rUdRLtW
 dl2SHllhyvrarBssjTr9bJGVxX/U81t2hwPqARt8sc7X/a4By8SE7pieu/UuvkLLAPbi
 3H+y3Mp9fB29rTc5HRJIUuJeEmnTjfe5VtbfpVuy5YOKxOyfc74jEsQRzDNWD7+6nqeO
 QdSuhBlkDMeKe0kk6/uJag/OoD0/O1shXcZHq1Dx4HXQAwdK5j9TCHtzjZGF6OIxwzlS
 bvcKiNgAGSuftIe+TF64xtpKSyovxRcpGwrSzGEFXus8CpT9w+CB60oSYDARBEO/eR3E lA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37u3erqpfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:06:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G25nqs037121;
        Fri, 16 Apr 2021 02:06:27 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by aserp3020.oracle.com with ESMTP id 37unx3sqey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:06:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WE214qnTsfy1w/FbEnNo365jOxLxZCeJRpdvdPnXIWkzzoNKjWlM2blDj93rCaAh922LbLa6KdmaUva05JCiYiDExF5ZBtvwFkwKBTG1zMxZTy++o12b0GFO9U+F4clwVhMCkGgpJHbQF0s67relEfhNoyMA5xXbYaGgzFK39Em/KFFIXRasTpP/wPkq3EL3QGUda2Uocr0avH0rZzSi9Ycmmcjxq0ZmWuubai4QCfo5zvYoDRR5AulYsNqgRCJL/mUKC1+ZXemw3jmM0yYXJPmH9XR6gXxngnOfySlSGV0ELWOatXUuwhpTSu/YiOqmin9mes3t17IbK101utfCWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+K5wNG3CkYZ3MqPRfsN15ktvV1jh2qB5PPIWYV8C3JQ=;
 b=Z4hLqBjYtiCm6RxWwT8RIkAVHguDmlEw3BWzZAkNaHHT0hLIwPz3hUCIvQSX9gc2n3JnJ+K8/KKXKikbzgcxdyBvjoM4rbY02Z5TBQh1GUu4PE+KghvLdMzjxblZWmbmZFC5eWG3WgM7lRcV4HmMohUDct96QpNWnspaBEQKZ7/9IeYh7jL2Lrp2gwJ/hneUP+ckI5bbWV7WUJvffg7Y3NaniUkOmVqnQBDUwQ2DvXABqoPNYEOF3CbMlIV7oCbf1dRs/VQB5fuJ3jK3FVTXZHxHHJf+EttZwzHiN4qbqZcSlqO9g2Rm41xhmchCyOC5wiIe7iuSxYDOmGJ1ENeBzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+K5wNG3CkYZ3MqPRfsN15ktvV1jh2qB5PPIWYV8C3JQ=;
 b=HpUgdEWSXNw91J+5ooqiupO1pAxQovpjgyG0lvDya3kst2sJQYMKvdYicWY+lDLPf+eEUVXdKKr5voC6jENyVkPCjPy9xXQrcDuFh948Y5f9WUAeV7JCO5LF4MRhp69p1cf9OgXdQE9kVHUNXrM+21SdsNUWIvq4esIujsyV0sE=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4519.namprd10.prod.outlook.com (2603:10b6:510:37::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Fri, 16 Apr
 2021 02:06:25 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4042.018; Fri, 16 Apr 2021
 02:06:25 +0000
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>, <stable@vger.kernel.org>,
        Aleksandr Volkov <a.y.volkov@yadro.com>,
        Aleksandr Miloserdov <a.miloserdov@yadro.com>
Subject: Re: [PATCH] scsi: qla2xxx: Reserve extra IRQ vectors
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17dl30yr0.fsf@ca-mkp.ca.oracle.com>
References: <20210412165740.39318-1-r.bolshakov@yadro.com>
Date:   Thu, 15 Apr 2021 22:06:22 -0400
In-Reply-To: <20210412165740.39318-1-r.bolshakov@yadro.com> (Roman Bolshakov's
        message of "Mon, 12 Apr 2021 19:57:40 +0300")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN4PR0501CA0024.namprd05.prod.outlook.com
 (2603:10b6:803:40::37) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0501CA0024.namprd05.prod.outlook.com (2603:10b6:803:40::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.6 via Frontend Transport; Fri, 16 Apr 2021 02:06:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95263124-adef-4a02-15a8-08d9007c3d24
X-MS-TrafficTypeDiagnostic: PH0PR10MB4519:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB451966556B97A14863274E8D8E4C9@PH0PR10MB4519.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: il8hoi34BjKd94Y/UqwIr671pZ4VKSQGaJ2ULYchY6E7EHs2w7mc0mdrem/GdQ5dy063pZnn33E83icY29rxM5vNDkJp77kxWMXvxRhiAjjZbpUlRmUjVDFrQYn8pc4HRzVYg0Eplf2TEeDM9YAAzl6ZlLDZHJL41sPswcjKCeknOKHH90rrIqAkHGhQNdxBYaJHV+017c8DnLyV/WO91W9M9LGmFzhwn93hj8MDI++8psqg7FaOE+TCNcoaSKUczLwjThQ5gsPSC+wmSlIRMTe+GA53fVFVyV4s+m1hbTfqYin8brRdT6k55G+YPjl4kABkuG/22slfo61TN4d0P1mf7nmbmDKKseAqTajKpnIYuAMB0myOA8wrG5F3LWYXG0am2q4prHJSBQl+uROC6bkhrkcC2eRUUpLZfh+tNQNpn49XCfz0+WfzVA+d9fJo3vVZURrJNXKM0E4Seel5r3Qwr5W9A/vPPoSxIGKLDwAMM/jRVVDh2sr0jIWuJzDDGbfwPB9z38kChlY0ic5QwhUMhNTUU9/VKP0Qp//KdgLWSWlzT8+zfspJ+j6a+4eurh0PTZhPd4xix3EbNMLWmqPMp2suEu7zE+4LmJExeCgFkEYreOAsSZBgUQudEtOfWv5nao0c7TwTbPEghTzrkSp/a4eH3n/5G9W8IP1O1OE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(39860400002)(366004)(396003)(2906002)(86362001)(66476007)(66946007)(6916009)(8936002)(956004)(36916002)(8676002)(38100700002)(55016002)(4326008)(7696005)(186003)(52116002)(558084003)(38350700002)(7416002)(83380400001)(26005)(54906003)(478600001)(16526019)(5660300002)(316002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?OB9O5Hxt1XYiPs25HoRPDQMn4TuzUYp++RK4sg+VXbL2a82FnD7STxuFM7St?=
 =?us-ascii?Q?5zooUowpVEnR2TC1s61dzhkAdSfuTfd9Y8iVjsC3x6l6CNvZOd2U9jvCjgD8?=
 =?us-ascii?Q?LcQPOVSUVyo+etvEQ5SBnL2JBWFBY9K1YMwnVrTxbTb0hKv1g4/5lrCksEv6?=
 =?us-ascii?Q?0pfJkZ9/JJF9v1Eo5rWCMTXxK4dBpK0kwWVhk7y++lW6qInVf/ZiO0D85iYA?=
 =?us-ascii?Q?sL3F758CYwV5bQUysjGsG7T5Ud6pggckb1u2eDcH9FDMaiM5+f9gZZnotGu9?=
 =?us-ascii?Q?OTy1YKrhYflvzPgucvO53qM+cKoogwLRRLw0RfwDIi4+dA5HzAaZvtCwuUoS?=
 =?us-ascii?Q?HOg7nPirQQBh/jAKaEr5kmXS4lBuvvGQ05jUjHvz4o4SnyI84z2xtMM2xoBY?=
 =?us-ascii?Q?UkPc6X4CDt+jc2ZA1kKVZUf+fpnhDQdxDBpl95caBCFN4cgaeBGhaUXnXWAP?=
 =?us-ascii?Q?3lABHyQqQ8AbSdc3QPMnn9ashQKJCHshCtes1ccARtYzb3zekAaUk/AKsLC5?=
 =?us-ascii?Q?efcKMEX4FJBSslPLPa15dsbgB4PQ4xeuWpwyQCS3AJ+SvDB7INW6QVZ5cLDL?=
 =?us-ascii?Q?S48+TMQAzRwgF7J+VZK/9SZLvZ2gHyTA7NM7zPPbSdYzeZcZohIH/WsH0xcq?=
 =?us-ascii?Q?NvblK3Tz3wRq5B61dGVWUpG0x5Kc190NluummjpCsGCmrKocTGxut7wugbBa?=
 =?us-ascii?Q?nLPOwXa4HsZlXDd+hpVjn1sTeUOqxRn2nkuXb9vg1xf8T6pMnihU6VVqe2mQ?=
 =?us-ascii?Q?fGMWYeDXH6/JzUQFm5Gyv9e7uXfWshCnVzSEQ+KFfaAHr74tnvH0afPUp3sr?=
 =?us-ascii?Q?YJcZnJRt1kB1r4cOQHeItr4rjY+9Hf5k1lln12evA4rGRSsUai7jOxavIhWi?=
 =?us-ascii?Q?PWzfAoiqDvzSjE6zHs0xsp9OI7NqhQqnuUevi5hAM0yrzzZtwC4F4A5NCBQ1?=
 =?us-ascii?Q?SON2fsCnwrYitVQzvmI9Bopk3t/00aKTpYFFfdBlBR47GQESxxspnydIYocm?=
 =?us-ascii?Q?d2dxqjeqwwrNagNdiQipEbXbWGuu294rmQD7to4y9GJjSVa6hP3W4A1g4cKH?=
 =?us-ascii?Q?UK4cOtI6W3eQgoSW187F7G2zCM6svMr/0b+lL9NbDKAVpBuQ7ZnvHIKo/sOw?=
 =?us-ascii?Q?mJXBM0cbih731fL7DI0bp+M6Pg8Tiv5Y62OSlSKtLP9lBUWg+f/EdW3sxd7G?=
 =?us-ascii?Q?UJqysbzAwb3J0Aqr5zOE9B9p6csECY2gkwTFZpfWq6TnRv1zqNO/EM20kut5?=
 =?us-ascii?Q?x4sEz4brqjTuX1U04kNdbzycHB/qcnp0+bYUHl+3fI8taVxCy/XhseE8l5ud?=
 =?us-ascii?Q?fGeMy8NOLh0St9wDV8N4JSoT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95263124-adef-4a02-15a8-08d9007c3d24
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:06:25.2162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YR1/vP5Zef0kN17qvCyPeddEbJTjtB8CGBplde7jX3M9ynj8cagOqDoeF3JYxdoQt8UlQ+ihUHuzom7GfCrun4nryfaJlUT22fDwQ/ZxAgU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4519
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160015
X-Proofpoint-ORIG-GUID: hOYE4uWwvKNkvpsl7tz_T3GCqAKPjdeh
X-Proofpoint-GUID: hOYE4uWwvKNkvpsl7tz_T3GCqAKPjdeh
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1011
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160015
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Roman,

> Commit a6dcfe08487e ("scsi: qla2xxx: Limit interrupt vectors to number
> of CPUs") lowers the number of allocated MSI-X vectors to the number
> of CPUs.

Applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
