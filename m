Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911D6628C5B
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 23:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237755AbiKNWyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 17:54:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236454AbiKNWyM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 17:54:12 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A1519001
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 14:54:11 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AELDlGN011907;
        Mon, 14 Nov 2022 22:53:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=qYg+N2nabZJyWXKIpUFaAGS5FjAlxfNkdFICOhmY8iU=;
 b=f7PMkXL5Se9Ony0OUPHgadHdWqkrdUAFe9bNr31O8NEFNIqM3lASoDwvyJkpFMOAwJt7
 DrBsAx3aVXrjD/svfBfdI8iRDzyYCpcM2maioQWROo32iX4owZFbAIQBF8/bQ8ptvt1W
 7GXwQpYDbHB0NeE0dm5ickfMRMXHBkTkyfG5wkld1191JgAUacv65f9GuMYfY/RSnGPg
 fFoeEzi879O/UEf6w6O0I2SVLNCxnT5naxzTr7cCnH+yXV50RN/E2dPu7BF+Sxf7yZf1
 yzxbZR3uVPyibx61rV19o8XIYk7lXlIAMeYIIjikXt4uMFIJrx5uKxWIm349plnIA/yC ng== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kut2dgy7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Nov 2022 22:53:56 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AELQaC3004941;
        Mon, 14 Nov 2022 22:53:55 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ku3k5mry0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Nov 2022 22:53:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=it5Fu/COVD8GK5i7rvf+N2DLZWyyBdxrG9qdRbYy0NW4hMXvp1Zna3tzTCcfa8wTu0SvZ7LnBi45+uipD0PcufRDwrcjgl6FIof481yWXk9PThAVzDcB6BkG8hYLiYzJAT12/FOZcWedDBlH/BoYdbDTWXwmc8ORnMOeDeNuVAPBHouyoNuhtCtsk1lWwpKKeFRf+roITYGeFK4RD53o6tOi0p+55d5gFcfyj0K/+yZcGyyf6JR2WJDfA5UB31YYbYBfAdJHOqQikG2fYM7EjcSO3bISBv5qSX3C6te9/dsmuVNmHD//0DZJBuX4aqDLI9W+ze8F3yTfs9PjkpRmOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qYg+N2nabZJyWXKIpUFaAGS5FjAlxfNkdFICOhmY8iU=;
 b=EbDf1AX1fbm2TbU6BShhBPXl1/YwuITOl5wJTVlxhR48ODHUJNv6MSK1IBIk3QgN3sx3xB1l6EOm5KS3YRPd4y6z5C3JABXZ5p+JCRyJJmmLgpOZ0sMMxRGIsN5NPBJskXLrMNi7pFk8GwB11y6HLWeH4WGfVR4avofcAp8gulyFEvAqJhOF8v1sUCuLmVp41yDpjSa0sCiF8Zrl+pi83gb/8eaLDDugpZARoOD58T2qVIfLk/zfh5kro7gocs9jinpDWV1e16kKZnScotgeOsrKiQeJgqG4iWKYkvkDxDUj6Bk1fAByiJ3W8DCJ0JTYY9TbXgOe4ZZ1+7grxwkuEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qYg+N2nabZJyWXKIpUFaAGS5FjAlxfNkdFICOhmY8iU=;
 b=D/dhUHpleeFq1eHt7RH6MEZUTIGvk2IMtkUBfFCNZvi2KqNFq+wJUIgfxsWrRaK+iG/t032O35WaiH/QfdxaHOeOekBTYEw+kUuKc8Iz3JrSfIUJG2PLyHBaAEHoTe2/Oamh9PXN2gy2Sv6/ckDT7G4nJvmzG0H1wcxe5HdwOBs=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by PH8PR10MB6479.namprd10.prod.outlook.com (2603:10b6:510:22d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 22:53:54 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721%4]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 22:53:54 +0000
Date:   Mon, 14 Nov 2022 14:53:51 -0800
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Yang Shi <shy828301@gmail.com>,
        James Houghton <jthoughton@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: Re: hwpoison, shmem: fix data lost issue for 5.15.y
Message-ID: <Y3LG/+wWSSj6ZYzl@monkey>
References: <20221114131403.GA3807058@u2004>
 <Y3JotyM0Flj5ijVW@kroah.com>
 <20221114223900.GA3883066@u2004>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114223900.GA3883066@u2004>
X-ClientProxiedBy: MW3PR06CA0011.namprd06.prod.outlook.com
 (2603:10b6:303:2a::16) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|PH8PR10MB6479:EE_
X-MS-Office365-Filtering-Correlation-Id: 884b2adf-a11f-4977-5b80-08dac6931ac5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: apye//LNyJ6Ja0ylq/vAxI+i8NyI2cKrihg+BR94Et+Zjm/50ilKxh3sMapVuKATfMtg/nZ96jrKafVBfoRqFp9FOm22GHR01zNS0XhHpWO4X1fazn3SlpzEhjoVoYzOMqbFzWU9/QIoAJCCjJZPeGwS/K7AgJfAGxcKEAKPxVjjrh5BrkpSoAiR0vU5zMxmxQ65GybenImg/t6p6fk+pKbnonV+Shd8QDKAnwWGRPeK1a82gNFx5MA+0QiR+Y9oEnpD0Yu5OO38FHlmTdLEv+yfu8Y3mjuI/L77Qz1ezqLvv3rhe8mGGMm2IqRLBYTUYBsdY48UqishxpvB7qrj9DDlW+Z9DJVKt07sOLsl0HX0jp/6XU7cO0t4bhTrdekQonAv2ASBwbxrgkyiZ1lhOGLAX8daKZ0jPAmfbi4OU3TisC5fUeOhFHeVTS4txoN2VKeB6Umlfil5P81ixEtw6jAbAu7rwjHQLonvjHWXahdZ9ZEO8nXHvtK/8QTAiQriCT9QkKoovn80XaV1crE7aTJ7cawboJFlYLuI/GN0DeOADdMz0EoZB5depKlzxjgAbm+n3v57uc2GubZwhLsyA/dy2/nTYr/kAUdUuS5Ieq6bWzn3bx3/4iHVYGMPK6X1Ivp38o/N3N69fPDTcvX0+PLxmIYsgY3DcxHbN9qwl48eC9iWdrhYp0wfLdL9ZRW+Q4wpp439blhRnnQ0QkVa3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(366004)(39860400002)(136003)(346002)(376002)(451199015)(83380400001)(41300700001)(5660300002)(186003)(33716001)(8936002)(44832011)(4326008)(316002)(6916009)(54906003)(66476007)(8676002)(66946007)(66556008)(38100700002)(2906002)(478600001)(6512007)(6666004)(26005)(6506007)(53546011)(6486002)(9686003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HRtFmd2GBL51xpG/7FN23lXFBYJkBcW1YQN7zwHQAJ0q+OcLdpIq5mbZgeJw?=
 =?us-ascii?Q?qFC8Hkb1+6TfKGVo9y7BMUY2iPJqVnb/ied5ACqAMqe0rpG72Q2IKEdv8s0K?=
 =?us-ascii?Q?5AggD/1YUE1EqSJiFPaKCos6iceWZRAf/rP9DafSblSyWXYCIKGndSqNkxTs?=
 =?us-ascii?Q?kH/d8kSsmXJ/Xw3knHgnFEPlYKSslW0MTF23cVmuFaMx4k9eXJ/IvVWlV8Ra?=
 =?us-ascii?Q?e1sLmMSP6MEldBIZLqLxCTtybcqgORzHEsReDWaq8UrrZDlZ7+Xggs9Y53+o?=
 =?us-ascii?Q?RzeZuMQsIGsANLAPTuVURyWVd1VsGJpgC8LrP9FwTW166G/sasGZiPJR9HIY?=
 =?us-ascii?Q?H3GMPzYGR9dt5Tz/iGUtQc/RbCxJpEriH2dn9C8KAxj3LGvLjIxTD7AxbDvt?=
 =?us-ascii?Q?REapxk8xj75Qf6j9So/rVz+3wPRBL0AVpr6Sr+FrqSDRAgyAvehicCDgQT1o?=
 =?us-ascii?Q?pPAu7u9DhGnr24KLrPxUg278GdTmmymaXwVPqed63w9p6lJcppqjNfSDuOML?=
 =?us-ascii?Q?cjL90XJnMzWu1wrclaP7a9DUBVUvW1WcN+veuUZWwvevbywbAS8LFsUBE1YF?=
 =?us-ascii?Q?TCAyTIJlNFD6SGt8LRQAGp/ropzNWpxQhol84KlkEgWvVy0tUOHElaB6hsqf?=
 =?us-ascii?Q?qMjgMgcLWNnLRSXANTKT+Z358ta/bD8dmyad28t3aeDxpix/KKdmFwmBtZC6?=
 =?us-ascii?Q?TDTWmt5eQ1EnoST8FcwbLvZX/yb7flvQr6F3uqeJjW/yIALKvtacaH1voljE?=
 =?us-ascii?Q?v9gqOKuAkYdrAPTo+IOja1D5a8j72l+rEBzqqhI4DGvGDRvlzVUpIoTszX1K?=
 =?us-ascii?Q?EtpJ9SN+2ErorFr4j76b2WMTQ0Ex1MoutLBJOEmLMbPlZyadfX6vtTBSk42H?=
 =?us-ascii?Q?8zrOuCC1bVoAtAHZRSUTQ1IsZwf2BTCH6XUS2iMvdb69l/iCekS6wWDsoN6D?=
 =?us-ascii?Q?qdXDYGNWq13rlo+sEInxRzqcLSbEBWXW0MWDMe9rUjK029L9AET5NYktXrd8?=
 =?us-ascii?Q?eZEV1fKJPEvpNQzAWpK4HhNHvp/TRYJuwChQnauAZNw2+zzUEPL7UEvaNCfa?=
 =?us-ascii?Q?O6pgcETnQ5P2GEakBSbFVNlBwJxvBxorx75uNq+Z/D6HISHavbnDfWGXNadG?=
 =?us-ascii?Q?i31DFhyOimKfu39alhJTeIFYlx1r5/PD+crK3z09R+yiOMyjjUcjChw32SIz?=
 =?us-ascii?Q?f3s1oAKHqxOA+Ol8SFPQxHVq9HR5UFTJIXbd5/yJuksULJ/ddPM+TEnbGOQT?=
 =?us-ascii?Q?kULzTV5zuUqhhwWPcvQFnaukajle2bzn2o43hV1VPvk7HHCXrOcKZRWuPyMY?=
 =?us-ascii?Q?fZdOVTFHC5YhvImwcVkTh5FFP5mNfHKgUpZ1h9oy/Ma1XjKQY+XHm+SqGP1U?=
 =?us-ascii?Q?CK9m0iXpP9Knzj+eo5SaJhHyGQvzovBzxitomrlLDn2GeF8ReH0kua02GCJb?=
 =?us-ascii?Q?LyPw1lD4Sevo+uT0IgA54gINi3/GBsQU/dWKf72sDRb4kkdIwNa3y93MpetG?=
 =?us-ascii?Q?eKCoBN+WitiPNWNcDwRTSO5N++wT5SBRyhx4p/IRJRmyrE7Iyv0ASe+v0BZ2?=
 =?us-ascii?Q?0VGp/ixUvpzG0rH+hZEauie/RVz6A0Y51+6lvv/6PumLpuUCV7/kqex1KCt7?=
 =?us-ascii?Q?Tw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?rh+Yr5K742j3gVS9IadGC+604afa6X1V0hdJuQGdCRC3Ye146V0+TEcMe8TO?=
 =?us-ascii?Q?LvKWVpiVUS5odPN3Qx+VCbNuqJEqUdPRqZmZ01Q8B8N4friqCgwHmuag3bb4?=
 =?us-ascii?Q?AePZnYOURY2dQeIgTvuJUlAruyaP4YGXOQRw2Eu03Y3inphep6Rjpci+vQWP?=
 =?us-ascii?Q?7G+7e6Sj7dUuc4zYCF/1GXZVwWoTJlvUe+4VQMBQz6+QIy2xV+JlIlVs7yp1?=
 =?us-ascii?Q?J0WryzM0NZJy+EZa1JC5Uva/t37VvVDzZA0cAt3FQOGIU5+qU5RHSs6x967f?=
 =?us-ascii?Q?MsHTt2nGFSdV+EKF5ktkC2OEAnA+/0VemhYTp1nHzVlyUIKMqomay1Kr4gqD?=
 =?us-ascii?Q?AOqhOpkiWdCJWUQyeuruLVNlqwmDkeJ0O1PnuHZuvMbl553OyokPqzflOtFv?=
 =?us-ascii?Q?2B+KBst7QgVIQZTnKurz5G7t7nTOiBpF+8ky+7oh4CombwaJ1Xk09spCSQqt?=
 =?us-ascii?Q?7MGY/HO6MrZJLhtiKuyfiJnCdH9Du6lzEk2GDk91wEdE8Pc4PJvvigofU30C?=
 =?us-ascii?Q?UftnmgEU6gZhGYR+3BkqnBI2IHevetuwN4FOGaT9Icm9YwoEMW2Pg9R9VzBB?=
 =?us-ascii?Q?FSZvMcisIsWKiOdGjRea1/h95NSrl4Ta4ePgp1dB9xH3Z1ezXG4qARy99b6J?=
 =?us-ascii?Q?XZTw26BaazQjvOfs3tRXIQzK6XqkLQigYb8R7faN9K70I0IFn2O+X4EV2a+f?=
 =?us-ascii?Q?+HXM8XnyAV4sBokVBk5o3Z7uWCHfd6JJBjW7l7AabvEKuKPWwh61hnJpwd2g?=
 =?us-ascii?Q?rDph7tF1EnesN8G3V2MwcpdUG0/aPRDt9vp5gPdLRGJYg0mfzSbn74v/7ma4?=
 =?us-ascii?Q?GZeSPTHFlFjIokUEyegoQjTMq/4ykp6257trp4oa+ivtRV2pHKRdC9GwVas6?=
 =?us-ascii?Q?bf8VwZevrvR0AZeR7IMbs3Jd16Z7NSwUDvICxXONL/xb5QvflzPnw2xkVCTA?=
 =?us-ascii?Q?1le4KsjTO4JIT56537z094rD+X1I+T9QhBCn7iTCRub/ISUclpmuh+1rjC2u?=
 =?us-ascii?Q?52vjS9Ul8XeSShB+Sb81iwG4hxYQboUWdYFLgjRV32AGjvU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 884b2adf-a11f-4977-5b80-08dac6931ac5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 22:53:53.9698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: en0B+vEBQj1o1R2amrgnwfArnVtersFSXtwm64mFvrR4tMzgESGoQ42FEREzAFODm8Lp4fWNv8JLKzz3XlWBUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6479
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-14_15,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 malwarescore=0 suspectscore=0 mlxlogscore=633 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211140161
X-Proofpoint-GUID: ikIWbCOguGMet_2n2e3QpwdhyCXYBDQk
X-Proofpoint-ORIG-GUID: ikIWbCOguGMet_2n2e3QpwdhyCXYBDQk
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/15/22 07:39, Naoya Horiguchi wrote:
> On Mon, Nov 14, 2022 at 05:11:35PM +0100, Greg KH wrote:
> > On Mon, Nov 14, 2022 at 10:14:03PM +0900, Naoya Horiguchi wrote:
> > > Hi,
> > > 
> > > I'd like to request the follow commits to be backported to 5.15.y.
> > > 
> > > - dd0f230a0a80 ("mm: hwpoison: refactor refcount check handling")
> > > - 4966455d9100 ("mm: hwpoison: handle non-anonymous THP correctly")
> > > - a76054266661 ("mm: shmem: don't truncate page if memory failure happens")
> > > 
> > > These patches fixed a data lost issue by preventing shmem pagecache from
> > > being removed by memory error.  These were not tagged for stable originally,
> > > but that's revisited recently.
> > 
> > And have you tested that these all apply properly (and in which order?)
> 
> Yes, I've checked that these cleanly apply (without any change) on
> 5.15.78 in the above order (i.e. dd0f23 is first, 496645 comes next,
> then a76054).
> 
> > and work correctly?
> 
> Yes, I ran related testcases in my test suite, and their status changed
> FAIL to PASS with these patches.

Hi Naoya,

Just curious if you have plans to do backports for earlier releases?

If not, I can start that effort.  We have seen data loss/corruption because of
this on a 4.14 based release.   So, I would go at least that far back.
-- 
Mike Kravetz
