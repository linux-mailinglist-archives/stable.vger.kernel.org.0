Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8E036D043
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 03:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235422AbhD1B0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 21:26:19 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59768 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbhD1B0T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Apr 2021 21:26:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13S1PXpl029458;
        Wed, 28 Apr 2021 01:25:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : from :
 subject : message-id : date : content-type : content-transfer-encoding :
 mime-version; s=corp-2020-01-29;
 bh=YHvhn94p8mkzsV/sEU1b5FOlKGk5O9UP+40c9X9TFzg=;
 b=aSmT/cSZ4/vaX4Lw4rd4elUHG6Syi2tEXLPWzpEsvyDIadcgV8BGPdwAklmtx4aQSEcm
 VSni7E06NuaN/Nuozj0oyt14qqkor/rSfXyBYoCINYieihhklmTmsAVFI6VgpsJ84YX3
 BYf/zRwDNuzibpaDYA9xoxvabJ/KmbytIcZRmBYkV23WGSkSbC4v1azeNj53mDc0HqTR
 deg9vthS7SXTFa7CjxuAu5cXinWrITSJRXzZuEVqASf71W90jX5nXFccWMaZPE8nl3Oq
 JfiB98CwzUoiZzneqBJhvaKXwOu75NRWKfwwWyYs33qjsXlmVe9sCg635nJk/1r38Gst +A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 385afsy90n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Apr 2021 01:25:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13S1Obhv139058;
        Wed, 28 Apr 2021 01:25:32 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2041.outbound.protection.outlook.com [104.47.56.41])
        by aserp3030.oracle.com with ESMTP id 3849cfmgbx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Apr 2021 01:25:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7U2fTtgz2gyHpme8N1RQQbKaUOcXSD8/5SsvswvLgV4z10sDF5KpXKzD8DQVivvqwtGV2sFdED60zU0XZR3fh/lUmrDRKzkES7feqnTgZ2829o5JVfmBu8yCTqk0BZ/Z2nAFl1t7Td1eB3UGCjeRkx9oIYPo9+hUOuKfT6f6Mes4nH4Vq/Tlbp8pbhzy9Tulg2xdODmL/J/YDIsbDapBJV6zM+JplR0ILvNwbDX+tZS6yzYi0FWWZ3VExDrjpi01e9BDhvbvFODCeYAhGeZ//QvLbzFLJsLXrHyWXfkfjiaBnbVRuIkxGUc/J9n6Z3V39e5y7rhbsT5Zs+448OOGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YHvhn94p8mkzsV/sEU1b5FOlKGk5O9UP+40c9X9TFzg=;
 b=UhP8DLhwujNP4L1tApa5ZVLHFcKewv9wS1TIrvHcl4AY6Oukfcsmkw5Y0zSebt30OMuok/qbshKI8iV9bK6tWfWgY7o4zr5R4O/18oz59o7vhmy2asuYDlsf8HgkdTBQ6xlWBZ28I2Mfuxzp6+rAvm0eBjZlKanM55wzQdU/TptCRi2lF71UfOW44Dyy1FtIeCRb81qxLKjWunJ7olBvGG6WwVFphEJNcAKy1Ph4BKUK35tQ4dee7gu90RV5ax7tJI6OvKxzZLuKyHezil5gS78mBrZS/hU83A92D6pmNocMjsAXSyrHDoWCW853Fpc+tBugs2BgXQYp4PsCDnSQgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YHvhn94p8mkzsV/sEU1b5FOlKGk5O9UP+40c9X9TFzg=;
 b=iTBoM7rqOtmU316eGW20DQ/ZM1eBC9A2BLI8G4c30638JcOxEydTl2fi946kxKQy3GvDDRegdVOD1L6bz4jjo83e30TfXLEbJ2BuOkVV4uLiNTKO37OdSxDIE97Wzb2WNILj0PYgJoqAmyDjKspFGXeH91/Rbm0XRbzOA7Ln9BU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3851.namprd10.prod.outlook.com (2603:10b6:5:1fb::17)
 by DM6PR10MB3594.namprd10.prod.outlook.com (2603:10b6:5:155::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Wed, 28 Apr
 2021 01:25:30 +0000
Received: from DM6PR10MB3851.namprd10.prod.outlook.com
 ([fe80::e490:f9ff:f8f3:c1e6]) by DM6PR10MB3851.namprd10.prod.outlook.com
 ([fe80::e490:f9ff:f8f3:c1e6%7]) with mapi id 15.20.4065.027; Wed, 28 Apr 2021
 01:25:30 +0000
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
From:   George Kennedy <george.kennedy@oracle.com>
Subject: Re: Needed in 5.4.y: [PATCH 5.10 055/126] ACPI: tables: x86: Reserve
 memory occupied by ACPI tables
Organization: Oracle Corporation
Message-ID: <d12fc637-f30f-9b52-afce-2e0b3efb865e@oracle.com>
Date:   Tue, 27 Apr 2021 21:25:28 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [108.26.147.230]
X-ClientProxiedBy: SA0PR12CA0022.namprd12.prod.outlook.com
 (2603:10b6:806:6f::27) To DM6PR10MB3851.namprd10.prod.outlook.com
 (2603:10b6:5:1fb::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.228] (108.26.147.230) by SA0PR12CA0022.namprd12.prod.outlook.com (2603:10b6:806:6f::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Wed, 28 Apr 2021 01:25:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d289863-90ef-4e41-8175-08d909e482d0
X-MS-TrafficTypeDiagnostic: DM6PR10MB3594:
X-Microsoft-Antispam-PRVS: <DM6PR10MB3594C90E6FFFF371AA310474E6409@DM6PR10MB3594.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5J1MZEAC0PDytdCVSV9tPO8J5ImMT1LUFWf/ymbuMgLKgcqMfvd4WrAdgvRE7cKCk/gPdj5rNNirtpC7pYhM1Cmilm6FmczErmhDemJ1WP8bovgqhvVSpL6bZOLtLSW1uioEJu52NFt6wdysVeWMretm+8e/I3fHY2niZpPXTj6aa/UcgBeiBnpgU1+iXyAcEGR1kKMf6Yyj6HCkccbP2KJ5zI0YKU8ndCGS7V/1PILkwUnstkCOH34eq5YAsG+UBj6zTymtdoVpHwS1zcVDFnKIbO/ro6/3z8vgHueQWvCpYinSSPX7imHo1HC/XLipUZ5cbmC30KRDprtwc81KFbdmhU0Fe1j1v7wJ5PGZvJwY0G2VOqhl4/JLqr34ZAej/EiMG6grd6e03hbqHKTdNxB9ZKLuvSSCtHkVdGpTFaBkbOeyxJIEn35PSaY6B2d3xSucIh6z9OdZ0b2Md2jOZ+dAv4aOvp1W78Yseay2O3RlsM88FFmvaONwT/uJ7V01hb4V1+G6BBs7wlaOat1ThwiPUYhIIa+kWTj2ALW33Deo3LMU0rMxOnmfTbLhKrkXWLQXiX9Sqcj5w/nlOO9ynejS3iki7Pe8q/fADbiJeREdfPnl6E0qWW7TKNsAMqv2H1FvEMnpXz6aYOMEUHpSKZjUJhSQijSbec2N7YpL9LZcSNzLukGC6R6ZiOXNYtYf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3851.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(346002)(136003)(366004)(39860400002)(83730400007)(2616005)(5660300002)(956004)(44832011)(36756003)(66476007)(6916009)(8936002)(26005)(66946007)(2906002)(16526019)(4326008)(6486002)(478600001)(38100700002)(4744005)(31696002)(16576012)(316002)(8676002)(31686004)(66556008)(86362001)(83380400001)(36916002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?djAxYldNazNZM0ZHUGNsaW1BTDFlSzdoZXFSbE5GdGt2NkJZK0NOdmg3cVJR?=
 =?utf-8?B?TVFjTTBZYkhqTmhGMU9YcmtzaGpURmpyRitjMHJDb2k4YUI5Z1UxcVpnYlN5?=
 =?utf-8?B?cncvaXJnYmg2YVUxN05SZ3RLaEtvcm9vakhiQVR5N3RKYVJNMTF4cGEvSlNR?=
 =?utf-8?B?cVo1OHMwZzdmc1dGTHk0MDFPWm1UU2hWdWNhZjlQQmRBNHM4QUtrVmhNQ3JJ?=
 =?utf-8?B?eUxzcWJKeUtDWlNtZGkrc0pQM09obVJIMkwwb3BiZmpEQmg1RVA0dGpxeGc3?=
 =?utf-8?B?aHJaYUw4L2pQbW1QL1dLd0JaSmNDV2pTZVRLTlBFQnZwcnE0Smo4a2lGOG9E?=
 =?utf-8?B?OW55ZWpGM3orSDdybFVCMHowSmY4cjM0NVNnMDgvQld3bDJTZmp3T1NSYndC?=
 =?utf-8?B?cWcxVXNSN3BqMk1MV3diWXFzc2ZtdGRKOXd2bFRjenhMaFB4dXcwWnMwQlRO?=
 =?utf-8?B?VzRmODd5aUZyQ2o1MWozL3Z3Nll0cDJvOGpyYlhNemxKQzNnOElZTEJqSHNh?=
 =?utf-8?B?Ymg4TnBZb0hzYU5VMGNxa2UzdHRzWGtaMVZPN2xFU245R0RnTzhzbmZObzBD?=
 =?utf-8?B?TmVkQ0huUnhESTBHbUhlSFhpR29tWjlaa29PamlZVFpydDkrdHowc1M2NUJu?=
 =?utf-8?B?bFVjOTVUT1hjVWlSNzJjM0VXTFpuMkVzMnVKUno4VThldW9nZDNRQUU5SFVI?=
 =?utf-8?B?eWVrRXVJU3F6ZjVqNDhQMDZzVkhMcFFyTXFVTTdDRWVUS0dmYTFpd2JrNTJu?=
 =?utf-8?B?SHBZKzNaUk5uRkhTWm9iU0dwcmEzZVZaWHUyR05xZnhDM1ppMlI3SVBTam1k?=
 =?utf-8?B?S21JOW4rTWdvKzhLZG1XcnJWci9lTmJYTHpUYnM5S0JML2NHMVhNc0ZqVVkz?=
 =?utf-8?B?eHhVWDE3Ti9TbUtxZzMyaXRQSWMvdEtlZHhtUVFRbENaZERNVXBFaVRDTnVh?=
 =?utf-8?B?aXVWZnhvMGs0Rk9ySnFicWU3bmR3dGlGT2FqM0xpVTFXUWNHdElyR2N6ZnVP?=
 =?utf-8?B?R3FnMExEOHhiWk91czFMcnFURGVvWXJLbzU4WnFNYWlEN3o3YWRkby80S2FY?=
 =?utf-8?B?U0wrY1ZaR1pXcWttYkdDZXI4VE04K1ZXcHQ4Vk8vM3czZWl2R28rL2Y3Rmd3?=
 =?utf-8?B?K3ZURTk0akxQMkhwdmR0bFY5OENidmRPcTVsSnFxRklyY3h0cVdodk1nRlR2?=
 =?utf-8?B?UFRYc1pMWHdYcGhralpxT2UzamdHUHhxdTQ4dlIyTDhaY2NGZkVBRENsdjA1?=
 =?utf-8?B?N0xTWDg0S3M5S2FMdG9MbG9SdFRWQW1xeUtocnNQU29uU2dxWmxlVnNYUkZy?=
 =?utf-8?B?dDArNEJISzVVYk5PVnBJNGs4SlQ5czEyamUyeUNqZUY0azgzL0FKdkdUYnlq?=
 =?utf-8?B?ZTJWTm1uVHNVaWNuOWFDaUVEM0pBTS91VFFXaTdKMkorVHRYNkR6Ym9FL2pV?=
 =?utf-8?B?dTJGejE5MmpTV1lyTGkyZnVoL1VzVFFUaEZFQUxETEIxZ3Y2ZVdvQmE3Qi9l?=
 =?utf-8?B?bFZ4bUxDWks4RnkwSTE2bVNYRis5YTVGbllHOEZWTkpnaTdidjBmWHJtSy9r?=
 =?utf-8?B?aVoySHpoVU56YkhSOWdTV3I1b1drLzNHSG52bzBwaUlNbnhMc00zOGt2QUJo?=
 =?utf-8?B?L1VENFpWODA3Yi9HNjBQVWhDSkJuTDNuVHNrbE91U0IxWDMzZzJPMGI1UG5L?=
 =?utf-8?B?S25lVGloWllUWXE0RXljMTlkTndIMWlQcWtJa0puazFnTi81M2FMOFY5YURm?=
 =?utf-8?Q?KWfIRbX7w/p7iZmQTkf+EGHjRx+w7hNRCyaz71p?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d289863-90ef-4e41-8175-08d909e482d0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3851.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 01:25:30.5689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MolrXX89ANsdglD6at6NsfTBAPtxyeJBUZru7cZkJrpZkPh4JUWKE5qvUrFBcLfBnnUBG2qPbJ6fxcXD3F5+zkyFsyHQXc6eep/T5RTAY6E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3594
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=992 suspectscore=0
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104280007
X-Proofpoint-GUID: 9Z8ah7dkt8y-yLN3WoifpNJkcrHoaUs7
X-Proofpoint-ORIG-GUID: 9Z8ah7dkt8y-yLN3WoifpNJkcrHoaUs7
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1015 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104280007
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

We need the following 2 upstream commits applied to 5.4.y to fix an iBFT 
boot failure:

2021-03-29 rafael.j.wysocki@intel.com - 1a1c130a 2021-03-23 Rafael J. 
Wysocki ACPI: tables: x86: Reserve memory occupied by ACPI tables
2021-04-13 rafael.j.wysocki@intel.com - 6998a88 2021-04-13 Rafael J. 
Wysocki ACPI: x86: Call acpi_boot_table_init() after acpi_table_upgrade()

Currently, only the first commit (1a1c130a) is destined for 5.10 & 5.11.

The 2nd commit (6998a88) is needed as well and both commits are needed 
in 5.4.y.

Thank you,
George
