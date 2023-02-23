Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99EA26A0F07
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 19:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjBWSFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 13:05:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjBWSFR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 13:05:17 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C61166EE;
        Thu, 23 Feb 2023 10:05:15 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31NH02fj030897;
        Thu, 23 Feb 2023 18:04:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=QgZMAc+0jLryqtIOnd6vBGcq2dI4xL3V/rde8uXga/I=;
 b=MEBd/9Pz03Y0Pu8RJzd3dg+S4EFs6tLa5Q8UgWSS0nPltX7c7ZPLIS5un3D33vnRK/0I
 WfrwHlNZGbvCsFcYLUYC5pmmZBwhI9DtqoKuZm1bfmG4lUbPPUh8pQsgboM+6+kRxc3K
 9A8zyoGCT0KdLZGsbPNXlCZ+ZwvO3uKDG58foC8Kamjqejz8DXYF7siztD7mX1gRuAyv
 UrzUg3aD1Hu5CLYPUpcHEb8jThmal7CXP2XCQrhyWl2HzS9XpLVI0xRLYpdLnUkwNX4o
 SlcONl4ESzLtLJmMOu5sFIHEgcbV7EwcM2leK+ltYl/xsC52EcAAJUPALers5mdnmd6s Yg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntq7uk56b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Feb 2023 18:04:24 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31NGdEAs031608;
        Thu, 23 Feb 2023 18:04:22 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn48gaa2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Feb 2023 18:04:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VssU1VhHFlU9jsocskmW3YNUvVj7BwUaf2Y7isxxcdv50G9Y7uFYzWLZ+zneVqenIIl+1u+kpm15nCUhAG5JQ6Wr+F00T9UuhSaZba0QODACIxS7LxMW3oiR/sGKwnuBSfgj9YvxU6wZ6K6CkVQ9jhNElNsdPlN/WMxGwf7mN3+dKlt3fx+NuHC6r+USTHYyB3hy9VWOdr2iZta9/Ww1DghCkQOknon5V54E77L7Ydb05RsCnogRDo9q1QyA1JS01NMCubO+kzFmmjcoYc2VtRNGNF4TAUvkTonGtcRqXcwvOsBVB789GnR/HrfdlhYcRA8vLfhd0HShLu+e3mMsCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QgZMAc+0jLryqtIOnd6vBGcq2dI4xL3V/rde8uXga/I=;
 b=ZhHCzzDTCDje7YnnmE4nmWKloSa5WHG0obKwS+lxig8KkJcavXO8lDuc9sk4vfvpUBu9iIedDHS4KR9wX21aKxdj1FbvKE3ht0YRc6Pf7EJDQNakRAgFvquXQ46rfj4ZRNIt0mOiG1+ClGyqNvdr2aQ2ySpZIX4NoljvtDe+EWMcde+L5p+keqyveQ8g7MGnlTDe8cVkrj1cDxZD7gfBZXZsWcd+hotHVKu5kXRRvnp6C0/zmYtcT1xYb+ty3M4xat4Nsvc6Qo0lKPKRZ5e5QEAyEb1mAstsOEupcvV8+C7ZEHJaLwxEZZf9d9wl+Slnxl0q2X/7Lol/uUvSlROeRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QgZMAc+0jLryqtIOnd6vBGcq2dI4xL3V/rde8uXga/I=;
 b=bmzQy8Q9UTsBqHCVZYmIl5K2CNUxmneLH6xpJb4DWjUg1tYY46m36oSixt6RGw9MBxJWwDU5Rwwtev+9MyIabsT3T+cKjAfKb868fyA4mdVXn7uWSOrpcWLqu45cT20mSHHaROCmS9MI25b5THSJrHsGaiH8RqF8GN/thXsaycw=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by BY5PR10MB4338.namprd10.prod.outlook.com (2603:10b6:a03:207::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.7; Thu, 23 Feb
 2023 18:04:20 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f%3]) with mapi id 15.20.6156.007; Thu, 23 Feb 2023
 18:04:20 +0000
Date:   Thu, 23 Feb 2023 12:04:12 -0600
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Rich Felker <dalias@libc.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: Re: [PATCH 5.15 v2 0/5] Fix Build ID on arm64 if CONFIG_MODVERSIONS=y
Message-ID: <20230223180412.wwz73bz4uezm3dzk@oracle.com>
References: <20230210-tsaeger-upstream-linux-stable-5-15-v2-0-6c68622745e9@oracle.com>
 <Y/c4G34O0B8zqobt@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y/c4G34O0B8zqobt@kroah.com>
X-ClientProxiedBy: BY5PR13CA0020.namprd13.prod.outlook.com
 (2603:10b6:a03:180::33) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|BY5PR10MB4338:EE_
X-MS-Office365-Filtering-Correlation-Id: 85e2961e-72c1-4d54-259c-08db15c862a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a4aZxDhBNrHAmZ4BAMRz9O4876c0P6wbXcbQNdjhvFUlByGfZ38FeQXEGrpIMU8kKsOC/kXYjmRMQKfoGZNB9VmmhHjMizT/miLHqnh9KHnSAsYWTnprCCPzXaCuc3FxUdh1yDcnIUsb/A3GP6Cgm6NWVkuxHmmi3Hg9pRWfwlVOg/YTI2Ibs19wGuX+7M7BSfiNe2bI/K/uCqwST+U+LTLLriaRL4RWqmNiODZ0xSXcVjcrdGh/IUJwgj5hlra6Dvs2qE4h5XkJoCduqOEvfRaLQcF8h/fgSpJ7a/bJ/QtXx2xEXpbw9bV4Q1dS5GcP3IY/sXpY8U9PJlKMcklJCczfsLaHcWUEvJoe1f1hJfeT5tB5ZIqVtO8dXcX/jEWw9B7QvGP1gnIjccWMdhGQXjC2NgUnUw3dyJ4KsyJThB6Bgp4JNM9r4uUShbs6f8XHFHPvGQzeM5Ylt9qbtMHhyikJymU8h/wK2hxT0bzvsLqoPtBFf4MD08PbRUOx8j/wJPzmzeinzI57/LspUEIhPq4/DfpNscw6ouTfIjE4gtWg0ZV98PJ/OvOtToNzddg9DsDzE1FmwQh/w5TFZZxakyxjAHONS9aDtlCQfNQ1VbU22m1APxrYSCnL0ZW60hylLDymnL+pXkTpwL5oAteZbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(366004)(346002)(396003)(376002)(451199018)(7416002)(44832011)(2906002)(4744005)(8936002)(5660300002)(41300700001)(6916009)(8676002)(66476007)(4326008)(66946007)(316002)(478600001)(6486002)(26005)(186003)(6666004)(1076003)(6506007)(2616005)(38100700002)(86362001)(66556008)(54906003)(36756003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OU9FS2hkeHZ2cWN2bi9qYXo3OVRPQjRJeC9jakNJZlJ0emJDRERpU3ROV2l3?=
 =?utf-8?B?bGo2MnJCOUlIUzJoODFOTWgxWERoMHNvT3czd0pRZ0ZFRXVCUWhjV01mQXBD?=
 =?utf-8?B?ODArMjZORkRYUWJMUmp4MmJ5Z29mV05mVVIxNmhDM3RsbUM4dkNuM1ovb01E?=
 =?utf-8?B?b0g4UnU3WGhiTXdxMGdoWEZVZDRMUFBaSHB4bUVxb2JRc1JlVlp1MWJaSGFV?=
 =?utf-8?B?aFExalBaOHBvZCtTc05jbkFiUXhnS21FckQybnFzZFlEOExRMUNueEFEa2Zt?=
 =?utf-8?B?VjFFL092UXptSG54MFdXbm9HY2kyYjUrKzkzdUd2TFhnSlR0clJuS2dHdzRI?=
 =?utf-8?B?bWU2bmJVMFp1VXA1S0hud3NsOStmbkZGK1luWlRQSU80NDlMeEVFaVVrSHY2?=
 =?utf-8?B?RzBROGtxcmlXbWcrd1lOUHcvL0RvTzZlKzdQUGIvMklmZWZKOE9xMnVjK1Jx?=
 =?utf-8?B?enNINzZjYlowQjk2SUM5VjJNbjVtUEpJdkdUazArVW90VEJJYnB2QlBCOGVI?=
 =?utf-8?B?eExOZ1loV0w1YVpDVzJlUWkwbXU1VEN2YXFySHpka1BCQjAxR0YzZEVHZzM5?=
 =?utf-8?B?THVKWXRZSE1JRGtpM09udXRrWlNpa3JUUnE4WWFqZkNuLzUvWVI0ZEJwbXk2?=
 =?utf-8?B?dlZESndNM0duTGdEMlVQVUk5UXY4U1pqcXRIYzh4R2hxbE9ONDdrSUpNTUFO?=
 =?utf-8?B?b3ZicjN0M1ZZNFp0YVp3VXJ5RmttSFFGUzNNcmhuVVpqZVFYaWZFQmZjT1Bu?=
 =?utf-8?B?SityUHl1NDUralhWczNnSWlhRVNuTUFNVTJ2QXQ0OUkwMnJ4aitiQWJXa2h5?=
 =?utf-8?B?VEVHQWtTQTBkNmd2RGM5dzNhL1VrZlRoMzFmdXF5a3ZjYXNFS2dCYlBLVXJR?=
 =?utf-8?B?bjhNSnBqaDBvV0YxMlg2aFh2S1d0OG9INDZUUUE3ZGlrSVV6amhFaHpSMkp1?=
 =?utf-8?B?L2dvYTQ0dFVFaHU0cmQ5eUFJVVZ3THQwYlBHRFBvRk5sZnBsVFhLRTNZQ2xZ?=
 =?utf-8?B?SW1IaGw0SjNEbTRrOGY1d3Z0Q1paVEVPODBkN2NwaGppaWU0aDZrV1BNQzE1?=
 =?utf-8?B?YzVkaFZBRVhkS3JnTFdYV0tLZXNPeHBCNFZYNDRqb09nMURGdkVPZVJwMVdM?=
 =?utf-8?B?S1diSWg5UkcxREZyM1lrVW84ampPenZiakpZZjlJSGlIQUxkOXRQelFNaDhw?=
 =?utf-8?B?eTZDY2N0YmVmSEZCdkxHT3dFb3VEMUltS1dlaEdENzFPN3IrSWNoN2F5SG5o?=
 =?utf-8?B?a3NiTk9EQVJNaS9TZ0pSSnplKzJxK2RubkJpRFVIQUlzTEJUS0JGU2ZHRjRu?=
 =?utf-8?B?c0VlUzBpTmhjOEZVRE1scnVsWVc0elpnV3JsK1llUDk0UWRtRWUzTWYvUnp2?=
 =?utf-8?B?RUY5Y3BmM3hiR0xQZWlCWHVrOE1Pc2FzTUJaT0dzcUpJQmUwL1dwcHhod3VR?=
 =?utf-8?B?TDlneStIUlYxVk1tTC9ueEtSVG1jc1JLUGFFcU92Z3RrSy9ZYi9RQ0pLcktC?=
 =?utf-8?B?Q3dqaFpOWVNvZzVNN0NZckhCckVBVStOM3ZBWkdBZjljekVWQnZLU0N2aEpF?=
 =?utf-8?B?cnZ4SjdjVUUxdTNyUkRDaUh5OERJZ2tLRG1tNU9JOFdoUXRuRzRna1V3VCtw?=
 =?utf-8?B?bzh5cEZSUzM5cnpBMnZjUEpCa0lidTAxbXdhd2xyY2R6VjVRb3ZSTGNPMndN?=
 =?utf-8?B?aVNpS0lDTmIwRUVLL1lrK3loaWZ6NHlUNm9zdVV3b1liV0dnSndzZmZCUys3?=
 =?utf-8?B?eFlpcFExQjN6dzNVYWt2ODAyZUU0QnkxZCtPVk1qMWdUaDdaQ2FHd1oxZlZU?=
 =?utf-8?B?bUtRMmFpMFFiTmg0blpWSjVTd2ZZcWhqRk1vczN5bGo2c2p6S1ZqN0RPbHJO?=
 =?utf-8?B?VEtKVFBOYUpwelg1aUhWMnVZaXI5cFpEdENDNDhMbGZiaytpN3NteGFoM0wr?=
 =?utf-8?B?TzIxOG9BS3NGL2lGZHVrUFBFNXdwRVNqZHJpVTZqc3BDVUdLanJuSEkzRkhn?=
 =?utf-8?B?NFMyVW1TbFZ0MGlTRVZLSXp5NlJjcVVmVTkyRkZnR2FGY2NlUDBkQlBJSUlF?=
 =?utf-8?B?U1ZOYmF6NnpqaU9Tak9iRWRFbVVrOWpLWFc5TlJVcmZqYkgxZ1V5WHV4TGhv?=
 =?utf-8?Q?cpPAo0csTznULVQGHF+lXxmd9?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?STZHM05qelRmcUwxSktRSER6K1NWVC91ek8rNmxZMlJubFlhMm0wSk1DaTRN?=
 =?utf-8?B?cHVnNk1IVmVDNWxPcEJKWmZRdnVrcElYaEJLdFM5d2FMSktoR2RYeWh6SGpi?=
 =?utf-8?B?d1dGdTJ1Sk5NTzc1QU4zaVlkT21oRWtaOUxYbFlFWHpEUGh5eDlweXJHQkhE?=
 =?utf-8?B?TU1TMXd2Q2lyT041bjBZczFkUlJiaWVGWWdhT2hVcEZkYzNtWFc0UDFyTzdK?=
 =?utf-8?B?K3JUNy8ydVVZN08rRGg4OG1kbDFnMXdRUEpMVFdZK0wrZy9nMVhUNll0eGcr?=
 =?utf-8?B?WmhxNDJRY3ZPbStlaGZ5cXFqZmZ1NzQ4ZEh1RDBZb0JtcWFsM3dmaUt1elRh?=
 =?utf-8?B?d29jTHpMMjNnOFd4Q2FReFZoeEJnbnRDZVJPNTFvaGY0bWUyeTViUmhROG54?=
 =?utf-8?B?d3RjbEhwZWpvQThOK21vRmRkSVpYMXlSK1Q5NUZpaE5RTHVpNmVic21MaFZh?=
 =?utf-8?B?QnpYRWhhSkJsUkdpTVdDSWxyNkJoU1N4OVFtTTExVXUzYVZ2aXhJV3g1b2Ey?=
 =?utf-8?B?RnB3ellkTE12WlFySXZ4eHRQVWdnUkdRY2lOZG91ZjlNY09RMk5seWRqTDB5?=
 =?utf-8?B?eGJsWUM0Z09hRnF3RHhpQnc1ZkJ5SzdkWVRUUVdnMTdGN0xvZkpsbGV0VjNM?=
 =?utf-8?B?NXdBRzBVRlorT1RMUDlsdng4cFRaRndEY3l2clYzY2NvaGdvdnlIRTZuQVZk?=
 =?utf-8?B?ams4WHlXdEM2UDd0S1B2b3FKdld2SXVvaFk1ZDRKRFRFSG1kank2L055NUJy?=
 =?utf-8?B?eVR6QzZrR2xKSGF1Nkg1Yjhkb2JOaXl6bXdSUTZRZHJkMkFXa2ZaUUUzQ3Qz?=
 =?utf-8?B?Ui9KZWQ2NWRhMElxQjNWM3oxVUJIRHYyWDl0OE9mQ21SVFZLMnVBVHNVbXJv?=
 =?utf-8?B?S205L2pnbXZIUVlFdjZWOE9tZ3NRVW16Y2Q2cTF3YjMyV2ZXS0xqOVAxQkZL?=
 =?utf-8?B?OGI5Z0pqZmY4T1Z0cWxwbVZHU3lKWE1SY3hybERybWFzQVVxbjRFbWpVS1Rz?=
 =?utf-8?B?UFd6WUtiYTdsczAvZ1pmdHNUbzJRaDFZZ1Z5cHIyNzQza3ZMYmFsazI2MlB0?=
 =?utf-8?B?VjdpOGIzNkd6cXNKQjUwTk1RdTZ0QnJDVjA0cDNRRGY4aUduQ0FRYjVJMnAr?=
 =?utf-8?B?d2JhUVFkS09RLzJKZUxkSVlMVVFUdENVV2JTS2g4TW9ubTkra2NGZmZjL21P?=
 =?utf-8?B?N2Rjb0h2OVd1cGg3MUFmdENYc29OalJRS3FWdW9scXZWNExDZno1eDltQ0xK?=
 =?utf-8?B?SU0rZWlzOXNwU0ZJMFVvajZyTG52cFBEVUtoRkZkbmEvZVo5TDZZN0pkWVhL?=
 =?utf-8?B?YklWWmZrTGt5ZTAxMWNUT0didlFiaStnWHI5ZjBHclNnalZuY1NDaFpaSE5q?=
 =?utf-8?B?WnNocU5ZbTlwMDMwY3ZlQXNId281NFlydzIyK1RpZ3B2RnREeDJhNVVOQXNR?=
 =?utf-8?B?OCtDZ210ZHV2T1g3RGl1dENxNG9VUy9UT3BuNHVyWEZwbTRKdEdHakRKaXBr?=
 =?utf-8?B?Q041ZTEySExJOGxjTWxJZ2I3aitTZjdvNmM5VDVoNDJPd1hyOExmUXdhbW4z?=
 =?utf-8?B?TWtmTGllOW5PbTVUSlZsWE41MUxwbC8zZllQL1RkeE5SYXQ2cWIzVjdIcmFh?=
 =?utf-8?B?M1RET2RkT2tWTUdmQ3pqQUh0alp0bDhBUkN0WjF6b0JYQTlsUjhib0pFanJP?=
 =?utf-8?B?MUx6TE91akZqVEkrZkNDbFB1a0FyWStVMXVOV0NyMFpUUHMxVUY5MTl1UWp5?=
 =?utf-8?B?M3I4ay9hNTlxOHl4QWcwdGRkRnl5T0c5SEUwWHhKcjduaUJLRC9COVpRbEt1?=
 =?utf-8?B?OGJQeUtnWE12TXN5NFhNdz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85e2961e-72c1-4d54-259c-08db15c862a0
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 18:04:19.9268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BkR/itKHfm03sSs/n5u28CFVpeaKT/FeUSf+7etpMXseLktzjZcuq5PX1pPiAYbgmzOr4HqYY4tiGIi7pEGTuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4338
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-23_11,2023-02-23_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=863 phishscore=0
 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302230150
X-Proofpoint-GUID: YC6LzyAzke04Zh6_NPCYZiwviBtye_5X
X-Proofpoint-ORIG-GUID: YC6LzyAzke04Zh6_NPCYZiwviBtye_5X
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 23, 2023 at 10:55:39AM +0100, Greg Kroah-Hartman wrote:
> On Fri, Feb 10, 2023 at 01:18:39PM -0700, Tom Saeger wrote:
> > Build ID is missing for arm64 with CONFIG_MODVERSIONS=y using ld >= 2.36
> > on 5.4, 5.10, and 5.15
> > 
> > Backport BuildID fixes.
> 
> I do not understand why you are applying patches from 6.2 that "fix"
> something that is not in this kernel (or the older ones).  Please
> document that really well on your next set of submissions.

Build ID is missing for arm64 with CONFIG_MODVERSIONS=y using ld >= 2.36
That's it.

What is quirky is binutils 'ld'.
Where this can be fixed is the kernel linker script, which IS present.
Those are the patches.

> 
> I've taken the 6.1.y series only and dropped all the others.

All the others is where it's really broken.

> 
> thanks,
> 
> greg k-h
