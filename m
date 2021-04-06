Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCA6354BD4
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 06:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242481AbhDFExG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 00:53:06 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52740 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242515AbhDFExG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 00:53:06 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1364oatC076370;
        Tue, 6 Apr 2021 04:52:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=eETOmGz2rRCw9BE5xtPMNQ0/xCsuKK1xXVq0cnwiA0Q=;
 b=uZ4ILxkOFxiAKsOsl5nsLmc95IdXBSkIDsyrb+fCPVhfq0n5yTD010wfvIA1KRRW92xN
 1YUylK+YX7AF3URggT1WhTI9yFynrD2NSrrPQda5oaTJ0bbuQjTj599EMDW5yTU9mssF
 wrG0etEK1YzQVt2sDb3CoXhOMvOqx3rH8OGPMWT4obTBt2EftJ1OwpLPZNNdZxWnE43D
 FyXiZTB9ufwD0rrvtB5PlceUiuX9kwixz96CHxE97HhVy927gXr/3CqoVlFY1/VP28D/
 cxoieuP6m5vekXXZtBkWiw7KbyctrJvVFkjvm5mO/uncsTfm34ir8AwBv2L8pZUegYqM /g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 37qfuxbbtf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 04:52:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1364nrJx099499;
        Tue, 6 Apr 2021 04:52:44 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by userp3030.oracle.com with ESMTP id 37qa3hx8kx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 04:52:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IBXYktLUH7p5JHmdFblT9I8FkpD6s66lKw2Bg0c7aPlVUpDBfNBZohjOeTEm1YLcmEymARXWWXsZrCMjFyhqF6+KTKO8ziP5WVhcb+fYBeBB7Fry0wV/1nD8c6lwKOFVtr3MyDfblrdzVD49zk9csBodS5qN5t1jO5xcdr4WbaOVSwlABg6laeJAYpC0/Xv70lUS9U09bmad1JS/gpjKxTVU5w1myfJhbePPQZDNw5sXN3D2Bq5LR6JOs89UpU1tmI6fxtN62wzEv+4D2OtsRiM+WywrAj5GOjDR+W/OlKGTo8raZaAkGpViEtXlsXchRzuQfvgXaS/srhzrp0h7pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eETOmGz2rRCw9BE5xtPMNQ0/xCsuKK1xXVq0cnwiA0Q=;
 b=GQ1fLVIT7pRyn7F85DHAC5QQYbj1JBlp3ML7RA438+j6VHhryx4+0fDqrSxj+wBIOZArXMNZYcYppasviHuZxNnrzM1+/0rYy2nWPE5jakeIpWAH5qzeAYltuPbgEXkUrjGNFqT5/A1iLNebaLVjY8tDIOFAwZTn+J8K22trHFEsgi34mdzvLsiOHbHkJpgY5R1g0bq2Dp8SW8/DgpamzLgJA5aON/uvAO+lLsYKQ79IFYVOf8llE7qoMqkiGRdn6mZMuVbESQCNbSqY5+/CDUZl1s+xQmYJqgSnyIrjN4L2S32/MeAD3uaD12gavQNE6uL7/fw5B+nuk9aA7i1VZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eETOmGz2rRCw9BE5xtPMNQ0/xCsuKK1xXVq0cnwiA0Q=;
 b=zhd2TVNSprZwWp4687P22mYj7nPTeZ1n7nPVPMa8i1SPy9QSOfeDNmVVXkxxarysIswJZG6hNXVHe2NWCWXxY+eO1Mk83EjxiWmfhgYz6m5nuMrAn8BqoWwuMbjn1iugRohkckH7lQeNCwERDVFONUAQ12FuDBFSUWNBzNfM+50=
Authentication-Results: microchip.com.com; dkim=none (message not signed)
 header.d=none;microchip.com.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4407.namprd10.prod.outlook.com (2603:10b6:510:31::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Tue, 6 Apr
 2021 04:52:42 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 04:52:42 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Viswas G <Viswas.G@microchip.com.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Viswas.G@microchip.com, Vasanthalakshmi.Tharmarajan@microchip.com,
        Ash Izat <ash@ai0.uk>, Jinpu Wang <jinpu.wang@cloud.ionos.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/1] pm80xx: Fix chip initialization failure
Date:   Tue,  6 Apr 2021 00:52:35 -0400
Message-Id: <161768453466.32039.5842026607462396914.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210402054212.17834-1-Viswas.G@microchip.com.com>
References: <20210402054212.17834-1-Viswas.G@microchip.com.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR13CA0058.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR13CA0058.namprd13.prod.outlook.com (2603:10b6:a03:2c2::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.9 via Frontend Transport; Tue, 6 Apr 2021 04:52:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46259c3f-b96c-4c26-2c02-08d8f8b7cf8e
X-MS-TrafficTypeDiagnostic: PH0PR10MB4407:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB440761C9727A1B17233073058E769@PH0PR10MB4407.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 97WuF0qgMyDYOEqMdZ35rTDQRJfvjXlc2cQghRdsKOwgNOoJRGxg5OgWnFGpAjQtXCf+vMLDepOfCrbDeLM4B70WKWIhG71kyQ+QCjft7Cv/4pe55y3aeTZ68l4+/4yi/eB0aCYEAjmsnTTx6s5J6BSiEmRFckGMiovIO6BptBrekImr73oYp3CkcHFpUXlGvBKQbq2wPppeTS2b/B1wO82sk37JGxvY1ABzdFvkicWKqih3UdoiuFG5LJRzVRV/LfhLPWIpnK/f8byyAx1FB2gIfW+nbNdrLJRaEItpg1X+UlxogLyOnjITiOA2duo3JSQqOd726piBZOmkakhpkdb5+z2T6DmY0EBdJW4CCHdemDC/pO2fEYG6EE9AjLXtO4STGEHNsUMv8LEl1kYCCw7qq0XAK3EkOA1UJS0lBg3sUx3WhdC2vyR1oQyhhd+HUgBbOzsQ7dZzGpt628JRkm5ewsR5/0+SBSDxEqNz0BDqWO160qZXCFaaWkxkOn5yCcnnUrtzQqeR4RX0ETjd6l1Hyc8yTg03YjIqz3ftvkWPZ5qS/poD6sDqpDf83voHcGCfo21Ho42Jaz4Y8Fq4exYjSgcR6WV89vicb5H3olBBKHWtSIfz1iyGWjxgwj9UjNKhOXmyz0+gvGMCYFtC7XiijD9erFu9LI2Uv1x1VSobR7cXLVfAu0tzWadwKwL+6bUrb2LFPGwZmEETpIyDx9WY1WBuUfiiQ0xI1Yf5aXb1vdFpa5/oCm/dxewQiD2mMV3nIxIST8nWzPGLjrU/9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(396003)(136003)(52116002)(8936002)(6486002)(7696005)(66946007)(66476007)(186003)(478600001)(86362001)(966005)(8676002)(4326008)(66556008)(956004)(2616005)(6666004)(26005)(16526019)(4744005)(36756003)(316002)(2906002)(38100700001)(103116003)(54906003)(5660300002)(83380400001)(38350700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QlR0OGN0ZXFOYzRoWnJURDVoTlVqamJVS3Q1NXFMVlp0K3hKTmtKMmdiQ0hZ?=
 =?utf-8?B?R0FsbldOQVhGQUJvdnlRQ3d2VC9FSjBIaWNSNURkQjlTZ2ZpSUdYRWJ3a3Jw?=
 =?utf-8?B?NnZkckVPMWpkUnp4TlZVaEZMYW5OQit1blZMbm14WWRjcHd3cUhpZ3lIRm9W?=
 =?utf-8?B?ZGdKWTFiUnZFeVczNDRvQkJBeDNESHVZbDBNZUdYRDRaK0lqTloySUxCRi92?=
 =?utf-8?B?L0orWUcvRkI4bTBOTUh1NUVYR3FtY1FBdzF0Y2FuN3NlakNCYTBTT0xkNFNB?=
 =?utf-8?B?Y0RHcmFxVlJzVFljaEdCUVU2ZHk4Nml5MnZ6WHcrd3RlV1VqbDVkczZURTAr?=
 =?utf-8?B?d0tVYk1KcDZkYWt2VzlBdHR3ZDZuM0s0c0RSSERXTFpMc25NbzU2K2JGZU91?=
 =?utf-8?B?ZHVCdHY2TWhQK2NiS2g4K29ZMkdDK3Z5czEwRnhDWVZkejlHREYwOVZtK3Rn?=
 =?utf-8?B?ZTRZZkNBTEVRTEU4UmNldzJmVUUzaFUvUExFcFRiU1lKeEUwV1c1ZktBTmJr?=
 =?utf-8?B?d3EvL3plRlhhWjlkS2l6M3lPRGIwZDRZZVBwSGhjbWdjUDUvalEwSGxHR3hj?=
 =?utf-8?B?UFB0TnRiKzJwNWs1TG9mNzAxRnhId3ptZjJhb1NFQThpaExuM3hVMjRibGZ5?=
 =?utf-8?B?aHgyUXVjc001cER2Tm95dFF1UGk0ZmNpWm0yaEswU08vdlhQNkJtazdSR3JB?=
 =?utf-8?B?UWhnMS9IWFhMakV3b3craHI1N1VSRFB1YXk4ODdJckg0TUx3eXIxcSt6dDh6?=
 =?utf-8?B?MGIwZDdmQXlWNVl1RkhCVzRCQkdWdGpVaElkdEt5Uk1SekxtalVRNmQwZzRC?=
 =?utf-8?B?RWJCY2NpTks5YzBhelZqbDBRK3hXZGtGaVl1b3RZempRNGx5dExOcnNTTzUr?=
 =?utf-8?B?Z1ZLbjFlRkJrMDExOS9tZmlTL3I3VmNubFdxOWltS2VhYmphUFJmbmJhSWZt?=
 =?utf-8?B?OGR1TWZuaGJDekRrSmtGZzhHdU5vaklLOWdheEhueDJVWWFiMVVXaVVkalIy?=
 =?utf-8?B?eTE0dXpNNTJ6M3ZncStxSkJpeXQwQ1dVa0pRWVo1RFdhMmRLcjJzclVCL2da?=
 =?utf-8?B?MUJEUkxOMWZDakF3Z3JKTisxcFMyZ1lSWXorY1BuOXdWOFhJRlZONlVVNUhK?=
 =?utf-8?B?RmIrYllmZ2t4ay80QTFpcHVYb1I0TlN3Wk5iMEcrM241YVpxZUhQMzI5bEpJ?=
 =?utf-8?B?Y0hUbDBuRENKUXA5TGd4S2pmZDlLdWs5R3JIVVUxMVg3L2xOMlFMOExIZGFP?=
 =?utf-8?B?ZlppNnpRRnp5WDdjZm5YWEUyUE5rV0doOFdpZWRUMXhLZU1wWHBIWVJ1UXB1?=
 =?utf-8?B?OFlTL1UrQUdqcWU2cHBrbGZXN2o1SGV0dzY2aWlJV1VteVBZSXhKVG9uY3Rm?=
 =?utf-8?B?bi95c2xGYWcraEVtdVN1T2J6ZjdUSTNTVXdaNnBmM3dXWWpFVEx1czlXYkcr?=
 =?utf-8?B?NVJIdHZ6T0pTVzlkTEYycUhxUlBjQ2lhbTRnYlBmR1U4MXBLR3ljU29zQTNJ?=
 =?utf-8?B?Y2owZktmZk93aHBINURMZUtRV3pray80dW55MWxvNnJIZzh5Y2lOenhiVGpV?=
 =?utf-8?B?N21SSXFPbHZJcm9OVmRqWS93Z0ltWnB5UE5SeFF5TWNpZExvYWxKR01OZUFm?=
 =?utf-8?B?bWlHSE5xRDNlSFhZb1ZZeWd6alR3WTlZbDNKSzIwK3BzV0NpY0MzcmwwUXJD?=
 =?utf-8?B?bmNYeFNIN2ZIUFNlSUd6OGxiVmRSblN1T1I0UG1sVU9ub2dISjRFWHhvLzZX?=
 =?utf-8?Q?xw4HElA6tYff/5C6ZtMzCiyvoQEPj8BtwO9TEnA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46259c3f-b96c-4c26-2c02-08d8f8b7cf8e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 04:52:41.9990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2NL9rDyjCnYHM1VAo2ZG+fMo+o4/vyeKh+KyVzhhrOxEfYVtPsdzyL8UdMctbeMwGGt5MiUSF1ERJLmyDLTBnZt4mTm7j8/lg7AcU0Gd0kc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4407
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060030
X-Proofpoint-GUID: xWFmrN5ugiezb4o6BxJ67tJuTqd1FUxN
X-Proofpoint-ORIG-GUID: xWFmrN5ugiezb4o6BxJ67tJuTqd1FUxN
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 malwarescore=0
 suspectscore=0 impostorscore=0 mlxscore=0 priorityscore=1501
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060030
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2 Apr 2021 11:12:12 +0530, Viswas G wrote:

> Inbound and outbound queues are not properly configured and
> that leads to MPI configuration failure.
> 
> Fixes: 05c6c029a44d ("scsi: pm80xx: Increase number of supported queues")
> 
> Cc: stable@vger.kernel.org # 5.10+

Applied to 5.12/scsi-fixes, thanks!

[1/1] pm80xx: Fix chip initialization failure
      https://git.kernel.org/mkp/scsi/c/65df7d1986a1

-- 
Martin K. Petersen	Oracle Linux Engineering
